const express = require('express')
const mysql = require('mysql2')
const cors = require('cors')
const https = require('https')
const fs = require('fs')
const os = require('os')
const CONFIG = require('./.server_config.json')


const connection = mysql.createConnection({
  host: CONFIG.host,
  user: CONFIG.user,
  password: CONFIG.password,
  database: CONFIG.database
})

connection.connect()

const app = express()
app.use(cors()) // This is for flutter to work, the exact reason isn't researched
const port = 443


/**
 * @api {get} Hello
 * @apiDescription Responds to the '/hello' suffix with the webserver's and the system's uptime.
 */
app.get('/hello', (req, res) => {
	res.json([
    "Hello! The database is live.",
    "The server has been up for " + process.uptime() + " seconds",
    "The system has been up for " + os.uptime() + " seconds"
  ])
})

/**
 * @api {get} Score
 * @apiDescription Retrieve each subcategory's score and overall score for each institution
 */
app.get('/score', (req, res) => {
  connection.query('CALL GetSchoolScores', (err, rows) => {
    if (err) {
      res.status(500).json({ error: 'CALL GetSchoolScore failed' })
      return
    }
    res.json(rows[0])
  })
})

/**
 * @api {get} Averages
 * @apiDescription Retrieve average male and female executive pay for each institution
 */
app.get('/averages', (req, res) => {
  connection.query('CALL GetAverages', (err, rows) => {
    if (err) {
      res.status(500).json({ error: 'CALL GetAverages failed' })
      return
    }
    res.json(rows[0])
  })
})

/**
 * @api {get} Metadata
 * @apiDescription Retrieve state (location), institution ownership,
 * and financial structure metadata for each institution
 */
app.get('/metadata', (req, res) => {
  connection.query('CALL GetMetadata', (err, rows) => {
    if (err) {
      res.status(500).json({ error: 'CALL GetMetadata failed' })
      return
    }
    res.json(rows[0])
  })
})

/**
 * @api {get} Data
 * @apiDescription Retrieve data of an institution by its UID
 */
app.get('/data', (req, res) => {
  if (req.query.uids.match('^[0-9, ]*$')) {
    connection.query('CALL GetSchoolData(?)', [req.query.uids], (err, rows) => {
      if (err) {
        res.status(500).json({ error: 'CALL GetSchoolData failed: ' + err });
        return;
      }
      res.json(rows[0]);
    });
  } else {
    // If string validation fails, then don't query the database
    res.status(400).json({ error: "The provided list of UIDs contains illegal characters outside [0-9, ' ' (space), ',' (comma)]" });
  }
});

const options = {
  key: fs.readFileSync(CONFIG.key),
  cert: fs.readFileSync(CONFIG.cert),
}

https.createServer(options, app).listen(port, () => {
  console.log(`HTTPS server running on port ${port}`)
})
