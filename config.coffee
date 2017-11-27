require('./_env') if require('fs').existsSync './_env.coffee'
CONFIG =
  NAME: 'Lendme'
  URL: process.env.URL or '/'
  EMBED_URL: process.env.EMBED_URL or ''
  STATIC_URL: process.env.STATIC_URL or '' # do not include ending slash
  ROOT: __dirname
  DB:
    REDIS:
      HOST: process.env.DB_REDIS_HOST or 'ec2-34-232-232-46.compute-1.amazonaws.com'
      PORT: process.env.DB_REDIS_PORT or 64719
      USER: 'h'
      PASSWORD: 'p4a8e85876038d8eff7d0f661d7c59c9993796cbb0d66af5c2e443820ca6344c6'
      PREFIX: 'lendme:'
  EXPRESS:
    SESSION:
      KEY: 'lendme.s'
      SECRET: '7s0ARiQ0kh7U8kYlwTcOBLyNtQHoUVkO740yrjB5I1gHxarMHqWD2dPesMaJ'

exports.CONFIG = CONFIG