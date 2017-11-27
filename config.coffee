require('./_env') if require('fs').existsSync './_env.coffee'
CONFIG =
  NAME: 'Lendme'
  URL: process.env.URL or '/'
  EMBED_URL: process.env.EMBED_URL or ''
  STATIC_URL: process.env.STATIC_URL or '' # do not include ending slash
  ROOT: __dirname
  DB:
    REDIS:
      HOST: process.env.DB_REDIS_HOST or 'redis://rediscloud:GFtYUUN5uWQzpakQ@redis-16689.c8.us-east-1-2.ec2.cloud.redislabs.com'
      PORT: process.env.DB_REDIS_PORT or 16689
      PREFIX: 'lendme:'
  EXPRESS:
    SESSION:
      KEY: 'lendme.s'
      SECRET: '7s0ARiQ0kh7U8kYlwTcOBLyNtQHoUVkO740yrjB5I1gHxarMHqWD2dPesMaJ'

exports.CONFIG = CONFIG