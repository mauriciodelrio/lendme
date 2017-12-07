class tDelete
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
          ).appendTo "#t_space_del"
  set_bindings: () ->
    $('#delete_t_space').submit @delete_t_space

  delete_t_space: (e) ->
    e.preventDefault()
    params = $(e.currentTarget).serialize()
    $.post '/api/t_space/delete', params, (data) =>
      if data.status is 'OK' and data.data
        alert 'Tipo espacio borrado con éxito'
      else
        alert 'Ocurrió un error, intenta más tarde'

window.tDelete = tDelete