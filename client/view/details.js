Template.details.helpers({
  allShips: function () {
    console.log('allShip');
    var value = Ships.find({}, {speed :{$ne: undefined}}, {limit: 10}).fetch();

    return value;
  }
});
