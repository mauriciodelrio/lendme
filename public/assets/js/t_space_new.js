// Generated by CoffeeScript 1.12.7
(function() {
  var tNew;

  tNew = (function() {
    function tNew() {
      $.ajaxSetup({
        cache: false
      });
      this.set_bindings();
    }

    tNew.prototype.set_bindings = function() {
      return $('#new_t_space').submit(this.new_t_space);
    };

    tNew.prototype.new_t_space = function(e) {
      var params;
      e.preventDefault();
      params = $(e.currentTarget).serialize();
      return $.post('/api/t_space/new', params, (function(_this) {
        return function(data) {
          if (data.status === 'OK' && data.data) {
            return alert('Tipo espacio ingresado con éxito');
          } else {
            return alert('Ocurrió un error, intenta más tarde');
          }
        };
      })(this));
    };

    return tNew;

  })();

  window.tNew = tNew;

}).call(this);
