-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 05, 2025 at 10:51 AM
-- Server version: 5.7.24
-- PHP Version: 8.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `project_user_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateAchievement` (IN `p_name` VARCHAR(255), IN `p_description` TEXT, IN `p_icon_url` VARCHAR(255))   BEGIN
    INSERT INTO achievements (name, description, icon_url)
    VALUES (p_name, p_description, p_icon_url);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateCourse` (IN `p_name` VARCHAR(255), IN `p_language_code` VARCHAR(10))   BEGIN
    INSERT INTO courses (name, language_code) VALUES (p_name, p_language_code);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateFriend` (IN `p_user_id` INT, IN `p_friend_id` INT, IN `p_status` VARCHAR(50))   BEGIN
    INSERT INTO friends (user_id, friend_id, status)
    VALUES (p_user_id, p_friend_id, IFNULL(p_status, 'pending'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateLeaderboardEntry` (IN `p_user_id` INT, IN `p_course_id` INT, IN `p_rank` INT, IN `p_xp_total` INT, IN `p_period` VARCHAR(50))   BEGIN
    INSERT INTO leaderboard (user_id, course_id, rank, xp_total, period)
    VALUES (p_user_id, p_course_id, p_rank, p_xp_total, p_period);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateLesson` (IN `p_unit_id` INT, IN `p_title` VARCHAR(255), IN `p_description` TEXT, IN `p_difficulty` VARCHAR(50))   BEGIN
    INSERT INTO lessons (unit_id, title, description, difficulty)
    VALUES (p_unit_id, p_title, p_description, p_difficulty);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateLessonProgress` (IN `p_user_id` INT, IN `p_lesson_id` INT, IN `p_course_id` INT, IN `p_progress_percent` INT, IN `p_xp_total` INT, IN `p_attempts` INT)   BEGIN
    INSERT INTO lesson_progress (user_id, lesson_id, course_id, progress_percent, xp_total, attempts)
    VALUES (p_user_id, p_lesson_id, p_course_id, IFNULL(p_progress_percent, 0), IFNULL(p_xp_total, 0), IFNULL(p_attempts, 0));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateLogin` (IN `p_user_id` INT, IN `p_device_info` VARCHAR(255), IN `p_ip_address` VARCHAR(45), IN `p_session_token` VARCHAR(255), IN `p_expires_at` TIMESTAMP)   BEGIN
    INSERT INTO logins (user_id, device_info, ip_address, session_token, expires_at)
    VALUES (p_user_id, p_device_info, p_ip_address, p_session_token, p_expires_at);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateScore` (IN `p_user_id` INT, IN `p_lesson_id` INT, IN `p_course_id` INT, IN `p_score` INT, IN `p_xp_earned` INT, IN `p_attempts` INT)   BEGIN
    INSERT INTO scores (user_id, lesson_id, course_id, score, xp_earned, attempts)
    VALUES (p_user_id, p_lesson_id, p_course_id, p_score, IFNULL(p_xp_earned, 0), IFNULL(p_attempts, 1));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateStreak` (IN `p_user_id` INT, IN `p_current_streak` INT, IN `p_longest_streak` INT, IN `p_last_active_date` DATE)   BEGIN
    INSERT INTO streaks (user_id, current_streak, longest_streak, last_active_date)
    VALUES (p_user_id, IFNULL(p_current_streak, 0), IFNULL(p_longest_streak, 0), p_last_active_date);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateUnit` (IN `p_course_id` INT, IN `p_title` VARCHAR(255), IN `p_order_index` INT)   BEGIN
    INSERT INTO units (course_id, title, order_index)
    VALUES (p_course_id, p_title, p_order_index);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateUser` (IN `p_username` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password_hash` VARCHAR(255), IN `p_role` VARCHAR(50))   BEGIN
    INSERT INTO users (username, email, password_hash, role)
    VALUES (p_username, p_email, p_password_hash, IFNULL(p_role, 'student'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateUserAchievement` (IN `p_user_id` INT, IN `p_achievement_id` INT)   BEGIN
    INSERT INTO user_achievements (user_id, achievement_id)
    VALUES (p_user_id, p_achievement_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteAchievement` (IN `p_id` INT)   BEGIN
    IF EXISTS (SELECT 1 FROM user_achievements WHERE achievement_id = p_id)
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete achievement: users have earned it.';
    ELSE
        DELETE FROM achievements WHERE id = p_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteCourse` (IN `p_id` INT)   BEGIN
    IF EXISTS (SELECT 1 FROM units WHERE course_id = p_id)
        OR EXISTS (SELECT 1 FROM leaderboard WHERE course_id = p_id)
        OR EXISTS (SELECT 1 FROM scores WHERE course_id = p_id)
        OR EXISTS (SELECT 1 FROM lesson_progress WHERE course_id = p_id)
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete course: related records exist.';
    ELSE
        DELETE FROM courses WHERE id = p_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteFriend` (IN `p_id` INT)   BEGIN
    DELETE FROM friends WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteLeaderboardEntry` (IN `p_id` INT)   BEGIN
    DELETE FROM leaderboard WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteLesson` (IN `p_id` INT)   BEGIN
    IF EXISTS (SELECT 1 FROM scores WHERE lesson_id = p_id)
        OR EXISTS (SELECT 1 FROM lesson_progress WHERE lesson_id = p_id)
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete lesson: scores or progress exist.';
    ELSE
        DELETE FROM lessons WHERE id = p_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteLessonProgress` (IN `p_id` INT)   BEGIN
    DELETE FROM lesson_progress WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteLogin` (IN `p_id` INT)   BEGIN
    DELETE FROM logins WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteScore` (IN `p_id` INT)   BEGIN
    DELETE FROM scores WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteStreak` (IN `p_id` INT)   BEGIN
    DELETE FROM streaks WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteUnit` (IN `p_id` INT)   BEGIN
    IF EXISTS (SELECT 1 FROM lessons WHERE unit_id = p_id)
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete unit: lessons exist under this unit.';
    ELSE
        DELETE FROM units WHERE id = p_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteUser` (IN `p_id` INT)   BEGIN
    IF EXISTS (SELECT 1 FROM scores WHERE user_id = p_id)
        OR EXISTS (SELECT 1 FROM friends WHERE user_id = p_id OR friend_id = p_id)
        OR EXISTS (SELECT 1 FROM leaderboard WHERE user_id = p_id)
        OR EXISTS (SELECT 1 FROM logins WHERE user_id = p_id)
        OR EXISTS (SELECT 1 FROM streaks WHERE user_id = p_id)
        OR EXISTS (SELECT 1 FROM lesson_progress WHERE user_id = p_id)
        OR EXISTS (SELECT 1 FROM user_achievements WHERE user_id = p_id)
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete user: related records exist.';
    ELSE
        DELETE FROM users WHERE id = p_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteUserAchievement` (IN `p_id` INT)   BEGIN
    DELETE FROM user_achievements WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAchievement` (IN `p_id` INT)   BEGIN
    SELECT * FROM achievements WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCourse` (IN `p_id` INT)   BEGIN
    SELECT * FROM courses WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetFriend` (IN `p_id` INT)   BEGIN
    SELECT * FROM friends WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetLeaderboardEntry` (IN `p_id` INT)   BEGIN
    SELECT * FROM leaderboard WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetLesson` (IN `p_id` INT)   BEGIN
    SELECT * FROM lessons WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetLessonProgress` (IN `p_id` INT)   BEGIN
    SELECT * FROM lesson_progress WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetLogin` (IN `p_id` INT)   BEGIN
    SELECT * FROM logins WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetScore` (IN `p_id` INT)   BEGIN
    SELECT * FROM scores WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetStreak` (IN `p_id` INT)   BEGIN
    SELECT * FROM streaks WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUnit` (IN `p_id` INT)   BEGIN
    SELECT * FROM units WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUser` (IN `p_id` INT)   BEGIN
    SELECT * FROM users WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserAchievement` (IN `p_id` INT)   BEGIN
    SELECT * FROM user_achievements WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateAchievement` (IN `p_id` INT, IN `p_name` VARCHAR(255), IN `p_description` TEXT, IN `p_icon_url` VARCHAR(255))   BEGIN
    UPDATE achievements
    SET name = p_name,
        description = p_description,
        icon_url = p_icon_url
    WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateCourse` (IN `p_id` INT, IN `p_name` VARCHAR(255), IN `p_language_code` VARCHAR(10))   BEGIN
    UPDATE courses SET name = p_name, language_code = p_language_code WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateFriendStatus` (IN `p_id` INT, IN `p_status` VARCHAR(50))   BEGIN
    UPDATE friends SET status = p_status WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateLeaderboardEntry` (IN `p_id` INT, IN `p_rank` INT, IN `p_xp_total` INT, IN `p_period` VARCHAR(50))   BEGIN
    UPDATE leaderboard
    SET rank = p_rank,
        xp_total = p_xp_total,
        period = p_period
    WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateLesson` (IN `p_id` INT, IN `p_title` VARCHAR(255), IN `p_description` TEXT, IN `p_difficulty` VARCHAR(50))   BEGIN
    UPDATE lessons SET title = p_title, description = p_description, difficulty = p_difficulty WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateLessonProgress` (IN `p_id` INT, IN `p_progress_percent` INT, IN `p_xp_total` INT, IN `p_attempts` INT)   BEGIN
    UPDATE lesson_progress
    SET progress_percent = p_progress_percent,
        xp_total = p_xp_total,
        attempts = p_attempts
    WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateLogin` (IN `p_id` INT, IN `p_device_info` VARCHAR(255), IN `p_ip_address` VARCHAR(45), IN `p_session_token` VARCHAR(255), IN `p_expires_at` TIMESTAMP)   BEGIN
    UPDATE logins
    SET device_info = p_device_info,
        ip_address = p_ip_address,
        session_token = p_session_token,
        expires_at = p_expires_at
    WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateScore` (IN `p_id` INT, IN `p_score` INT, IN `p_xp_earned` INT, IN `p_attempts` INT)   BEGIN
    UPDATE scores
    SET score = p_score,
        xp_earned = p_xp_earned,
        attempts = p_attempts
    WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateStreak` (IN `p_id` INT, IN `p_current_streak` INT, IN `p_longest_streak` INT, IN `p_last_active_date` DATE)   BEGIN
    UPDATE streaks
    SET current_streak = p_current_streak,
        longest_streak = p_longest_streak,
        last_active_date = p_last_active_date
    WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUnit` (IN `p_id` INT, IN `p_title` VARCHAR(255), IN `p_order_index` INT)   BEGIN
    UPDATE units SET title = p_title, order_index = p_order_index WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUser` (IN `p_id` INT, IN `p_username` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_role` VARCHAR(50))   BEGIN
    UPDATE users
    SET username = p_username, email = p_email, role = p_role
    WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUserAchievement` (IN `p_id` INT, IN `p_user_id` INT, IN `p_achievement_id` INT)   BEGIN
    UPDATE user_achievements
    SET user_id = p_user_id,
        achievement_id = p_achievement_id
    WHERE id = p_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `achievements`
--

CREATE TABLE `achievements` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `icon_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `achievements`
--

INSERT INTO `achievements` (`id`, `name`, `description`, `icon_url`, `created_at`) VALUES
(1, 'First Steps', 'Completed your first lesson', 'https://example.com/icons/first_steps.png', '2025-08-26 07:44:46'),
(2, 'Streak Starter', 'Maintained a 3-day learning streak', 'https://example.com/icons/streak.png', '2025-08-26 07:44:46'),
(3, 'Quick Learner', 'Completed 5 lessons in one day', 'https://example.com/icons/quick_learner.png', '2025-08-26 07:44:46'),
(4, 'Dedicated', 'Studied 7 days in a row', 'https://example.com/icons/dedicated.png', '2025-08-26 07:44:46'),
(5, 'Perfect Score', 'Achieved 100% on a lesson', 'https://example.com/icons/perfect.png', '2025-08-26 07:44:46'),
(6, 'Marathon', 'Studied for 30 days straight', 'https://example.com/icons/marathon.png', '2025-08-26 07:44:46'),
(7, 'High Scorer', 'Earned 1000 XP', 'https://example.com/icons/high_scorer.png', '2025-08-26 07:44:46'),
(8, 'Polyglot', 'Started 3 different courses', 'https://example.com/icons/polyglot.png', '2025-08-26 07:44:46'),
(9, 'Social Learner', 'Added 5 friends', 'https://example.com/icons/social.png', '2025-08-26 07:44:46'),
(10, 'Night Owl', 'Studied between midnight and 3am', 'https://example.com/icons/night_owl.png', '2025-08-26 07:44:46'),
(11, 'Early Bird', 'Studied before 6am', 'https://example.com/icons/early_bird.png', '2025-08-26 07:44:46'),
(12, 'Fast Progress', 'Completed an entire unit in one day', 'https://example.com/icons/fast_progress.png', '2025-08-26 07:44:46'),
(13, 'Top 10', 'Ranked in the top 10 of a leaderboard', 'https://example.com/icons/top10.png', '2025-08-26 07:44:46'),
(14, 'Veteran', 'Used the app for 100 days', 'https://example.com/icons/veteran.png', '2025-08-26 07:44:46'),
(15, 'Community Helper', 'Helped another user in discussion forums', 'https://example.com/icons/helper.png', '2025-08-26 07:44:46');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `language_code` varchar(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `name`, `language_code`, `created_at`) VALUES
(1, 'Spanish for Beginners', 'es', '2025-08-26 07:44:54'),
(2, 'French Essentials', 'fr', '2025-08-26 07:44:54'),
(3, 'German Basics', 'de', '2025-08-26 07:44:54'),
(4, 'Japanese 101', 'ja', '2025-08-26 07:44:54'),
(5, 'Italian Starter', 'it', '2025-08-26 07:44:54'),
(6, 'Mandarin Chinese', 'zh', '2025-08-26 07:44:54'),
(7, 'Portuguese Intro', 'pt', '2025-08-26 07:44:54'),
(8, 'Russian Alphabet', 'ru', '2025-08-26 07:44:54'),
(9, 'Arabic Foundations', 'ar', '2025-08-26 07:44:54'),
(10, 'Hindi Learners', 'hi', '2025-08-26 07:44:54'),
(11, 'Korean Basics', 'ko', '2025-08-26 07:44:54'),
(12, 'Greek Fundamentals', 'el', '2025-08-26 07:44:54'),
(13, 'Turkish Language', 'tr', '2025-08-26 07:44:54'),
(14, 'Dutch Beginners', 'nl', '2025-08-26 07:44:54'),
(15, 'Swedish Intro', 'sv', '2025-08-26 07:44:54');

-- --------------------------------------------------------

--
-- Table structure for table `friends`
--

CREATE TABLE `friends` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `friend_id` int(11) NOT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `friends`
--

INSERT INTO `friends` (`id`, `user_id`, `friend_id`, `status`, `created_at`) VALUES
(1, 1, 2, 'accepted', '2025-08-21 07:45:19'),
(2, 2, 3, 'accepted', '2025-08-22 07:45:19'),
(3, 3, 4, 'accepted', '2025-08-23 07:45:19'),
(4, 4, 5, 'pending', '2025-08-24 07:45:19'),
(5, 5, 6, 'accepted', '2025-08-25 07:45:19'),
(6, 6, 7, 'accepted', '2025-08-20 07:45:19'),
(7, 7, 8, 'blocked', '2025-08-19 07:45:19'),
(8, 8, 9, 'accepted', '2025-08-23 07:45:19'),
(9, 9, 10, 'accepted', '2025-08-24 07:45:19'),
(10, 10, 11, 'pending', '2025-08-25 07:45:19'),
(11, 11, 12, 'accepted', '2025-08-21 07:45:19'),
(12, 12, 13, 'accepted', '2025-08-22 07:45:19'),
(13, 13, 14, 'accepted', '2025-08-23 07:45:19'),
(14, 14, 15, 'accepted', '2025-08-24 07:45:19'),
(15, 15, 1, 'accepted', '2025-08-25 07:45:19');

-- --------------------------------------------------------

--
-- Table structure for table `leaderboard`
--

CREATE TABLE `leaderboard` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `rank` int(11) NOT NULL,
  `xp_total` int(11) NOT NULL,
  `period` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `leaderboard`
--

INSERT INTO `leaderboard` (`id`, `user_id`, `course_id`, `rank`, `xp_total`, `period`, `updated_at`) VALUES
(1, 1, 1, 1, 1200, 'weekly', '2025-08-26 07:46:06'),
(2, 2, 1, 3, 950, 'weekly', '2025-08-26 07:46:06'),
(3, 3, 2, 2, 1100, 'weekly', '2025-08-26 07:46:06'),
(4, 4, 3, 5, 850, 'weekly', '2025-08-26 07:46:06'),
(5, 5, 4, 4, 900, 'weekly', '2025-08-26 07:46:06'),
(6, 6, 5, 6, 700, 'weekly', '2025-08-26 07:46:06'),
(7, 7, 6, 7, 650, 'weekly', '2025-08-26 07:46:06'),
(8, 8, 7, 3, 1000, 'weekly', '2025-08-26 07:46:06'),
(9, 9, 8, 1, 1300, 'weekly', '2025-08-26 07:46:06'),
(10, 10, 9, 8, 600, 'weekly', '2025-08-26 07:46:06'),
(11, 11, 10, 2, 1150, 'weekly', '2025-08-26 07:46:06'),
(12, 12, 11, 4, 900, 'weekly', '2025-08-26 07:46:06'),
(13, 13, 12, 5, 850, 'weekly', '2025-08-26 07:46:06'),
(14, 14, 13, 6, 750, 'weekly', '2025-08-26 07:46:06'),
(15, 15, 14, 3, 1050, 'weekly', '2025-08-26 07:46:06');

-- --------------------------------------------------------

--
-- Table structure for table `lessons`
--

CREATE TABLE `lessons` (
  `id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `difficulty` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lessons`
--

INSERT INTO `lessons` (`id`, `unit_id`, `title`, `description`, `difficulty`, `created_at`) VALUES
(1, 1, 'Spanish Alphabet', 'Learn the Spanish alphabet', 'Easy', '2025-08-26 07:45:10'),
(2, 2, 'Common Spanish Phrases', 'Basic greetings and phrases', 'Easy', '2025-08-26 07:45:10'),
(3, 3, 'Bonjour and Beyond', 'French greetings and introductions', 'Easy', '2025-08-26 07:45:10'),
(4, 4, 'German Vowels', 'Understanding German vowels', 'Medium', '2025-08-26 07:45:10'),
(5, 5, 'Hiragana Set 1', 'First set of Hiragana characters', 'Medium', '2025-08-26 07:45:10'),
(6, 6, 'Italian Hello', 'Greetings in Italian', 'Easy', '2025-08-26 07:45:10'),
(7, 7, 'Mandarin Tones', 'Introduction to tones', 'Hard', '2025-08-26 07:45:10'),
(8, 8, 'Portuguese Vowels', 'Understanding vowel sounds', 'Medium', '2025-08-26 07:45:10'),
(9, 9, 'Russian Alphabet Intro', 'Learning Cyrillic letters', 'Medium', '2025-08-26 07:45:10'),
(10, 10, 'Arabic Letters', 'Introduction to Arabic script', 'Medium', '2025-08-26 07:45:10'),
(11, 11, 'Hindi Vowels', 'Basic Hindi vowel sounds', 'Easy', '2025-08-26 07:45:10'),
(12, 12, 'Hangul Consonants', 'Korean consonant basics', 'Medium', '2025-08-26 07:45:10'),
(13, 13, 'Greek Alphabet', 'Learning the Greek alphabet', 'Medium', '2025-08-26 07:45:10'),
(14, 14, 'Turkish Letters', 'Introduction to Turkish alphabet', 'Easy', '2025-08-26 07:45:10'),
(15, 15, 'Dutch Greetings', 'Basic greetings in Dutch', 'Easy', '2025-08-26 07:45:10');

-- --------------------------------------------------------

--
-- Table structure for table `lesson_progress`
--

CREATE TABLE `lesson_progress` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lesson_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `progress_percent` int(11) DEFAULT '0',
  `xp_total` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lesson_progress`
--

INSERT INTO `lesson_progress` (`id`, `user_id`, `lesson_id`, `course_id`, `progress_percent`, `xp_total`, `attempts`, `last_updated`) VALUES
(1, 1, 1, 1, 100, 50, 1, '2025-08-26 07:45:58'),
(2, 2, 2, 1, 80, 45, 2, '2025-08-26 07:45:58'),
(3, 3, 3, 2, 100, 60, 1, '2025-08-26 07:45:58'),
(4, 4, 4, 3, 75, 40, 3, '2025-08-26 07:45:58'),
(5, 5, 5, 4, 90, 55, 2, '2025-08-26 07:45:58'),
(6, 6, 6, 5, 95, 50, 1, '2025-08-26 07:45:58'),
(7, 7, 7, 6, 60, 30, 3, '2025-08-26 07:45:58'),
(8, 8, 8, 7, 85, 40, 2, '2025-08-26 07:45:58'),
(9, 9, 9, 8, 100, 70, 1, '2025-08-26 07:45:58'),
(10, 10, 10, 9, 78, 35, 2, '2025-08-26 07:45:58'),
(11, 11, 11, 10, 88, 50, 1, '2025-08-26 07:45:58'),
(12, 12, 12, 11, 91, 55, 2, '2025-08-26 07:45:58'),
(13, 13, 13, 12, 84, 45, 1, '2025-08-26 07:45:58'),
(14, 14, 14, 13, 80, 40, 2, '2025-08-26 07:45:58'),
(15, 15, 15, 14, 93, 60, 1, '2025-08-26 07:45:58');

-- --------------------------------------------------------

--
-- Table structure for table `logins`
--

CREATE TABLE `logins` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `login_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `device_info` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `session_token` varchar(255) DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `logins`
--

INSERT INTO `logins` (`id`, `user_id`, `login_time`, `device_info`, `ip_address`, `session_token`, `expires_at`) VALUES
(1, 1, '2025-08-26 05:45:37', 'iPhone 13, iOS 16', '192.168.0.11', 'token1', '2025-08-27 07:45:37'),
(2, 2, '2025-08-26 04:45:37', 'Samsung Galaxy, Android 12', '192.168.0.12', 'token2', '2025-08-27 07:45:37'),
(3, 3, '2025-08-26 02:45:37', 'Windows 11, Chrome', '192.168.0.13', 'token3', '2025-08-27 07:45:37'),
(4, 4, '2025-08-25 07:45:37', 'MacBook Pro, Safari', '192.168.0.14', 'token4', '2025-08-27 07:45:37'),
(5, 5, '2025-08-26 06:45:37', 'Pixel 6, Android 13', '192.168.0.15', 'token5', '2025-08-27 07:45:37'),
(6, 6, '2025-08-24 07:45:37', 'Linux, Firefox', '192.168.0.16', 'token6', '2025-08-27 07:45:37'),
(7, 7, '2025-08-26 03:45:37', 'iPhone 12, iOS 15', '192.168.0.17', 'token7', '2025-08-27 07:45:37'),
(8, 8, '2025-08-26 04:45:37', 'Windows 10, Edge', '192.168.0.18', 'token8', '2025-08-27 07:45:37'),
(9, 9, '2025-08-21 07:45:37', 'MacBook Air, Safari', '192.168.0.19', 'token9', '2025-08-27 07:45:37'),
(10, 10, '2025-08-26 01:45:37', 'iPad, iOS 16', '192.168.0.20', 'token10', '2025-08-27 07:45:37'),
(11, 11, '2025-08-26 05:45:37', 'Windows 11, Firefox', '192.168.0.21', 'token11', '2025-08-27 07:45:37'),
(12, 12, '2025-08-23 07:45:37', 'Galaxy Tab, Android 12', '192.168.0.22', 'token12', '2025-08-27 07:45:37'),
(13, 13, '2025-08-26 03:45:37', 'Linux, Chrome', '192.168.0.23', 'token13', '2025-08-27 07:45:37'),
(14, 14, '2025-08-26 02:45:37', 'Windows 10, Chrome', '192.168.0.24', 'token14', '2025-08-27 07:45:37'),
(15, 15, '2025-08-26 06:45:37', 'iPhone 14, iOS 16', '192.168.0.25', 'token15', '2025-08-27 07:45:37');

-- --------------------------------------------------------

--
-- Table structure for table `scores`
--

CREATE TABLE `scores` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lesson_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  `xp_earned` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '1',
  `completed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `scores`
--

INSERT INTO `scores` (`id`, `user_id`, `lesson_id`, `course_id`, `score`, `xp_earned`, `attempts`, `completed_at`) VALUES
(1, 1, 1, 1, 95, 50, 1, '2025-08-25 07:45:50'),
(2, 2, 2, 1, 87, 45, 2, '2025-08-24 07:45:50'),
(3, 3, 3, 2, 90, 60, 1, '2025-08-25 07:45:50'),
(4, 4, 4, 3, 76, 40, 3, '2025-08-23 07:45:50'),
(5, 5, 5, 4, 88, 55, 2, '2025-08-24 07:45:50'),
(6, 6, 6, 5, 92, 50, 1, '2025-08-25 07:45:50'),
(7, 7, 7, 6, 65, 30, 3, '2025-08-24 07:45:50'),
(8, 8, 8, 7, 85, 40, 2, '2025-08-25 07:45:50'),
(9, 9, 9, 8, 98, 70, 1, '2025-08-25 07:45:50'),
(10, 10, 10, 9, 78, 35, 2, '2025-08-23 07:45:50'),
(11, 11, 11, 10, 88, 50, 1, '2025-08-24 07:45:50'),
(12, 12, 12, 11, 91, 55, 2, '2025-08-25 07:45:50'),
(13, 13, 13, 12, 84, 45, 1, '2025-08-25 07:45:50'),
(14, 14, 14, 13, 80, 40, 2, '2025-08-24 07:45:50'),
(15, 15, 15, 14, 93, 60, 1, '2025-08-25 07:45:50');

-- --------------------------------------------------------

--
-- Table structure for table `streaks`
--

CREATE TABLE `streaks` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `current_streak` int(11) NOT NULL DEFAULT '0',
  `longest_streak` int(11) NOT NULL DEFAULT '0',
  `last_active_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `streaks`
--

INSERT INTO `streaks` (`id`, `user_id`, `current_streak`, `longest_streak`, `last_active_date`) VALUES
(1, 1, 5, 7, '2025-08-25'),
(2, 2, 3, 5, '2025-08-24'),
(3, 3, 7, 10, '2025-08-25'),
(4, 4, 2, 4, '2025-08-23'),
(5, 5, 10, 10, '2025-08-25'),
(6, 6, 1, 3, '2025-08-25'),
(7, 7, 6, 8, '2025-08-25'),
(8, 8, 4, 6, '2025-08-24'),
(9, 9, 8, 9, '2025-08-25'),
(10, 10, 3, 5, '2025-08-23'),
(11, 11, 9, 12, '2025-08-25'),
(12, 12, 0, 4, '2025-08-21'),
(13, 13, 2, 6, '2025-08-24'),
(14, 14, 7, 9, '2025-08-25'),
(15, 15, 5, 7, '2025-08-25');

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `order_index` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `units`
--

INSERT INTO `units` (`id`, `course_id`, `title`, `order_index`, `created_at`) VALUES
(1, 1, 'Introduction to Spanish', 1, '2025-08-26 07:45:02'),
(2, 1, 'Spanish Basics', 2, '2025-08-26 07:45:02'),
(3, 2, 'French Greetings', 1, '2025-08-26 07:45:02'),
(4, 3, 'German Alphabet', 1, '2025-08-26 07:45:02'),
(5, 4, 'Hiragana Basics', 1, '2025-08-26 07:45:02'),
(6, 5, 'Italian Greetings', 1, '2025-08-26 07:45:02'),
(7, 6, 'Pinyin & Tones', 1, '2025-08-26 07:45:02'),
(8, 7, 'Portuguese Sounds', 1, '2025-08-26 07:45:02'),
(9, 8, 'Russian Letters', 1, '2025-08-26 07:45:02'),
(10, 9, 'Arabic Alphabet', 1, '2025-08-26 07:45:02'),
(11, 10, 'Hindi Script', 1, '2025-08-26 07:45:02'),
(12, 11, 'Hangul Basics', 1, '2025-08-26 07:45:02'),
(13, 12, 'Greek Letters', 1, '2025-08-26 07:45:02'),
(14, 13, 'Turkish Alphabet', 1, '2025-08-26 07:45:02'),
(15, 14, 'Dutch Basics', 1, '2025-08-26 07:45:02');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(50) DEFAULT 'student',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `role`, `created_at`, `last_login`) VALUES
(1, 'alex_jones', 'alex.jones@example.com', 'hash_pw1', 'student', '2025-08-11 07:44:32', '2025-08-25 07:44:32'),
(2, 'maria_lee', 'maria.lee@example.com', 'hash_pw2', 'student', '2025-08-12 07:44:32', '2025-08-24 07:44:32'),
(3, 'john_smith', 'john.smith@example.com', 'hash_pw3', 'student', '2025-08-13 07:44:32', '2025-08-23 07:44:32'),
(4, 'emma_clark', 'emma.clark@example.com', 'hash_pw4', 'student', '2025-08-14 07:44:32', '2025-08-24 07:44:32'),
(5, 'liam_chen', 'liam.chen@example.com', 'hash_pw5', 'student', '2025-08-15 07:44:32', '2025-08-26 02:44:32'),
(6, 'olivia_wong', 'olivia.wong@example.com', 'hash_pw6', 'student', '2025-08-16 07:44:32', '2025-08-26 00:44:32'),
(7, 'noah_patel', 'noah.patel@example.com', 'hash_pw7', 'student', '2025-08-17 07:44:32', '2025-08-20 07:44:32'),
(8, 'sophia_garcia', 'sophia.garcia@example.com', 'hash_pw8', 'student', '2025-08-18 07:44:32', '2025-08-26 06:44:32'),
(9, 'ethan_kim', 'ethan.kim@example.com', 'hash_pw9', 'student', '2025-08-19 07:44:32', '2025-08-26 05:44:32'),
(10, 'ava_ross', 'ava.ross@example.com', 'hash_pw10', 'student', '2025-08-20 07:44:32', '2025-08-26 03:44:32'),
(11, 'mason_ali', 'mason.ali@example.com', 'hash_pw11', 'student', '2025-08-21 07:44:32', '2025-08-26 06:44:32'),
(12, 'mia_johnson', 'mia.johnson@example.com', 'hash_pw12', 'student', '2025-08-22 07:44:32', '2025-08-26 07:24:32'),
(13, 'lucas_brown', 'lucas.brown@example.com', 'hash_pw13', 'student', '2025-08-23 07:44:32', '2025-08-26 07:34:32'),
(14, 'isabella_davis', 'isabella.davis@example.com', 'hash_pw14', 'student', '2025-08-24 07:44:32', '2025-08-26 07:14:32'),
(15, 'jack_wilson', 'jack.wilson@example.com', 'hash_pw15', 'student', '2025-08-25 07:44:32', '2025-08-26 07:44:32');

-- --------------------------------------------------------

--
-- Table structure for table `user_achievements`
--

CREATE TABLE `user_achievements` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `achievement_id` int(11) NOT NULL,
  `earned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_achievements`
--

INSERT INTO `user_achievements` (`id`, `user_id`, `achievement_id`, `earned_at`) VALUES
(1, 1, 1, '2025-08-16 07:46:13'),
(2, 1, 5, '2025-08-21 07:46:13'),
(3, 2, 2, '2025-08-19 07:46:13'),
(4, 3, 3, '2025-08-20 07:46:13'),
(5, 4, 4, '2025-08-18 07:46:13'),
(6, 5, 1, '2025-08-24 07:46:13'),
(7, 6, 7, '2025-08-22 07:46:13'),
(8, 7, 9, '2025-08-23 07:46:13'),
(9, 8, 10, '2025-08-24 07:46:13'),
(10, 9, 11, '2025-08-25 07:46:13'),
(11, 10, 12, '2025-08-25 07:46:13'),
(12, 11, 13, '2025-08-24 07:46:13'),
(13, 12, 14, '2025-08-23 07:46:13'),
(14, 13, 15, '2025-08-25 07:46:13'),
(15, 14, 8, '2025-08-25 07:46:13');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `achievements`
--
ALTER TABLE `achievements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `friends`
--
ALTER TABLE `friends`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `friend_id` (`friend_id`);

--
-- Indexes for table `leaderboard`
--
ALTER TABLE `leaderboard`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `lessons`
--
ALTER TABLE `lessons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `unit_id` (`unit_id`);

--
-- Indexes for table `lesson_progress`
--
ALTER TABLE `lesson_progress`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `lesson_id` (`lesson_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `logins`
--
ALTER TABLE `logins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `scores`
--
ALTER TABLE `scores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `lesson_id` (`lesson_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `streaks`
--
ALTER TABLE `streaks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_achievements`
--
ALTER TABLE `user_achievements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `achievement_id` (`achievement_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `achievements`
--
ALTER TABLE `achievements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `friends`
--
ALTER TABLE `friends`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `leaderboard`
--
ALTER TABLE `leaderboard`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `lessons`
--
ALTER TABLE `lessons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `lesson_progress`
--
ALTER TABLE `lesson_progress`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `logins`
--
ALTER TABLE `logins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `scores`
--
ALTER TABLE `scores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `streaks`
--
ALTER TABLE `streaks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `units`
--
ALTER TABLE `units`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `user_achievements`
--
ALTER TABLE `user_achievements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `friends`
--
ALTER TABLE `friends`
  ADD CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `friends_ibfk_2` FOREIGN KEY (`friend_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `leaderboard`
--
ALTER TABLE `leaderboard`
  ADD CONSTRAINT `leaderboard_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `leaderboard_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);

--
-- Constraints for table `lessons`
--
ALTER TABLE `lessons`
  ADD CONSTRAINT `lessons_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`);

--
-- Constraints for table `lesson_progress`
--
ALTER TABLE `lesson_progress`
  ADD CONSTRAINT `lesson_progress_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `lesson_progress_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`),
  ADD CONSTRAINT `lesson_progress_ibfk_3` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);

--
-- Constraints for table `logins`
--
ALTER TABLE `logins`
  ADD CONSTRAINT `logins_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `scores`
--
ALTER TABLE `scores`
  ADD CONSTRAINT `scores_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `scores_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`),
  ADD CONSTRAINT `scores_ibfk_3` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);

--
-- Constraints for table `streaks`
--
ALTER TABLE `streaks`
  ADD CONSTRAINT `streaks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `units`
--
ALTER TABLE `units`
  ADD CONSTRAINT `units_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);

--
-- Constraints for table `user_achievements`
--
ALTER TABLE `user_achievements`
  ADD CONSTRAINT `user_achievements_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `user_achievements_ibfk_2` FOREIGN KEY (`achievement_id`) REFERENCES `achievements` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
