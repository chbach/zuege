angular.module("wfb").controller('MainCtrl', function($scope, $http) {
  var success;
  success = function(data) {
    console.log(data);
    return $scope.trains = data;
  };
  $http.get('/data').success(success);
  return $scope.isDelayed = function(train) {
    return train.delay.length > 0;
  };
});
