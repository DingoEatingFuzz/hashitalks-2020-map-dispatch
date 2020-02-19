var D3Node = require("d3-node");
var d3core = require("d3");
var d3geo = require("d3-geo");
var d3geoProjection = require("d3-geo-projection");
var fs = require("fs");
var fspath = require("path");
var projectionMap = require("./projection-map");

var d3 = Object.assign({}, d3core, d3geo, d3geoProjection);

// Read in args
var projectionName = process.argv[2];
var filePath = process.argv[3];
var outPath = process.argv[4] || "./out";

if (!filePath) throw new Error("File is required");

var projectionSlug = projectionName.toLowerCase().replace(/[\s\(\)]/g, "-");
var projection = (
  projectionMap.find(d => d.name === projectionName) ||
  projectionMap.find(d => d.name === "orthographic")
).value();

var outline = { type: "Sphere" };
projection.fitWidth(900, outline);

// Transform the Data

var data = JSON.parse(fs.readFileSync(filePath, "utf8"));
var stitchedData = d3.geoStitch(data);

// Set up map properties
var graticule = d3.geoGraticule10();
var path = d3.geoPath(projection);

// Create the SVG
var d3n = new D3Node();
var svg = d3n.createSVG(900, 900);

var extent = d3.extent(stitchedData.features.map(f => +f.properties.POP2005));
var scale = d3
  .scaleSymlog()
  .domain(extent)
  .interpolate(() => d3.interpolateViridis);

var map = svg.append("g").attr("clip-path", `url(#clip-${projectionSlug}`);

map
  .append("path")
  .attr("class", "outline")
  .attr("d", path(outline))
  .style("fill", "#ffffff")
  .style("stroke", "none");

map
  .append("path")
  .attr("class", "graticule")
  .attr("d", path(graticule))
  .style("fill", "none")
  .style("stroke", "rgba(0,0,0,0.5)")
  .style("stroke-width", "1");

map
  .selectAll(".region")
  .data(stitchedData.features)
  .enter()
  .append("path")
  .attr("class", "region")
  .attr("d", path)
  .style("fill", d => scale(+d.properties.POP2005))
  .style("stroke", "rgba(0, 0, 0, 0.3)")
  .style("stroke-width", "0.5");

svg
  .append("path")
  .attr("class", "outline")
  .attr("d", path(outline))
  .style("fill", "none")
  .style("stroke", "#000000")
  .style("stroke-width", "2");

var defs = svg.append("defs");
var clip = defs.append("clipPath").attr("id", `clip-${projectionSlug}`);
clip
  .append("path")
  .attr("class", "outline")
  .attr("d", path(outline))
  .style("fill", "none")
  .style("stroke", "#000000")
  .style("stroke-width", "2");

// Save to disk
fs.writeFileSync(
  fspath.join(outPath, projectionName + ".svg"),
  d3n.svgString()
);
