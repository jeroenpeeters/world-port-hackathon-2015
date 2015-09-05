// on startup run resizing event
Meteor.startup(function() {

});

map = null;

Template.map.rendered = function() {
  //L.Icon.Default.imagePath = 'packages/bevanhunt_leaflet/images';

  map = L.map('map', {
    doubleClickZoom: false
  }).setView([51.9000, 4.40259933], 13);

//  L.tileLayer.provider('Thunderforest.Outdoors').addTo(map);
  L.tileLayer('http://{s}.tile.stamen.com/toner/{z}/{x}/{y}.png',{opacity:.5}).addTo(map);

  map.invalidateSize()

  map.on('dblclick', function(event) {
    /*Meteor.call('createShip', {
      title: 'title',
      description: 'descr',
      latlng: event.latlng
    });*/
    //Markers.insert({latlng: event.latlng});
    console.log('dbclick');
    //openCreateDialog(event.latlng);
  });

  map.on('moveend', function(event){
    var bounds = map.getBounds();
    ne = bounds.getNorthEast()
    sw = bounds.getSouthWest()
    filter = {
      min:{
        lat: sw.lat,
        lng: sw.lng
      },
      max:{
        lat: ne.lat,
        lng: ne.lng
      }
    }
    Session.set('boundsFilter', filter);
  });

  //LatLong = Meteor.npmRequire('simple-latlong')
  var query = Ships.find();
  query.observe({
    added: function (document) {
      // length
      // width
      /*if(document.bounds){
        L.rectangle(document.bounds, {color: "#ff7800", weight: 1}).addTo(map);
      }*/
      var marker = L.marker(document.latlng,{_id: 1,icon: createIcon(document.travel.speed)
      }).addTo(map)
        .on('click', function(event) {
          Session.set('selectedShipId', document._id);
          console.log('selected:', marker);
          //map.removeLayer(marker);
          //Ships.remove({_id: document._id});
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

  historyLayer = null
  var q = HistoryData.find();
  q.observe({
    added: function (document) {
      if(historyLayer){
        map.removeLayer(historyLayer);
      }
      historyLayer = L.polyline(document.points, {color: 'yellow'});
      historyLayer.addTo(map);
    },
    removed: function (oldDocument) {
      if(historyLayer){
        map.removeLayer(historyLayer);
      }
    }
  });

  var openCreateDialog = function (latlng) {
    console.log('set flag showCreateDialog');
    Session.set("createCoords", latlng);
    Session.set("showCreateDialog", true);
  };

  var createIcon = function(speed) {
    var className = 'leaflet-div-icon ';

    if (speed < 5) className += "stopped";
    if (speed > 5) className += "moving";
    return L.divIcon({
      iconSize: [30, 30],
  //    html: 'test',
      className: className
    });
  };
  var createHistoryIcon = function(speed) {
    return L.divIcon({
      iconSize: [10, 10],
      className: 'leaflet-div-icon history'
    });
  };

  setTimeout(function(){
    $(window).resize(function() {
      $('#map').css('height', window.innerHeight - 1);
    });
    $(window).resize(); // trigger resize event
  }, 500);

}
