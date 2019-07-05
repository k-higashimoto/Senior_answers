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
  res.render("login");
});


router.post("/", (req, res, next) => {
  let connection = mysql.createConnection(mysqlSetting);

  connection.connect();

  let email    = req.body.email;
  let password = req.body.password;

  let query = `CALL login("${email}", "${password}")`;
  connection.query(query, (err, results, fileds) => {
    // ユーザーの認証
    if (results[0] == false) {
      res.render("login");

    } else {
      let user = results[0][0];

      req.session.login   = true;
      req.session.user_id = user.user_id;
      
      res.redirect("/question-square");
    }
  });

  connection.end();
});


module.exports = router;
