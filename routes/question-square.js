let express = require('express');
let mysql = require('mysql');


let router = express.Router();


let mysqlSetting = {
  host:     'localhost',
  user:     'root',
  password: '',
  database: 'senior_answers'
};


// 質問一覧ページ
router.get("/", (req, res, next) => {
  if (!req.session.login) {
    res.redirect("/login");
  }

  let connection = mysql.createConnection(mysqlSetting);

  connection.connect();

  let query = "CALL show_question_threads()";
  connection.query(query, (err, results, fileds) => {
    let data = {
      "questionList": results[0]
    }

    res.render("question-square", data);
  });

  connection.end();
});


// 質問詳細ページ
router.get("/details/:q", (req, res, next) => {
  if (!req.session.login) {
    res.redirect("/login");
  }

  let connection = mysql.createConnection(mysqlSetting);

  connection.connect();

  let question_number = req.params.q;
  let query = `CALL show_question_thread_details(${question_number})`;
  connection.query(query, (err, results, fileds) => {
    
    let question = results[0][0];
    let answers  = results[1];
    let data = {
      "question_number":  question_number,
      "user_id":          question.user_id,
      "title":            question.title,
      "message":          question.message,
      "nickname":         question.nickname,
      "created_at":       question.created_at,
      "answerList":       answers
    };

    res.render("question-square-details", data);
  });

  connection.end();
});


// 回答投稿時の処理
router.post("/details/:q", (req, res, next) => {
  if (!req.session.login) {
    res.redirect("/login");
  }

  let connection = mysql.createConnection(mysqlSetting);

  connection.connect();

  let question_number = req.params.q;
  let user_id         = req.session.user_id;
  let message         = req.body.message;
  
  let query = `CALL post_answer_for_question(${question_number}, ${user_id}, '${message}')`;
  connection.query(query, (err, results, fileds) => {
    
    res.redirect(`/question-square/details/${question_number}`);
  });

  connection.end();
})


// 質問投稿ページ
router.get("/post", (req, res, next) => {
  if (!req.session.login) {
    res.redirect("/login");
  }

  res.render("post-new-question");
})


// 質問投稿時の処理
router.post("/post", (req, res, next) => {
  if (!req.session.login) {
    res.redirect("/login");
  }

  let connection = mysql.createConnection(mysqlSetting);

  connection.connect();

  let user_id = req.session.user_id;
  let title   = req.body.title;
  let message = req.body.message;

  let query = `CALL post_new_question(${user_id}, "${title}", "${message}")`;
  connection.query(query, (err, results, fileds) => {
    
    res.redirect("/question-square");
  });

  connection.end();
})


module.exports = router;
