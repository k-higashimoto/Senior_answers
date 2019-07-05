let express = require('express');
let router  = express.Router();
let mysql   = require('mysql');


let mysqlSetting = {
  host:     'localhost',
  user:     'root',
  password: '',
  database: 'senior_answers'
};


router.get('/', function (req, res, next) {
  let connection = mysql.createConnection(mysqlSetting);

  connection.connect();

  let user_id = req.session.user_id;

  let query = `CALL show_user_profile(${user_id})`;
  connection.query(query, (err, results, fileds) => {
    if (err) {
      console.log(err.stack);
    }

    const USER = results[0][0];
    const DATA = {
        user_id:        USER["user_id"],
        nickname:       USER["nickname"],
        email:          USER["email"],
        kosen_name:     USER["kosen_name"],
        specialty_name: USER["specialty_name"],
        grade:          USER["grade"],
        kizuna_point:   USER["kizuna_point"]
    };

    res.render("mypage", DATA);
  });

  connection.end();
});


module.exports = router;
