let express = require('express');
let router  = express.Router();


router.get('/', function(req, res, next) {
  res.redirect("login");
});


module.exports = router;
