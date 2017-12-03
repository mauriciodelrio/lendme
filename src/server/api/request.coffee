Space = new (require('../lib/pgconn').Space)()
Mail = new (require('../lib/mail'))()
_ = require 'lodash'
module.exports = () ->
  send: ((req, res) ->
    console.log "request"
    res.send status: 'OK', data: "NOT TODAY"
  )
  filter_spaces: ((req, res) ->
    console.log req.query?.type_spa
    if req.query?.type_spa and req.query?.time_interval and req.query?.capacity and req.query?.day and req.query?.month and req.query?.recurrent

      console.log 'valid params'
    else
      res.send status: 'Error', message: 'Debe completar todos los campos'
  )
