class tUpdate
  constructor: () ->
    $.ajaxSetup cache: false
    @set_bindings()
    @init()
  
  init: () ->
    $.getJSON('/api/t_space')
    .always (data) ->
      if data.status is 'OK' and data?.data
        for t_space in data.data or []
          $('#opt_t_spa').tmpl(
            id: t_space.type_spa_id
            name: t_space.type_spa_name
          ).appendTo "#t_space_up"
  set_bindings: () ->
    $('#update_t_space').submit @update_t_space

  update_t_space: (e) ->
    e.preventDefault()
    params = $(e.currentTarget).serialize()
    $.post '/api/t_space/update', params, (data) =>
      if data.status is 'OK' and data.data
        alert 'Tipo espacio modificado con éxito'
      else
        alert 'Ocurrió un error, intenta más tarde'

window.tUpdate = tUpdate