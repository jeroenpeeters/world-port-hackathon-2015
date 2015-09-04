Template.details.helpers({
  allShips: function () {
    var value = Ships.find({}, {limit: 10}, {speed :{$ne: undefined}}).fetch();
    return value;
  }
});
