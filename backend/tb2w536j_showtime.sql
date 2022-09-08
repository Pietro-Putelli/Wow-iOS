-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 04, 2019 at 03:33 PM
-- Server version: 5.6.39-cll-lve
-- PHP Version: 7.2.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tb2w536j_showtime`
--

-- --------------------------------------------------------

--
-- Table structure for table `activations`
--

CREATE TABLE `activations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` text NOT NULL,
  `date` date NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `activations`
--

INSERT INTO `activations` (`id`, `user_id`, `token`, `date`, `active`) VALUES
(12, 3, '5ca6843bcf64b113e1a4b3999f1c7aaa', '2018-09-25', 1),
(75, 157, 'd1377bad2e16b9574abd11b40d25d572', '2019-01-28', 0),
(74, 156, '65f2bc861da381a56bf34032a4734971', '2019-01-28', 0),
(73, 155, '54ae7d9b342d26cffb244b974f5a4632', '2019-01-21', 1),
(72, 154, '90cd953e034ad25a963a7f9c20ae45eb', '2019-01-14', 0),
(71, 153, '039ed15f0f1f5b6af557d207fce29b8d', '2018-12-29', 0),
(70, 151, '15837dd3c0fea9e4faa7e860c8c536d5', '2018-12-01', 0),
(69, 150, '1d4f3afe5412c7faef13d0eced48e884', '2018-11-28', 1),
(68, 148, 'cd4338643e444aad393fe0dbae5173db', '2018-11-22', 1),
(67, 147, '8ca9f98ed0c3b24d41aec2fb48a05468', '2018-11-22', 1),
(56, 136, '25177448aeda96db94ced05e1a90272f', '2018-11-21', 1),
(55, 38, '692f60ef09989eaf450c3ddbae24e75e', '2018-11-21', 1),
(66, 146, '7ee065fef64cd3621ca19a3119a8bdda', '2018-11-22', 0),
(76, 158, '804bb3251e4cb4d045a695a765f3a872', '2019-02-01', 0),
(77, 159, 'aa827a4c951144d6de2ea015239e0294', '2019-02-02', 0),
(78, 160, 'b019566a1c30f1c6b797a356ae9835dd', '2019-02-04', 0),
(79, 161, '3167f1dc0229d46a01cff1ed2dbf012d', '2019-02-06', 0),
(80, 162, '18ca1fb7f6d9a74cee92a6b64afe1af9', '2019-02-17', 0),
(81, 163, 'eac4776b248a7d3fda924e8ef3aa6938', '2019-02-17', 1),
(82, 164, 'beaaf35f72901b7082a12090f2cb9c31', '2019-02-17', 0),
(83, 165, 'f954928185724babad63c8c75052f7fa', '2019-02-17', 0),
(84, 166, 'c1aae20771f3bd8c90229fe61c0d1c7c', '2019-02-23', 0),
(85, 167, 'bba007bb8e77c86d444cd00e42a784d5', '2019-02-23', 0),
(86, 168, '2919aaae71849c381a01b08f24d9348f', '2019-02-23', 0),
(87, 169, 'ec871b6be4bdde3ea97d65046c39d170', '2019-02-23', 0),
(88, 170, '75dcb35c1889bfd0561d4e67940f746c', '2019-02-27', 0),
(89, 171, '1903755b60d72a2c8ad41eafef985fe5', '2019-03-05', 0),
(90, 172, '5f002f3918747217ab998d3f9f8a1e00', '2019-03-05', 1),
(91, 173, 'b30aa6f89e4e7b156e7d63857c3c9e49', '2019-03-05', 0),
(92, 174, '693bde4ec52be70a0cf282c9c19332f6', '2019-03-06', 0),
(93, 175, '7241f807087630ac60309a13a46be0c8', '2019-03-06', 1),
(94, 176, '3d983081f91e88a2c9558319f450f089', '2019-03-19', 0),
(95, 177, '227e86c86d33655caba77ba237b48f81', '2019-03-21', 0),
(96, 178, '893357c57f797afe22ee772aa891ea47', '2019-04-12', 0),
(97, 179, '11e83c49a73edceeaa54f87265fc4f7f', '2019-04-29', 0),
(98, 180, 'd4a810d10234ab17d71e6ff42f6059ff', '2019-04-29', 0),
(99, 181, '17a502d57399cd8a33d4db27279cfa57', '2019-05-05', 0),
(100, 182, 'cf278fa00f7df7bf276fa08d63c62d63', '2019-05-16', 0),
(101, 183, '6bd9a156ae4c20c0dfe409347b3be687', '2019-05-16', 0),
(102, 184, 'fd1e1c14f6788457d7c4a5aa9ee79044', '2019-05-27', 0),
(103, 185, 'c116462ac55e3815563d88ff1a314480', '2019-06-14', 0),
(104, 186, 'b0808dd85031186cba01f87f4b753372', '2019-06-14', 0),
(105, 187, 'd03dedd6946734b7e6bd86d7c4c9c1d5', '2019-06-14', 0),
(106, 188, 'b34dac155238c1d072f0d7e3421524e7', '2019-06-14', 0),
(107, 189, '89f5b49274c9bacb99f56051fa268a17', '2019-06-14', 0);

-- --------------------------------------------------------

--
-- Table structure for table `aphorisms`
--

CREATE TABLE `aphorisms` (
  `author` text NOT NULL,
  `aphorism` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `eventanswers`
--

CREATE TABLE `eventanswers` (
  `id` int(11) NOT NULL,
  `discussion_id` int(11) NOT NULL,
  `user_name` text NOT NULL,
  `user_email` text NOT NULL,
  `date` date NOT NULL,
  `answer_json` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `eventanswers`
--

INSERT INTO `eventanswers` (`id`, `discussion_id`, `user_name`, `user_email`, `date`, `answer_json`) VALUES
(12, 10, 'Martina_Putelli', 'martinaputelli@gmail.com', '2019-02-06', '{\n  \"title\" : \"ejheejejejejeheheheheharjesjhf\",\n  \"content\" : \"Smmesnjwwhwrhwrhwrhrwhwbrwrbwhrwhwhwhejherhehdbhehrhrrh\"\n}'),
(13, 11, 'PietroPutelli', 'pietroputelli80@gmail.com', '2019-02-08', '{\n  \"title\" : \"example discussion\",\n  \"content\" : \"Cajxejdwjwcjcwjfwkdkwfwkfwkcwkcwkcwkcwkkfwcwkwgkvwkvwkvwkwckfwkfwkcwjcwj\"\n}'),
(14, 10, 'PietroPutelli', 'pietroputelli80@gmail.com', '2019-02-07', '{\n  \"title\" : \"ho gnenwgnwg\",\n  \"content\" : \"Bqfwnggnwwngnwgwngegmwnfwbfgbwwngwnggnwwnggnwwbfengehngenwt\"\n}');

-- --------------------------------------------------------

--
-- Table structure for table `eventdiscussions`
--

CREATE TABLE `eventdiscussions` (
  `id` int(11) NOT NULL,
  `user_name` text NOT NULL,
  `user_email` text NOT NULL,
  `event_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `discussion_json` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `eventdiscussions`
--

INSERT INTO `eventdiscussions` (`id`, `user_name`, `user_email`, `event_id`, `date`, `discussion_json`) VALUES
(11, 'PietroPutelli', 'pietroputelli80@gmail.com', 72, '2019-02-08', '{\n  \"title\" : \"jjybgbhh\",\n  \"content\" : \"Btbrhrntnfbnfnfngnffnnfg ng gnmggn fnff fnfngn Fing fn\"\n}'),
(10, 'PietroPutelli', 'pietroputelli80@gmail.com', 69, '2019-02-09', '{\n  \"title\" : \"ncekrckececkecmece\",\n  \"content\" : \"Wxcenxwndencwmxwmxwkeckecjejcejecjevjcekececkkececkkcekcekce\"\n}'),
(13, 'Pietro Putelli', 'pietroputelli80@gmail.com', 69, '2019-06-22', '{\n  \"title\" : \"discussion \",\n  \"content\" : \"Djcjjdnsjxjejfjdjfjfjfjcjdjjejfjfjsjcjdjsnncndnxjdncjdj\"\n}');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `owner` text NOT NULL,
  `local_id` int(11) NOT NULL,
  `going` int(11) NOT NULL,
  `likes` int(11) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `to_date` date NOT NULL,
  `json_event` text NOT NULL,
  `active` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `owner`, `local_id`, `going`, `likes`, `latitude`, `longitude`, `to_date`, `json_event`, `active`) VALUES
(69, 'pietroputelli80@gmail.com', 32, 27, 78, 45.46320575288196, 9.189924921221916, '2019-03-19', '{\n  \"place\" : \"Bar@onda gianico\",\n  \"going\" : 0,\n  \"publicTransport\" : \"\",\n  \"title\" : \"E-mission festival\",\n  \"likes\" : 0,\n  \"toDate\" : \"19 Mar 2019\",\n  \"local_id\" : 32,\n  \"owner\" : \"pietroputelli80@gmail.com\",\n  \"city\" : \"Milan\",\n  \"ticket\" : \"\",\n  \"fromDate\" : \"16 Mar 2019\",\n  \"music\" : \"Rock, Jazz, Pop\",\n  \"atDate\" : \"12:23\",\n  \"details\" : \"Shshdksbcnsndndndndndndnnfafjajfaafjafjfjafjafjaafjfjafjafjaadj\",\n  \"info\" : \"\",\n  \"email\" : \"\",\n  \"webSite\" : \"\",\n  \"phone\" : \"33473764701\",\n  \"near\" : \"\",\n  \"vip\" : \"\",\n  \"setUpBy\" : \"Bar@onda\",\n  \"price\" : \"\",\n  \"parking\" : \"\",\n  \"address\" : \" Via Marconi  Milan\"\n}', 1),
(72, 'pietroputelli80@gmail.com', 11, 68, 77, 45.81726, 10.076212, '0000-00-00', '{\r\n	\"place\": \"Sul lago di Iseo\",\r\n	\"going\": 0,\r\n	\"publicTransport\": \"\",\r\n	\"title\": \"Beer event\",\r\n	\"likes\": 0,\r\n	\"toDate\": \"29 Nov 2018\",\r\n	\"owner\": \"pietroputelli80@gmail.com\",\r\n	\"city\": \"Artogne\",\r\n	\"ticket\": \"\",\r\n	\"fromDate\": \"29 Nov 2018\",\r\n	\"localID\": 0,\r\n	\"atDate\": \"21:00\",\r\n	\"details\": \"Oxfxpgpdydpydpydpypzydpyxpyxpypdypdydyp\",\r\n	\"music\": \"Rock, Jazz, Pop, Disco\",\r\n	\"info\": \"\",\r\n	\"email\": \"beerBar@gmail.com\",\r\n	\"webSite\": \"www.beerBar.com\",\r\n	\"phone\": \"035 983384\",\r\n	\"near\": \"\",\r\n	\"vip\": \"Dj Ernest\",\r\n	\"setUpBy\": \"La Lanterna Beer Bar & Pizza \",\r\n	\"price\": \"\",\r\n	\"parking\": \"Ampio parcheggio\",\r\n	\"address\": \"Via Giacomo Matteotti, 6, 24065 Lovere BG\"\r\n}', 1),
(70, 'pietroputelli80@gmail.com', 130, 15, 30, 45.7121773, 9.4753237, '2018-12-04', '{\n  \"place\" : \"Ristorante La Corte del Noce\",\n  \"going\" : 0,\n  \"publicTransport\" : \"\",\n  \"title\" : \"Il bollito misto piemontese\",\n  \"likes\" : 0,\n  \"toDate\" : \"04 Dec 2018\",\n  \"local_id\" : 130,\n  \"owner\" : \"pietroputelli80@gmail.com\",\n  \"city\" : \"Gianico\",\n  \"ticket\" : \"\",\n  \"fromDate\" : \"03 Dec 2018\",\n  \"music\" : \"Musica classica\",\n  \"atDate\" : \"12:10\",\n  \"details\" : \"Sjsjxkskkdmxkdjd\",\n  \"info\" : \"\",\n  \"email\" : \"\",\n  \"webSite\" : \"\",\n  \"phone\" : \"035 792277\",\n  \"near\" : \"\",\n  \"vip\" : \"\",\n  \"setUpBy\" : \"La corte del noce\",\n  \"price\" : \"\",\n  \"parking\" : \"\",\n  \"address\" : \"Via Alfredo Biffi, 8 Villa d Adda\"\n}', 1);

-- --------------------------------------------------------

--
-- Table structure for table `friends`
--

CREATE TABLE `friends` (
  `id` int(11) NOT NULL,
  `friend_json` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `localreviews`
--

CREATE TABLE `localreviews` (
  `id` int(11) NOT NULL,
  `user_name` text NOT NULL,
  `user_email` text NOT NULL,
  `local_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `date` date NOT NULL,
  `review_json` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `localreviews`
--

INSERT INTO `localreviews` (`id`, `user_name`, `user_email`, `local_id`, `rating`, `date`, `review_json`) VALUES
(58, 'Galileo Galilei', 'galileogalilei@yahoo.com', 11, 2, '2019-02-06', '{\n  \"title\" : \"hdjeecjjcasxj\",\n  \"content\" : \"Wcjcejscjcsjcajxqjxaksckvsjscjvsjcsjscjacjacjscjscwjcjcsvsjsvjcsjscjca\"\n}'),
(57, 'Galileo Galilei', 'galileogalilei@yahoo.com', 32, 4, '2019-02-07', '{\n  \"title\" : \"Sjdjsja\",\n  \"content\" : \"Scjxjasjwwxjscjcejcejcejwxjxwjwxjwxjwxjjxecejsckcekvkevkevkevkevdksvk\"\n}'),
(66, 'Albert Einstein', 'alberteinstein@gmail.com', 130, 4, '2019-02-08', '{\n  \"title\" : \"Ottimo ristorante\",\n  \"content\" : \"Ottimo ristorante, si mangia molto bene, personale amichevole e perfetta location.\"\n}'),
(67, 'Albert Einstein', 'alberteinstein@gmail.com', 32, 5, '2019-02-08', '{\n  \"title\" : \"good place\",\n  \"content\" : \"Djdjfjdjdjajdjfjskjwjdjsndjfjdjsjsjdjjfjfjffjckkdkfkfkdkdkdkdkdkdkwkwk\"\n}');

-- --------------------------------------------------------

--
-- Table structure for table `locals`
--

CREATE TABLE `locals` (
  `id` int(11) NOT NULL,
  `owner` text NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `rating` double NOT NULL,
  `images` varchar(60000) NOT NULL DEFAULT 'a:0:{}',
  `likes` int(11) NOT NULL DEFAULT '0',
  `json_local` text NOT NULL,
  `active` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `locals`
--

INSERT INTO `locals` (`id`, `owner`, `latitude`, `longitude`, `rating`, `images`, `likes`, `json_local`, `active`) VALUES
(11, 'pietroputelli80@gmail.com', 45.81534, 10.0729, 2, 'a:3:{i:0;s:26:\"IMG20181113102723909103035\";i:1;s:26:\"IMG20181113102723825772047\";i:2;s:25:\"IMG2018111310272426015043\";}', 123, '{\r\n  \"place\" : \"Sul lago di Iseo\",\r\n  \"phoneNumber\" : \"035 983384\",\r\n  \"title\" : \"La Lanterna Beer Bar & Pizza\",\r\n  \"likes\" : 0,\r\n  \"owner\" : \"pietroputelli80@gmail.com\",\r\n  \"coverImgPath\" : \"\",\r\n  \"parkingInfo\" : \"Ampio parcheggio\",\r\n  \"moreInfo\" : \"\",\r\n  \"city\" : \"Lovere\",\r\n  \"images\" : [\r\n    \"\"\r\n  ],\r\n  \"music\" : \"Rock, Jazz, Disco\",\r\n  \"timetable\" : [\r\n    \"11:00\",\r\n    \"23:00\",\r\n    \"11:00\",\r\n    \"23:00\",\r\n    \"11:00\",\r\n    \"23:00\",\r\n    \"11:00\",\r\n    \"23:00\",\r\n    \"11:00\",\r\n    \"23:00\",\r\n    \"11:00\",\r\n    \"23:00\",\r\n    \"11:00\",\r\n    \"23:00\"\r\n  ],\r\n  \"details\" : \"A pochi passi dal centro storico di Lovere, uno dei Borghi piu belli d\' Italia, direttamente sul lago con posizione panoramica, il locale La lanterna  vi accoglie in un ambiente caldo ed elegante ma non troppo formale.\",\r\n  \"quickInfo\" : [1,3,4,7,10,12],\r\n  \"nearInfo\" : \"Lago d Iseo\",\r\n  \"subtitle\" : \"Bar\",\r\n  \"webSite\" : \"http://www.pinocchioristorante.it/\",\r\n  \"email\" : \"lalanterna@gmail.com\",\r\n  \"rating\" : 0,\r\n  \"address\" : \"Via Giacomo Matteotti, 6 Lovere\",\r\n  \"ptInfo\" : \"\"\r\n}', 1),
(32, 'pietroputelli80@gmail.com', 45.8646177, 10.1773728, 4.5, 'a:3:{i:0;s:23:\"IMG20181229195746265053\";i:1;s:23:\"IMG20181229195780462980\";i:2;s:23:\"IMG20181229195906461000\";}', 96, '{\n  \"place\" : \"\",\n  \"phoneNumber\" : \"3347676270\",\n  \"title\" : \"Bar@onda\",\n  \"likes\" : 0,\n  \"owner\" : \"pietroputelli80@gmail.com\",\n  \"parkingInfo\" : \"\",\n  \"moreInfo\" : \"\",\n  \"city\" : \"Milan\",\n  \"music\" : \"\",\n  \"timetable\" : [\n    \"05:00\",\n    \"19:00\",\n    \"Close\",\n    \"Close\",\n    \"05:00\",\n    \"19:00\",\n    \"05:00\",\n    \"19:00\",\n    \"10:00\",\n    \"24:00\",\n    \"01:00\",\n    \"13:00\",\n    \"Close\",\n    \"Close\"\n  ],\n  \"details\" : \"Aperitivo ricchi e gustosi, ottima musica e drink rinfrescanti sia analcolici che alcolici molto buoni. Consigliato vivamente. Gli Eventi e le feste sono frequenti e molto belli. Locale accogliente e personale cordiale.\",\n  \"quickInfo\" : [\n    0,\n    1,\n    14,\n    7,\n    6,\n    9,\n    8\n  ],\n  \"numberOfReviews\" : 0,\n  \"subtitle\" : \"music bar club\",\n  \"webSite\" : \"\",\n  \"nearInfo\" : \"\",\n  \"email\" : \"\",\n  \"rating\" : 0,\n  \"address\" : \"via marconi 17 gianico\",\n  \"ptInfo\" : \"\"\n}', 1),
(130, 'pietroputelli80@gmail.com', 45.7121773, 9.4753237, 4, 'a:4:{i:0;s:26:\"IMG20181128224232660994052\";i:1;s:26:\"IMG20181128224232634791016\";i:2;s:26:\"IMG20181128224232589686036\";i:3;s:26:\"IMG20181128224232539320945\";}', 2, '{\r\n  \"place\" : \"\",\r\n  \"phoneNumber\" : \"3347676270\",\r\n  \"title\" : \"La corte del noce\",\r\n  \"likes\" : 0,\r\n  \"owner\" : \"pietroputelli80@gmail.com\",\r\n  \"parkingInfo\" : \"\",\r\n  \"moreInfo\" : \"\",\r\n  \"city\" : \"Villa d adda\",\r\n  \"music\" : \"\",\r\n  \"timetable\" : [\r\n    \"19:30\",\r\n    \"22:30\",\r\n    \"19:49\",\r\n    \"20:34\",\r\n    \"18:49\",\r\n    \"21:49\",\r\n    \"19:49\",\r\n    \"21:49\",\r\n    \"18:49\",\r\n    \"21:49\",\r\n    \"18:49\",\r\n    \"21:49\",\r\n    \"10:45\",\r\n    \"23:45\"\r\n  ],\r\n  \"details\" : \"In unâ€™oasi di pace, tra il verde lussureggiante delle colline bergamasche e lâ€™affascinante scenario del Parco dellâ€™Adda, sorge un antico casolare del 1400, dimora oggi del Ristorante La Corte del Noce. \",\r\n  \"quickInfo\" : [0,1,2,3,4,8,11,12,13,14],\r\n  \"numberOfReviews\" : 0,\r\n  \"subtitle\" : \"Ristorante\",\r\n  \"webSite\" : \"\",\r\n  \"nearInfo\" : \"\",\r\n  \"email\" : \"\",\r\n  \"rating\" : 0,\r\n  \"address\" : \"Via Alfredo Biffi 8 villa d adda\",\r\n  \"ptInfo\" : \"\"\r\n}', 1);

-- --------------------------------------------------------

--
-- Table structure for table `localsrating`
--

CREATE TABLE `localsrating` (
  `id` int(11) NOT NULL,
  `local_id` int(11) NOT NULL,
  `number_reviews` int(11) NOT NULL,
  `sum_reviews` int(11) NOT NULL,
  `rating` double NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `localsrating`
--

INSERT INTO `localsrating` (`id`, `local_id`, `number_reviews`, `sum_reviews`, `rating`) VALUES
(1, 32, 2, 9, 4.5),
(3, 11, 1, 2, 2),
(4, 130, 1, 4, 4),
(25, 152, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `quadris_followers`
--

CREATE TABLE `quadris_followers` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `follower_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `quadris_followers`
--

INSERT INTO `quadris_followers` (`id`, `user_id`, `follower_id`) VALUES
(104, 5, 9);

-- --------------------------------------------------------

--
-- Table structure for table `quadris_games`
--

CREATE TABLE `quadris_games` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `challenger_id` int(11) NOT NULL,
  `accepted` tinyint(1) NOT NULL,
  `turn` int(11) NOT NULL,
  `user_turn` int(11) NOT NULL,
  `json_moves` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `quadris_games`
--

INSERT INTO `quadris_games` (`id`, `user_id`, `challenger_id`, `accepted`, `turn`, `user_turn`, `json_moves`) VALUES
(327, 5, 9, 1, 0, 0, 'a:2:{i:0;a:5:{i:0;i:0;i:1;i:6;i:2;i:12;i:3;i:8;i:4;i:9;}i:1;a:5:{i:0;i:2;i:1;i:10;i:2;i:13;i:3;i:5;i:4;i:4;}}');

-- --------------------------------------------------------

--
-- Table structure for table `quadris_users`
--

CREATE TABLE `quadris_users` (
  `id` int(11) NOT NULL,
  `email` text NOT NULL,
  `username` text NOT NULL,
  `password` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `quadris_users`
--

INSERT INTO `quadris_users` (`id`, `email`, `username`, `password`) VALUES
(6, 'jostin@gmail.com', 'jostin_coca', 'jostin09'),
(5, 'pietroputelli80@gmail.com', 'Pietro', '123456789'),
(8, 'luigiputelli80@gmail.com', 'Luigi', '12345678'),
(9, 'mario@gmail.com', 'Mario', '12345678'),
(10, 'paololunini96@gmail.com', 'Osmany96', 'Cigolino96');

-- --------------------------------------------------------

--
-- Table structure for table `resetpassword`
--

CREATE TABLE `resetpassword` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(60000) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `resetpassword`
--

INSERT INTO `resetpassword` (`id`, `user_id`, `token`, `active`) VALUES
(150, 38, 'dfeeca8981c05a1791d5a6680f2b3aa7', 1),
(149, 171, '0ac0c12046e396a51880499d7cec38f3', 1),
(148, 160, 'ed80aaa4388dba80c0b91924ea8d47b4', 0),
(147, 38, '5fc93a282b8ce87c869902e66568697d', 1),
(146, 160, '25d19214051138b9f64f5f86afdb7afa', 0),
(145, 160, '86155073dde562c6e703df2abecef353', 1),
(144, 160, '731804b6972bf5ae1380c0bcf8b10346', 1),
(143, 38, 'e028d933532237e779f96b034cc2dc4b', 0),
(141, 0, 'aec41769f71c74a4d78b17b8634fabb2', 0),
(140, 0, '979f8887d1ad171b00f124cdc09177f3', 0),
(139, 0, '06151a89946ae311b195635056792d4c', 0),
(138, 0, 'c7e2a1a39ad6389f3f39f89b81c4456c', 0),
(137, 0, 'b3416aee7da1d5f7f38eea9ef8b1ad9b', 0),
(136, 0, '6239ad5efcc3d269c6fcb13b870a370f', 0),
(135, 152, 'e250aae24f0ca71d6ba04231c9754adf', 0),
(133, 152, '2579b3b39d13a79f158c9da8e30a9c25', 0),
(132, 152, '61f02913f26cf1daa25d4a206171f3e1', 0),
(131, 0, '46bfe8fdd7503b08f177cbef6fc7ca3f', 0),
(130, 146, 'a9ab2a108c58dab17f82a3e303314d22', 1),
(129, 0, 'a1c94020f7e159969c9a1fe9746b4b3e', 0),
(127, 0, '163e6f3b279b4d11dacf05399ba6cee0', 0),
(128, 0, 'f152f9d497ce302f5b3dc22296421337', 0),
(126, 0, '048795d38e66718078c63f7d7c6fcec3', 0),
(125, 0, 'da815dae04a7f1468404bb9701360e29', 0),
(134, 152, 'a223c41ba46ba5df4ae972b3b2db9937', 0),
(142, 0, 'bc04e0f2f837cb4272f0eb52e2293414', 0);

-- --------------------------------------------------------

--
-- Table structure for table `usereventfavourites`
--

CREATE TABLE `usereventfavourites` (
  `id` int(11) NOT NULL,
  `user_id` text NOT NULL,
  `event_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `usereventfavourites`
--

INSERT INTO `usereventfavourites` (`id`, `user_id`, `event_id`) VALUES
(72, 'pietroputelli80@gmail.com', 69),
(60, 'martinaputelli@gmail.com', 70),
(73, 'pietroputelli80@gmail.com', 70),
(68, 'martinaputelli@gmail.com', 69);

-- --------------------------------------------------------

--
-- Table structure for table `usereventgoing`
--

CREATE TABLE `usereventgoing` (
  `id` int(11) NOT NULL,
  `user_id` text NOT NULL,
  `event_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `usereventgoing`
--

INSERT INTO `usereventgoing` (`id`, `user_id`, `event_id`) VALUES
(63, 'pietroputelli80@gmail.com', 72),
(59, 'martinaputelli@gmail.com', 72),
(50, 'galileogalilei@yahoo.com', 69),
(64, 'pietroputelli80@gmail.com', 69),
(60, 'martinaputelli@gmail.com', 69);

-- --------------------------------------------------------

--
-- Table structure for table `userfriends`
--

CREATE TABLE `userfriends` (
  `id` int(11) NOT NULL,
  `user_id` text NOT NULL,
  `friend_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userfriends`
--

INSERT INTO `userfriends` (`id`, `user_id`, `friend_id`) VALUES
(211, 'pietroputelli80@gmail.com', 9),
(201, 'pietroputelli80@gmail.com', 16),
(98, 'galileogalilei@yahoo.com', 154),
(96, 'martinaputelli@gmail.com', 11),
(97, 'galileogalilei@yahoo.com', 38),
(114, 'martinaputelli@gmail.com', 38),
(210, 'pietroputelli80@gmail.com', 154),
(208, 'pietroputelli80@gmail.com', 11);

-- --------------------------------------------------------

--
-- Table structure for table `userlocalfavourites`
--

CREATE TABLE `userlocalfavourites` (
  `id` int(11) NOT NULL,
  `user_id` text NOT NULL,
  `local_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userlocalfavourites`
--

INSERT INTO `userlocalfavourites` (`id`, `user_id`, `local_id`) VALUES
(83, 'martinaputelli@gmail.com', 32),
(91, 'pietroputelli80@gmail.com', 154),
(104, 'pietroputelli80@gmail.com', 32);

-- --------------------------------------------------------

--
-- Table structure for table `usersaccount`
--

CREATE TABLE `usersaccount` (
  `id` int(11) NOT NULL,
  `username` text NOT NULL,
  `email` text NOT NULL,
  `password` text NOT NULL,
  `status` text NOT NULL,
  `followers` int(11) NOT NULL,
  `following` int(11) NOT NULL,
  `phone` text NOT NULL,
  `businessEmail` text NOT NULL,
  `webSite` text NOT NULL,
  `deviceToken` text NOT NULL,
  `logged` int(11) NOT NULL,
  `club_open` int(11) NOT NULL,
  `event_set` int(11) NOT NULL,
  `event_friend` int(11) NOT NULL,
  `follow` int(11) NOT NULL,
  `answer` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `usersaccount`
--

INSERT INTO `usersaccount` (`id`, `username`, `email`, `password`, `status`, `followers`, `following`, `phone`, `businessEmail`, `webSite`, `deviceToken`, `logged`, `club_open`, `event_set`, `event_friend`, `follow`, `answer`) VALUES
(9, 'Steve Jobs', 'isaacnewton@email.com', '123456', 'Stay hungry, Stay foolish', 16891, 28, '3347676270', '', '', '', 0, 1, 1, 1, 1, 0),
(154, 'Martina_Putelli', 'martinaputelli@gmail.com', '12345678', 'Ãˆ meglio pe', 0, 0, '', '', '', '01994be50b59d9b408a4be7f975fea0312270272f8e5039c55556bab8d02bde2', 1, 1, 1, 1, 1, 1),
(10, 'Albert Einstein', 'alberteinstein@gmail.com', '12345678', 'Non piangere perche e finito, sorridi perche e accaduto.', 0, 0, '', '', '', '', 0, 1, 1, 1, 1, 0),
(11, 'Galileo Galilei', 'galileogalilei@yahoo.com', '12345678', 'Eppur si muove!', 0, 0, '', '', '', 'c70c1a1f91ca19115143613d298356bd7d2e6d0420aaae54df3ea160b8dedae5', 0, 0, 0, 0, 1, 0),
(13, 'NiccoloCopernico', 'niccolocopernico@gmail.com', 'Eliocentrism', 'Vivi come se dovessi morire domani, impara come se dovessi vivere per sempre.', 0, 0, '', '', '', '', 0, 1, 1, 1, 1, 0),
(16, 'Emanuele Richini', 'emanuelerichini@gmail.com', '1234567', 'La vita Ã¨ fatta di giorno che non significano nulla e di momenti che significano tutto.', 0, 0, '', '', '', '', 0, 1, 1, 1, 1, 0),
(38, 'Pietro Putelli', 'pietroputelli80@gmail.com', '25d55ad283aa400af464c76d713c07ad', 'Uno per me vale diecimila, se Ã¨ il migliore.\nEraclito ', 0, 0, '3347676270', 'pietroputelli80@gmail.com', 'www.pietroputelli.com', '5f97ed3ea9a2b8aa8b0fbc94e951ab43faed2ff28c6f28f6b623a6c094f10b9b', 1, 0, 1, 0, 0, 0),
(150, 'Gianfranco', 'gianfranco.putelli80@gmail.com', '123456789', 'Per me uno vale centomila se Ã¨ migliore. Eraclito', 0, 0, '', '', '', 'c70c1a1f91ca19115143613d298356bd7d2e6d0420aaae54df3ea160b8dedae5', 0, 1, 1, 1, 1, 0),
(3, 'P3lle', 'nicolop3lle@gmail.com', 'Corvito', 'Sjdjdjjdjd', 0, 0, '', '', '', '7beb9f72ffc9ef60457a6b32381ffcecbeed99c6efea4acfeacb1f5e7b77e70e', 0, 1, 1, 1, 1, 0),
(146, 'Elon Musk', 'luigiputelli80@gmail.com', '12345678', '', 0, 0, '', '', '', '', 0, 1, 1, 1, 1, 0),
(151, 'Irene', 'iribotticchio2002@gmail.com', 'irene2002', 'In cerca di letti comodi dove dormire.', 0, 0, '', '', '', '', 0, 1, 1, 1, 1, 0),
(176, 'rex', 'lobbialta@gmail.com', '56639ddf80861fff8b74352b18880392', 'CFO\nFinix', 0, 0, '', '', '', 'c2f7c1e5d9e13c9d84f74d2a749e7e80db648539b9140f52967e52275da88942', 1, 0, 0, 0, 0, 0),
(175, 'sisih', 'sihame.e96@icloud.com', 'da22b836e084a2159fa03d6a01ed3496', '', 0, 0, '', '', '', 'dd64c3651ec7e0fe99d047841394e105e8e57967b5a6d4e346f88f3b71ae243d', 1, 0, 0, 0, 0, 0),
(174, 'Sandrine Malvy', 'sandmalv@gmail.com', 'e19dde9c1089c50ecd80b53e3065ce52', '', 0, 0, '', '', '', 'b732ac51640387c1109dbdae95dfe6daaf3bcc689a80de4d75553c84ac1a96c0', 1, 0, 0, 0, 0, 0),
(173, 'macbolane ', 'macbolane2007@hotmail.fr', 'bf21ac67df2b9cf03c87d1b2e115379c', '', 0, 0, '', '', '', '', 0, 0, 0, 0, 0, 0),
(172, 'bema263', 'anderssonhagman1234@gmail.com', 'd495b46d73df6e8668ff52aca34bbd6e', '', 0, 0, '', '', '', 'ae7fd38724d7ba45e725ab40d5d220fd398a490f02f4aa7ef7cdc44dfe226f3f', 1, 0, 0, 0, 0, 0),
(171, 'kevinderham', 'kevinderham@gmail.com', 'df0ba3d915f73f064d413eaacd20b347', '', 0, 0, '', '', '', '51ace015f7d3ba464e5fa1fdd8df1e1e81ad644b8867b905bcfeb2574e4515c5', 1, 0, 0, 0, 0, 0),
(170, 'Steve Stephanopolis', 'scubasteveo12345@gmail.com', '2c6b6f9f09fdde31ca87c5bdf344d047', '', 0, 0, '', '', '', '3ae028bb185215424ed5e8aeb6df3773a870032c66d3f8e7566112eb54643945', 0, 0, 0, 0, 0, 0),
(177, 'Nely ', 'nelyzapatavasquez@gmail.com', '57d32c505ab6e8dad27f8b674a6387e3', '', 0, 0, '', '', '', 'e349dc21cc97037505e5f06cd4704932c0b35101901a3e149433a8bdc6545a4f', 1, 0, 0, 0, 0, 0),
(178, 'jhedrick', 'sandmanoo@hotmail.com', '79fca231edd18b26706c8be40dd6c422', '', 0, 0, '', '', '', 'bc8742d49a99ab8d9ac992981454b69c84134934b2628f445913080eb154b58f', 1, 0, 0, 0, 0, 0),
(179, 'AliExpress ', 'v.r-6@hotmail.com', '96a8a1a1579009772bf6d327b1ce34f0', '', 0, 0, '', '', '', '2be08ef938019781c64df1b3f49c39d4b47f6b90c51607f4cd80b80dd7d4930b', 1, 0, 0, 0, 0, 0),
(180, 'Filippo', 'filippo@gmail.com', '25d55ad283aa400af464c76d713c07ad', '', 0, 0, '', '', '', 'dc8bcde4ede631d0fc0c2f0f6d1e625d8848fac1471c6f18250ed9f1efa4a86e', 0, 0, 0, 0, 0, 0),
(181, 'omnia Ramadan ', 'fekryomnia@gmail.com', 'df8393e9abc84f2b51e3930bfc36deee', '', 0, 0, '', '', '', '', 0, 0, 0, 0, 0, 0),
(182, 'redp6540', 'shantihair@yahoo.com', '49a6f8cd10893d69a0bf4b85d397babe', '', 0, 0, '', '', '', '', 0, 0, 0, 0, 0, 0),
(183, 'William Palmer', 'redp6540@yahoo.com', '45684ea37ea0b4158a4bd5768889a318', '', 0, 0, '', '', '', 'fb76acd7770d043f564e86d821eda021acb627e3399073773b88e9b9797c0262', 0, 0, 0, 0, 0, 0),
(184, 'john', 'otterson.caleb00@gmail.con', 'e42a431f8e6185f76ac4f5d4007206e0', '', 0, 0, '', '', '', '', 0, 0, 0, 0, 0, 0),
(185, 'gshjdfjdjjf', 'djdjskdk@gmail.xom', '25d55ad283aa400af464c76d713c07ad', '', 0, 0, '', '', '', '', 0, 0, 0, 0, 0, 0),
(186, 'djjdndnsd', 'shdjdj@hdusismxom.com', 'e7fc8e274c489adb748b85abac4e0d63', '', 0, 0, '', '', '', '', 0, 0, 0, 0, 0, 0),
(187, 'sjdjjdjs', 'fndjajjsfj@dudhaj.xon', 'a07e5ebd58e947cb9b9198715b198ad7', '', 0, 0, '', '', '', '', 0, 0, 0, 0, 0, 0),
(188, 'djcjjskdf', 'hdjfjsidkd@fidissimo.com', '8409c909999de013e23491fe7befd61d', '', 0, 0, '', '', '', '', 0, 0, 0, 0, 0, 0),
(189, 'seantate2566', 'anthonykent2566@gmail.com', '83fcce08f299045530552f2e91ae9057', '', 0, 0, '', '', '', '18bffe1fd0de4013c0c5340428e0d7bf0a07494fbc24ba34f686acbf726a0c23', 1, 0, 1, 1, 1, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activations`
--
ALTER TABLE `activations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `eventanswers`
--
ALTER TABLE `eventanswers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `eventdiscussions`
--
ALTER TABLE `eventdiscussions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `friends`
--
ALTER TABLE `friends`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `localreviews`
--
ALTER TABLE `localreviews`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `locals`
--
ALTER TABLE `locals`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `localsrating`
--
ALTER TABLE `localsrating`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `quadris_followers`
--
ALTER TABLE `quadris_followers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `quadris_games`
--
ALTER TABLE `quadris_games`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `quadris_users`
--
ALTER TABLE `quadris_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `resetpassword`
--
ALTER TABLE `resetpassword`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usereventfavourites`
--
ALTER TABLE `usereventfavourites`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usereventgoing`
--
ALTER TABLE `usereventgoing`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `userfriends`
--
ALTER TABLE `userfriends`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `userlocalfavourites`
--
ALTER TABLE `userlocalfavourites`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usersaccount`
--
ALTER TABLE `usersaccount`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activations`
--
ALTER TABLE `activations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- AUTO_INCREMENT for table `eventanswers`
--
ALTER TABLE `eventanswers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `eventdiscussions`
--
ALTER TABLE `eventdiscussions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `friends`
--
ALTER TABLE `friends`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `localreviews`
--
ALTER TABLE `localreviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `locals`
--
ALTER TABLE `locals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=156;

--
-- AUTO_INCREMENT for table `localsrating`
--
ALTER TABLE `localsrating`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `quadris_followers`
--
ALTER TABLE `quadris_followers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- AUTO_INCREMENT for table `quadris_games`
--
ALTER TABLE `quadris_games`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=329;

--
-- AUTO_INCREMENT for table `quadris_users`
--
ALTER TABLE `quadris_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `resetpassword`
--
ALTER TABLE `resetpassword`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=151;

--
-- AUTO_INCREMENT for table `usereventfavourites`
--
ALTER TABLE `usereventfavourites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `usereventgoing`
--
ALTER TABLE `usereventgoing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `userfriends`
--
ALTER TABLE `userfriends`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=212;

--
-- AUTO_INCREMENT for table `userlocalfavourites`
--
ALTER TABLE `userlocalfavourites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- AUTO_INCREMENT for table `usersaccount`
--
ALTER TABLE `usersaccount`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=190;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
