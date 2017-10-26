express = require 'express'
partials = require 'express-partials'
path = require 'path'
favicon = require 'serve-favicon'
app = express()
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
ejs = require 'ejs'
CONFIG = require('./config').CONFIG
server = require('http').Server(app)

#ROUTES
ROUTES = 
  index: require './src/server/routes/index'
  err404: require './src/server/routes/err404'
  users: require './src/server/routes/users'

#API
API = 
  user: require('./src/server/api/user')().all_users

# view engine setup
app.set 'CONFIG', CONFIG
app.set 'view engine', 'ejs'
app.set 'views', path.join(__dirname, 'views')
app.set 'view options', { layout: 'layout.ejs' }
# uncomment after placing your favicon in /public
#app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use partials()
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: false
app.use cookieParser()
app.use express.static(path.join(__dirname, 'public'))
if process.env.NODE_ENV isnt 'production'
  app.use express.static "#{__dirname}/public"

#ROUTING
app.get '/', ROUTES.index
app.get '/users', ROUTES.users

#ROUTING API

app.get '/api/users', API.user
# catch 404 and forward to error handler
app.get '*', ROUTES.err404

# App
# ----------
IP = process.env.IP or '127.0.0.1'
PORT = process.env.PORT or 3000
server.listen PORT, IP
_package = require './package.json'
console.log "#{_package.name} #{_package.version} is running on #{IP}:#{PORT}"