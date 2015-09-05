Meteor.publish 'ships', (filter) ->
  min = filter.min
  max = filter.max
  console.log 'publish ships within range', min, max
  Ships.find
    $and: [
      {'latlng.lat': $gte: min.lat}
      {'latlng.lng': $gte: min.lng}
      {'latlng.lng': $lte: max.lng}
      {'latlng.lat': $lte: max.lat}
    ]
  ,
    fields: {locationHistory: 0}
    
Meteor.publish 'shipHistory', (mmsi) ->
  Ships.find {mmsi: mmsi}, fields: {locationHistory: 1}
