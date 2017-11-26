CONFIG = require('../../../config').CONFIG
Session = new (require('../lib/session'))()
Cache = new (require('../lib/cache'))()

middleware = (req, res, next) ->
  Session.check req, (session) ->
    if session
      next()
    else
      if req.xhr
        res.send s: 'e', d: 'expired'
      else
        Cache.del "user:#{req.session.user_id}", () -> 
          Session.clear req, () ->
            res.redirect '/'

module.exports = middleware