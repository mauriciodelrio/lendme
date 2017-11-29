module.exports = () ->
  send: ((req, res) ->
    console.log "request"
    res.send status: 'OK', data: "NOT TODAY"
  )
  filter_spaces: ((req, res) ->
    
  )