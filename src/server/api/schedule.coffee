Request = new (require('../lib/pgconn').Request)()
User = new (require('../lib/pgconn').User)()
Mail = new (require('../lib/mail'))()
Cache = new (require('../lib/cache'))()
_ = require 'lodash'
moment = require 'moment'
module.exports = () ->
  load_pending_requests: ((req, res) ->
    Cache.get "user:#{req.session.user_id}", (cache_user) ->
      console.log cache_user
      if cache_user
        params =
          ins_id: cache_user.ins_id
          state_req_id: '2'
        Request.connect (client) =>
          Request.get_request_by_state client, params, (resp) =>
            if resp.status is 'OK' and resp.data?
              console.log "resp data", resp.data
              res.send status: 'OK', data: resp.data
            else
              res.send status:'ERROR', data: resp.data
      else
        User.connect (client) ->
          User.get_user_by_id client, req.session.user_id, (user) ->
            if user
              params =
                ins_id: cache_user.ins_id
                state_req_id: '2'
              Request.connect (client) =>
                Request.get_request_by_state client, params, (resp) =>
                  if resp.status is 'OK' and resp.data?
                    res.send status: 'OK', data: resp.data
                  else
                    res.send status:'ERROR', data: resp.data
  )
  
  change_request: ((req, res) ->
    console.log req.session
    Cache.get "user:#{req.session.user_id}", (cache_user) ->
      if cache_user
        params=
          adm_id: cache_user.adm_id
          req_id:req.body.req_id
          state_req_id: if req.body.state? then '1' else '3'
          description: req.body.description
        console.log cache_user
        console.log params
        Request.connect (client) =>
          Request.change_request_dep client, params, (resp) =>
            if resp.status is 'OK' and resp.data
              console.log "DATA OK!!!"
              if resp.t is 'R'
                User.connect (client) =>
                  User.get_user_by_id client, resp.data, (resp) ->
                    #SEND MAIL RECHAZADO
                    res.send status: 'OK', data: 'Solicitud modificada exitosamente'
              else
                User.connect (client) =>
                  User.get_user_by_id client, resp.data, (resp) ->
                    #SEND MAIL APROBADO
                    res.send status: 'OK', data: 'Solicitud modificada exitosamente'
            else
              res.send status: 'ERROR', data: resp.data
        
      else
        User.connect (client) ->
          User.get_user_by_id client, req.session.user_id, (user) ->
            if user
              params=
                adm_id: user.adm_id
                req_id:req.body.req_id
                state_req_id: if req.body.state then '1' else '3'
                description: req.body.description
              Request.connect (client) =>
                Request.change_request_dep client, params, (resp) =>
                  if resp.status is 'OK' and resp.data
                    res.send status: 'OK', data: 'Solicitud modificada exitosamente'
                  else
                    res.send status: 'ERROR', data: 'No se ha podido modificar la solicitud, por favor intente más tarde'
  )