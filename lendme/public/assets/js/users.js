(function(){var User;User=(function(){function User(){this.load_users();}User.prototype.load_users=function(){return $.getJSON("/api/users").always(function(data){return console.log(data);});};return User;})();window.User=User;}).call(this);