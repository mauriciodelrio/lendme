module.exports = (req, res) ->
  res.render 'request', { title: 'Mis solicitudes' request: res.locals.REQUEST }