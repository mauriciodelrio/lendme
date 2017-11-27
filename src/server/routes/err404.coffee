module.exports = (req, res) ->
  res.status(404)
  res.render 'error404', { layout: true, title: '404' }