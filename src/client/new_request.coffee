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
    ###
    $.get '/api/request', params, (data) ->
    ###
    
window.NewRequest = NewRequest

