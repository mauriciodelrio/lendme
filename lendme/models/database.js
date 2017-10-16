const pg = require('pg');
const connectionString = process.env.DATABASE_URL || 'postgres://postgres:root@localhost:5432/lendme';

const client = new pg.Client(connectionString);
client.connect();
const query = client.query('SELECT * FROM public.User as U');
const queryIns = client.query('SELECT * FROM public."Institution" as I');
const join = client.query('SELECT * FROM public."User" INNER JOIN public."Institution" ON (public."User".ins_id = public."Institution".ins_id)');

query.on("row", function (row, result) {
    result.addRow(row);
});
query.on('end', (result) => { 
  console.log(JSON.stringify(result.rows, null, "    "));
});

queryIns.on("row", function (row, result) {
  result.addRow(row);
});
queryIns.on('end', (result) => { 
console.log(JSON.stringify(result.rows, null, "    ")); 
});

join.on("row", function (row, result) {
  result.addRow(row);
});
join.on('end', (result) => { 
console.log(JSON.stringify(result.rows, null, "    "));
client.end(); 
});