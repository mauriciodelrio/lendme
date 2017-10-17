express = require('express')
partials = require('express-partials')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
ejs = require 'ejs'
CONFIG = require('./config').CONFIG
index = require('./routes/index')
users = require('./routes/users')
app = express()
# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'ejs'
# uncomment after placing your favicon in /public
#app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));

app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use express.static(path.join(__dirname, 'public'))
if process.env.NODE_ENV isnt 'production'
  app.use express.static "#{__dirname}/public"
app.get '/', index
app.get '/users', users
# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err
  return

module.exports = app