Space = new (require('../lib/pgconn').Space)()
User = new (require('../lib/pgconn').User)()
Cache = new (require('../lib/cache'))()
module.exports = () ->
  get_all: ((req, res) ->
    Cache.get "user:#{req.session.user_id}", (cache_user) ->
      if cache_user
        Space.connect (client) ->
          Space.get_all_type_space client, cache_user.ins_id, (resp) ->
            if resp.status is 'OK' and resp.data
              res.send status: 'OK', data: resp.data
            else
              res.send status: 'ERROR', data: resp.data
      else
        User.connect (client) ->
          User.get_user_by_id client, req.session.user_id, (user) ->
            if user
              Space.connect (client) ->
                Space.get_all_type_space client, user[0].ins_id, (resp) ->
                  if resp.status is 'OK' and resp.data
                    res.send status: 'OK', data: resp.data
                  else
                    res.send status: 'ERROR', data: resp.data
  )

  new: ((req, res) ->
    Cache.get "user:#{req.session.user_id}", (cache_user) ->
      if cache_user
        Space.connect (client) ->
          params = 
            ins_id: cache_user.ins_id
            type_spa_name: req.body.type_spa_name
          Space.create_type_space client, params, (resp) ->
            if resp.status is 'OK' and resp.data
              res.send status: 'OK', data: resp.data
            else
              res.send status: 'ERROR', data: resp.data
      else
        User.connect (client) ->
          User.get_user_by_id client, req.session.user_id, (user) ->
            if user
              Space.connect (client) ->
                params = 
                  ins_id: user[0].ins_id
                  type_spa_name: req.body.type_spa_name
                Space.create_type_space client, params, (resp) ->
                  if resp.status is 'OK' and resp.data
                    res.send status: 'OK', data: resp.data
                  else
                    res.send status: 'ERROR', data: resp.data
  )
  update: ((req, res) ->
    Space.connect (client) ->
      params = 
        type_spa_id: req.body.type_spa_id
        type_spa_name: req.body.type_spa_name
      Space.update_type_space client, params, (resp) ->
        if resp.status is 'OK' and resp.data
          res.send status: 'OK', data: resp.data
        else
          res.send status: 'ERROR', data: resp.data
              
  )
  delete: ((req, res) ->
    Space.connect (client) ->
      params = 
        type_spa_id: req.body.type_spa_id
      Space.delete_type_space client, params, (resp) ->
        if resp.status is 'OK' and resp.data
          res.send status: 'OK', data: resp.data
        else
          res.send status: 'ERROR', data: resp.data
  )