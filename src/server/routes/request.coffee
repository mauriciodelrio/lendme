module.exports = (req, res) ->
  console.log res.locals.REQUEST, typeof res.locals.REQUEST
  res.render 'request', { title: 'Mis solicitudes', request: res.locals.REQUEST }