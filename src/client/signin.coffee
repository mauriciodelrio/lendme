class Signin
  constructor: () ->
    $.ajaxSetup cache: false
    @set_bindings()

  set_bindings: () ->
    $('#form-signin').submit @login

  login: (e) ->
    e.preventDefault()
    v = $(e.currentTarget).serialize()
    $.post '/api/signin', $(e.currentTarget).serialize(), (data) ->
      window.location.href = '/dashboard'

window.Signin = Signin