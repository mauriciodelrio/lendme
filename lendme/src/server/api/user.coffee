User = new (require('../lib/pgconn').User)()

module.exports = () ->
  all_users: ((req, res) ->
    User.connect (client) ->
      User.get_users client, (response) ->
        res.send status: 'OK', data: response
  )
  user_id: ((req, res) ->
    User.connect (client) ->
      User.get_user_by_id client, req.params.user_id, (response) ->
        res.send status: 'OK', data: response
  )