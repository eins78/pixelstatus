var layout = [];
var spacing = 0.05;

var oneStrip = [];
for (var i = 0; i < 60; i++) {
  oneStrip.push(i);
};

var sections = [
  {
    height: 1,
    offset: -65
  },
  {
    height: 1,
    offset: 0
  },
  {
    height: 0,
    offset: -65
  },
  {
    height: 0,
    offset: 0
  }
];

sections.forEach(function (sec) {
  oneStrip.forEach(function (n) {
    var x = 1;
    var y = (sec.offset + n) * spacing;
    var z = sec.height;
    layout.push({"point": [x, y, z]});
  });
});

console.log(JSON.stringify(layout, 0, 2));
