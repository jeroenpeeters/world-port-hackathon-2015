Template.details.helpers({
  allShips: function () {
    var entredname = shipname();
    console.log('entred name = '+ shipname());
    if (typeof(entredname) == "undefined") entredname='';
    var value = Ships.find({"details.shipname" : {$regex : ".*"+entredname+".*"}}).fetch()
//    Ships.find({"details.shipname" : {$regex : ".*S.*"}}).fetch();

    return value;
  }
});

  shipname = function() {
    return Session.get('shipname');
  }

Template.details.events({
  'keyup #shipname': function(event) {
        var entredShipName = $(event.currentTarget).val();
     console.log('entred: ' + $(event.currentTarget).val());
      Session.set('shipname', entredShipName);
  }
  });


// 'keyup #shipname': _.throttle(function (evt) {
//   ...
// }, 350),