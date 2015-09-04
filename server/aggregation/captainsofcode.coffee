renew = ->
  try
    result = HTTP.get "http://www.captainsofcode.gr/inRange?range=3.8,51.8,4.6,52.2"

    if result.data
      result.data.forEach (item) ->
        Ships.upsert {mmsi: item.mmsi},
          mmsi: item.mmsi
          latlng: {lat: item.lat, lng: item.lon}
          travel:
            speed: item.speed
            course: item.course
            heading: item.heading
          coc: item
    else
      console.log 'Unable to renew data from captainsofcode', result.err
  catch err
    console.log 'Unable to fetch data from captainsofcode', err

Meteor.setInterval renew, 5000

renew()
