require('./_env') if require('fs').existsSync './_env.coffee'
CONFIG =
  NAME: 'Lendme'
  URL: process.env.URL or '/'
  EMBED_URL: process.env.EMBED_URL or ''
  STATIC_URL: process.env.STATIC_URL or '' # do not include ending slash
  ROOT: __dirname

exports.CONFIG = CONFIG