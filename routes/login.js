let express = require('express');
let mysql   = require('mysql');
let bcrypt  = require('bcrypt');


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

  let query = `CALL login("${email}")`;
  connection.query(query, (err, results, fileds) => {

    // ユーザーの認証
    // ユーザーが存在するか
    if (results[0] == false) {
      res.render("login");
    }

    // ユーザーのパスワードは正しいか
    let user = results[0][0];
    if (bcrypt.compareSync(password, user.password)) {
      req.session.login   = true;
      req.session.user_id = user.user_id;
      
      res.redirect("/question-square");
    
    } else {
      res.render("login");
    }
  });

  connection.end();
});


module.exports = router;
