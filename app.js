let createError   = require("http-errors");
let express       = require("express");
let path          = require("path");
let cookieParser  = require("cookie-parser");
let logger        = require("morgan");
let session       = require("express-session");


let indexRouter           = require("./routes/index");
let loginRouter           = require("./routes/login");
let logoutRouter          = require("./routes/logout");
let signupRouter          = require("./routes/signup");
let mypageRouter          = require("./routes/mypage");
let questionSquareRouter  = require("./routes/question-square");


let app = express();

// view engine setup
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));


let session_opt = {
  secret: "secret",
  resave: false,
  saveUninitialized: false,
  cookie:{
    httpOnly: true,
    secure: false,
    maxage: 1000 * 60 * 30
  }
};
app.use(session(session_opt));


app.use("/", indexRouter);
app.use("/login", loginRouter);
app.use("/logout", logoutRouter);
app.use("/signup", signupRouter);
app.use("/mypage", mypageRouter);
app.use("/question-square", questionSquareRouter);


// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render("error");
});


module.exports = app;
