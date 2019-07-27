const mysql = require('mysql');
const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const path = require('path');

const UsersRouter = require('./users/routes.config');
const AuthorizationRouter = require('./authorization/routes.config');

app.use(bodyParser.json());


var mysqlConnection = mysql.createConnection({
    host: 'remotemysql.com',
    user : 'SAnxkqsG09',
    password: 'zvF4VuAySz',
    database : 'SAnxkqsG09'
});

mysqlConnection.connect((err) => {
    if(!err){
        console.log('DB connection succeeded.');
    } else {
        console.log('DB connection failed \n Error: ' + JSON.stringify(err, undefined, 2));
    }
});

app.listen(process.env.PORT || 3000, () => console.log('Express server is running at port no : 3000'));

UsersRouter.routesConfig(app);
AuthorizationRouter.routesConfig(app);

app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname, 'index.html'));
});

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

