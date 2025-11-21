-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 21, 2025 at 07:34 AM
-- Server version: 5.7.24
-- PHP Version: 8.1.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `project_user_db_singular`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `anonymize_due_users` ()   BEGIN
  -- anonymize all users soft-deleted at least 5 years ago and not yet anonymized
  DECLARE done INT DEFAULT 0;
  DECLARE cur_user_id INT;

  DECLARE cur CURSOR FOR
    SELECT id FROM `user`
    WHERE is_deleted = 1
      AND is_anonymized = 0
      AND deleted_at <= (NOW() - INTERVAL 5 YEAR);

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  fetch_loop: LOOP
    FETCH cur INTO cur_user_id;
    IF done = 1 THEN
      LEAVE fetch_loop;
    END IF;
    CALL anonymize_user(cur_user_id);
  END LOOP;
  CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `anonymize_user` (IN `p_id` INT)   BEGIN
  DECLARE v_new_username VARCHAR(255);
  DECLARE v_new_email VARCHAR(255);

  SET v_new_username = CONCAT('deleted_user_', p_id);
  SET v_new_email = CONCAT('deleted_user_', p_id, '@deleted.local');

  -- update user record: rename username/email, null PII, mark as anonymized
  UPDATE `user`
  SET username = v_new_username,
      email = v_new_email,
      password_hash = NULL,
      last_login = NULL,
      is_anonymized = 1,
      anonymized_at = NOW()
  WHERE id = p_id;

  -- purge PII from logins
  UPDATE login
  SET device_info = NULL, ip_address = NULL, session_token = NULL, expires_at = NULL, is_anonymized = 1, anonymized_at = NOW()
  WHERE user_id = p_id;
  -- Note: We keep foreign key relations intact for analytics/history
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_achievement` (IN `p_name` VARCHAR(255), IN `p_description` TEXT, IN `p_icon_url` VARCHAR(255))   BEGIN
  INSERT INTO achievement (name, description, icon_url)
  VALUES (p_name, p_description, p_icon_url);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_course` (IN `p_name` VARCHAR(255), IN `p_language_code` VARCHAR(10))   BEGIN
  INSERT INTO course (name, language_code) VALUES (p_name, p_language_code);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_friend` (IN `p_user_id` INT, IN `p_friend_id` INT, IN `p_status` VARCHAR(50))   BEGIN
  INSERT INTO friend (user_id, friend_id, status)
  VALUES (p_user_id, p_friend_id, IFNULL(p_status, 'pending'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_leaderboard` (IN `p_user_id` INT, IN `p_course_id` INT, IN `p_rank` INT, IN `p_xp_total` INT, IN `p_period` VARCHAR(50))   BEGIN
  INSERT INTO leaderboard (user_id, course_id, rank, xp_total, period)
  VALUES (p_user_id, p_course_id, p_rank, p_xp_total, p_period);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_lesson` (IN `p_unit_id` INT, IN `p_title` VARCHAR(255), IN `p_description` TEXT, IN `p_difficulty` VARCHAR(50))   BEGIN
  INSERT INTO lesson (unit_id, title, description, difficulty)
  VALUES (p_unit_id, p_title, p_description, p_difficulty);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_lesson_progress` (IN `p_user_id` INT, IN `p_lesson_id` INT, IN `p_course_id` INT, IN `p_progress_percent` INT, IN `p_xp_total` INT, IN `p_attempts` INT)   BEGIN
  INSERT INTO lesson_progress (user_id, lesson_id, course_id, progress_percent, xp_total, attempts)
  VALUES (p_user_id, p_lesson_id, p_course_id, IFNULL(p_progress_percent, 0), IFNULL(p_xp_total, 0), IFNULL(p_attempts, 0));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_login` (IN `p_user_id` INT, IN `p_device_info` VARCHAR(255), IN `p_ip_address` VARCHAR(45), IN `p_session_token` VARCHAR(255), IN `p_expires_at` TIMESTAMP)   BEGIN
  INSERT INTO login (user_id, device_info, ip_address, session_token, expires_at)
  VALUES (p_user_id, p_device_info, p_ip_address, p_session_token, p_expires_at);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_score` (IN `p_user_id` INT, IN `p_lesson_id` INT, IN `p_course_id` INT, IN `p_score` INT, IN `p_xp_earned` INT, IN `p_attempts` INT)   BEGIN
  INSERT INTO score (user_id, lesson_id, course_id, score, xp_earned, attempts)
  VALUES (p_user_id, p_lesson_id, p_course_id, p_score, IFNULL(p_xp_earned, 0), IFNULL(p_attempts, 1));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_streak` (IN `p_user_id` INT, IN `p_current_streak` INT, IN `p_longest_streak` INT, IN `p_last_active_date` DATE)   BEGIN
  INSERT INTO streak (user_id, current_streak, longest_streak, last_active_date)
  VALUES (p_user_id, IFNULL(p_current_streak, 0), IFNULL(p_longest_streak, 0), p_last_active_date);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_unit` (IN `p_course_id` INT, IN `p_title` VARCHAR(255), IN `p_order_index` INT)   BEGIN
  INSERT INTO unit (course_id, title, order_index)
  VALUES (p_course_id, p_title, p_order_index);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_user` (IN `p_username` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password_hash` VARCHAR(255), IN `p_role` VARCHAR(50))   BEGIN
  INSERT INTO `user` (username, email, password_hash, role)
  VALUES (p_username, p_email, p_password_hash, IFNULL(p_role, 'student'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_user_achievement` (IN `p_user_id` INT, IN `p_achievement_id` INT)   BEGIN
  INSERT INTO user_achievement (user_id, achievement_id)
  VALUES (p_user_id, p_achievement_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_achievement` (IN `p_id` INT)   BEGIN
  SELECT * FROM achievement WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_course` (IN `p_id` INT)   BEGIN
  SELECT * FROM course WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_friend` (IN `p_id` INT)   BEGIN
  SELECT * FROM friend WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_leaderboard` (IN `p_id` INT)   BEGIN
  SELECT * FROM leaderboard WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lesson` (IN `p_id` INT)   BEGIN
  SELECT * FROM lesson WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lesson_progress` (IN `p_id` INT)   BEGIN
  SELECT * FROM lesson_progress WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_login` (IN `p_id` INT)   BEGIN
  SELECT * FROM login WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_score` (IN `p_id` INT)   BEGIN
  SELECT * FROM score WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_streak` (IN `p_id` INT)   BEGIN
  SELECT * FROM streak WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_unit` (IN `p_id` INT)   BEGIN
  SELECT * FROM unit WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user` (IN `p_id` INT)   BEGIN
  SELECT id, username, email, role, created_at, last_login, is_deleted, deleted_at, is_anonymized, anonymized_at
  FROM `user` WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_achievement` (IN `p_id` INT)   BEGIN
  SELECT * FROM user_achievement WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `hard_delete_achievement` (IN `p_id` INT)   BEGIN
  DELETE FROM achievement WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `hard_delete_user` (IN `p_id` INT)   BEGIN
  DELETE FROM score WHERE user_id = p_id;
  DELETE FROM lesson_progress WHERE user_id = p_id;
  DELETE FROM login WHERE user_id = p_id;
  DELETE FROM leaderboard WHERE user_id = p_id;
  DELETE FROM friend WHERE user_id = p_id OR friend_id = p_id;
  DELETE FROM streak WHERE user_id = p_id;
  DELETE FROM user_achievement WHERE user_id = p_id;
  DELETE FROM `user` WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_achievement` (IN `p_id` INT)   BEGIN
  UPDATE achievement SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_course` (IN `p_id` INT)   BEGIN
  -- prevent accidental data-loss: check related tables, but still soft-delete
  IF EXISTS (SELECT 1 FROM unit WHERE course_id = p_id AND is_deleted = 0)
     OR EXISTS (SELECT 1 FROM leaderboard WHERE course_id = p_id AND is_deleted = 0)
     OR EXISTS (SELECT 1 FROM score WHERE course_id = p_id AND is_deleted = 0)
     OR EXISTS (SELECT 1 FROM lesson_progress WHERE course_id = p_id AND is_deleted = 0)
  THEN
     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete course: related records exist (soft-delete allowed).';
  ELSE
     UPDATE course SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_friend` (IN `p_id` INT)   BEGIN
  UPDATE friend SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_leaderboard` (IN `p_id` INT)   BEGIN
  UPDATE leaderboard SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_lesson` (IN `p_id` INT)   BEGIN
  IF EXISTS (SELECT 1 FROM score WHERE lesson_id = p_id AND is_deleted = 0)
     OR EXISTS (SELECT 1 FROM lesson_progress WHERE lesson_id = p_id AND is_deleted = 0)
  THEN
     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete lesson: scores or progress exist.';
  ELSE
     UPDATE lesson SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_lesson_progress` (IN `p_id` INT)   BEGIN
  UPDATE lesson_progress SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_login` (IN `p_id` INT)   BEGIN
  UPDATE login SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_score` (IN `p_id` INT)   BEGIN
  UPDATE score SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_streak` (IN `p_id` INT)   BEGIN
  UPDATE streak SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_unit` (IN `p_id` INT)   BEGIN
  IF EXISTS (SELECT 1 FROM lesson WHERE unit_id = p_id AND is_deleted = 0)
  THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete unit: lessons exist under this unit.';
  ELSE
    UPDATE unit SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_user` (IN `p_id` INT)   BEGIN
  -- security: remove active session tokens and device info
  UPDATE login
  SET device_info = NULL, ip_address = NULL, session_token = NULL, expires_at = NULL
  WHERE user_id = p_id AND is_deleted = 0;

  -- mark user as deleted (soft)
  UPDATE `user` SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `soft_delete_user_achievement` (IN `p_id` INT)   BEGIN
  UPDATE user_achievement SET is_deleted = 1, deleted_at = NOW() WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_achievement` (IN `p_id` INT, IN `p_name` VARCHAR(255), IN `p_description` TEXT, IN `p_icon_url` VARCHAR(255))   BEGIN
  UPDATE achievement
  SET name = p_name,
      description = p_description,
      icon_url = p_icon_url
  WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_course` (IN `p_id` INT, IN `p_name` VARCHAR(255), IN `p_language_code` VARCHAR(10))   BEGIN
  UPDATE course SET name = p_name, language_code = p_language_code WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_friend_status` (IN `p_id` INT, IN `p_status` VARCHAR(50))   BEGIN
  UPDATE friend SET status = p_status WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_leaderboard` (IN `p_id` INT, IN `p_rank` INT, IN `p_xp_total` INT, IN `p_period` VARCHAR(50))   BEGIN
  UPDATE leaderboard
  SET rank = p_rank,
      xp_total = p_xp_total,
      period = p_period
  WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_lesson` (IN `p_id` INT, IN `p_title` VARCHAR(255), IN `p_description` TEXT, IN `p_difficulty` VARCHAR(50))   BEGIN
  UPDATE lesson SET title = p_title, description = p_description, difficulty = p_difficulty WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_lesson_progress` (IN `p_id` INT, IN `p_progress_percent` INT, IN `p_xp_total` INT, IN `p_attempts` INT)   BEGIN
  UPDATE lesson_progress
  SET progress_percent = p_progress_percent,
      xp_total = p_xp_total,
      attempts = p_attempts
  WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_login` (IN `p_id` INT, IN `p_device_info` VARCHAR(255), IN `p_ip_address` VARCHAR(45), IN `p_session_token` VARCHAR(255), IN `p_expires_at` TIMESTAMP)   BEGIN
  UPDATE login
  SET device_info = p_device_info,
      ip_address = p_ip_address,
      session_token = p_session_token,
      expires_at = p_expires_at
  WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_score` (IN `p_id` INT, IN `p_score` INT, IN `p_xp_earned` INT, IN `p_attempts` INT)   BEGIN
  UPDATE score
  SET score = p_score,
      xp_earned = p_xp_earned,
      attempts = p_attempts
  WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_streak` (IN `p_id` INT, IN `p_current_streak` INT, IN `p_longest_streak` INT, IN `p_last_active_date` DATE)   BEGIN
  UPDATE streak
  SET current_streak = p_current_streak,
      longest_streak = p_longest_streak,
      last_active_date = p_last_active_date
  WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_unit` (IN `p_id` INT, IN `p_title` VARCHAR(255), IN `p_order_index` INT)   BEGIN
  UPDATE unit SET title = p_title, order_index = p_order_index WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user` (IN `p_id` INT, IN `p_username` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_role` VARCHAR(50))   BEGIN
  UPDATE `user`
  SET username = p_username,
      email = p_email,
      role = p_role
  WHERE id = p_id AND is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_achievement` (IN `p_id` INT, IN `p_user_id` INT, IN `p_achievement_id` INT)   BEGIN
  UPDATE user_achievement
  SET user_id = p_user_id,
      achievement_id = p_achievement_id
  WHERE id = p_id AND is_deleted = 0;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `achievement`
--

CREATE TABLE `achievement` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `icon_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `achievement`
--

INSERT INTO `achievement` (`id`, `name`, `description`, `icon_url`, `created_at`, `is_deleted`, `deleted_at`) VALUES
(1, 'First Steps', 'Completed your first lesson', 'https://example.com/icons/first_steps.png', '2025-11-19 11:27:56', 0, NULL),
(2, 'Streak Starter', 'Maintained a 3-day learning streak', 'https://example.com/icons/streak.png', '2025-11-19 11:27:56', 0, NULL);

--
-- Triggers `achievement`
--
DELIMITER $$
CREATE TRIGGER `achievement_before_update_set_deleted_at` BEFORE UPDATE ON `achievement` FOR EACH ROW BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `language_code` varchar(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`id`, `name`, `language_code`, `created_at`, `is_deleted`, `deleted_at`) VALUES
(1, 'Spanish for Beginners', 'es', '2025-11-19 11:27:56', 0, NULL),
(2, 'French Essentials', 'fr', '2025-11-19 11:27:56', 0, NULL);

--
-- Triggers `course`
--
DELIMITER $$
CREATE TRIGGER `course_before_update_set_deleted_at` BEFORE UPDATE ON `course` FOR EACH ROW BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `friend`
--

CREATE TABLE `friend` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `friend_id` int(11) NOT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `friend`
--
DELIMITER $$
CREATE TRIGGER `friend_before_update_set_deleted_at` BEFORE UPDATE ON `friend` FOR EACH ROW BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `leaderboard`
--
DELIMITER $$
CREATE TRIGGER `leaderboard_before_update_set_deleted_at` BEFORE UPDATE ON `leaderboard` FOR EACH ROW BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `lesson`
--

CREATE TABLE `lesson` (
  `id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `difficulty` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `lesson`
--
DELIMITER $$
CREATE TRIGGER `lesson_before_update_set_deleted_at` BEFORE UPDATE ON `lesson` FOR EACH ROW BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

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
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `lesson_progress`
--
DELIMITER $$
CREATE TRIGGER `lesson_progress_before_update_set_deleted_at` BEFORE UPDATE ON `lesson_progress` FOR EACH ROW BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `login_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `device_info` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `session_token` varchar(255) DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `is_anonymized` tinyint(1) NOT NULL DEFAULT '0',
  `anonymized_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `login`
--
DELIMITER $$
CREATE TRIGGER `login_before_update_set_deleted_at` BEFORE UPDATE ON `login` FOR EACH ROW BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `score`
--

CREATE TABLE `score` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lesson_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  `xp_earned` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '1',
  `completed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `score`
--
DELIMITER $$
CREATE TRIGGER `score_before_update_set_deleted_at` BEFORE UPDATE ON `score` FOR EACH ROW BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `streak`
--

CREATE TABLE `streak` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `current_streak` int(11) NOT NULL DEFAULT '0',
  `longest_streak` int(11) NOT NULL DEFAULT '0',
  `last_active_date` date DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `streak`
--
DELIMITER $$
CREATE TRIGGER `streak_before_update_set_deleted_at` BEFORE UPDATE ON `streak` FOR EACH ROW BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `unit`
--

CREATE TABLE `unit` (
  `id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `order_index` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `unit`
--
DELIMITER $$
CREATE TRIGGER `unit_before_update_set_deleted_at` BEFORE UPDATE ON `unit` FOR EACH ROW BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `role` varchar(50) DEFAULT 'student',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `is_anonymized` tinyint(1) NOT NULL DEFAULT '0',
  `anonymized_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `email`, `password_hash`, `role`, `created_at`, `last_login`, `is_anonymized`, `anonymized_at`, `is_deleted`, `deleted_at`) VALUES
(1, 'alex_jones', 'alex.jones@example.com', 'hash_pw1', 'student', '2025-08-11 07:44:32', '2025-08-25 07:44:32', 0, NULL, 0, NULL),
(2, 'maria_lee', 'maria.lee@example.com', 'hash_pw2', 'student', '2025-08-12 07:44:32', '2025-08-24 07:44:32', 0, NULL, 0, NULL);

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `user_before_insert_set_defaults` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
  IF NEW.is_deleted IS NULL THEN SET NEW.is_deleted = 0; END IF;
  IF NEW.is_anonymized IS NULL THEN SET NEW.is_anonymized = 0; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `user_before_update_set_deleted_at` BEFORE UPDATE ON `user` FOR EACH ROW BEGIN
  -- If marking deleted (0 -> 1) and deleted_at is null, set deleted_at
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_achievement`
--

CREATE TABLE `user_achievement` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `achievement_id` int(11) NOT NULL,
  `earned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `user_achievement`
--
DELIMITER $$
CREATE TRIGGER `user_achievement_before_update_set_deleted_at` BEFORE UPDATE ON `user_achievement` FOR EACH ROW BEGIN
  IF OLD.is_deleted = 0 AND NEW.is_deleted = 1 THEN
    SET NEW.deleted_at = IF(NEW.deleted_at IS NULL, NOW(), NEW.deleted_at);
  END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `achievement`
--
ALTER TABLE `achievement`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `friend`
--
ALTER TABLE `friend`
  ADD PRIMARY KEY (`id`),
  ADD KEY `friend_user_id` (`user_id`),
  ADD KEY `friend_friend_id` (`friend_id`);

--
-- Indexes for table `leaderboard`
--
ALTER TABLE `leaderboard`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leaderboard_user_id` (`user_id`),
  ADD KEY `leaderboard_course_id` (`course_id`);

--
-- Indexes for table `lesson`
--
ALTER TABLE `lesson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lesson_unit_id` (`unit_id`);

--
-- Indexes for table `lesson_progress`
--
ALTER TABLE `lesson_progress`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lp_user_id` (`user_id`),
  ADD KEY `lp_lesson_id` (`lesson_id`),
  ADD KEY `lp_course_id` (`course_id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`id`),
  ADD KEY `login_user_id` (`user_id`);

--
-- Indexes for table `score`
--
ALTER TABLE `score`
  ADD PRIMARY KEY (`id`),
  ADD KEY `score_user_id` (`user_id`),
  ADD KEY `score_lesson_id` (`lesson_id`),
  ADD KEY `score_course_id` (`course_id`);

--
-- Indexes for table `streak`
--
ALTER TABLE `streak`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `streak_user_id_unique` (`user_id`);

--
-- Indexes for table `unit`
--
ALTER TABLE `unit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `unit_course_id` (`course_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_username_unique` (`username`),
  ADD UNIQUE KEY `user_email_unique` (`email`);

--
-- Indexes for table `user_achievement`
--
ALTER TABLE `user_achievement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ua_user_id` (`user_id`),
  ADD KEY `ua_achievement_id` (`achievement_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `achievement`
--
ALTER TABLE `achievement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `course`
--
ALTER TABLE `course`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `friend`
--
ALTER TABLE `friend`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leaderboard`
--
ALTER TABLE `leaderboard`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lesson`
--
ALTER TABLE `lesson`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lesson_progress`
--
ALTER TABLE `lesson_progress`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `score`
--
ALTER TABLE `score`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `streak`
--
ALTER TABLE `streak`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `unit`
--
ALTER TABLE `unit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user_achievement`
--
ALTER TABLE `user_achievement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `friend`
--
ALTER TABLE `friend`
  ADD CONSTRAINT `friend_ibfk_friend` FOREIGN KEY (`friend_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `friend_ibfk_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `leaderboard`
--
ALTER TABLE `leaderboard`
  ADD CONSTRAINT `leaderboard_ibfk_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  ADD CONSTRAINT `leaderboard_ibfk_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `lesson`
--
ALTER TABLE `lesson`
  ADD CONSTRAINT `lesson_ibfk_unit` FOREIGN KEY (`unit_id`) REFERENCES `unit` (`id`);

--
-- Constraints for table `lesson_progress`
--
ALTER TABLE `lesson_progress`
  ADD CONSTRAINT `lesson_progress_ibfk_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  ADD CONSTRAINT `lesson_progress_ibfk_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`),
  ADD CONSTRAINT `lesson_progress_ibfk_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `score`
--
ALTER TABLE `score`
  ADD CONSTRAINT `score_ibfk_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  ADD CONSTRAINT `score_ibfk_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`),
  ADD CONSTRAINT `score_ibfk_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `streak`
--
ALTER TABLE `streak`
  ADD CONSTRAINT `streak_ibfk_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `unit`
--
ALTER TABLE `unit`
  ADD CONSTRAINT `unit_ibfk_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`);

--
-- Constraints for table `user_achievement`
--
ALTER TABLE `user_achievement`
  ADD CONSTRAINT `user_achievement_ibfk_achievement` FOREIGN KEY (`achievement_id`) REFERENCES `achievement` (`id`),
  ADD CONSTRAINT `user_achievement_ibfk_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `anonymize_old_users_event` ON SCHEDULE EVERY 1 DAY STARTS '2025-11-19 11:27:56' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
  -- Execute anonymization for due users
  CALL anonymize_due_users();
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
