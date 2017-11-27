class User
  constructor: () ->
    @load_users()

  load_users: () ->
    $.getJSON('/api/users')
    .always (data) ->
      if data.status is 'OK' and data?.data
        for user in data.data or []
          $('#users').tmpl(
            id: user.user_id
            name: user.user_name
            mail: user.user_mail
            status: user.user_state
          ).appendTo ".users-results"
    $.getJSON('/api/users/1')
    .always (data) ->
      if data.status is 'OK' and data?.data
        for user in data.data or []
          $('#users').tmpl(
            id: user.user_id
            name: user.user_name
            mail: user.user_mail
            status: user.user_state
          ).appendTo ".users-results"

window.User = User