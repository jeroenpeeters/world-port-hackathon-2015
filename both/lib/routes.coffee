Router.map ->

  @route 'index',
    path: '/'
    subscriptions: ->
      subs = []
      if Session.get 'boundsFilter'
        subs.push Meteor.subscribe 'ships', Session.get('boundsFilter')

      if Session.get 'selectedShip'
        subs.push Meteor.subscribe 'shipHistory', Session.get('selectedShip').mmsi

      return subs
