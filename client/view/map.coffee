@HistoryData = new Mongo.Collection null

Template.map.helpers
  selectedShip: ->
    ship = Ships.findOne _id: Session.get 'selectedShipId'

    HistoryData.remove({})

    if ship.locationHistory
      history = ship.locationHistory.map (item) -> {lat: item.lat, lng: item.lon}
      HistoryData.insert points: history

    ship

Template.map.events
  'click #closeButton': ->
    Session.set 'selectedShipId', null
