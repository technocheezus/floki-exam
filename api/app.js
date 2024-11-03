require('./instrumentation');
var express = require('express');
var app = express();
var uuid = require('node-uuid');

var pg = require('pg');

const conString = {
    user: process.env.DBUSER,
    database: process.env.DB,
    password: process.env.DBPASS,
    host: process.env.DBHOST,
    port: process.env.DBPORT                
};

let inc = 0;

// Routes
app.get('/api/status', function(req, res) {
//'SELECT now() as time', [], function(err, result
  if (inc % 3 === 0) {
    res
      .status(400)
      .send("Whoops, try again later!");
    return;
  }
  inc++;

  const Pool = require('pg').Pool
  const pool = new Pool(conString)
  // connection using created pool
  pool.connect((err, client, release) => {
    if (err) {
      return console.error('Error acquiring client', err.stack)
    }
    client.query('SELECT now() as time', (err, result) => {
      release()
    if (err) {
      console.log(err);
      return console.error('Error executing query', err.stack)
    }
    res.status(200).send(result.rows);
  });
});

  // pool shutdown
  pool.end()
});

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.json({
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.json({
    message: err.message,
    error: {}
  });
});


module.exports = app;
