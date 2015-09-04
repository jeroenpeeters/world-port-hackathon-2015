Router.map ->

  @route 'index',
    path: '/'
    subscriptions: ->
      [ Meteor.subscribe 'ships']
