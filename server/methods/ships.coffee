Meteor.methods
  createShip: (options) ->
    console.log 'insert ship', options
    Ships.insert
      owner: @userId
      latlng: options.latlng
      title: options.title
      description: options.description
