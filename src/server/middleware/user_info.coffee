CONFIG = require('../../../config').CONFIG
Cache = new (require('../lib/cache'))()
User = new (require('../lib/pgconn').User)()
Session = new (require('../lib/session'))()

middleware = (req, res, next) ->
  res.locals.USER = null
  return next() unless req.session.user_id
  Cache.get "user:#{req.session.user_id}", (cache_user) ->
    if cache_user
      res.locals.USER = if cache_user[0] then cache_user[0] else cache_user
      console.log "hay cache, seteo res locals", res.locals.USER
      next()
    else
      User.connect (client) ->
        User.get_user_by_id client, req.session.user_id, (user) ->
          if user
            user_data = user[0]
            Cache.set "user:#{req.session.user_id}", user_data, (cache_user) ->
              res.locals.USER = user_data
              console.log "no hay cache, seteo res locals", res.locals.USER
              next()
          else
            Cache.del "user:#{req.session.user_id}", () ->
              next()

module.exports = middleware
