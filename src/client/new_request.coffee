class NewRequest
  constructor: () ->
    $.ajaxSetup cache: false
    @set_bindings()
  
  set_bindings: () ->
    $('#filter').submit @load_spaces_preferences

  load_spaces_preferences: (e) ->
    e.preventDefault()
    params = $(e.currentTarget).serialize()
    console.log params
    $.get '/api/request/spaces', params, (data) ->
      if data.status is 'OK' and data.data
        console.log 'datos enviados'
      else
        console.log data.message
    
window.NewRequest = NewRequest

