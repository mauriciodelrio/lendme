CONFIG = require('../../../config').CONFIG
Cache = new (require('../lib/cache'))()
Request = new (require('../lib/pgconn').Request)()

middleware = (req, res, next) ->
  res.locals.REQUEST = null
  return next() unless req.session.user_id
  Request.connect (client) ->
    Request.get_request_by_user_id client, req.session.user_id, (request) ->
      if request
        request_data = request
        Cache.set "request:#{req.session.user_id}", request_data, (cache_request) ->
          res.locals.REQUEST = request_data
          next()
      else
        Cache.del "request:#{req.session.user_id}", () ->
          next()

module.exports = middleware