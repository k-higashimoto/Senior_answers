let express = require('express');
let mysql   = require('mysql');


let router = express.Router();


let mysqlSetting = {
  host:     'localhost',
  user:     'root',
  password: '',
  database: 'senior_answers'
};


router.get('/', function(req, res, next) {
  let connection = mysql.createConnection(mysqlSetting);

  connection.connect();

  let query = `CALL get_item_for_signup()`;
  connection.query(query, (err, results, fileds) => {
    let data = {
      "kosenList":      results[0],
      "specialtyList":  results[1]
    };

    res.render("signup", data);
  });

  connection.end();
});


router.post("/", (req, res, next) => {
  let connection = mysql.createConnection(mysqlSetting);

  connection.connect();

  let nickname         = req.body.nickname;
  let email            = req.body.email;
  let password         = req.body.password;
  let kosen_number     = req.body.kosen_number;
  let grade            = req.body.grade;
  let specialty_number = req.body.specialty_number;

  let query = `CALL add_user("${nickname}", "${email}", "${password}", ${kosen_number}, ${grade}, ${specialty_number}, "", "")`;
  connection.query(query, (err, results, fileds) => {

    res.redirect("signup/thanks-signup");
  });

  connection.end();
});


router.get("/thanks-signup", (req, res, next) => {
  res.render("thanks-signup");
});


module.exports = router;
