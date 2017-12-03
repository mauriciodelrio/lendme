User = new (require('../lib/pgconn').User)()
Cache = new (require('../lib/cache'))()
Session = new (require('../lib/session'))()
Mail = new (require('../lib/mail'))()
module.exports = () ->
  all_users: ((req, res) ->
    User.connect (client) ->
      User.get_users client, (response) ->
        res.send status: 'OK', data: response
  )
  user_id: ((req, res) ->
    User.connect (client) ->
      User.get_user_by_id client, req.params.user_id, (response) ->
        res.send status: 'OK', data: response
  )
  signin: ((req, res) ->
    if req.body?.email and req.body?.password
      params =
        mail : req.body.email
        password : req.body.password
      User.connect (client) ->
        User.get_user_by_mail client, params, (user) ->
          if user[0]?.user_id
            #limpiar sesiones anteriores acá
            User.clean_old_sessions client, user[0].user_id, (resp) ->
              if resp.status is 'OK' and resp.data?
                console.log resp
              else
                console.error resp
            console.log "---- traigo el USER ----"
            #Mail.send req.body.email, 'bienvenida', {name: String("#{user[0].user_name or ''} #{user[0].user_lastname or ''}").trim()}, (err, resp) ->
              #console.log err, resp
            Session.set user[0].user_id, {}, req, true, (session_id) ->
              if session_id?
                console.log "---- Seteo su session ----", session_id
                Cache.set "user:#{user.user_id}", user[0], (cache_user) ->
                  console.log "---- entro a Cache ----", cache_user
                  res.locals.USER = user[0]
                  res.send status: 'OK', data: user[0]
              else
                console.error "EMPTY RESPONSE SESSION"
                res.send status: 'ERROR', data: "LOGIN ERROR"
          else
            console.error user
            res.send status: 'ERROR', data: "USER NOT FOUND"
    else
      console.error "LOGIN_ERROR"
  )