# This is just a scratch file I'm preserving.
# Running this requires installing a bunch of packages globally
echo "Making a map! d3.geoAiry()"
geostitch world-population.geojson |
  geoproject 'd3.geoAiry().fitSize([900,900], d)' |
  ndjson-split 'd.features' |
  ndjson-map -r d3 \
    'z = d3.scaleSymlog().domain([0, 1312978855]).interpolate(() => d3.interpolateViridis),
    d.properties.stroke = "rgba(0, 0, 0, 0.3)",
    d.properties["stroke-width"] = "0.5",
    d.properties.fill = z(+d.properties.POP2005),
    d' > projections/world-population-airy.ndjson
geo2svg -n -p 1 -w 900 -h 900 < projections/world-population-airy.ndjson > test-svgs/world-population-airy.svg

echo "Making a map! d3.geoGingery()"
geostitch world-population.geojson |
  geoproject 'd3.geoGingery().lobes(6).fitSize([900,900], d)' |
  ndjson-split 'd.features' |
  ndjson-map -r d3 \
    'z = d3.scaleSymlog().domain([0, 1312978855]).interpolate(() => d3.interpolateViridis),
    d.properties.stroke = "rgba(0, 0, 0, 0.3)",
    d.properties["stroke-width"] = "0.5",
    d.properties.fill = z(+d.properties.POP2005),
    d' > projections/world-population-gingery.ndjson
geo2svg -n -p 1 -w 900 -h 900 < projections/world-population-gingery.ndjson > test-svgs/world-population-gingery.svg
