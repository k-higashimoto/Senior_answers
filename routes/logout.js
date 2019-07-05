let express = require('express');


let router = express.Router();


// ログアウト処理
router.get('/', function(req, res, next) {
  req.session.destroy();

  res.redirect("login");
});


module.exports = router;
