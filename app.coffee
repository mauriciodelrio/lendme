express = require 'express'
session = require 'express-session'
partials = require 'express-partials'
path = require 'path'
RedisStore = require('connect-redis')(session)
favicon = require 'serve-favicon'
app = express()
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
ejs = require 'ejs'
CONFIG = require('./config').CONFIG
server = require('http').Server(app)
module.exports = server
app.use session {
  store: new RedisStore url: CONFIG?.DB?.REDIS?.URL
  prefix: CONFIG?.DB?.REDIS?.PREFIX + 'sess:'
  key: CONFIG.EXPRESS.SESSION.KEY
  secret: CONFIG.EXPRESS.SESSION.SECRET
  resave: true,
  saveUninitialized: true
}
# Middleware
# ----------
middlewarePath = './src/server/middleware'
MIDDLEWARE =
  AUTH: require "#{middlewarePath}/auth"
  USER_INFO: require "#{middlewarePath}/user_info"
  REQUEST_INFO: require "#{middlewarePath}/request_info"

#ROUTES
ROUTES = 
  index: require './src/server/routes/index'
  err404: require './src/server/routes/err404'
  users: require './src/server/routes/users'
  signin: require './src/server/routes/signin'
  dashboard: require './src/server/routes/dashboard'
  request: require './src/server/routes/request'
  new_request: require './src/server/routes/new_request'
  all_request: require './src/server/routes/all_request'
  t_space: require './src/server/routes/t_space'
  t_space_new: require './src/server/routes/t_space_new'
  t_space_update: require './src/server/routes/t_space_update'
  t_space_delete: require './src/server/routes/t_space_delete'

#API
API = 
  users: require('./src/server/api/user')().all_users
  user: require('./src/server/api/user')().user_id
  signin: require('./src/server/api/user')().signin
  request: require('./src/server/api/request')().send
  req_spaces: require('./src/server/api/request')().filter_spaces
  time_interval: require('./src/server/api/request')().all_time_interval
  type_space: require('./src/server/api/request')().all_type_space
  type_request: require('./src/server/api/request')().all_type_request
  options_by_space: require('./src/server/api/request')().all_options_by_space
  t_space: require('./src/server/api/t_space')().get_all
  t_space_new: require('./src/server/api/t_space')().new
  t_space_update: require('./src/server/api/t_space')().update
  t_space_delete: require('./src/server/api/t_space')().delete

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
app.get '/signin', ROUTES.signin
app.get '/dashboard', [MIDDLEWARE.AUTH, MIDDLEWARE.USER_INFO], ROUTES.dashboard
app.get '/admin', [MIDDLEWARE.AUTH, MIDDLEWARE.USER_INFO], ROUTES.dashboard
app.get '/editor', [MIDDLEWARE.AUTH, MIDDLEWARE.USER_INFO], ROUTES.dashboard
app.get '/dashboard/request', [MIDDLEWARE.AUTH, MIDDLEWARE.USER_INFO, MIDDLEWARE.REQUEST_INFO], ROUTES.request
app.get '/dashboard/request/new', [MIDDLEWARE.AUTH, MIDDLEWARE.USER_INFO], ROUTES.new_request
app.get '/dashboard/all_request', [MIDDLEWARE.AUTH, MIDDLEWARE.USER_INFO], ROUTES.all_request
app.get '/dashboard/t_space', [MIDDLEWARE.AUTH, MIDDLEWARE.USER_INFO], ROUTES.t_space
app.get '/dashboard/t_space/new', [MIDDLEWARE.AUTH, MIDDLEWARE.USER_INFO], ROUTES.t_space_new
app.get '/dashboard/t_space/update', [MIDDLEWARE.AUTH, MIDDLEWARE.USER_INFO], ROUTES.t_space_update
app.get '/dashboard/t_space/delete', [MIDDLEWARE.AUTH, MIDDLEWARE.USER_INFO], ROUTES.t_space_delete

#ROUTING API
app.get '/api/users', API.users
app.post '/api/signin', API.signin
app.get '/api/users/:user_id', API.user
app.post '/api/request', API.request
app.get '/api/request/spaces', API.req_spaces
app.get '/api/request/interval', API.time_interval
app.get '/api/request/type_space', API.type_space
app.get '/api/request/type_request', API.type_request
app.get '/api/request/options', API.options_by_space
app.get '/api/t_space', API.t_space
app.post '/api/t_space/new', API.t_space_new
app.post '/api/t_space/update', API.t_space_update
app.post '/api/t_space/delete', API.t_space_delete
# catch 404 and forward to error handler
app.get '*', ROUTES.err404

# App
# ----------
IP = process.env.IP or '127.0.0.1'
PORT = process.env.PORT or 3000
server.listen PORT
#server.listen PORT, IP
_package = require './package.json'
console.log "#{_package.name} #{_package.version} is running on #{IP}:#{PORT}"