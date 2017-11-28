CONFIG = require('../../../config').CONFIG
User = new (require('./pgconn').User)()
crypto = require 'crypto'
redis = require 'redis'
Url = process.env.REDIS_URL or 'redis://localhost:6379'
rclient = redis.createClient Url, prefix: CONFIG?.DB?.REDIS?.PREFIX

class Session
  constructor: () ->
    @config =
      session_ttl: 30

  check: (req, cb) ->
    if req?.session?.session_id and req?.session?.user_id
      rclient.GET "app:session:#{crypto.createHash('md5').update(req.session.session_id).digest('hex')}", (r_error, r_session) =>
        if r_session
          cb? req.session.session_id
        else
          User.connect (client) =>
            User.get_session_by_id client, req.session.user_id, (session_data) =>
              if session_data
                key = "app:session:#{crypto.createHash('md5').update(session_data.ses_id).digest('hex')}"
                ttl = @config.session_ttl
                value = 'true'
                rclient.SETEX key, ttl, value
                cb? req.session.session_id
              else
                User.clean_old_sessions client, req.session.user_id, (resp) ->
                  if resp.status is 'OK' and resp.data?
                    console.log resp
                  else
                    console.error resp
                  cb?()
    else
      cb?()

  set: (user_id, metadata = {}, req, clear_others = false, cb) =>
    User.connect (client) =>
      User.create_session client, user_id, (session_data) =>
        if session_data?.ses_id
          req.session.session_id = session_data.ses_id
          req.session.user_id = user_id
          req.session.metadata = metadata if metadata
          key = "app:session:#{crypto.createHash('md5').update(session_data.ses_id).digest('hex')}"
          ttl = @config.session_ttl
          value = 'true'
          rclient.SETEX key, ttl, value
          cb? session_data.ses_id
        else
          cb?()

  clear: (req, cb) ->
    #TODO: clear session in SM
    key = "app:session:#{crypto.createHash('md5').update(req?.session?.session_id).digest('hex')}"
    rclient.DEL key
    if req?.session?
      req.session.destroy()
      req.session = null
    cb?()

module.exports = Session