pg = require 'pg'
connectionString = process.env.DATABASE_URL or 'postgres://postgres:root@localhost:5432/lendme'
client = new (pg.Client)(connectionString)
client.connect()
query = client.query 'SELECT * FROM public.User as U'
queryIns = client.query 'SELECT * FROM public."Institution" as I'
join = client.query 'SELECT * FROM public."User" INNER JOIN public."Institution" ON (public."User".ins_id = public."Institution".ins_id)'

query.on 'row', (row, result) ->
  result.addRow row

query.on 'end', (result) ->
  console.log JSON.stringify(result.rows, null, '    ')

queryIns.on 'row', (row, result) ->
  result.addRow row

queryIns.on 'end', (result) ->
  console.log JSON.stringify(result.rows, null, '    ')

join.on 'row', (row, result) ->
  result.addRow row

join.on 'end', (result) ->
  console.log JSON.stringify(result.rows, null, '    ')
  client.end()
