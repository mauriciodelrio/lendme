CONFIG = require('../../../config').CONFIG
Cache = new (require('../lib/cache'))()
User = new (require('../lib/pgconn').User)()
Session = new (require('../lib/session'))()

middleware = (req, res, next) ->
  res.locals.USER = null
  return next() unless req.session.user_id
  Cache.get "user:#{req.session.user_id}", (cache_user) ->
    if cache_user
      console.log "cache", cache_user
      res.locals.USER = cache_user[0]
      next()
    else
      User.connect (client) ->
        User.get_user_by_id client, req.session.user_id, (user) ->
          if user
            user_data = user[0]
            Cache.set "user:#{req.session.user_id}", user_data, (cache_user) ->
              res.locals.USER = user_data
              next()
          else
            Cache.del "user:#{req.session.user_id}", () ->
              next()

module.exports = middleware