module.exports = (req, res) ->
  if res.locals.USER.type_com_id is '1'
    res.render 'dashboard', title: 'Comunidad'
  else
    if res.locals.USER.type_admin_id is '1'
      res.render 'admin', title: 'Administración'
    else
      res.render 'editor', title: 'Editor'