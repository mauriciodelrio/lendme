User = new (require('../lib/pgconn').User)()

module.exports = () ->
  all_users: ((req, res) ->
    console.log "hereee"
    User.connect (client) ->
      User.get_users client, (response) ->
        console.log response
    )