var fs = require("fs");
var express = require("express");
var bodyParser = require("body-parser");

var app = express();

app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ limit: "50mb" }));

app.use(
  bodyParser.urlencoded({
    extended: true
  })
);

app.use(bodyParser.json());

app.get("/hello", (req, res) => {
  res.json({ message: "Hi" });
});

app.post("/svg", (req, res) => {
  const { svg, filename } = req.body;
  fs.writeFile(
    `out/${filename}`,
    new Buffer(svg, "base64").toString("utf8"),
    err => {
      if (err) {
        console.log("Oh no!", err);
        res.json({ success: false });
      }
      console.log(`Wrote file ${filename}`);
      res.json({ success: true });
    }
  );
});

app.listen(3000);
