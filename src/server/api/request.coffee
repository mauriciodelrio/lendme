Request = new (require('../lib/pgconn').Request)()
User = new (require('../lib/pgconn').User)()
Mail = new (require('../lib/mail'))()
Cache = new (require('../lib/cache'))()
_ = require 'lodash'
moment = require 'moment'
async = require 'async'
module.exports = () ->
  send: ((req, res) ->
    Cache.get "user:#{req.session.user_id}", (cache_user) ->
      if cache_user
        params =
          user_id: cache_user.user_id
          ins_id: cache_user.ins_id
          date: "#{req.body.day}-#{req.body.month}-#{moment().year()}"
          time_id: req.body.time_interval or ''
          req_description: req.body.description or ''
          type_req_id: req.body.type_sol or ''
          req_dependant: if req.body.dependant? then true else false
          type_state_req_id: '2'
          spa_id: req.body.spa_id or ''
        Request.connect (client) =>
          Request.new_request client, params, (resp) =>
            if resp.status is 'OK' and resp.data?
              contador = 0
              size_body = Object.keys(req.body).length
              for key of req.body
                if /^opt-/.test key
                  new_opt = key.split '-'
                  params2 =
                    opt_id: new_opt[1]
                    req_id: resp.data.req_id
                  Request.connect (client) =>
                    Request.new_request_options client, params2, (resp) =>
                      contador += 1
                else
                  contador += 1
              if contador = size_body - 1
                res.send status: 'OK', data: 'Se ha generado solicitud exitosamente, verifica tu mail para más información'
            else
              res.send status: 'ERROR', data: 'No se ha podido crear el nuevo espacio, intente más tarde'
      else
        User.connect (client) ->
          User.get_user_by_id client, req.session.user_id, (user) ->
            if user
              params =
                user_id: user[0].user_id
                ins_id: user[0].ins_id
                date: "#{req.body.day}-#{req.body.month}-#{moment().year()}"
                time_id: req.body.time_interval
                req_description: req.body.description
                type_req_id: req.body.type_sol
                dependant: if req.body.dependant then req.body.dependant else false
                type_state_req_id: '2'
                spa_id: req.body.spa_id
              Request.connect (client) =>
                Request.new_request client, params, (resp) =>
                  if resp.status is 'OK' and resp.data?
                    contador = 0
                    size_body = Object.keys(req.body).length
                    for key of req.body
                      if /^opt-/.test key
                        new_opt = key.split '-'
                        params2 =
                          opt_id: new_opt[1]
                          req_id: resp.data.req_id
                        Request.connect (client) =>
                          Request.new_request_options client, params2, (resp) =>
                            contador += 1
                      else
                        contador += 1
                    if contador = size_body - 1
                      res.send status: 'OK', data: 'Se ha generado solicitud exitosamente, verifica tu mail para más información'
                  else
                    res.send status: 'ERROR', data: 'No se ha podido crear el nuevo espacio, intente más tarde'


  )
  filter_spaces: ((req, res) ->
    Cache.get "user:#{req.session.user_id}", (cache_user) ->
      if cache_user
        if req.query?.type_spa and req.query?.time_interval and req.query?.capacity and req.query?.day and req.query?.month and cache_user.ins_id
          params =
            type_spa_id: req.query.type_spa
            time_id: req.query.time_interval
            capacity: req.query.capacity
            sch_date: "#{req.query.day}-#{req.query.month}-#{moment().year()}"
            recurrent: if req.query.recurrent? then req.query.recurrent else false
            ins_id: cache_user.ins_id
          
          if params.capacity < 5 or params.capacity > 500
            res.send status: 'Error', message: 'Se deben solicitar espacios para un mínimo de 5 personas y un máximo de 500'
          else
            Request.connect (client) ->
              Request.check_spaces client, params, (resp) ->
                if resp.status is 'OK' and resp.data?
                  res.send status: 'OK', data: resp.data
        else
          res.send status: 'Error', message: 'Debe completar todos los campos'
      else
        User.connect (client) ->
          User.get_user_by_id client, req.session.user_id, (user) ->
            if user
              if req.query?.type_spa and req.query?.time_interval and req.query?.capacity and req.query?.day and req.query?.month and user[0].ins_id
                params =
                  type_spa_id: req.query.type_spa
                  time_id: req.query.time_interval
                  capacity: req.query.capacity
                  sch_date: "#{req.query.day}-#{req.query.month}-#{moment().year()}"
                  recurrent: if req.query.recurrent? then req.query.recurrent else false
                  ins_id: user[0].ins_id
                
                if params.capacity < 5 or params.capacity > 500
                  res.send status: 'Error', message: 'Se deben solicitar espacios para un mínimo de 5 personas y un máximo de 500'
                else
                  Request.connect (client) ->
                    Request.check_spaces client, params, (resp) ->
                      if resp.status is 'OK' and resp.data?
                        res.send status: 'OK', data: resp.data
              else
                res.send status: 'Error', message: 'Debe completar todos los campos'
            
  )
  all_time_interval: ((req, res) =>
    Cache.get "user:#{req.session.user_id}", (cache_user) ->
      if cache_user
        if cache_user.ins_id
          Request.connect (client) =>
            Request.get_all_time_interval client, cache_user.ins_id, (resp) ->
              if resp.status is 'OK' and resp.data?
                res.send status: 'OK', data: resp.data
              else
                res.send status: 'ERROR', data: resp.data
        else
          res.send status: 'ERROR', data: 'No se encontró institución, intente más tarde'
      else
        User.connect (client) ->
          User.get_user_by_id client, req.session.user_id, (user) ->
            if user
              if user[0].ins_id
                Request.connect (client) =>
                  Request.get_all_time_interval client, user[0].ins_id, (resp) ->
                    if resp.status is 'OK' and resp.data?
                      res.send status: 'OK', data: resp.data
                    else
                      res.send status: 'ERROR', data: resp.data
              else
                res.send status: 'ERROR', data: 'No se encontró institución, intente más tarde'
            
  )
  all_type_space: ((req, res) =>
    Cache.get "user:#{req.session.user_id}", (cache_user) ->
      if cache_user
        if cache_user.ins_id
          Request.connect (client) =>
            Request.get_all_type_space client, cache_user.ins_id, (resp) ->
              if resp.status is 'OK' and resp.data?
                res.send status: 'OK', data: resp.data
              else
                res.send status: 'ERROR', data: resp.data
        else
          res.send status: 'ERROR', data: 'No se encontró institución, intente más tarde'
      else
        User.connect (client) ->
          User.get_user_by_id client, req.session.user_id, (user) ->
            if user
              if user[0].ins_id
                Request.connect (client) =>
                  Request.get_all_type_space client, user[0].ins_id, (resp) ->
                    if resp.status is 'OK' and resp.data?
                      res.send status: 'OK', data: resp.data
                    else
                      res.send status: 'ERROR', data: resp.data
              else
                res.send status: 'ERROR', data: 'No se encontró institución, intente más tarde'
        
  )
  all_type_request: ((req, res) =>
    Cache.get "user:#{req.session.user_id}", (cache_user) ->
      if cache_user
        if cache_user.ins_id
          Request.connect (client) =>
            Request.get_all_type_request client, cache_user.ins_id, (resp) ->
              if resp.status is 'OK' and resp.data?
                res.send status: 'OK', data: resp.data
              else
                res.send status: 'ERROR', data: resp.data
        else
          res.send status: 'ERROR', data: 'No se encontró institución, intente más tarde'
      else
        User.connect (client) ->
          User.get_user_by_id client, req.session.user_id, (user) ->
            if user
              if user[0].ins_id
                Request.connect (client) =>
                  Request.get_all_type_request client, user[0].ins_id, (resp) ->
                    if resp.status is 'OK' and resp.data?
                      res.send status: 'OK', data: resp.data
                    else
                      res.send status: 'ERROR', data: resp.data
              else
                res.send status: 'ERROR', data: 'No se encontró institución, intente más tarde'

  )

  all_options_by_space: ((req, res) =>
    Cache.get "user:#{req.session.user_id}", (cache_user) ->
      if cache_user
        if cache_user.ins_id
          Request.connect (client) =>
            params =
              ins_id: cache_user.ins_id
              spa_id: req.query.spa_id or ''
            Request.get_all_options_by_space client, params, (resp) ->
              if resp.status is 'OK' and resp.data?
                res.send status: 'OK', data: resp.data
              else
                res.send status: 'ERROR', data: resp.data
        else
          res.send status: 'ERROR', data: 'No se encontró institución, intente más tarde'
      else
        User.connect (client) ->
          User.get_user_by_id client, req.session.user_id, (user) ->
            if user
              if user[0].ins_id
                Request.connect (client) =>
                  params =
                    ins_id: user[0].ins_id
                    spa_id: req.query.spa_id or ''
                  Request.get_all_options_by_space client, params, (resp) ->
                    if resp.status is 'OK' and resp.data?
                      res.send status: 'OK', data: resp.data
                    else
                      res.send status: 'ERROR', data: resp.data
              else
                res.send status: 'ERROR', data: 'No se encontró institución, intente más tarde'

  )
