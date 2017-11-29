CONFIG = require('../../../config').CONFIG
Cache = new (require('../lib/cache'))()
Request = new (require('../lib/pgconn').Request)()

middleware = (req, res, next) ->
  res.locals.REQUEST = null
  return next() unless req.session.user_id
  Cache.del "request:#{req.session.user_id}", () ->
    Cache.get "request:#{req.session.user_id}", (cache_request) ->
      if cache_request
        res.locals.REQUEST = cache_request
        console.log "hay cache, seteo res locals", res.locals.REQUEST
        next()
      else
        Request.connect (client) ->
          Request.get_request_by_user_id client, req.session.user_id, (request) ->
            if request
              request_data = request
              Cache.set "request:#{req.session.user_id}", request_data, (cache_request) ->
                res.locals.REQUEST = request_data
                console.log "no hay cache, seteo res locals", res.locals.REQUEST
                next()
            else
              Cache.del "request:#{req.session.user_id}", () ->
                next()

module.exports = middleware