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
          Ships.upsert {mmsi: ship.mmsi}, ship
          console.log 'Only updating ship travel info'
        else
          console.log 'enrich ship with details'
          enrichWithDetails
            mmsi: item.mmsi
            latlng: {lat: item.lat, lng: item.lon}
            travel:
              speed: item.speed
              course: item.course
              heading: item.heading
    else
      console.log 'MarineTraffic API returned an error', result.err
  catch err
    console.log 'Unable to fetch ship details from MarineTraffic API', err

Meteor.setInterval renew, 20000

renew()
