require('./_env') if require('fs').existsSync './_env.coffee'
CONFIG =
  NAME: 'Lendme'
  URL: process.env.URL or ''
  STATIC_URL: process.env.STATIC_URL or '' # do not include ending slash
  ROOT: __dirname
  DB:
    REDIS:
      HOST: process.env.DB_REDIS_HOST or '127.0.0.1'
      PORT: process.env.DB_REDIS_PORT or 6379
      USER: process.env.DB_REDIS_USER or ''
      PASSWORD: process.env.DB_REDIS_PASSWORD or ''
      URL: process.env.REDIS_URL or ''
      PREFIX: 'lendme:'
  EXPRESS:
    SESSION:
      KEY: 'lendme.s'
      SECRET: '7s0ARiQ0kh7U8kYlwTcOBLyNtQHoUVkO740yrjB5I1gHxarMHqWD2dPesMaJ'
  MAIL:
    SENDER_ADDRESS: 'LendMe <noreply@lendmechile.herokuapp.com>'
    TEMPLATES:
      'bienvenida':
        subject: 'Bienvenid@ a LendMe!'
        text: "Hola {{name}},\n\nEsta es tu primera vez en LendMe, gracias por ser parte de nuestro servicio, por este medio te notificaremos cuando registres una solicitud de espacio"
      SIGNATURE: "\n\n--\nSaludos\nEl Equipo de LendMe\nhttps://lendmechile.herokuapp.com/\n"
    MANDRILL:
      USERNAME: 'University'
      API_KEY: 'cBaPwA7s9NpZibZrhvyLag'
      HOST: 'smtp.mandrillapp.com'
      PORT: 587
    GMAIL:
      SERVICE: 'gmail'
      USER: 'mauricio.delr@gmail.com'
      PASSWORD: 'Noventaidos92'

exports.CONFIG = CONFIG