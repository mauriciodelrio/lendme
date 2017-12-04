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
    connectionString = process.env.DATABASE_URL or 'postgres://postgres:h0l1b4by@localhost:5432/lendme'
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

  hash: (length = 32) ->
    charset = ''
    Array.apply(0, Array(length)).map( ->
      ((charset) -> charset.charAt Math.floor(Math.random() * charset.length)) 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    ).join ''

  crypt_pass: (pass) ->
    new_pass = crypto.createHash('md5').update(pass).digest 'hex'
    new_pass

  get_user_by_id: (client, params, cb) ->
    query = client.query "SELECT * FROM public.\"User\" as U WHERE U.user_id = '#{params}'", (err, res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err

  get_user_by_mail: (client, params, cb) ->
    query = client.query "SELECT * FROM public.\"User\" as U INNER JOIN public.\"Community\" as C ON U.user_id = C.user_id INNER JOIN public.\"Institution\" as I ON U.ins_id = I.ins_id WHERE U.user_mail = '#{params.mail}' AND U.user_password = '#{params.password}'", (err, res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err
  
  get_session_by_id: (client, params, cb) ->
    date_now = moment().format("YYYY-MM-DD HH:mm")
    query = client.query "SELECT * FROM public.\"User\" as U INNER JOIN public.\"User_session\" as S ON U.user_id = S.user_id WHERE U.user_id = '#{params}' AND S.ses_expiration > '#{date_now}'", (err, res) ->
      if not err
        cb? res.rows[0]
      else
        console.error err
        cb? err

  create_community: (client, params, cb) ->
    query = client.query "INSERT INTO public.\"User\" (user_id, user_date, ins_id, user_name, user_lastname, user_state, user_password, user_mail) VALUES (#{params.user_id}, #{params.user_date}, #{params.ins_id}, #{params.user_name}, #{params.user_lastname}, #{params.user_state}, #{params.user_password}, #{params.user_mail})", (err, res) ->
      if not err
        query = client.query "INSERT INTO public.\"Community\" (com_id, com_date, type_com_id, user_id) VALUES (#{params.com_id}, #{params.user_date}, #{params.type_com_id}, #{params.user_id})", (err, res) -> 
          if not err
            cb? res.rows
          else 
            console.error err
      else
        console.error err
  
  create_session: (client, params, cb) ->
    id = crypto.createHash('md5').update(this.hash()).digest 'hex'
    date_created = moment().format("YYYY-MM-DD HH:mm")
    date_expired = moment().add(1, 'd').format("YYYY-MM-DD HH:mm")
    console.log "estoy aca??"
    query = client.query "INSERT INTO public.\"User_session\" (ses_id, ses_date, user_id, ses_expiration, ses_state) VALUES ('#{id}', '#{date_created}', '#{params}', '#{date_expired}', #{true}) RETURNING *", (err, res) ->
      if not err
        cb? res.rows[0]
      else
        console.error err
  
  clean_old_sessions: (client, user_id, cb) ->
    date_now = moment().format("YYYY-MM-DD HH:mm")
    query = client.query "UPDATE public.\"User_session\" SET ses_state = #{false} WHERE user_id = '#{user_id}' AND ses_date < '#{date_now}' RETURNING *", (err, res) ->
      if not err
        cb? {status: 'OK', data: res.rows[0]}
      else
        console.error err

class Request
  constructor: () ->

  connect: (cb) ->
    connectionString = process.env.DATABASE_URL or 'postgres://postgres:h0l1b4by@localhost:5432/lendme'
    client = new (pg.Client)(connectionString)
    client.connect()
    cb? client

  get_request_by_user_id: (client, params, cb) ->
    query = client.query "SELECT * FROM public.\"Request\" as R WHERE R.user_id = '#{params}'", (err, res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err

module.exports =
  User: User
  Request: Request