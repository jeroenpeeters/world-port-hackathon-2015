// on startup run resizing event
Meteor.startup(function() {
  $(window).resize(function() {
    $('#map').css('height', window.innerHeight - 82 - 45);
  });
  $(window).resize(); // trigger resize event
});

Template.map.rendered = function() {
  //L.Icon.Default.imagePath = 'packages/bevanhunt_leaflet/images';

  var map = L.map('map', {
    doubleClickZoom: false
  }).setView([51.9000, 4.40259933], 13);

//  L.tileLayer.provider('Thunderforest.Outdoors').addTo(map);
  L.tileLayer('http://{s}.tile.stamen.com/toner/{z}/{x}/{y}.png',{opacity:.5}).addTo(map);

  map.on('dblclick', function(event) {
    Meteor.call('createShip', {
      title: 'title',
      description: 'descr',
      latlng: event.latlng
    });
    //Markers.insert({latlng: event.latlng});
    console.log('dbclick');
    //openCreateDialog(event.latlng);
  });

  var query = Ships.find();
  query.observe({
    added: function (document) {
      var marker = L.marker(document.latlng,{_id: 1,icon: createIcon()
      }).addTo(map)
        .on('click', function(event) {
          map.removeLayer(marker);
          Ships.remove({_id: document._id});
        });
    },
    removed: function (oldDocument) {
      layers = map._layers;
      var key, val;
      for (key in layers) {
        val = layers[key];
        if (val._latlng) {
          if (val._latlng.lat === oldDocument.latlng.lat && val._latlng.lng === oldDocument.latlng.lng) {
            map.removeLayer(val);
          }
        }
      }
    }
  });

  var openCreateDialog = function (latlng) {
    console.log('set flag showCreateDialog');
    Session.set("createCoords", latlng);
    Session.set("showCreateDialog", true);
  };

  var createIcon = function() {
  var className = 'leaflet-div-icon public';
  return L.divIcon({
    iconSize: [30, 30],
//    html: 'test',
    className: className
  });
};
}
