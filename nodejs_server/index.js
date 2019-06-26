// nodejs_server/index.js

const mysql = require('mysql');
const express = require('express');
var app = express();
const bodyParser = require('body-parser');

app.use(bodyParser.json());

var mysqlConnection = mysql.createConnection({
    host: 'remotemysql.com',
    user : 'SAnxkqsG09',
    password: 'UVPm0V5IwA',
    database : 'SAnxkqsG09'
});

mysqlConnection.connect((err) => {
    if(!err){
        console.log('DB connection succeeded.');
    } else {
        console.log('DB connection failed \n Error: ' + JSON.stringify(err, undefined, 2));
    }
});

app.listen(3000, () => console.log('Express server is running at port no : 3000'));

app.get('/ingredients', (req, res) => {
    mysqlConnection.query('SELECT * FROM ingredients', (err, rows, fields) => {
        if(!err){
            res.send(rows);
        } else {
            console.log(err);
        }
    })
});

app.get('/ingredients/:name', (req, res) => {
    mysqlConnection.query('SELECT * FROM ingredients WHERE Name = ?', [req.params.name], (err, rows, fields) => {
        if(!err){
           res.send(rows);
        } else {
            console.log(err);
        }
    })
})
