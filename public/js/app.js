(function($){
  $(document).ready(function(){

      $('#form_login').submit(function(){
        $('#login_modal').modal('hide');
      });

  });
})(jQuery);


var cibyl = angular.module('cibyl', ['ngCookies']);
cibyl.factory('Properties', function(){
  var prop_set = {};
  return {
    get: function (key) {
      return prop_set[key];
    },
    set: function(key, value) {
      prop_set[key] = value;
    }
  };
});

function AuthCtrl($scope, $cookies, Properties){

  $scope.check_auth = function(){
    if ($cookies.username){
      Properties.set('logged_in', true);
      Properties.set('username', $cookies.username);
    }else{
      Properties.set('logged_in', false);
      Properties.set('username', "None");
    }
  };
  $scope.check_auth();
  
  $scope.auth = function(){
    if (Properties.get('logged_in')){
      return Properties.get('username');
    }else{
      return "None";
    }
  };

  $scope.logged_in = function(){
    return Properties.get('logged_in');
  };

  $scope.log_in = function(){
    console.log("Logging in: " + $scope.login_email);
    Properties.set('logged_in', true);
    Properties.set('username', $scope.login_email);
    $cookies.username = $scope.login_email;
  };

  $scope.log_out = function(){
    Properties.set('logged_in', false);
    Properties.set('username', "None");
    $cookies.username = "";
  };
}

function JobCtrl($scope, $http, Properties){

  $scope.refresh = function(){
    console.log("Here")
    $http.get('/api/config').success(function(data) {
      console.log(data);
      $scope.jobs = data.config.jobs
      job_map = {}
      for (job in $scope.jobs){
        job_map[$scope.jobs[job].name] = $scope.jobs[job];
      }
      $scope.job_map = job_map;
    });
  };
  $scope.refresh();

  $scope.meta = function(name){
    // $scope.loaded_job = name
    $http.get('/api/job/' + name).success(function(data) {
        console.log(data);
        if (data.job){
          $scope.loaded_job = data.job;
          $scope.loaded_job.pretty = JSON.stringify($scope.loaded_job, undefined, 2);
        }
    });
  }

  $scope.loaded_job = function(){
    $scope.loaded_job;
  };

  $scope.is_busy = function(name){
    return $scope.job_map[name].busy == true
  };

  $scope.run = function(name, value){
    var error = false;
    if (!name){
      error = "Choose an job to run";
    }
    var body = {};

    if (error){
      alert(error);
    }else{
      $http.post('/api/job/' + name + '/run', body).success(function(data) {
        console.log(data);
        alert('Started');
        setTimeout($scope.refresh, 1000);
      });
    }

  };
}
