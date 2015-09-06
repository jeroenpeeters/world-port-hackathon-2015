northWest = (latlng, gamma, halfWidth, halfLength) ->
  loc = new LatLong(latlng.lat, latlng.lng)
  loc.moveNorth halfWidth
  loc.moveWest halfLength
  {
    lat: loc.lat
    lng: loc.long
  }

northEast = (latlng, gamma, halfWidth, halfLength) ->
  loc = new LatLong(latlng.lat, latlng.lng)
  loc.moveNorth halfWidth
  loc.moveEast halfLength
  {
    lat: loc.lat
    lng: loc.long
  }

southWest = (latlng, gamma, halfWidth, halfLength) ->
  loc = new LatLong(latlng.lat, latlng.lng)
  loc.moveSouth halfWidth
  loc.moveWest halfLength
  {
    lat: loc.lat
    lng: loc.long
  }

southEast = (latlng, gamma, halfWidth, halfLength) ->
  loc = new LatLong(latlng.lat, latlng.lng)
  loc.moveSouth halfWidth
  loc.moveEast halfLength
  {
    lat: loc.lat
    lng: loc.long
  }

###
lat: (loc.lat * Math.cos(gamma)) - (loc.long * Math.sin(gamma))
lng: (loc.lat * Math.sin(gamma)) + (loc.long * Math.cos(gamma))
###

bounds = (details, heading, latlng)->
  halfWidth = details.width/2
  halfLength = details.length/2
  gamma = heading - 270
  nw = northWest(latlng, gamma, halfWidth, halfLength)
  ne = northEast(latlng, gamma, halfWidth, halfLength)
  sw = southWest(latlng, gamma, halfWidth, halfLength)
  se = southEast(latlng, gamma, halfWidth, halfLength)
  return [[nw, ne], [sw, se]]

enrichWithDetails = (ship) ->
  try
    console.log "Getting ship details for ship with mmsi #{ship.mmsi}"
    result = HTTP.get "http://www.captainsofcode.gr/ship?MMSI=#{ship.mmsi}"
    if result.data and result.data.length > 0
      ship.details = result.data[0]
      ship.details.image =
        src: "http://photos.marinetraffic.com/ais/showphoto.aspx?mmsi=#{ship.mmsi}"
      Ships.upsert {mmsi: ship.mmsi}, ship
    else
      console.log 'MarineTraffic API returned an error', result.err
  catch err
    console.log 'Unable to fetch ship details from MarineTraffic API', err


renew = ->
  try
    result = HTTP.get "http://www.captainsofcode.gr/inRange?range=3.8,51.8,4.6,52.2"

    if result.data
      result.data.forEach (item) ->
        ship = Ships.findOne mmsi: item.mmsi
        if ship
          ship.latlng =
            lat: item.lat
            lng: item.lon
          ship.travel =
            speed: item.speed
            course: item.course
            heading: item.heading

          if ship.details
            ship.bounds = bounds ship.details, item.heading, ship.latlng
          Ships.upsert {mmsi: ship.mmsi}, ship
          #console.log 'Only updating ship travel info'
        else
          #console.log 'enrich ship with details'
          Ships.insert
            mmsi: item.mmsi
            latlng: {lat: item.lat, lng: item.lon}
            travel:
              speed: item.speed
              course: item.course
              heading: item.heading
          fetchShipDetails mmsi: item.mmsi
          fetchShipLocationHistory mmsi: item.mmsi
    else
      console.log 'MarineTraffic API returned an error', result.err
  catch err
    console.log 'Unable to fetch ship details from MarineTraffic API', err

fetchShipLocationHistory = (task) ->
  console.log "Getting ship location history for ship with mmsi #{task.mmsi}"
  result = HTTP.get "http://www.captainsofcode.gr/loc?dates=1439856000,1441442831&MMSI=#{task.mmsi}"
  if result?.data
    sortedData = lodash.sortByAll result.data, 'timestamp'
    Ships.update {mmsi: task.mmsi}, $set: locationHistory: sortedData

fetchShipDetails = (task) ->
  try
    console.log "Getting ship details for ship with mmsi #{task.mmsi}"
    result = HTTP.get "http://www.captainsofcode.gr/ship?MMSI=#{task.mmsi}"
    if result.data and result.data.length > 0
      details = result.data[0]
      details.image =
        src: "http://photos.marinetraffic.com/ais/showphoto.aspx?mmsi=#{task.mmsi}"
      Ships.update {mmsi: task.mmsi}, $set: details: details
    else
      console.log 'MarineTraffic API returned an error', result.err
  catch err
    console.log 'Unable to fetch ship details from MarineTraffic API', err

#Meteor.setInterval renew, 20000

#renew()
