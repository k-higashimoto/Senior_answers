-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 2019 年 7 朁E03 日 08:41
-- サーバのバージョン： 10.1.31-MariaDB
-- PHP Version: 7.2.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `senior_answers`
--

DELIMITER $$
--
-- プロシージャ
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_user` (IN `in_nickname` VARCHAR(20) CHARSET utf8, IN `in_email` VARCHAR(20) CHARSET utf8, IN `in_password` VARCHAR(20) CHARSET utf8, IN `in_kosen_number` INT(3), IN `in_grade` INT(1), IN `in_specialty_number` INT(3), IN `in_self_introduction` VARCHAR(255) CHARSET utf8, IN `in_interest` VARCHAR(20) CHARSET utf8)  NO SQL
BEGIN
    INSERT INTO users(nickname, email, password, kosen_number, specialty_number, grade, self_introduction, interest)
    VALUES (in_nickname, in_email, in_password, in_kosen_number, in_specialty_number, in_grade, in_self_introduction, in_interest);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_item_for_signup` ()  NO SQL
BEGIN
	CALL get_kosen_list();
    CALL get_specialty_list();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_kosen_list` ()  NO SQL
BEGIN
	SELECT kosen_number, kosen_name FROM kosen;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_specialty_list` ()  NO SQL
BEGIN
	SELECT specialty_number, specialty_name FROM specialty;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login` (IN `in_email` VARCHAR(20) CHARSET utf8, IN `in_password` VARCHAR(20) CHARSET utf8)  BEGIN
    SELECT user_id, email, password FROM users
    WHERE  email = in_email AND password = in_password;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `post_answer_for_question` (IN `in_question_number` INT(8), IN `in_answer_person` INT(8), IN `in_message` TEXT CHARSET utf8)  NO SQL
BEGIN
    INSERT INTO answers (question_number, answer_person, message) VALUES
    (in_question_number, in_answer_person, in_message);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `post_new_question` (IN `in_question_person` INT(8), IN `in_title` VARCHAR(20) CHARSET utf8, IN `in_message` TEXT CHARSET utf8mb4)  NO SQL
BEGIN
    INSERT INTO questions(question_person, title, message)
    VALUES(in_question_person, in_title, in_message);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_answers_for_question` (IN `in_question_number` INT(8))  NO SQL
SELECT users.user_id, users.nickname, answers.message, answers.created_at from answers
INNER JOIN questions on answers.question_number = questions.question_number
INNER JOIN users on answers.answer_person = users.user_id
WHERE answers.question_number = in_question_number
ORDER BY answers.created_at DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_question_detail` (IN `in_question_number` INT(8))  NO SQL
BEGIN
    SELECT question_number, users.nickname, title, message, fixed, created_at FROM questions
    INNER JOIN users
 	ON questions.question_person = users.user_id
    WHERE question_number = in_question_number;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_question_threads` ()  NO SQL
BEGIN
    SELECT question_number, users.nickname, title, message, fixed, created_at 		FROM questions
    INNER JOIN users
 	ON questions.question_person = users.user_id
    ORDER BY questions.created_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_question_thread_details` (IN `in_question_number` INT)  NO SQL
BEGIN
    SELECT question_number, users.user_id, users.nickname, title, message, fixed, created_at 		FROM questions
    INNER JOIN users
 	ON questions.question_person = users.user_id
    WHERE question_number = in_question_number;
    CALL show_answers_for_question(in_question_number);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_user_profile` (IN `id` INT(8))  BEGIN
    SELECT user_id, nickname, email, kosen_name, specialty_name, grade, kizuna_point FROM users
    INNER JOIN kosen on users.kosen_number = kosen.kosen_number
    INNER JOIN specialty on users.specialty_number = specialty.specialty_number
    WHERE user_id = id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- テーブルの構造 `answers`
--

CREATE TABLE `answers` (
  `answer_number` int(8) NOT NULL,
  `question_number` int(8) NOT NULL,
  `answer_person` int(8) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- テーブルのデータのダンプ `answers`
--

INSERT INTO `answers` (`answer_number`, `question_number`, `answer_person`, `message`, `created_at`) VALUES
(3, 2, 3, 'int型とは整数の箱です', '2019-06-29 19:52:05'),
(11, 4, 4, '確かに難しいですね。', '2019-07-01 21:23:41'),
(12, 4, 2, '自主的に学習していくことが\r\n望まれます。', '2019-07-01 21:25:09'),
(13, 4, 7, 'あの教科は難しい。', '2019-07-02 20:57:27'),
(14, 4, 9, '先生の話をしっかり聞くように', '2019-07-02 21:19:49'),
(15, 4, 10, '配布資料をしっかり見ましょう', '2019-07-02 21:32:21'),
(17, 4, 3, '確かにあれは難しい', '2019-07-03 15:00:18');

-- --------------------------------------------------------

--
-- テーブルの構造 `kosen`
--

CREATE TABLE `kosen` (
  `kosen_number` int(3) NOT NULL,
  `kosen_name` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- テーブルのデータのダンプ `kosen`
--

INSERT INTO `kosen` (`kosen_number`, `kosen_name`) VALUES
(1, '旭川'),
(2, '釧路'),
(3, '苫小牧'),
(4, '函館'),
(5, '八戸'),
(6, '一関'),
(7, '仙台'),
(8, '秋田'),
(9, '鶴岡'),
(10, '福島'),
(11, '茨城'),
(12, '小山'),
(13, '群馬'),
(14, '木更津'),
(15, '東京'),
(16, 'サレジオ'),
(17, '産業技術'),
(18, '長岡'),
(19, '富山'),
(20, '本郷'),
(21, '射水'),
(22, '石川'),
(23, '国際'),
(24, '福井'),
(25, '長野'),
(26, '岐阜'),
(27, '沼津'),
(28, '豊田'),
(29, '鈴鹿'),
(30, '鳥羽'),
(31, '近畿'),
(32, '舞鶴'),
(33, '大阪'),
(34, '神戸'),
(35, '明石'),
(36, '奈良'),
(37, '和歌山'),
(38, '米子'),
(39, '松江'),
(40, '津山'),
(41, '呉'),
(42, '広島商船'),
(43, '宇部'),
(44, '大島商船'),
(45, '徳山'),
(46, '阿南'),
(47, '香川'),
(48, '新居浜'),
(49, '弓削商船'),
(50, '高知'),
(51, '有明'),
(52, '北九州'),
(53, '久留米'),
(54, '佐世保'),
(55, '熊本'),
(56, '大分'),
(57, '都城'),
(58, '鹿児島'),
(59, '沖縄'),
(60, '函館'),
(61, '富士和裁'),
(62, '大島商船');

-- --------------------------------------------------------

--
-- テーブルの構造 `questions`
--

CREATE TABLE `questions` (
  `question_number` int(8) NOT NULL,
  `question_person` int(8) NOT NULL,
  `title` varchar(30) NOT NULL,
  `message` text NOT NULL,
  `fixed` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- テーブルのデータのダンプ `questions`
--

INSERT INTO `questions` (`question_number`, `question_person`, `title`, `message`, `fixed`, `created_at`) VALUES
(1, 3, 'photoshopのレイヤー機能がわかりません', '今、photoshopを使っているんですが、\r\nレイヤー機能がよく理解できません。\r\n\r\n誰か教えてください！！', 1, '2019-06-01 00:00:00'),
(2, 2, 'C言語分からん', 'C言語の使い方がよくわかりません。\r\n特にint型ってなんですか？', 1, '2019-06-01 00:00:00'),
(4, 3, 'メディア情報分からん', 'オクターブの使い方が全然わかりません', 0, '2019-06-29 00:00:00'),
(5, 7, 'ロバート先生について', 'ロバート先生についてどう思いますか？\r\nだれか教えてください', 0, '2019-07-02 20:58:31'),
(6, 9, '情報数学わからん', '情報数学がわかりません。\r\n特にカルノー図や、論理回路や必要十分条件とかがわかりません！', 0, '2019-07-02 21:21:39'),
(7, 17, 'インターンについて', 'インターンシップの優良企業を教えてください！！', 0, '2019-07-03 15:32:02');

-- --------------------------------------------------------

--
-- テーブルの構造 `specialty`
--

CREATE TABLE `specialty` (
  `specialty_number` int(3) NOT NULL,
  `specialty_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- テーブルのデータのダンプ `specialty`
--

INSERT INTO `specialty` (`specialty_number`, `specialty_name`) VALUES
(1, '電子・電気'),
(2, '機械'),
(3, '情報'),
(4, 'メディア'),
(5, '経営'),
(6, '国際');

-- --------------------------------------------------------

--
-- テーブルの構造 `users`
--

CREATE TABLE `users` (
  `user_id` int(8) NOT NULL,
  `nickname` varchar(20) NOT NULL,
  `email` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `kosen_number` int(3) NOT NULL,
  `specialty_number` int(3) NOT NULL,
  `grade` int(1) NOT NULL,
  `self_introduction` varchar(255) DEFAULT NULL,
  `interest` varchar(20) DEFAULT NULL,
  `kizuna_point` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- テーブルのデータのダンプ `users`
--

INSERT INTO `users` (`user_id`, `nickname`, `email`, `password`, `kosen_number`, `specialty_number`, `grade`, `self_introduction`, `interest`, `kizuna_point`) VALUES
(1, 'admin', 'admin@.ac.jp', 'password', 23, 3, 3, '', '', 99999),
(2, '金魚', 'kingyo@ac.jp', 'password', 4, 4, 3, 'とてもとてもよろしく', 'ドローン', 25),
(3, 'ユッキーナ', 'misa@ac.jp', 'password', 33, 5, 1, '初心者ですがよろしくお願いします', 'VR', 300),
(4, 'ブクブク茶釜', 'bukubuku@ac.jp', 'password', 16, 6, 5, 'どうも～', 'アルゴリズム', 2456),
(9, '★ZUN★', 'zun@ac.jp', 'password', 23, 3, 4, '', '', 0),
(10, 'TKG', 'tkg@ac.jp', 'password', 2, 6, 1, '', '', 0),
(17, '邪王心眼', 'zyaou@ac.jp', 'password', 56, 3, 5, '', '', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `answers`
--
ALTER TABLE `answers`
  ADD PRIMARY KEY (`answer_number`),
  ADD KEY `answer_person` (`answer_person`),
  ADD KEY `question_number` (`question_number`);

--
-- Indexes for table `kosen`
--
ALTER TABLE `kosen`
  ADD PRIMARY KEY (`kosen_number`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`question_number`);

--
-- Indexes for table `specialty`
--
ALTER TABLE `specialty`
  ADD PRIMARY KEY (`specialty_number`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `kosen_number` (`kosen_number`),
  ADD KEY `specialty_number` (`specialty_number`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `answers`
--
ALTER TABLE `answers`
  MODIFY `answer_number` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `kosen`
--
ALTER TABLE `kosen`
  MODIFY `kosen_number` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `question_number` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `specialty`
--
ALTER TABLE `specialty`
  MODIFY `specialty_number` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- ダンプしたテーブルの制約
--

--
-- テーブルの制約 `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`kosen_number`) REFERENCES `kosen` (`kosen_number`),
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`specialty_number`) REFERENCES `specialty` (`specialty_number`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
