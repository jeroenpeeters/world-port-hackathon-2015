Router.map ->

  @route 'index',
    path: '/'
    subscriptions: ->
      subs = []
      if Session.get 'boundsFilter'
        subs.push Meteor.subscribe 'ships', Session.get('boundsFilter')

      if Session.get 'selectedShipId'
        subs.push Meteor.subscribe 'shipHistory', Session.get('selectedShipId')

      return subs
