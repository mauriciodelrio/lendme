const pg = require('pg');
const connectionString = process.env.DATABASE_URL || 'postgres://mauricio:root@localhost:5432/lendme';

const client = new pg.Client(connectionString);
client.connect();
const query = client.query(
  'CREATE TABLE example(id SERIAL PRIMARY KEY, text VARCHAR(40) not null, complete BOOLEAN)');
query.on('end', () => { client.end(); });