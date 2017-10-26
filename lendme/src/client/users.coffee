class User
  constructor: () ->
    @load_users()

  load_users: () ->
    $.getJSON('/api/users')
    .always (data) ->
      console.log data

window.User = User