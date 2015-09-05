Template.details.helpers({
  allShips: function () {
    var entredname = shipname();
    if (typeof(entredname) == "undefined") entredname='';
    var value = Ships.find({"details.shipname" : {$regex : entredname , $options:'i'}});

    return value;
  }
});

  shipname = function() {
    return Session.get('shipname');
  }

Template.details.events({
  'keyup #shipname': function(event) {
      var entredShipName = $(event.currentTarget).val();
      Session.set('shipname', entredShipName);
  },
    'click #gothere': function(event) {
      if(map){
        map.setView([this.latlng.lat, this.latlng.lng], 20);
      }
  }
  });
