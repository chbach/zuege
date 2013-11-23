angular.module("wfb").controller 'MainCtrl', ($scope, $http) ->

	success = (data) -> 
		$scope.trains = data

	$http.get('/data').success success

	$scope.isDelayed = (train) ->
		train.delay.length > 0 
