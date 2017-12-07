class tNew
  constructor: () ->
    $.ajaxSetup cache: false
    @set_bindings()
  
  set_bindings: () ->
    $('#new_t_space').submit @new_t_space

  new_t_space: (e) ->
    e.preventDefault()
    params = $(e.currentTarget).serialize()
    $.post '/api/t_space/new', params, (data) =>
      if data.status is 'OK' and data.data
        alert 'Tipo espacio ingresado con éxito'
      else
        alert 'Ocurrió un error, intenta más tarde'

window.tNew = tNew
