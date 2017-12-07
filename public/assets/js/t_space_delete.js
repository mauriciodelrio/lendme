// Generated by CoffeeScript 1.12.7
(function() {
  var tDelete;

  tDelete = (function() {
    function tDelete() {
      $.ajaxSetup({
        cache: false
      });
      this.set_bindings();
      this.init();
    }

    tDelete.prototype.init = function() {
      return $.getJSON('/api/t_space').always(function(data) {
        var i, len, ref, results, t_space;
        if (data.status === 'OK' && (data != null ? data.data : void 0)) {
          ref = data.data || [];
          results = [];
          for (i = 0, len = ref.length; i < len; i++) {
            t_space = ref[i];
            results.push($('#opt_t_spa').tmpl({
              id: t_space.type_spa_id,
              name: t_space.type_spa_name
            }).appendTo("#t_space_del"));
          }
          return results;
        }
      });
    };

    tDelete.prototype.set_bindings = function() {
      return $('#delete_t_space').submit(this.delete_t_space);
    };

    tDelete.prototype.delete_t_space = function(e) {
      var params;
      e.preventDefault();
      params = $(e.currentTarget).serialize();
      return $.post('/api/t_space/delete', params, (function(_this) {
        return function(data) {
          if (data.status === 'OK' && data.data) {
            return alert('Tipo espacio borrado con éxito');
          } else {
            return alert('Ocurrió un error, intenta más tarde');
          }
        };
      })(this));
    };

    return tDelete;

  })();

  window.tDelete = tDelete;

}).call(this);
