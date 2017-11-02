pg = require 'pg'
async = require 'async'
_ = require 'lodash'
moment = require 'moment'
crypto = require 'crypto'
#queryIns = client.query 'SELECT * FROM public."Institution" as I'
#join = client.query 'SELECT * FROM public."User" INNER JOIN public."Institution" ON (public."User".ins_id = public."Institution".ins_id)'

class User
  constructor: () ->

  connect: (cb) ->
    connectionString = process.env.DATABASE_URL or 'postgres://postgres:root@localhost:5432/lendme'
    client = new (pg.Client)(connectionString)
    client.connect()
    cb? client

  get_users: (client, cb) ->
    query = client.query 'SELECT * FROM public."User" as U', (err, res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err
  
  get_user_by_id: (client, params, cb) ->
    query = client.query "SELECT * FROM public.\"User\" as U where U.user_id = '#{params}'", (err, res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err
  
  get_session_by_id: (client, params, cb) ->
    query = client.query "SELECT * FROM public.\"User\" as U INNER JOIN public.\"User_session\" as S ON U.user_id = S.user_id WHERE U.user_id = '#{params}'", (err, res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err
  
  create_session: (client, params, cb) ->
    id = crypto.createHash('md5').update(moment()).digest 'hex'
    date_created = moment()
    date_expired = moment().add 1, 'd'
    query = client.query "INSERT INTO public.\"User_session\" (ses_id, ses_date, user_id, ses_expiration, ses_state) VALUES (#{id}, #{date_created}, #{params}, #{date_expired}, #{true})", (err, res) ->
      if not err
        cb? res.rows
      else
        console.error err

module.exports =
  User: User
###
queryIns.on 'row', (row, result) ->
  result.addRow row

queryIns.on 'end', (result) ->
  console.log JSON.stringify(result.rows, null, '    ')

join.on 'row', (row, result) ->
  result.addRow row

join.on 'end', (result) ->
  console.log JSON.stringify(result.rows, null, '    ')
  client.end()
###