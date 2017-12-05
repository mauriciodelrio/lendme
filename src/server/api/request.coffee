Space = new (require('../lib/pgconn').Space)()
Mail = new (require('../lib/mail'))()
_ = require 'lodash'
moment = require 'moment'
module.exports = () ->
  send: ((req, res) ->
    console.log "request"
    res.send status: 'OK', data: "NOT TODAY"
  )
  filter_spaces: ((req, res) ->
    console.log req.query?.type_spa
    if req.query?.type_spa and req.query?.time_interval and req.query?.capacity and req.query?.day and req.query?.month and req.query?.recurrent and res.locals.USER?.ins_id
      params =
        type_spa: req.query.type_spa
        time_interval: req.query.time_interval
        capacity: req.query.capacity
        date: "#{req.query.day}/#{req.query.month}/#{moment().year()}"
        recurrent: req.query.recurrent
        ins_id: res.locals.USER.ins_id
      
      if params.capacity < 5 or params.capacity > 500
        res.send status: 'Error', message: 'Se deben solicitar espacios para un mínimo de 5 personas y un máximo de 500'
      else
        Space.connect (client) ->
          Space.get_spaces_with_filters client, params, (resp) ->
            res.send status: 'OK', data: resp 
    else
      res.send status: 'Error', message: 'Debe completar todos los campos'
  )
