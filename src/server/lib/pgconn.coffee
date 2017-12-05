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
      ((charset) -> charset.charAt Math.floor(Math.random() * charset.length)) 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0root789'
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

  hash: (length = 32) ->
    charset = ''
    Array.apply(0, Array(length)).map( ->
      ((charset) -> charset.charAt Math.floor(Math.random() * charset.length)) 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0root789'
    ).join ''

  get_request_by_user_id: (client, params, cb) ->
    query = client.query "SELECT * FROM public.\"Request\" as R WHERE R.user_id = '#{params}'", (err, res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err
  
  get_all_time_interval: (client, ins_id, cb) ->
    query = client.query "SELECT time_name,time_begin,time_end FROM public.\"Time_interval\" WHERE time_state = #{true} AND ins_id = '#{ins_id}' ORDER BY time_id ASC ", (err,res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err

  get_all_options: (client, ins_id, cb) ->
    query = client.query "SELECT opt_name FROM public.\"Option\" WHERE opt_state = #{true} AND ins_id = '#{ins_id}' ORDER BY opt_id ASC ", (err,res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err
  
  get_all_type_space: (client, ins_id, cb) ->
    query = client.query "SELECT type_spa_name FROM public.\"Type_space\" WHERE ins_id = '#{ins_id}' ORDER BY type_spa_id ASC ", (err,res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err
      
  get_request_by_state: (client, params, cb) ->
    #busca todas las request con cierto estado y de cierta institucion (params contiene el id de ins y el id del estado) 
    query = client.query "SELECT * FROM public.\"Request\" AS R WHERE R.state_req_id='#{params.state_req_id}' AND R.ins_id = '#{params.ins_id}'  ", (err,res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err
  

  check_spaces: (client, params, cb) ->
    #query que busca los espacios  con las preferencias (params)
    #falta condicion para las opciones quizas hacer join entre space,space_op?
    query = client.query "Select spa_name, spa_reference FROM public.\"Space\" WHERE spa_id NOT IN (SELECT spa_id FROM public.\"Schedule\" WHERE time_id ='#{params.time_id}' AND sch_date = '#{params.sch_date}') AND spa_state = #{true} AND type_spa_id = '#{params.type_spa_id}' AND ins_id = '#{params.ins_id}'", (err, res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err 

  new_request:(client, params, cb) ->
    id = crypto.createHash('md5').update(this.hash()).digest 'hex' #query que revisa el numero de solicitudes pendientes que tiene un usuario (quizas usar un if para ver si es necesario hacerlo?)
    query = client.query "SELECT COALESCE ((SELECT COUNT(user_id) FROM \"Request\" WHERE user_id ='#{params.user_id}' AND state_req_id = '3' GROUP BY user_id),0)" (err, res) ->
      if not err
        if res.rows[0].count(*) > 5 && res.rows[0].type_com_id = '1' #checkeo de si supera el maximo de solicitudes 
          #Notificar
          cb? "Ha superado el máximo de solicitudes"
        else      
          #query que agrega una request a la tabla
          query = client.query "INSERT INTO public. \"Request\" VALUES ('#{id}','#{params.ins_id}','#{params.user_id}','#{date}','#{params.time_id}','#{params.req_description}','#{params.type_req_id}','#{params.req_dependant}','#{false}',#{params.spa_id}) RETURNING *", (err, res) ->
            if not err
              cb? res.rows[0]
            else 
              console.error err
              cb? err 
      else
        console.error err
            #lo mismo que arriba

  change_request_dep:(client, params, cb) -> #query encargada de cambiar el estado de una solicitud
    query = client.query "UPDATE public.\"Request\" SET 'state_req_id = '#{params.state_req_id}' WHERE req_id = '#{params.req_id}'" , (err, res) ->
    if not err
      if params.state_req_id = '1' # 1 (de momento) significa que aprueba la solicitud lo que hace una query para sacar los datos necesarios para agregar un schedule
        query = client.query "SELECT * From public.\"Request\" AS R INNER JOIN public.\"Community\" AS C ON R.user_id = C.user_id INNER JOIN public.\"Space\" AS S ON S.spa_id = R.spa_id WHERE R.req_id = '#{params.req_id}'", (err, res) ->
        if not err
          params2 =  
            adm_id = params.adm_id
            sch_date = res.rows[0].req_date
            sch_capacity = res.rows[0].spa_capacity
            type_sch_id = params.type_sch_id
            com_id = res.rows[0].com_id
            time_id = res.rows[0].time_id
            spa_id = res.rows[0].spa_id
            ins_id = res.rows[0].ins_id
          this.req_to_sch client , params2 , (resp) -> ## es necesario escribir algo mas aca?
            if resp
              cb? resp
            else
              cb? "Error al crear registro"
        else
          console.error err
          cb? err
      else
        cb? "0"
    else
      console.error err
      cb? err

  req_to_sch: (client, params, cb) ->
    id = crypto.createHash('md5').update(this.hash()).digest 'hex' #query que agrega un schedule
    query = client.query "INSERT INTO public.\"Schedule\" (sch_id, adm_id, com_id, sch_date, time_id, spa_id, sch_description, type_sch_id, sch_capacity, ins_id, sch_state) VALUES ('#{id},'#{params.adm_id}','#{params.com_id}','#{params.sch_date}','#{params.time_id}','#{params.spa_id}','#{params.type_sch_id}','#{params.sch_capacity}','#{params.ins_id}',#{true}) RETURNING *", (err, res) -> 
      if not err
        cb? res.rows
      else
        console.error err
        cb? err

  #este no se si va aca
  get_all_schedules:(client, ins_id, cb) ->
    query = client.query "SELECT * FROM public.\"Schedule\" WHERE sch_state = #{true} AND ins_id = '#{ins_id}' ORDER BY sch_id ASC ", (err, res) ->
      if not err
        cb? res.rows
      else
        console.error err
        cb? err

class Basic
  constructor: () ->

  connect: (cb) ->
    connectionString = process.env.DATABASE_URL or 'postgres://postgres:root@localhost:5432/lendme'
    client = new (pg.Client)(connectionString)
    client.connect()
    cb? client

  mant_type_space:(client,params,cb) ->
    if params.trans = 'I'
      query = client.query "INSERT INTO public.\"Type_space\"(type_spa_id, ins_id, type_spa_name, type_spa_date) VALUES ('#{params.type_spa_id}','#{params.ins_id}','#{params_type_spa_name}','#{params.type_spa_date}') RETURNING *", (err,res) ->
        if not err
          cb? res.rows[0]
        else
          console.error err
    if params.trans = 'U'
      query = client.query "UPDATE public.\"Type_space\" type_spa_name='#{params.type_spa_name}' WHERE type_spa_id = '#{params.type_spa_id}' RETURNING *", (err,res) ->
        if not err
          cb? {status: 'OK', data: res.rows[0]}
        else
          console.error err
    if params.trans = 'C'
      query = client.query "UPDATE public.\"Type_space\" type_spa_state='#{params.type_spa_state}' WHERE type_spa_id = '#{params.type_spa_id}' RETURNING *", (err,res) ->
        if not err
          cb? {status: 'OK', data: res.rows[0]}
        else
          console.error err



module.exports =
  User: User
  Request: Request
  Basic: Basic