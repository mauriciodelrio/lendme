CONFIG = require('../../../config').CONFIG
crypto = require 'crypto'
redis = require 'redis'
rclient = redis.createClient CONFIG?.DB?.REDIS?.PORT, CONFIG?.DB?.REDIS?.HOST, prefix: CONFIG?.DB?.REDIS?.PREFIX
async = require 'async'

class Cache
  constructor: () ->
    @config =
      search_ttl: 60

  get: (key, type..., cb) ->
    domain = 'app:cache'
    domain += ":#{type[0]}" if type.length > 0
    if key and key isnt 'all'
      rclient.HGET domain, key, (error, response) ->
        try
          _resp = JSON.parse response
        catch e
          #
        cb? _resp
    else
      rclient.HGETALL domain, (error, response) ->
        _response = {}
        for key, value of (response or {})
          try
            _response[key] = JSON.parse value
          catch e
            #
        cb? _response

  getRaw: (key, type, cb) ->
    domain = "app:cache:#{type}:#{key}"
    rclient.GET domain, (error, response) ->
      cb? response

  setRaw: (key, type, value, ttl..., cb) ->
    domain = "app:cache:#{type}:#{key}"
    ttl = ttl[0] or null
    if ttl
      rclient.SETEX domain, ttl, value, (error, response) -> cb? !error?
    else
      rclient.SET domain, value, (error, response) -> cb? !error?

  set: (key, value, type..., cb) ->
    domain = 'app:cache'
    domain += ":#{type[0]}" if type.length > 0
    _value = null
    try
      _value = JSON.stringify value
    catch e
      #
    rclient.HSET domain, key, _value, (error, response) ->
      cb? !error?

  del: (key, cb) ->
    rclient.DEL key, (error, response) ->
      cb? !error?

  hdel: (key, type..., cb) ->
    if key is 'all' and type?
      @get 'all', type, (data) =>
        data = (key for key, val of data)
        async.each data, (key, done) =>
          @hdel key, type, () ->
            done null, key
    else
      domain = 'app:cache'
      domain += ":#{type[0]}" if type.length > 0
      rclient.HDEL domain, key, (error, response) ->
        cb? !error?

  search_get: (key, cb) ->
    if typeof key is 'object'
      try
        key = JSON.stringify key
      catch e
        #
    rclient.GET "app:search-cache:#{crypto.createHash('md5').update(key).digest('hex')}", (error, response) ->
      _response = {}
      try
        _response = JSON.parse response
      catch e
        #
      cb? _response

  search_set: (key, value, cb) ->
    if typeof key is 'object'
      try
        key = JSON.stringify key
      catch e
        #
    _value = null
    try
      _value = JSON.stringify value
    catch e
      #
    rclient.SETEX "app:search-cache:#{crypto.createHash('md5').update(key).digest('hex')}", @config.search_ttl, _value, (error, response) ->
      cb? !error?

module.exports = Cache