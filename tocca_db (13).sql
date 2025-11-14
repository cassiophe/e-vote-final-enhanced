-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 14, 2025 at 01:29 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tocca_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_admin_audit_log`
--

CREATE TABLE `tbl_admin_audit_log` (
  `log_id` int(11) NOT NULL,
  `event_time` datetime NOT NULL DEFAULT current_timestamp(),
  `admin_id` int(11) DEFAULT NULL,
  `admin_name` varchar(128) DEFAULT NULL,
  `module` varchar(64) NOT NULL,
  `entity_type` varchar(64) NOT NULL,
  `entity_id` varchar(64) DEFAULT NULL,
  `action` enum('create','update','delete','activate','deactivate','archive','restore','schedule_change','other') NOT NULL,
  `details_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details_json`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_admin_audit_log`
--

INSERT INTO `tbl_admin_audit_log` (`log_id`, `event_time`, `admin_id`, `admin_name`, `module`, `entity_type`, `entity_id`, `action`, `details_json`, `ip_address`, `user_agent`) VALUES
(24, '2025-10-14 14:42:46', NULL, 'testuser', 'categories', 'category', '7', 'delete', '{\"old\":{\"category_id\":7,\"category_name\":\"edited test category\",\"status\":1,\"event_id\":1}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(25, '2025-10-14 14:56:16', NULL, 'testuser', 'nomination_fields', 'nomination_field', '25', 'update', '{\"old\":{\"id\":25,\"label\":\"Official Business Name\",\"name\":\"official_business_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"new\":{\"id\":25,\"label\":\"Official Business Name test audit\",\"name\":\"official_business_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"diff\":{\"changed\":{\"label\":{\"old\":\"Official Business Name\",\"new\":\"Official Business Name test audit\"}}}}', NULL, NULL),
(26, '2025-10-14 15:04:17', NULL, 'testuser', 'nomination_fields', 'nomination_field', '25', 'update', '{\"old\":{\"id\":25,\"label\":\"Official Business Name test audit\",\"name\":\"official_business_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"new\":{\"id\":25,\"label\":\"Official Business Name original\",\"name\":\"official_business_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"diff\":{\"changed\":{\"label\":{\"old\":\"Official Business Name test audit\",\"new\":\"Official Business Name original\"}}}}', NULL, NULL),
(27, '2025-10-14 15:08:44', NULL, 'testuser', 'nomination_fields', 'nomination_field', '25', 'update', '{\"old\":{\"id\":25,\"label\":\"Official Business Name original\",\"name\":\"official_business_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"new\":{\"id\":25,\"label\":\"Official Business Name original 11\",\"name\":\"official_business_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"diff\":{\"changed\":{\"label\":{\"old\":\"Official Business Name original\",\"new\":\"Official Business Name original 11\"}}}}', NULL, NULL),
(28, '2025-10-14 15:09:57', NULL, 'testuser', 'nomination_fields', 'nomination_field', '26', 'update', '{\"old\":{\"id\":26,\"label\":\"Owner/President/General Manager\",\"name\":\"owner_president_general_manager\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":2},\"new\":{\"id\":26,\"label\":\"Owner/President/General Manager test est\",\"name\":\"owner_president_general_manager\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":2},\"diff\":{\"changed\":{\"label\":{\"old\":\"Owner/President/General Manager\",\"new\":\"Owner/President/General Manager test est\"}}}}', NULL, NULL),
(29, '2025-10-14 15:13:32', NULL, 'testuser', 'nomination_fields', 'nomination_field', '25', 'update', '{\"event_id\":1,\"old\":{\"id\":25,\"label\":\"Official Business Name original 11\",\"name\":\"official_business_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"new\":{\"id\":25,\"label\":\"Official Business Name\",\"name\":\"official_business_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"diff\":{\"changed\":{\"label\":{\"old\":\"Official Business Name original 11\",\"new\":\"Official Business Name\"}}}}', NULL, NULL),
(30, '2025-10-14 15:14:05', NULL, 'testuser', 'nomination_fields', 'nomination_field', '32', 'create', '{\"event_id\":1,\"new\":{\"id\":32,\"label\":\"test label for audit\",\"name\":\"test_label_for_audit\",\"type\":\"text\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":11}}', NULL, NULL),
(31, '2025-10-14 15:23:26', NULL, 'testuser', 'nomination_fields', 'nomination_field', '26', 'update', '{\"event_id\":1,\"old\":{\"id\":26,\"label\":\"Owner/President/General Manager test est\",\"name\":\"owner_president_general_manager\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":2},\"new\":{\"id\":26,\"label\":\"Owner/President/General Manager\",\"name\":\"owner_president_general_manager\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":2},\"diff\":{\"changed\":{\"label\":{\"old\":\"Owner/President/General Manager test est\",\"new\":\"Owner/President/General Manager\"}}}}', NULL, NULL),
(32, '2025-10-14 15:23:48', NULL, 'testuser', 'nomination_fields', 'nomination_field', '32', 'delete', '{\"event_id\":1,\"old\":{\"id\":32,\"label\":\"test label for audit\",\"name\":\"test_label_for_audit\",\"type\":\"text\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":11}}', NULL, NULL),
(33, '2025-10-14 15:24:12', NULL, 'testuser', 'nomination_fields', 'nomination_field', '28', 'update', '{\"event_id\":1,\"new\":{\"label\":\"Company Logo\"},\"diff\":{\"changed\":{\"is_active\":{\"old\":1,\"new\":0}}}}', NULL, NULL),
(34, '2025-10-14 15:25:22', NULL, 'testuser', 'nomination_fields', 'nomination_field', '29', 'update', '{\"event_id\":1,\"old\":{\"id\":29,\"label\":\"Business Address\",\"name\":\"business_address\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":5},\"new\":{\"id\":29,\"label\":\"Business Address\",\"name\":\"business_address\",\"type\":\"textarea\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":5},\"diff\":{\"changed\":{\"type\":{\"old\":\"text\",\"new\":\"textarea\"}}}}', NULL, NULL),
(35, '2025-10-14 15:26:21', NULL, 'testuser', 'nomination_fields', 'nomination_field', '29', 'update', '{\"event_id\":1,\"old\":{\"id\":29,\"label\":\"Business Address\",\"name\":\"business_address\",\"type\":\"textarea\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":5},\"new\":{\"id\":29,\"label\":\"Business Address\",\"name\":\"business_address\",\"type\":\"textarea\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":5},\"diff\":{\"changed\":{\"is_required\":{\"old\":1,\"new\":0}}}}', NULL, NULL),
(36, '2025-10-14 15:31:55', NULL, 'testuser', 'nomination_fields', 'nomination_field', '30', 'update', '{\"event_id\":1,\"old\":{\"id\":30,\"label\":\"Mobile Number\",\"name\":\"mobile_number\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":2},\"new\":{\"id\":30,\"label\":\"Mobile Number\",\"name\":\"mobile_number\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":3},\"diff\":{\"changed\":{\"sort_order\":{\"old\":2,\"new\":3}}}}', NULL, NULL),
(37, '2025-10-14 16:03:43', NULL, 'testuser', 'nomination_fields', 'nomination_field', '29', 'update', '{\"event_id\":1,\"old\":{\"id\":29,\"label\":\"Business Address\",\"name\":\"business_address\",\"type\":\"textarea\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":5},\"new\":{\"id\":29,\"label\":\"Business Address\",\"name\":\"business_address\",\"type\":\"select\",\"options\":[\"Option a\",\"Option b\",\"Option c\"],\"is_required\":0,\"is_active\":1,\"sort_order\":5},\"diff\":{\"changed\":{\"type\":{\"old\":\"textarea\",\"new\":\"select\"},\"options\":{\"old\":null,\"new\":[\"Option a\",\"Option b\",\"Option c\"]}}}}', NULL, NULL),
(38, '2025-10-14 16:05:19', NULL, 'testuser', 'nomination_fields', 'nomination_field', '29', 'update', '{\"event_id\":1,\"old\":{\"id\":29,\"label\":\"Business Address\",\"name\":\"business_address\",\"type\":\"select\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":5},\"new\":{\"id\":29,\"label\":\"Business Address\",\"name\":\"business_address\",\"type\":\"checkbox\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":5},\"diff\":{\"changed\":{\"type\":{\"old\":\"select\",\"new\":\"checkbox\"}}}}', NULL, NULL),
(39, '2025-10-14 16:06:14', NULL, 'testuser', 'categories', 'category', '10', 'create', '{\"new\":{\"category_id\":10,\"category_name\":\"add category\",\"status\":1,\"event_id\":1}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(40, '2025-10-14 16:07:20', NULL, 'testuser', 'categories', 'category', '10', 'deactivate', '{\"old\":{\"category_id\":10,\"category_name\":\"add category\",\"status\":1,\"event_id\":1},\"new\":{\"category_id\":10,\"category_name\":\"add category\",\"status\":0,\"event_id\":1},\"diff\":{\"changed\":{\"status\":{\"old\":1,\"new\":0}}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(41, '2025-10-14 16:08:05', NULL, 'testuser', 'categories', 'category', '10', 'update', '{\"old\":{\"category_id\":10,\"category_name\":\"add category\",\"status\":0,\"event_id\":1},\"new\":{\"category_name\":\"CATEGORY ADD\",\"event_id\":1},\"diff\":{\"changed\":{\"category_name\":{\"old\":\"add category\",\"new\":\"CATEGORY ADD\"}}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(42, '2025-10-14 16:08:26', NULL, 'testuser', 'categories', 'category', '10', 'delete', '{\"old\":{\"category_id\":10,\"category_name\":\"CATEGORY ADD\",\"status\":0,\"event_id\":1}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(43, '2025-10-14 16:41:22', NULL, 'testuser', 'nomination_fields', 'nomination_field', '28', 'update', '{\"event_id\":1,\"new\":{\"label\":\"Company Logo\"},\"diff\":{\"changed\":{\"is_active\":{\"old\":0,\"new\":1}}}}', NULL, NULL),
(44, '2025-10-14 17:04:55', NULL, 'testuser', 'schedule', 'event_schedule', '1', 'schedule_change', '{\"event_id\":1,\"diff\":{\"changed\":{\"nomination_start\":{\"old\":\"2025-10-14 01:00:00\",\"new\":\"2025-10-14 04:00:00\"}}}}', NULL, NULL),
(45, '2025-10-14 17:42:43', NULL, 'testuser', 'nomination_fields', 'nomination_field', '25', 'update', '{\"event_id\":1,\"new\":{\"label\":\"Official Business Name\"},\"diff\":{\"changed\":{\"is_active\":{\"old\":1,\"new\":0}}}}', NULL, NULL),
(46, '2025-10-14 17:43:49', NULL, 'testuser', 'schedule', 'event_schedule', '1', 'schedule_change', '{\"event_id\":1,\"diff\":{\"changed\":{\"nomination_start\":{\"old\":\"2025-10-14 04:00:00\",\"new\":\"2025-10-14 06:00:00\"}}}}', NULL, NULL),
(47, '2025-10-14 17:46:38', NULL, 'testuser', 'nomination_fields', 'nomination_text', NULL, 'update', '{\"section\":\"instructions\",\"event_id\":1,\"diff\":{\"changed\":{\"bullets_json\":{\"old\":\"[\\\"poipo\\\",\\\"iiopi\\\",\\\"iiopiop\\\"]\",\"new\":\"[\\\"one\\\",\\\"two\\\",\\\"three\\\"]\"}}}}', NULL, NULL),
(48, '2025-10-14 17:48:21', NULL, 'testuser', 'events', 'event', '18', 'create', '{\"event_id\":18,\"new\":{\"event_id\":18,\"event_name\":\"Test Event 2\",\"year\":2025,\"description\":\"test\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-14 17:48:21\"}}', NULL, NULL),
(49, '2025-10-14 17:53:41', NULL, 'testuser', 'events', 'event', '1', 'activate', '{\"event_id\":1,\"new\":{\"event_id\":1,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-07-17 04:55:36\"}}', NULL, NULL),
(50, '2025-10-14 20:02:05', NULL, 'testuser', 'nomination_fields', 'nomination_field', '25', 'update', '{\"event_id\":1,\"new\":{\"label\":\"Official Business Name\"},\"diff\":{\"changed\":{\"is_active\":{\"old\":0,\"new\":1}}}}', NULL, NULL),
(51, '2025-10-14 20:41:57', NULL, 'testuser', 'nomination_fields', 'nomination_text', NULL, 'update', '{\"section\":\"intro\",\"event_id\":1,\"diff\":{\"changed\":{\"body_html\":{\"old\":\"\",\"new\":\"test test test introduction\"}}}}', NULL, NULL),
(52, '2025-10-14 20:42:54', NULL, 'testuser', 'nomination_fields', 'nomination_field', '29', 'update', '{\"event_id\":1,\"old\":{\"id\":29,\"label\":\"Business Address\",\"name\":\"business_address\",\"type\":\"checkbox\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":5},\"new\":{\"id\":29,\"label\":\"Business Address\",\"name\":\"business_address\",\"type\":\"text\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":5},\"diff\":{\"changed\":{\"type\":{\"old\":\"checkbox\",\"new\":\"text\"}}}}', NULL, NULL),
(53, '2025-10-14 20:46:18', NULL, 'testuser', 'nomination_fields', 'nomination_field', '33', 'create', '{\"event_id\":1,\"new\":{\"id\":33,\"label\":\"Able to see your name:\",\"name\":\"able_to_see_your_name\",\"type\":\"radio\",\"options\":[\"Anonymous\",\"Not\"],\"is_required\":0,\"is_active\":1,\"sort_order\":0}}', NULL, NULL),
(54, '2025-10-14 20:46:53', NULL, 'testuser', 'nomination_fields', 'nomination_field', '33', 'update', '{\"event_id\":1,\"old\":{\"id\":33,\"label\":\"Able to see your name:\",\"name\":\"able_to_see_your_name\",\"type\":\"radio\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":0},\"new\":{\"id\":33,\"label\":\"Able to see your name:\",\"name\":\"able_to_see_your_name\",\"type\":\"radio\",\"options\":[\"option a\",\"option b\"],\"is_required\":1,\"is_active\":1,\"sort_order\":0},\"diff\":{\"changed\":{\"is_required\":{\"old\":0,\"new\":1},\"options\":{\"old\":null,\"new\":[\"option a\",\"option b\"]}}}}', NULL, NULL),
(55, '2025-10-14 20:47:27', NULL, 'testuser', 'nomination_fields', 'nomination_field', '33', 'update', '{\"event_id\":1,\"old\":{\"id\":33,\"label\":\"Able to see your name:\",\"name\":\"able_to_see_your_name\",\"type\":\"radio\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":0},\"new\":{\"id\":33,\"label\":\"Able to see your name:\",\"name\":\"able_to_see_your_name\",\"type\":\"checkbox\",\"options\":[\"option a\",\"option b\"],\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"diff\":{\"changed\":{\"type\":{\"old\":\"radio\",\"new\":\"checkbox\"},\"sort_order\":{\"old\":0,\"new\":1},\"options\":{\"old\":null,\"new\":[\"option a\",\"option b\"]}}}}', NULL, NULL),
(56, '2025-10-14 22:30:14', NULL, 'testuser', 'nomination_fields', 'nomination_field', '34', 'create', '{\"event_id\":1,\"new\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"radio\",\"options\":[\"a\",\"b\",\"c\"],\"is_required\":0,\"is_active\":1,\"sort_order\":0}}', NULL, NULL),
(57, '2025-10-14 22:30:23', NULL, 'testuser', 'nomination_fields', 'nomination_field', '34', 'update', '{\"event_id\":1,\"old\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"radio\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":0},\"new\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"radio\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":11},\"diff\":{\"changed\":{\"sort_order\":{\"old\":0,\"new\":11}}}}', NULL, NULL),
(58, '2025-10-14 22:33:37', NULL, 'testuser', 'nomination_fields', 'nomination_field', '34', 'update', '{\"event_id\":1,\"old\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"radio\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":11},\"new\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"radio\",\"options\":[\"angel\",\"rysha\",\"lianne\"],\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"diff\":{\"changed\":{\"is_required\":{\"old\":0,\"new\":1},\"options\":{\"old\":null,\"new\":[\"angel\",\"rysha\",\"lianne\"]}}}}', NULL, NULL),
(59, '2025-10-14 22:39:40', NULL, 'testuser', 'nomination_fields', 'nomination_field', '34', 'update', '{\"event_id\":1,\"old\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"radio\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"new\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"radio\",\"options\":[\"A\",\"B\",\"C\"],\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"diff\":{\"changed\":{\"options\":{\"old\":null,\"new\":[\"A\",\"B\",\"C\"]}}}}', NULL, NULL),
(60, '2025-10-14 22:44:07', NULL, 'testuser', 'nomination_fields', 'nomination_field', '34', 'update', '{\"event_id\":1,\"old\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"radio\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"new\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"radio\",\"options\":[\"a\",\"b\",\"c\"],\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"diff\":{\"changed\":{\"options\":{\"old\":null,\"new\":[\"a\",\"b\",\"c\"]}}}}', NULL, NULL),
(61, '2025-10-14 22:45:34', NULL, 'testuser', 'nomination_fields', 'nomination_field', '34', 'update', '{\"event_id\":1,\"old\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"radio\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"new\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"select\",\"options\":[\"a\",\"b\",\"c\"],\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"diff\":{\"changed\":{\"type\":{\"old\":\"radio\",\"new\":\"select\"},\"options\":{\"old\":null,\"new\":[\"a\",\"b\",\"c\"]}}}}', NULL, NULL),
(62, '2025-10-14 22:48:05', NULL, 'testuser', 'nomination_fields', 'nomination_field', '34', 'update', '{\"event_id\":1,\"old\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"select\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"new\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"select\",\"options\":[\"b\",\"f\",\"d\",\"d\"],\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"diff\":{\"changed\":{\"options\":{\"old\":null,\"new\":[\"b\",\"f\",\"d\",\"d\"]}}}}', NULL, NULL),
(63, '2025-10-14 22:49:01', NULL, 'testuser', 'nomination_fields', 'nomination_field', '34', 'update', '{\"event_id\":1,\"old\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"select\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"new\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"select\",\"options\":[\"s\",\"d\",\"f\"],\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"diff\":{\"changed\":{\"options\":{\"old\":null,\"new\":[\"s\",\"d\",\"f\"]}}}}', NULL, NULL),
(64, '2025-10-14 23:08:52', NULL, 'testuser', 'nomination_fields', 'nomination_field', '34', 'update', '{\"event_id\":1,\"old\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"select\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"new\":{\"id\":34,\"label\":\"Test Radio Button\",\"name\":\"test_radio_button\",\"type\":\"select\",\"options\":[\"K\",\"D\",\"S\"],\"is_required\":1,\"is_active\":1,\"sort_order\":11},\"diff\":{\"changed\":{\"options\":{\"old\":null,\"new\":[\"K\",\"D\",\"S\"]}}}}', NULL, NULL),
(65, '2025-10-14 23:09:57', NULL, 'testuser', 'nomination_fields', 'nomination_field', '33', 'update', '{\"event_id\":1,\"old\":{\"id\":33,\"label\":\"Able to see your name:\",\"name\":\"able_to_see_your_name\",\"type\":\"checkbox\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"new\":{\"id\":33,\"label\":\"Able to see your name:\",\"name\":\"able_to_see_your_name\",\"type\":\"checkbox\",\"options\":[\"YES\",\"NO\"],\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"diff\":{\"changed\":{\"options\":{\"old\":null,\"new\":[\"YES\",\"NO\"]}}}}', NULL, NULL),
(66, '2025-10-14 23:10:10', NULL, 'testuser', 'nomination_fields', 'nomination_field', '33', 'delete', '{\"event_id\":1,\"old\":{\"id\":33,\"label\":\"Able to see your name:\",\"name\":\"able_to_see_your_name\",\"type\":\"checkbox\",\"options\":[\"YES\",\"NO\"],\"is_required\":1,\"is_active\":1,\"sort_order\":1}}', NULL, NULL),
(67, '2025-10-14 23:25:26', NULL, 'testuser', 'schedule', 'event_schedule', '1', 'schedule_change', '{\"event_id\":1,\"diff\":{\"changed\":{\"voting_start\":{\"old\":\"2025-10-22 01:00:00\",\"new\":\"2025-10-16 01:00:00\"}}}}', NULL, NULL),
(68, '2025-10-14 23:25:32', NULL, 'testuser', 'schedule', 'event_schedule', '1', 'schedule_change', '{\"event_id\":1,\"diff\":{\"changed\":{\"voting_end\":{\"old\":\"2025-10-23 23:59:00\",\"new\":\"2025-10-17 23:59:00\"}}}}', NULL, NULL),
(69, '2025-10-14 23:33:12', NULL, 'testuser', 'nomination_fields', 'nomination_field', '35', 'create', '{\"event_id\":1,\"new\":{\"id\":35,\"label\":\"Gender\",\"name\":\"gender\",\"type\":\"radio\",\"options\":[\"Female\",\"Male\"],\"is_required\":1,\"is_active\":1,\"sort_order\":0}}', NULL, NULL),
(70, '2025-10-14 23:53:39', NULL, 'testuser', 'events', 'event', '18', 'archive', '{\"event_id\":18,\"old\":{\"event_id\":18,\"event_name\":\"Test Event 2\",\"year\":2025,\"description\":\"test\",\"is_active\":0,\"is_archived\":0,\"created_at\":\"2025-10-14 17:48:21\"},\"new\":{\"event_id\":18,\"event_name\":\"Test Event 2\",\"year\":2025,\"description\":\"test\",\"is_active\":0,\"is_archived\":1,\"created_at\":\"2025-10-14 17:48:21\"},\"diff\":{\"changed\":{\"is_archived\":{\"old\":0,\"new\":1}}}}', NULL, NULL),
(71, '2025-10-14 23:53:41', NULL, 'testuser', 'events', 'event', '15', 'archive', '{\"event_id\":15,\"old\":{\"event_id\":15,\"event_name\":\"test 10000\",\"year\":2025,\"description\":\"test description\",\"is_active\":0,\"is_archived\":0,\"created_at\":\"2025-10-14 12:11:58\"},\"new\":{\"event_id\":15,\"event_name\":\"test 10000\",\"year\":2025,\"description\":\"test description\",\"is_active\":0,\"is_archived\":1,\"created_at\":\"2025-10-14 12:11:58\"},\"diff\":{\"changed\":{\"is_archived\":{\"old\":0,\"new\":1}}}}', NULL, NULL),
(72, '2025-10-14 23:53:43', NULL, 'testuser', 'events', 'event', '7', 'archive', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"Test Event\",\"year\":2025,\"description\":\"TEST\",\"is_active\":0,\"is_archived\":0,\"created_at\":\"2025-10-14 11:37:04\"},\"new\":{\"event_id\":7,\"event_name\":\"Test Event\",\"year\":2025,\"description\":\"TEST\",\"is_active\":0,\"is_archived\":1,\"created_at\":\"2025-10-14 11:37:04\"},\"diff\":{\"changed\":{\"is_archived\":{\"old\":0,\"new\":1}}}}', NULL, NULL),
(73, '2025-10-14 23:55:21', NULL, 'testuser', 'events', 'event', '1', 'archive', '{\"event_id\":1,\"old\":{\"event_id\":1,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-07-17 04:55:36\"},\"new\":{\"event_id\":1,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":0,\"is_archived\":1,\"created_at\":\"2025-07-17 04:55:36\"},\"diff\":{\"changed\":{\"is_archived\":{\"old\":0,\"new\":1},\"is_active\":{\"old\":1,\"new\":0}}}}', NULL, NULL),
(74, '2025-10-15 01:18:23', NULL, NULL, 'events', 'event', '19', 'create', '{\"event_id\":19,\"new\":{\"event_id\":19,\"event_name\":\"gergre\",\"year\":2025,\"description\":\"trhrthrt\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-15 01:18:23\",\"nomination_start\":\"2025-10-16 01:18:00\",\"nomination_end\":\"2025-10-17 01:18:00\",\"voting_start\":\"2025-10-18 01:18:00\",\"voting_end\":\"2025-10-19 01:18:00\"}}', NULL, NULL),
(75, '2025-10-15 01:18:51', NULL, 'testuser', 'events', 'event', '1', 'activate', '{\"event_id\":1,\"new\":{\"event_id\":1,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-07-17 04:55:36\",\"nomination_start\":\"2025-10-14 06:00:00\",\"nomination_end\":\"2025-10-15 13:40:00\",\"voting_start\":\"2025-10-16 01:00:00\",\"voting_end\":\"2025-10-17 23:59:00\"}}', NULL, NULL),
(76, '2025-10-15 01:27:51', NULL, 'testuser', 'events', 'event', '19', 'archive', '{\"event_id\":19,\"old\":{\"event_id\":19,\"event_name\":\"gergre\",\"year\":2025,\"description\":\"trhrthrt\",\"is_active\":0,\"is_archived\":0,\"created_at\":\"2025-10-15 01:18:23\",\"nomination_start\":\"2025-10-16 01:18:00\",\"nomination_end\":\"2025-10-17 01:18:00\",\"voting_start\":\"2025-10-18 01:18:00\",\"voting_end\":\"2025-10-19 01:18:00\"},\"new\":{\"event_id\":19,\"event_name\":\"gergre\",\"year\":2025,\"description\":\"trhrthrt\",\"is_active\":0,\"is_archived\":1,\"created_at\":\"2025-10-15 01:18:23\",\"nomination_start\":\"2025-10-16 01:18:00\",\"nomination_end\":\"2025-10-17 01:18:00\",\"voting_start\":\"2025-10-18 01:18:00\",\"voting_end\":\"2025-10-19 01:18:00\"},\"diff\":{\"changed\":{\"is_archived\":{\"old\":0,\"new\":1}}}}', NULL, NULL),
(77, '2025-10-15 01:44:21', NULL, 'testuser', 'events', 'event', '1', 'update', '{\"event_id\":1,\"old\":{\"event_id\":1,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-07-17 04:55:36\",\"nomination_start\":\"2025-10-14 06:00:00\",\"nomination_end\":\"2025-10-15 13:40:00\",\"voting_start\":\"2025-10-16 01:00:00\",\"voting_end\":\"2025-10-17 23:59:00\"},\"new\":{\"event_id\":1,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-07-17 04:55:36\",\"nomination_start\":\"2025-10-13 06:00:00\",\"nomination_end\":\"2025-10-14 13:40:00\",\"voting_start\":\"2025-10-15 01:00:00\",\"voting_end\":\"2025-10-17 23:59:00\"},\"diff\":{\"changed\":{\"nomination_start\":{\"old\":\"2025-10-14 06:00:00\",\"new\":\"2025-10-13 06:00:00\"},\"nomination_end\":{\"old\":\"2025-10-15 13:40:00\",\"new\":\"2025-10-14 13:40:00\"},\"voting_start\":{\"old\":\"2025-10-16 01:00:00\",\"new\":\"2025-10-15 01:00:00\"}}}}', NULL, NULL),
(78, '2025-10-15 11:52:33', NULL, 'testuser', 'categories', 'category', '4', 'delete', '{\"old\":{\"category_id\":4,\"category_name\":\"Feelings\",\"status\":1,\"event_id\":1}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(79, '2025-10-15 11:52:54', NULL, 'testuser', 'categories', 'category', '1', 'delete', '{\"old\":{\"category_id\":1,\"category_name\":\"Food\",\"status\":1,\"event_id\":1}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(80, '2025-10-15 11:52:56', NULL, 'testuser', 'categories', 'category', '3', 'delete', '{\"old\":{\"category_id\":3,\"category_name\":\"Retail\",\"status\":1,\"event_id\":1}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(81, '2025-10-15 11:52:59', NULL, 'testuser', 'categories', 'category', '2', 'delete', '{\"old\":{\"category_id\":2,\"category_name\":\"Service\",\"status\":1,\"event_id\":1}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(82, '2025-10-15 11:53:02', NULL, 'testuser', 'categories', 'category', '7', 'delete', '{\"old\":{\"category_id\":7,\"category_name\":\"test\",\"status\":1,\"event_id\":1}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(83, '2025-10-15 11:58:36', NULL, 'testuser', 'categories', 'category', '8', 'create', '{\"new\":{\"category_id\":8,\"category_name\":\"Food\",\"status\":1,\"event_id\":1}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(84, '2025-10-15 12:00:00', NULL, 'testuser', 'questions', 'question', '62', 'create', '{\"new\":{\"question_id\":62,\"question_name\":\"Best Pandesal\",\"category_id\":8,\"choice_type\":1,\"event_id\":1}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(85, '2025-10-15 12:00:51', NULL, 'testuser', 'questions', 'question', '62', 'update', '{\"old\":{\"question_id\":62,\"question_name\":\"Best Pandesal\",\"category_id\":8,\"choice_type\":1,\"event_id\":1},\"new\":{\"question_id\":62,\"question_name\":\"Best Pandesal\",\"category_id\":8,\"choice_type\":0,\"event_id\":1},\"diff\":{\"changed\":{\"choice_type\":{\"old\":1,\"new\":0}}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(86, '2025-10-15 12:07:44', NULL, 'testuser', 'choices', 'choice', '58', 'delete', '{\"old\":{\"choice_id\":58,\"choice_name\":\"\",\"email\":\"gucelarysha@gmail.com\",\"status\":1,\"event_id\":1,\"links\":{\"old\":[]}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(87, '2025-10-15 12:08:21', NULL, 'testuser', 'choices', 'choice', '49', 'activate', '{\"old\":{\"choice_id\":49,\"choice_name\":\"Andoks\",\"email\":\"pyonicoy@gmail.com\",\"status\":0,\"event_id\":1},\"new\":{\"choice_id\":49,\"choice_name\":\"Andoks\",\"email\":\"pyonicoy@gmail.com\",\"status\":1,\"event_id\":1},\"diff\":{\"changed\":{\"status\":{\"old\":0,\"new\":1}}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(88, '2025-10-15 12:08:39', NULL, 'testuser', 'choices', 'choice', '49', 'delete', '{\"old\":{\"choice_id\":49,\"choice_name\":\"Andoks\",\"email\":\"pyonicoy@gmail.com\",\"status\":1,\"event_id\":1,\"links\":{\"old\":[]}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(89, '2025-10-15 12:12:51', NULL, 'testuser', 'nomination_fields', 'nomination_field', '23', 'update', '{\"event_id\":1,\"new\":{\"label\":\"Type\"},\"diff\":{\"changed\":{\"is_active\":{\"old\":1,\"new\":0}}}}', NULL, NULL),
(90, '2025-10-15 12:13:29', NULL, 'testuser', 'nomination_fields', 'nomination_text', NULL, 'update', '{\"section\":\"intro\",\"event_id\":1,\"diff\":{\"changed\":{\"body_html\":{\"old\":\"k;;k;kl;kl;kl;klkl;kl\",\"new\":\"teeeeeeeeeeeeeeeeeeeeeeeest\"}}}}', NULL, NULL),
(91, '2025-10-16 05:53:35', NULL, 'testuser', 'nomination_fields', 'nomination_text', NULL, 'update', '{\"section\":\"intro\",\"event_id\":1,\"diff\":{\"changed\":{\"body_html\":{\"old\":null,\"new\":\"The City Government of Ormoc through the Tatak Ormoc Business Awards Organizing Committee in partnership with the Ormoc City Chamber of Commerce and Industry and STI College – Ormoc is pleased to inform the public of the opening of the 2024 Tatak Ormoc Consumers’ Choice Awards (TOCCA)\\r\\n\\r\\nThe 2024 TOCCA determines which Ormocanon products and services are top of mind to the citizens, and recognizes the best among them.\"},\"is_active\":{\"old\":null,\"new\":0}}}}', NULL, NULL),
(92, '2025-10-16 05:54:40', NULL, 'testuser', 'nomination_fields', 'nomination_text', NULL, 'update', '{\"section\":\"instructions\",\"event_id\":1,\"diff\":{\"changed\":{\"title\":{\"old\":null,\"new\":\"Instructions\"},\"bullets_json\":{\"old\":null,\"new\":\"[\\\"Please complete all required fields before submitting.\\\",\\\"Select the category and awards that best fit your business.\\\",\\\"Use the address search to auto-fill your exact location.\\\",\\\"Prepare your official business or company name.\\\",\\\"Have a high-resolution company logo ready (PNG\\\\/JPG\\\\/WEBP, max 10MB).\\\",\\\"Keep your current Mayor\'s Permit number on hand.\\\",\\\"Provide a complete business address: Street, Barangay, City\\\\/Municipality, Province, and Postal Code.\\\",\\\"Know the full name of the owner, president, or general manager.\\\",\\\"Ensure you have a mobile number in 09XXXXXXXXX format.\\\"]\"},\"is_active\":{\"old\":null,\"new\":1}}}}', NULL, NULL),
(93, '2025-10-16 06:53:48', NULL, 'testuser', 'events', 'event', '7', 'create', '{\"event_id\":7,\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 20:53:00\",\"voting_start\":\"2025-10-16 09:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"}}', NULL, NULL),
(94, '2025-10-16 07:09:01', NULL, 'testuser', 'categories', 'category', '9', 'create', '{\"new\":{\"category_id\":9,\"category_name\":\"Food\",\"status\":1,\"event_id\":7}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(95, '2025-10-16 07:12:01', NULL, 'testuser', 'categories', 'category', '9', 'update', '{\"old\":{\"category_id\":9,\"category_name\":\"Food\",\"status\":1,\"event_id\":7},\"new\":{\"category_name\":\"Food\",\"event_id\":7},\"diff\":{\"changed\":[]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(96, '2025-10-16 07:12:28', NULL, 'testuser', 'categories', 'category', '9', 'update', '{\"old\":{\"category_id\":9,\"category_name\":\"Food\",\"status\":1,\"event_id\":7},\"new\":{\"category_name\":\"Foods\",\"event_id\":7},\"diff\":{\"changed\":{\"category_name\":{\"old\":\"Food\",\"new\":\"Foods\"}}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(97, '2025-10-16 08:13:06', NULL, 'testuser', 'nomination_fields', 'nomination_text', NULL, 'update', '{\"section\":\"intro\",\"event_id\":7,\"diff\":{\"changed\":{\"body_html\":{\"old\":null,\"new\":\"The City Government of Ormoc through the **Tatak Ormoc Business Awards Organizing Committee** in partnership with the Ormoc City Chamber of Commerce and Industry and STI College – Ormoc is pleased to inform the public of the opening of the **2024 Tatak Ormoc Consumers’ Choice Awards (TOCCA)**\\r\\n\\r\\nThe 2024 TOCCA determines which Ormocanon products and services are top of mind to the citizens, and recognizes the best among them.\"},\"is_active\":{\"old\":null,\"new\":1}}}}', NULL, NULL),
(98, '2025-10-16 08:13:26', NULL, 'testuser', 'nomination_fields', 'nomination_text', NULL, 'update', '{\"section\":\"instructions\",\"event_id\":7,\"diff\":{\"changed\":{\"title\":{\"old\":null,\"new\":\"Instructions\"},\"bullets_json\":{\"old\":null,\"new\":\"[\\\"Please complete all required fields before submitting.\\\",\\\"Select the category and awards that best fit your business.\\\",\\\"Use the address search to auto-fill your exact location.\\\",\\\"Prepare your official business or company name.\\\",\\\"Have a high-resolution company logo ready (PNG\\\\/JPG\\\\/WEBP, max 10MB).\\\",\\\"Keep your current Mayor\'s Permit number on hand.\\\",\\\"Provide a complete business address: Street, Barangay, City\\\\/Municipality, Province, and Postal Code.\\\",\\\"Know the full name of the owner, president, or general manager.\\\",\\\"Ensure you have a mobile number in 09XXXXXXXXX format.\\\"]\"},\"is_active\":{\"old\":null,\"new\":1}}}}', NULL, NULL),
(99, '2025-10-16 08:13:58', NULL, 'testuser', 'nomination_fields', 'nomination_text', NULL, 'update', '{\"section\":\"instructions\",\"event_id\":7,\"diff\":{\"changed\":{\"title\":{\"old\":\"Instructions\",\"new\":\"**Instructions**\"}}}}', NULL, NULL),
(100, '2025-10-16 08:14:14', NULL, 'testuser', 'nomination_fields', 'nomination_text', NULL, 'update', '{\"section\":\"instructions\",\"event_id\":7,\"diff\":{\"changed\":{\"title\":{\"old\":\"**Instructions**\",\"new\":\"Instructions\"}}}}', NULL, NULL),
(101, '2025-10-16 08:15:16', NULL, 'testuser', 'nomination_fields', 'nomination_text', NULL, 'update', '{\"section\":\"instructions\",\"event_id\":7,\"diff\":{\"changed\":{\"bullets_json\":{\"old\":\"[\\\"Please complete all required fields before submitting.\\\",\\\"Select the category and awards that best fit your business.\\\",\\\"Use the address search to auto-fill your exact location.\\\",\\\"Prepare your official business or company name.\\\",\\\"Have a high-resolution company logo ready (PNG\\\\/JPG\\\\/WEBP, max 10MB).\\\",\\\"Keep your current Mayor\'s Permit number on hand.\\\",\\\"Provide a complete business address: Street, Barangay, City\\\\/Municipality, Province, and Postal Code.\\\",\\\"Know the full name of the owner, president, or general manager.\\\",\\\"Ensure you have a mobile number in 09XXXXXXXXX format.\\\"]\",\"new\":\"[\\\"Please complete all required fields before submitting.\\\",\\\"Select the category and awards that best fit your business.\\\",\\\"Use the address search to auto-fill your exact location.\\\",\\\"Prepare your official business or company name.\\\",\\\"Have a high-resolution company logo ready (PNG\\\\/JPG\\\\/WEBP, max 10MB).\\\",\\\"Keep your current Mayor\'s Permit number on hand.\\\",\\\"Provide a complete business address: Street, Barangay, City\\\\/Municipality, Province, and Postal Code.\\\",\\\"Know the full name of the owner, president, or general manager.\\\",\\\"Ensure you have a mobile number in **09XXXXXXXXX** format.\\\"]\"}}}}', NULL, NULL),
(102, '2025-10-16 08:17:46', NULL, 'testuser', 'nomination_fields', 'nomination_field', '24', 'create', '{\"event_id\":7,\"new\":{\"id\":24,\"label\":\"Business/Company Name\",\"name\":\"business_company_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":0}}', NULL, NULL),
(103, '2025-10-16 08:18:19', NULL, 'testuser', 'nomination_fields', 'nomination_field', '25', 'create', '{\"event_id\":7,\"new\":{\"id\":25,\"label\":\"Name of Ownder/President/General Manager\",\"name\":\"name_of_ownder_president_general_manager\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1}}', NULL, NULL),
(104, '2025-10-16 08:18:34', NULL, 'testuser', 'nomination_fields', 'nomination_field', '26', 'create', '{\"event_id\":7,\"new\":{\"id\":26,\"label\":\"Mobile Number\",\"name\":\"mobile_number\",\"type\":\"tel\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":3}}', NULL, NULL),
(105, '2025-10-16 08:20:57', NULL, 'testuser', 'nomination_fields', 'nomination_field', '27', 'create', '{\"event_id\":7,\"new\":{\"id\":27,\"label\":\"Designation in the Business/Company\",\"name\":\"designation_in_the_business_company\",\"type\":\"select\",\"options\":[\"Sole Proprietorship\",\"Partnership\",\"Limited Liability Company\",\"Corporation\"],\"is_required\":1,\"is_active\":1,\"sort_order\":4}}', NULL, NULL),
(106, '2025-10-16 08:21:21', NULL, 'testuser', 'nomination_fields', 'nomination_field', '28', 'create', '{\"event_id\":7,\"new\":{\"id\":28,\"label\":\"Mayor\'s Permit Number\",\"name\":\"mayor_s_permit_number\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":5}}', NULL, NULL),
(107, '2025-10-16 08:21:36', NULL, 'testuser', 'nomination_fields', 'nomination_field', '29', 'create', '{\"event_id\":7,\"new\":{\"id\":29,\"label\":\"Email\",\"name\":\"email\",\"type\":\"email\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":6}}', NULL, NULL),
(108, '2025-10-16 08:21:54', NULL, 'testuser', 'nomination_fields', 'nomination_field', '30', 'create', '{\"event_id\":7,\"new\":{\"id\":30,\"label\":\"Website\",\"name\":\"website\",\"type\":\"url\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":7}}', NULL, NULL),
(109, '2025-10-16 08:22:24', NULL, 'testuser', 'nomination_fields', 'nomination_field', '31', 'create', '{\"event_id\":7,\"new\":{\"id\":31,\"label\":\"Business/Company Address\",\"name\":\"business_company_address\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":8}}', NULL, NULL),
(110, '2025-10-16 08:22:41', NULL, 'testuser', 'nomination_fields', 'nomination_field', '32', 'create', '{\"event_id\":7,\"new\":{\"id\":32,\"label\":\"Business/Company Logo\",\"name\":\"business_company_logo\",\"type\":\"file\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":0}}', NULL, NULL),
(111, '2025-10-16 08:22:57', NULL, 'testuser', 'nomination_fields', 'nomination_field', '24', 'update', '{\"event_id\":7,\"old\":{\"id\":24,\"label\":\"Business/Company Name\",\"name\":\"business_company_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":0},\"new\":{\"id\":24,\"label\":\"Business/Company Name\",\"name\":\"business_company_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":0},\"diff\":{\"changed\":[]}}', NULL, NULL),
(112, '2025-10-16 08:23:03', NULL, 'testuser', 'nomination_fields', 'nomination_field', '32', 'update', '{\"event_id\":7,\"old\":{\"id\":32,\"label\":\"Business/Company Logo\",\"name\":\"business_company_logo\",\"type\":\"file\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":0},\"new\":{\"id\":32,\"label\":\"Business/Company Logo\",\"name\":\"business_company_logo\",\"type\":\"file\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":9},\"diff\":{\"changed\":{\"sort_order\":{\"old\":0,\"new\":9}}}}', NULL, NULL),
(113, '2025-10-16 08:23:38', NULL, 'testuser', 'nomination_fields', 'nomination_field', '27', 'update', '{\"event_id\":7,\"old\":{\"id\":27,\"label\":\"Designation in the Business/Company\",\"name\":\"designation_in_the_business_company\",\"type\":\"select\",\"options\":[\"Sole Proprietorship\",\"Partnership\",\"Limited Liability Company\",\"Corporation\"],\"is_required\":1,\"is_active\":1,\"sort_order\":4},\"new\":{\"id\":27,\"label\":\"Designation in the Business/Company\",\"name\":\"designation_in_the_business_company\",\"type\":\"radio\",\"options\":[\"Sole Proprietorship\",\"Partnership\",\"Limited Liability Company\",\"Corporation\"],\"is_required\":1,\"is_active\":1,\"sort_order\":4},\"diff\":{\"changed\":{\"type\":{\"old\":\"select\",\"new\":\"radio\"}}}}', NULL, NULL),
(114, '2025-10-16 08:23:57', NULL, 'testuser', 'nomination_fields', 'nomination_field', '27', 'update', '{\"event_id\":7,\"old\":{\"id\":27,\"label\":\"Designation in the Business/Company\",\"name\":\"designation_in_the_business_company\",\"type\":\"radio\",\"options\":[\"Sole Proprietorship\",\"Partnership\",\"Limited Liability Company\",\"Corporation\"],\"is_required\":1,\"is_active\":1,\"sort_order\":4},\"new\":{\"id\":27,\"label\":\"Designation in the Business/Company\",\"name\":\"designation_in_the_business_company\",\"type\":\"select\",\"options\":[\"Sole Proprietorship\",\"Partnership\",\"Limited Liability Company\",\"Corporation\"],\"is_required\":1,\"is_active\":1,\"sort_order\":4},\"diff\":{\"changed\":{\"type\":{\"old\":\"radio\",\"new\":\"select\"}}}}', NULL, NULL),
(115, '2025-10-16 08:26:03', NULL, 'testuser', 'nomination_fields', 'nomination_field', '32', 'update', '{\"event_id\":7,\"old\":{\"id\":32,\"label\":\"Business/Company Logo\",\"name\":\"business_company_logo\",\"type\":\"file\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":9},\"new\":{\"id\":32,\"label\":\"Business/Company Logo\",\"name\":\"business_company_logo\",\"type\":\"file\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":9},\"diff\":{\"changed\":{\"is_required\":{\"old\":1,\"new\":0}}}}', NULL, NULL),
(116, '2025-10-16 08:28:43', NULL, 'testuser', 'questions', 'question', '71', 'update', '{\"old\":{\"question_id\":71,\"question_name\":\"Best Break - up Food\",\"category_id\":13,\"choice_type\":1,\"event_id\":7},\"new\":{\"question_id\":71,\"question_name\":\"Best Break - up Food\",\"category_id\":13,\"choice_type\":0,\"event_id\":7},\"diff\":{\"changed\":{\"choice_type\":{\"old\":1,\"new\":0}}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(117, '2025-10-16 08:28:47', NULL, 'testuser', 'questions', 'question', '72', 'update', '{\"old\":{\"question_id\":72,\"question_name\":\"Best Date Place\",\"category_id\":13,\"choice_type\":1,\"event_id\":7},\"new\":{\"question_id\":72,\"question_name\":\"Best Date Place\",\"category_id\":13,\"choice_type\":0,\"event_id\":7},\"diff\":{\"changed\":{\"choice_type\":{\"old\":1,\"new\":0}}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(118, '2025-10-16 08:28:50', NULL, 'testuser', 'questions', 'question', '74', 'update', '{\"old\":{\"question_id\":74,\"question_name\":\"Best Hairstylist\",\"category_id\":13,\"choice_type\":1,\"event_id\":7},\"new\":{\"question_id\":74,\"question_name\":\"Best Hairstylist\",\"category_id\":13,\"choice_type\":0,\"event_id\":7},\"diff\":{\"changed\":{\"choice_type\":{\"old\":1,\"new\":0}}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(119, '2025-10-16 08:28:52', NULL, 'testuser', 'questions', 'question', '73', 'update', '{\"old\":{\"question_id\":73,\"question_name\":\"Best Hangover Food\",\"category_id\":13,\"choice_type\":1,\"event_id\":7},\"new\":{\"question_id\":73,\"question_name\":\"Best Hangover Food\",\"category_id\":13,\"choice_type\":0,\"event_id\":7},\"diff\":{\"changed\":{\"choice_type\":{\"old\":1,\"new\":0}}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(120, '2025-10-16 08:28:54', NULL, 'testuser', 'questions', 'question', '75', 'update', '{\"old\":{\"question_id\":75,\"question_name\":\"Best Recvoery Dood\",\"category_id\":13,\"choice_type\":1,\"event_id\":7},\"new\":{\"question_id\":75,\"question_name\":\"Best Recvoery Dood\",\"category_id\":13,\"choice_type\":0,\"event_id\":7},\"diff\":{\"changed\":{\"choice_type\":{\"old\":1,\"new\":0}}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(121, '2025-10-16 09:33:25', NULL, 'testuser', 'nomination_fields', 'nomination_field', '24', 'update', '{\"event_id\":7,\"old\":{\"id\":24,\"label\":\"Business/Company Name\",\"name\":\"business_company_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":0},\"new\":{\"id\":24,\"label\":\"Business Name\",\"name\":\"business_company_name\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":0},\"diff\":{\"changed\":{\"label\":{\"old\":\"Business/Company Name\",\"new\":\"Business Name\"}}}}', NULL, NULL),
(122, '2025-10-16 10:33:25', NULL, 'testuser', 'nomination_fields', 'nomination_field', '25', 'update', '{\"event_id\":7,\"old\":{\"id\":25,\"label\":\"Name of Ownder/President/General Manager\",\"name\":\"name_of_ownder_president_general_manager\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"new\":{\"id\":25,\"label\":\"Owner/President/General Manager\",\"name\":\"name_of_ownder_president_general_manager\",\"type\":\"text\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":1},\"diff\":{\"changed\":{\"label\":{\"old\":\"Name of Ownder/President/General Manager\",\"new\":\"Owner/President/General Manager\"}}}}', NULL, NULL),
(123, '2025-10-16 11:04:51', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-15 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"},\"diff\":{\"changed\":{\"voting_start\":{\"old\":\"2025-10-16 13:53:00\",\"new\":\"2025-10-15 13:53:00\"}}}}', NULL, NULL);
INSERT INTO `tbl_admin_audit_log` (`log_id`, `event_time`, `admin_id`, `admin_name`, `module`, `entity_type`, `entity_id`, `action`, `details_json`, `ip_address`, `user_agent`) VALUES
(124, '2025-10-16 11:13:37', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-15 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"},\"diff\":{\"changed\":{\"voting_start\":{\"old\":\"2025-10-15 13:53:00\",\"new\":\"2025-10-16 13:53:00\"}}}}', NULL, NULL),
(125, '2025-10-16 11:14:01', NULL, 'testuser', 'events', 'event', '8', 'create', '{\"event_id\":8,\"new\":{\"event_id\":8,\"event_name\":\"jtyjytjjty\",\"year\":2025,\"description\":\"tutyuy\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 11:14:01\",\"nomination_start\":\"2025-10-15 11:13:00\",\"nomination_end\":\"2025-10-16 11:13:00\",\"voting_start\":\"2025-10-15 11:13:00\",\"voting_end\":\"2025-10-15 11:13:00\"}}', NULL, NULL),
(126, '2025-10-16 11:14:06', NULL, 'testuser', 'events', 'event', '7', 'activate', '{\"event_id\":7,\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"}}', NULL, NULL),
(127, '2025-10-16 11:21:59', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-15 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"},\"diff\":{\"changed\":{\"voting_start\":{\"old\":\"2025-10-16 13:53:00\",\"new\":\"2025-10-15 13:53:00\"}}}}', NULL, NULL),
(128, '2025-10-16 11:22:17', NULL, 'testuser', 'events', 'event', '9', 'create', '{\"event_id\":9,\"new\":{\"event_id\":9,\"event_name\":\"regerg\",\"year\":2025,\"description\":\"ergergere\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 11:22:17\",\"nomination_start\":\"2025-10-15 11:22:00\",\"nomination_end\":\"2025-10-14 11:22:00\",\"voting_start\":\"2025-10-17 11:22:00\",\"voting_end\":\"2025-10-15 11:22:00\"}}', NULL, NULL),
(129, '2025-10-16 11:27:17', NULL, 'testuser', 'events', 'event', '7', 'activate', '{\"event_id\":7,\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-15 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"}}', NULL, NULL),
(130, '2025-10-16 11:27:30', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-15 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-15 08:53:00\",\"voting_start\":\"2025-10-15 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-16 08:53:00\",\"new\":\"2025-10-15 08:53:00\"}}}}', NULL, NULL),
(131, '2025-10-16 11:27:57', NULL, 'testuser', 'events', 'event', '10', 'create', '{\"event_id\":10,\"new\":{\"event_id\":10,\"event_name\":\"test\",\"year\":2025,\"description\":\"tgegeer\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 11:27:57\",\"nomination_start\":\"2025-10-15 11:27:00\",\"nomination_end\":\"2025-10-14 11:27:00\",\"voting_start\":\"2025-10-15 11:27:00\",\"voting_end\":null}}', NULL, NULL),
(132, '2025-10-16 11:35:53', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":0,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-15 08:53:00\",\"voting_start\":\"2025-10-15 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":0,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-15 08:53:00\",\"new\":\"2025-10-16 08:53:00\"},\"voting_start\":{\"old\":\"2025-10-15 13:53:00\",\"new\":\"2025-10-16 13:53:00\"}}}}', NULL, NULL),
(133, '2025-10-16 11:37:09', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":0,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 13:53:00\",\"voting_end\":\"2025-10-16 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":0,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 20:53:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":{\"voting_start\":{\"old\":\"2025-10-16 13:53:00\",\"new\":\"2025-10-16 20:53:00\"},\"voting_end\":{\"old\":\"2025-10-16 18:53:00\",\"new\":\"2025-10-17 18:53:00\"}}}}', NULL, NULL),
(134, '2025-10-16 11:37:12', NULL, 'testuser', 'events', 'event', '10', 'archive', '{\"event_id\":10,\"old\":{\"event_id\":10,\"event_name\":\"test\",\"year\":2025,\"description\":\"tgegeer\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 11:27:57\",\"nomination_start\":\"2025-10-15 11:27:00\",\"nomination_end\":\"2025-10-14 11:27:00\",\"voting_start\":\"2025-10-15 11:27:00\",\"voting_end\":null},\"new\":{\"event_id\":10,\"event_name\":\"test\",\"year\":2025,\"description\":\"tgegeer\",\"is_active\":0,\"is_archived\":1,\"created_at\":\"2025-10-16 11:27:57\",\"nomination_start\":\"2025-10-15 11:27:00\",\"nomination_end\":\"2025-10-14 11:27:00\",\"voting_start\":\"2025-10-15 11:27:00\",\"voting_end\":null},\"diff\":{\"changed\":{\"is_archived\":{\"old\":0,\"new\":1},\"is_active\":{\"old\":1,\"new\":0}}}}', NULL, NULL),
(135, '2025-10-16 11:37:14', NULL, 'testuser', 'events', 'event', '7', 'activate', '{\"event_id\":7,\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 20:53:00\",\"voting_end\":\"2025-10-17 18:53:00\"}}', NULL, NULL),
(136, '2025-10-16 11:37:16', NULL, 'testuser', 'events', 'event', '9', 'archive', '{\"event_id\":9,\"old\":{\"event_id\":9,\"event_name\":\"regerg\",\"year\":2025,\"description\":\"ergergere\",\"is_active\":0,\"is_archived\":0,\"created_at\":\"2025-10-16 11:22:17\",\"nomination_start\":\"2025-10-15 11:22:00\",\"nomination_end\":\"2025-10-14 11:22:00\",\"voting_start\":\"2025-10-17 11:22:00\",\"voting_end\":\"2025-10-15 11:22:00\"},\"new\":{\"event_id\":9,\"event_name\":\"regerg\",\"year\":2025,\"description\":\"ergergere\",\"is_active\":0,\"is_archived\":1,\"created_at\":\"2025-10-16 11:22:17\",\"nomination_start\":\"2025-10-15 11:22:00\",\"nomination_end\":\"2025-10-14 11:22:00\",\"voting_start\":\"2025-10-17 11:22:00\",\"voting_end\":\"2025-10-15 11:22:00\"},\"diff\":{\"changed\":{\"is_archived\":{\"old\":0,\"new\":1}}}}', NULL, NULL),
(137, '2025-10-16 11:37:18', NULL, 'testuser', 'events', 'event', '8', 'archive', '{\"event_id\":8,\"old\":{\"event_id\":8,\"event_name\":\"jtyjytjjty\",\"year\":2025,\"description\":\"tutyuy\",\"is_active\":0,\"is_archived\":0,\"created_at\":\"2025-10-16 11:14:01\",\"nomination_start\":\"2025-10-15 11:13:00\",\"nomination_end\":\"2025-10-16 11:13:00\",\"voting_start\":\"2025-10-15 11:13:00\",\"voting_end\":\"2025-10-15 11:13:00\"},\"new\":{\"event_id\":8,\"event_name\":\"jtyjytjjty\",\"year\":2025,\"description\":\"tutyuy\",\"is_active\":0,\"is_archived\":1,\"created_at\":\"2025-10-16 11:14:01\",\"nomination_start\":\"2025-10-15 11:13:00\",\"nomination_end\":\"2025-10-16 11:13:00\",\"voting_start\":\"2025-10-15 11:13:00\",\"voting_end\":\"2025-10-15 11:13:00\"},\"diff\":{\"changed\":{\"is_archived\":{\"old\":0,\"new\":1}}}}', NULL, NULL),
(138, '2025-10-16 11:43:43', NULL, 'testuser', 'nomination_fields', 'nomination_field', '29', 'update', '{\"event_id\":7,\"old\":{\"id\":29,\"label\":\"Email\",\"name\":\"email\",\"type\":\"email\",\"options\":null,\"is_required\":0,\"is_active\":1,\"sort_order\":6},\"new\":{\"id\":29,\"label\":\"Email\",\"name\":\"email\",\"type\":\"email\",\"options\":null,\"is_required\":1,\"is_active\":1,\"sort_order\":6},\"diff\":{\"changed\":{\"is_required\":{\"old\":0,\"new\":1}}}}', NULL, NULL),
(139, '2025-10-16 12:01:32', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 20:53:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 12:05:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":{\"voting_start\":{\"old\":\"2025-10-16 20:53:00\",\"new\":\"2025-10-16 12:05:00\"}}}}', NULL, NULL),
(140, '2025-10-16 14:04:18', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 12:05:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-17 12:05:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":{\"voting_start\":{\"old\":\"2025-10-16 12:05:00\",\"new\":\"2025-10-17 12:05:00\"}}}}', NULL, NULL),
(141, '2025-10-16 14:04:24', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-17 12:05:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-17 08:53:00\",\"voting_start\":\"2025-10-17 12:05:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-16 08:53:00\",\"new\":\"2025-10-17 08:53:00\"}}}}', NULL, NULL),
(142, '2025-10-16 14:47:48', NULL, NULL, 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-17 08:53:00\",\"voting_start\":\"2025-10-17 12:05:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 20:53:00\",\"voting_start\":\"2025-10-17 12:05:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-17 08:53:00\",\"new\":\"2025-10-16 20:53:00\"}}}}', NULL, NULL),
(143, '2025-10-16 14:59:02', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 20:53:00\",\"voting_start\":\"2025-10-17 12:05:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 15:01:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-16 20:53:00\",\"new\":\"2025-10-16 08:53:00\"},\"voting_start\":{\"old\":\"2025-10-17 12:05:00\",\"new\":\"2025-10-16 15:01:00\"}}}}', NULL, NULL),
(144, '2025-10-16 14:59:27', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 08:53:00\",\"voting_start\":\"2025-10-16 15:01:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 15:02:00\",\"voting_start\":\"2025-10-16 15:05:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-16 08:53:00\",\"new\":\"2025-10-16 15:02:00\"},\"voting_start\":{\"old\":\"2025-10-16 15:01:00\",\"new\":\"2025-10-16 15:05:00\"}}}}', NULL, NULL),
(145, '2025-10-16 15:22:39', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 06:53:00\",\"nomination_end\":\"2025-10-16 15:02:00\",\"voting_start\":\"2025-10-16 15:05:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-15 06:53:00\",\"nomination_end\":\"2025-10-16 15:02:00\",\"voting_start\":\"2025-10-16 15:25:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":{\"nomination_start\":{\"old\":\"2025-10-16 06:53:00\",\"new\":\"2025-10-15 06:53:00\"},\"voting_start\":{\"old\":\"2025-10-16 15:05:00\",\"new\":\"2025-10-16 15:25:00\"}}}}', NULL, NULL),
(146, '2025-10-16 15:30:05', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-15 06:53:00\",\"nomination_end\":\"2025-10-16 15:02:00\",\"voting_start\":\"2025-10-16 15:25:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:31:00\",\"nomination_end\":\"2025-10-17 15:02:00\",\"voting_start\":\"2025-10-17 16:25:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":{\"nomination_start\":{\"old\":\"2025-10-15 06:53:00\",\"new\":\"2025-10-16 15:31:00\"},\"nomination_end\":{\"old\":\"2025-10-16 15:02:00\",\"new\":\"2025-10-17 15:02:00\"},\"voting_start\":{\"old\":\"2025-10-16 15:25:00\",\"new\":\"2025-10-17 16:25:00\"}}}}', NULL, NULL),
(147, '2025-10-16 15:30:43', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:31:00\",\"nomination_end\":\"2025-10-17 15:02:00\",\"voting_start\":\"2025-10-17 16:25:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:31:00\",\"nomination_end\":\"2025-10-17 15:02:00\",\"voting_start\":\"2025-10-17 16:25:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":[]}}', NULL, NULL),
(148, '2025-10-16 15:31:14', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:31:00\",\"nomination_end\":\"2025-10-17 15:02:00\",\"voting_start\":\"2025-10-17 16:25:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-17 15:02:00\",\"voting_start\":\"2025-10-17 16:25:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":{\"nomination_start\":{\"old\":\"2025-10-16 15:31:00\",\"new\":\"2025-10-16 15:35:00\"}}}}', NULL, NULL),
(149, '2025-10-16 15:31:24', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-17 15:02:00\",\"voting_start\":\"2025-10-17 16:25:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-17 15:02:00\",\"voting_start\":\"2025-10-17 16:25:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":[]}}', NULL, NULL),
(150, '2025-10-16 16:22:54', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 15:38:00\",\"voting_start\":\"2025-10-16 15:39:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-17 15:39:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-16 15:38:00\",\"new\":\"2025-10-16 17:20:00\"},\"voting_start\":{\"old\":\"2025-10-16 15:39:00\",\"new\":\"2025-10-17 15:39:00\"}}}}', NULL, NULL),
(151, '2025-10-16 16:24:18', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-17 15:39:00\",\"voting_end\":\"2025-10-17 18:53:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-17 15:39:00\",\"voting_end\":\"2025-10-18 15:38:00\"},\"diff\":{\"changed\":{\"voting_end\":{\"old\":\"2025-10-17 18:53:00\",\"new\":\"2025-10-18 15:38:00\"}}}}', NULL, NULL),
(152, '2025-10-16 16:45:54', NULL, 'testuser', 'events', 'event', '7', 'archive', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-17 15:39:00\",\"voting_end\":\"2025-10-18 15:38:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":0,\"is_archived\":1,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-17 15:39:00\",\"voting_end\":\"2025-10-18 15:38:00\"},\"diff\":{\"changed\":{\"is_archived\":{\"old\":0,\"new\":1},\"is_active\":{\"old\":1,\"new\":0}}}}', NULL, NULL),
(153, '2025-10-16 20:00:35', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-17 15:39:00\",\"voting_end\":\"2025-10-18 15:38:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:02:00\",\"voting_end\":\"2025-10-18 15:38:00\"},\"diff\":{\"changed\":{\"voting_start\":{\"old\":\"2025-10-17 15:39:00\",\"new\":\"2025-10-16 20:02:00\"}}}}', NULL, NULL),
(154, '2025-10-16 20:37:06', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:02:00\",\"voting_end\":\"2025-10-18 15:38:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:02:00\",\"voting_end\":\"2025-10-17 15:38:00\"},\"diff\":{\"changed\":{\"voting_end\":{\"old\":\"2025-10-18 15:38:00\",\"new\":\"2025-10-17 15:38:00\"}}}}', NULL, NULL),
(155, '2025-10-16 20:37:18', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:02:00\",\"voting_end\":\"2025-10-17 15:38:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:39:00\",\"voting_end\":\"2025-10-17 15:38:00\"},\"diff\":{\"changed\":{\"voting_start\":{\"old\":\"2025-10-16 20:02:00\",\"new\":\"2025-10-16 20:39:00\"}}}}', NULL, NULL),
(156, '2025-10-16 20:59:07', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:39:00\",\"voting_end\":\"2025-10-17 15:38:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:39:00\",\"voting_end\":\"2025-10-17 23:38:00\"},\"diff\":{\"changed\":{\"voting_end\":{\"old\":\"2025-10-17 15:38:00\",\"new\":\"2025-10-17 23:38:00\"}}}}', NULL, NULL),
(157, '2025-10-16 20:59:41', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:39:00\",\"voting_end\":\"2025-10-17 23:38:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:39:00\",\"voting_end\":\"2025-10-17 21:00:00\"},\"diff\":{\"changed\":{\"voting_end\":{\"old\":\"2025-10-17 23:38:00\",\"new\":\"2025-10-17 21:00:00\"}}}}', NULL, NULL),
(158, '2025-10-16 21:00:12', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:39:00\",\"voting_end\":\"2025-10-17 21:00:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:39:00\",\"voting_end\":\"2025-10-16 21:02:00\"},\"diff\":{\"changed\":{\"voting_end\":{\"old\":\"2025-10-17 21:00:00\",\"new\":\"2025-10-16 21:02:00\"}}}}', NULL, NULL),
(159, '2025-10-16 21:20:19', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-16 20:39:00\",\"voting_end\":\"2025-10-16 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-17 00:43:00\",\"voting_end\":\"2025-10-17 21:02:00\"},\"diff\":{\"changed\":{\"voting_start\":{\"old\":\"2025-10-16 20:39:00\",\"new\":\"2025-10-17 00:43:00\"},\"voting_end\":{\"old\":\"2025-10-16 21:02:00\",\"new\":\"2025-10-17 21:02:00\"}}}}', NULL, NULL),
(160, '2025-10-16 21:20:40', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 17:20:00\",\"voting_start\":\"2025-10-17 00:43:00\",\"voting_end\":\"2025-10-17 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 21:25:00\",\"voting_start\":\"2025-10-17 00:43:00\",\"voting_end\":\"2025-10-17 21:02:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-16 17:20:00\",\"new\":\"2025-10-16 21:25:00\"}}}}', NULL, NULL),
(161, '2025-10-16 21:40:16', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 21:25:00\",\"voting_start\":\"2025-10-17 00:43:00\",\"voting_end\":\"2025-10-17 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 22:25:00\",\"voting_start\":\"2025-10-17 00:43:00\",\"voting_end\":\"2025-10-17 21:02:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-16 21:25:00\",\"new\":\"2025-10-16 22:25:00\"}}}}', NULL, NULL),
(162, '2025-10-16 22:27:16', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 22:25:00\",\"voting_start\":\"2025-10-17 00:43:00\",\"voting_end\":\"2025-10-17 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 22:36:00\",\"voting_start\":\"2025-10-17 00:43:00\",\"voting_end\":\"2025-10-17 21:02:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-16 22:25:00\",\"new\":\"2025-10-16 22:36:00\"}}}}', NULL, NULL),
(163, '2025-10-17 05:09:49', NULL, NULL, 'choices', 'choice', '64', 'update', '{\"old\":{\"choice_id\":64,\"choice_name\":\"Angel\'s Burger\",\"email\":\"ampcapacio@gmail.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":64,\"choice_name\":\"Angel\'s Burger\",\"email\":\"ampcapacio@gmail.com\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[64,66],\"new\":[63,64,65,66,67,69,76,77,78,80,81,82,83]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(164, '2025-10-17 05:10:08', NULL, NULL, 'choices', 'choice', '65', 'update', '{\"old\":{\"choice_id\":65,\"choice_name\":\"Gemma\'s Store\",\"email\":\"rinyqekyv@mailinator.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":65,\"choice_name\":\"Gemma\'s Store\",\"email\":\"rinyqekyv@mailinator.com\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[65],\"new\":[64,65,79,80,82,83]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(165, '2025-10-17 05:10:22', NULL, NULL, 'choices', 'choice', '66', 'update', '{\"old\":{\"choice_id\":66,\"choice_name\":\"Sloane Sweeney\",\"email\":\"gucelarysha@gmail.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":66,\"choice_name\":\"Sloane Sweeney\",\"email\":\"gucelarysha@gmail.com\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[63,65],\"new\":[63,64,65,66,67,68,69,70,76,77,78,79,80,81,82,83]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(166, '2025-10-17 05:24:07', NULL, 'tocca_admin2025', 'choices', 'choice', '65', 'update', '{\"old\":{\"choice_id\":65,\"choice_name\":\"Gemma\'s Store\",\"email\":\"rinyqekyv@mailinator.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":65,\"choice_name\":\"Gemma\'s Store\",\"email\":\"rinyqekyv@mailinator.com\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(167, '2025-10-17 05:45:49', NULL, 'tocca_admin2025', 'categories', 'category', '9', 'delete', '{\"old\":{\"category_id\":9,\"category_name\":\"Foods\",\"status\":1,\"event_id\":7}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(168, '2025-10-17 10:38:17', NULL, 'tocca_admin2025', 'events', 'event', '11', 'create', '{\"event_id\":11,\"new\":{\"event_id\":11,\"event_name\":\"Bagong Awards\",\"year\":2025,\"description\":\"\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-17 10:38:17\",\"nomination_start\":\"2025-10-17 10:36:00\",\"nomination_end\":\"2025-10-18 10:36:00\",\"voting_start\":\"2025-10-19 10:37:00\",\"voting_end\":\"2025-10-20 10:37:00\"}}', NULL, NULL),
(169, '2025-10-17 10:41:21', NULL, 'tocca_admin2025', 'events', 'event', '7', 'activate', '{\"event_id\":7,\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 22:36:00\",\"voting_start\":\"2025-10-17 00:43:00\",\"voting_end\":\"2025-10-17 21:02:00\"}}', NULL, NULL),
(170, '2025-10-17 10:49:37', NULL, 'tocca_admin2025', 'categories', 'category', '14', 'create', '{\"new\":{\"category_id\":14,\"category_name\":\"Bagong Category\",\"status\":1,\"event_id\":7}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(171, '2025-10-17 10:51:19', NULL, 'tocca_admin2025', 'questions', 'question', '84', 'create', '{\"new\":{\"question_id\":84,\"question_name\":\"Bagong Award\",\"category_id\":14,\"choice_type\":1,\"event_id\":7}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(172, '2025-10-17 10:59:11', NULL, 'tocca_admin2025', 'choices', 'choice', '68', 'create', '{\"new\":{\"choice_id\":68,\"choice_name\":\"Bagong Store\",\"email\":\"gucelarysha@gmail.com\",\"status\":1,\"event_id\":7},\"links\":{\"new\":[63,84]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(173, '2025-10-17 11:55:07', NULL, 'tocca_admin2025', 'choices', 'choice', '64', 'update', '{\"old\":{\"choice_id\":64,\"choice_name\":\"Angel\'s Burger\",\"email\":\"ampcapacio@gmail.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":64,\"choice_name\":\"Angel\'s Burger\",\"email\":\"ampcapacio@gmail.com\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[63,64,65,66,67,69,76,77,78,80,81,82,83],\"new\":[63,64,65,66,67,69,76,77,78,80,81,82,83,84]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(174, '2025-10-17 11:55:13', NULL, 'tocca_admin2025', 'choices', 'choice', '65', 'update', '{\"old\":{\"choice_id\":65,\"choice_name\":\"Gemma\'s Store\",\"email\":\"rinyqekyv@mailinator.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":65,\"choice_name\":\"Gemma\'s Store\",\"email\":\"rinyqekyv@mailinator.com\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[64,65,79,80,82,83],\"new\":[64,65,79,80,82,83,84]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(175, '2025-10-17 11:55:17', NULL, 'tocca_admin2025', 'choices', 'choice', '67', 'update', '{\"old\":{\"choice_id\":67,\"choice_name\":\"Gray Shelton\",\"email\":\"gucelarysha@gmail.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":67,\"choice_name\":\"Gray Shelton\",\"email\":\"gucelarysha@gmail.com\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[64,69],\"new\":[64,69,84]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(176, '2025-10-17 12:25:49', NULL, NULL, 'questions', 'question', '85', 'create', '{\"new\":{\"question_id\":85,\"question_name\":\"New Award\",\"category_id\":14,\"choice_type\":1,\"event_id\":7}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(177, '2025-10-17 12:25:58', NULL, NULL, 'questions', 'question', '85', 'update', '{\"old\":{\"question_id\":85,\"question_name\":\"New Award\",\"category_id\":14,\"choice_type\":1,\"event_id\":7},\"new\":{\"question_id\":85,\"question_name\":\"New Award\",\"category_id\":14,\"choice_type\":1,\"event_id\":7},\"diff\":{\"changed\":[]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(178, '2025-10-17 12:50:26', NULL, NULL, 'choices', 'choice', '66', 'update', '{\"old\":{\"choice_id\":66,\"choice_name\":\"Sloane Sweeney\",\"email\":\"gucelarysha@gmail.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":66,\"choice_name\":\"Sloane Sweeney\",\"email\":\"gucelarysha@gmail.com\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[63,64,65,66,67,68,69,70,76,77,78,79,80,81,82,83],\"new\":[63,64,65,66,67,68,69,70,76,77,78,79,80,81,82,83,84]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(179, '2025-10-17 13:06:50', NULL, NULL, 'questions', 'question', '86', 'create', '{\"new\":{\"question_id\":86,\"question_name\":\"New test Award\",\"category_id\":14,\"choice_type\":1,\"event_id\":7}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(180, '2025-10-17 13:07:02', NULL, NULL, 'questions', 'question', '87', 'create', '{\"new\":{\"question_id\":87,\"question_name\":\"ewtet\",\"category_id\":14,\"choice_type\":1,\"event_id\":7}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(181, '2025-10-17 13:07:44', NULL, NULL, 'questions', 'question', '87', 'update', '{\"old\":{\"question_id\":87,\"question_name\":\"ewtet\",\"category_id\":14,\"choice_type\":1,\"event_id\":7},\"new\":{\"question_id\":87,\"question_name\":\"Change Award\",\"category_id\":14,\"choice_type\":1,\"event_id\":7},\"diff\":{\"changed\":{\"question_name\":{\"old\":\"ewtet\",\"new\":\"Change Award\"}}}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(182, '2025-10-17 13:08:01', NULL, NULL, 'questions', 'question', '87', 'update', '{\"old\":{\"question_id\":87,\"question_name\":\"Change Award\",\"category_id\":14,\"choice_type\":1,\"event_id\":7},\"new\":{\"question_id\":87,\"question_name\":\"Change Award\",\"category_id\":10,\"choice_type\":1,\"event_id\":7},\"diff\":{\"changed\":{\"category_id\":{\"old\":14,\"new\":10}}}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(183, '2025-10-17 13:21:02', NULL, NULL, 'choices', 'choice', '72', 'update', '{\"old\":{\"choice_id\":72,\"choice_name\":\"7-Eleven\",\"email\":\"support@7eleven.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":72,\"choice_name\":\"7-Eleven\",\"email\":\"support@7eleven.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[84]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(184, '2025-10-17 14:01:29', NULL, NULL, 'questions', 'question', '86', 'delete', '{\"old\":{\"question_id\":86,\"question_name\":\"New test Award\",\"category_id\":14,\"choice_type\":1,\"event_id\":7}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0');
INSERT INTO `tbl_admin_audit_log` (`log_id`, `event_time`, `admin_id`, `admin_name`, `module`, `entity_type`, `entity_id`, `action`, `details_json`, `ip_address`, `user_agent`) VALUES
(185, '2025-10-17 14:28:25', NULL, NULL, 'choices', 'choice', '105', 'create', '{\"new\":{\"choice_id\":105,\"choice_name\":\"test\",\"email\":\"gucelarysha@gmail.com\",\"status\":1,\"event_id\":7},\"links\":{\"new\":[76,78]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(186, '2025-10-17 14:44:10', NULL, NULL, 'choices', 'choice', '106', 'create', '{\"new\":{\"choice_id\":106,\"choice_name\":\"test est\",\"email\":\"amfcapacio@gmail.com\",\"status\":1,\"event_id\":7},\"links\":{\"new\":[84]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(187, '2025-10-17 14:48:39', NULL, NULL, 'choices', 'choice', '72', 'update', '{\"old\":{\"choice_id\":72,\"choice_name\":\"7-Eleven\",\"email\":\"support@7eleven.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":72,\"choice_name\":\"7-Eleven\",\"email\":\"support@7eleven.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[84],\"new\":[63,84]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(188, '2025-10-17 14:48:50', NULL, NULL, 'choices', 'choice', '96', 'update', '{\"old\":{\"choice_id\":96,\"choice_name\":\"Ace Hardware\",\"email\":\"info@acehardware.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":96,\"choice_name\":\"Ace Hardware\",\"email\":\"info@acehardware.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(189, '2025-10-17 14:48:55', NULL, NULL, 'choices', 'choice', '84', 'update', '{\"old\":{\"choice_id\":84,\"choice_name\":\"Adidas\",\"email\":\"service@adidas.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":84,\"choice_name\":\"Adidas\",\"email\":\"service@adidas.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(190, '2025-10-17 14:49:09', NULL, NULL, 'choices', 'choice', '81', 'update', '{\"old\":{\"choice_id\":81,\"choice_name\":\"Bench\",\"email\":\"info@bench.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":81,\"choice_name\":\"Bench\",\"email\":\"info@bench.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(191, '2025-10-17 14:49:28', NULL, NULL, 'choices', 'choice', '86', 'update', '{\"old\":{\"choice_id\":86,\"choice_name\":\"Chowking\",\"email\":\"info@chowking.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":86,\"choice_name\":\"Chowking\",\"email\":\"info@chowking.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(192, '2025-10-17 14:49:34', NULL, NULL, 'choices', 'choice', '99', 'update', '{\"old\":{\"choice_id\":99,\"choice_name\":\"Daiso Japan\",\"email\":\"service@daiso.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":99,\"choice_name\":\"Daiso Japan\",\"email\":\"service@daiso.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(193, '2025-10-17 14:49:38', NULL, NULL, 'choices', 'choice', '94', 'update', '{\"old\":{\"choice_id\":94,\"choice_name\":\"Dunkin\'\",\"email\":\"service@dunkin.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":94,\"choice_name\":\"Dunkin\'\",\"email\":\"service@dunkin.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(194, '2025-10-17 14:49:49', NULL, NULL, 'choices', 'choice', '65', 'update', '{\"old\":{\"choice_id\":65,\"choice_name\":\"Gemma\'s Store\",\"email\":\"rinyqekyv@mailinator.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":65,\"choice_name\":\"Gemma\'s Store\",\"email\":\"rinyqekyv@mailinator.com\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[64,65,79,80,82,83,84],\"new\":[63,64,65,79,80,82,83,84]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(195, '2025-10-17 14:49:55', NULL, NULL, 'choices', 'choice', '103', 'update', '{\"old\":{\"choice_id\":103,\"choice_name\":\"Globe Store\",\"email\":\"support@globestore.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":103,\"choice_name\":\"Globe Store\",\"email\":\"support@globestore.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(196, '2025-10-17 14:50:01', NULL, NULL, 'choices', 'choice', '92', 'update', '{\"old\":{\"choice_id\":92,\"choice_name\":\"Goldilocks\",\"email\":\"hello@goldilocks.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":92,\"choice_name\":\"Goldilocks\",\"email\":\"hello@goldilocks.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(197, '2025-10-17 14:50:23', NULL, NULL, 'choices', 'choice', '67', 'update', '{\"old\":{\"choice_id\":67,\"choice_name\":\"Gray Shelton\",\"email\":\"gucelarysha@gmail.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":67,\"choice_name\":\"Gray Shelton\",\"email\":\"gucelarysha@gmail.co\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":{\"email\":{\"old\":\"gucelarysha@gmail.com\",\"new\":\"gucelarysha@gmail.co\"}}},\"links\":{\"old\":[64,69,84],\"new\":[63,64,69,84]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(198, '2025-10-17 14:50:31', NULL, NULL, 'choices', 'choice', '80', 'update', '{\"old\":{\"choice_id\":80,\"choice_name\":\"H&M\",\"email\":\"contact@hm.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":80,\"choice_name\":\"H&M\",\"email\":\"contact@hm.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(199, '2025-10-17 14:50:40', NULL, NULL, 'choices', 'choice', '97', 'update', '{\"old\":{\"choice_id\":97,\"choice_name\":\"Handyman\",\"email\":\"hello@handyman.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":97,\"choice_name\":\"Handyman\",\"email\":\"hello@handyman.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(200, '2025-10-17 14:50:47', NULL, NULL, 'choices', 'choice', '69', 'update', '{\"old\":{\"choice_id\":69,\"choice_name\":\"Jollibee\",\"email\":\"contact@jollibee.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":69,\"choice_name\":\"Jollibee\",\"email\":\"contact@jollibee.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(201, '2025-10-17 14:50:52', NULL, NULL, 'choices', 'choice', '88', 'update', '{\"old\":{\"choice_id\":88,\"choice_name\":\"KFC\",\"email\":\"support@kfc.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":88,\"choice_name\":\"KFC\",\"email\":\"support@kfc.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(202, '2025-10-17 14:50:56', NULL, NULL, 'choices', 'choice', '85', 'update', '{\"old\":{\"choice_id\":85,\"choice_name\":\"Mang Inasal\",\"email\":\"contact@manginasal.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":85,\"choice_name\":\"Mang Inasal\",\"email\":\"contact@manginasal.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(203, '2025-10-17 14:51:01', NULL, NULL, 'choices', 'choice', '70', 'update', '{\"old\":{\"choice_id\":70,\"choice_name\":\"McDonald\'s\",\"email\":\"hello@mcdonalds.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":70,\"choice_name\":\"McDonald\'s\",\"email\":\"hello@mcdonalds.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(204, '2025-10-17 14:51:09', NULL, NULL, 'choices', 'choice', '73', 'update', '{\"old\":{\"choice_id\":73,\"choice_name\":\"Mercury Drug\",\"email\":\"service@mercurydrug.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":73,\"choice_name\":\"Mercury Drug\",\"email\":\"service@mercurydrug.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(205, '2025-10-17 14:51:18', NULL, NULL, 'choices', 'choice', '98', 'update', '{\"old\":{\"choice_id\":98,\"choice_name\":\"Miniso\",\"email\":\"support@miniso.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":98,\"choice_name\":\"Miniso\",\"email\":\"support@miniso.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(206, '2025-10-17 14:51:24', NULL, NULL, 'choices', 'choice', '95', 'update', '{\"old\":{\"choice_id\":95,\"choice_name\":\"Mister Donut\",\"email\":\"contact@misterdonut.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":95,\"choice_name\":\"Mister Donut\",\"email\":\"contact@misterdonut.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(207, '2025-10-17 14:51:28', NULL, NULL, 'choices', 'choice', '75', 'update', '{\"old\":{\"choice_id\":75,\"choice_name\":\"National Book Store\",\"email\":\"contact@nationalbookstore.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":75,\"choice_name\":\"National Book Store\",\"email\":\"contact@nationalbookstore.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(208, '2025-10-17 14:51:34', NULL, NULL, 'choices', 'choice', '83', 'update', '{\"old\":{\"choice_id\":83,\"choice_name\":\"Nike\",\"email\":\"support@nike.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":83,\"choice_name\":\"Nike\",\"email\":\"support@nike.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(209, '2025-10-17 14:51:43', NULL, NULL, 'choices', 'choice', '93', 'update', '{\"old\":{\"choice_id\":93,\"choice_name\":\"Red Ribbon Bakeshop\",\"email\":\"support@redribbon.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":93,\"choice_name\":\"Red Ribbon Bakeshop\",\"email\":\"support@redribbon.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(210, '2025-10-17 14:51:49', NULL, NULL, 'choices', 'choice', '78', 'update', '{\"old\":{\"choice_id\":78,\"choice_name\":\"Puregold\",\"email\":\"support@puregold.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":78,\"choice_name\":\"Puregold\",\"email\":\"support@puregold.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(211, '2025-10-17 14:51:54', NULL, NULL, 'choices', 'choice', '101', 'update', '{\"old\":{\"choice_id\":101,\"choice_name\":\"Power Mac Center\",\"email\":\"info@powermaccenter.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":101,\"choice_name\":\"Power Mac Center\",\"email\":\"info@powermaccenter.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(212, '2025-10-17 14:52:00', NULL, NULL, 'choices', 'choice', '82', 'update', '{\"old\":{\"choice_id\":82,\"choice_name\":\"Penshoppe\",\"email\":\"hello@penshoppe.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":82,\"choice_name\":\"Penshoppe\",\"email\":\"hello@penshoppe.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(213, '2025-10-17 14:52:07', NULL, NULL, 'choices', 'choice', '90', 'update', '{\"old\":{\"choice_id\":90,\"choice_name\":\"Pizza Hut\",\"email\":\"contact@pizzahut.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":90,\"choice_name\":\"Pizza Hut\",\"email\":\"contact@pizzahut.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(214, '2025-10-17 14:52:17', NULL, NULL, 'choices', 'choice', '77', 'update', '{\"old\":{\"choice_id\":77,\"choice_name\":\"Robinsons Supermarket\",\"email\":\"hello@robinsonssupermarket.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":77,\"choice_name\":\"Robinsons Supermarket\",\"email\":\"hello@robinsonssupermarket.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(215, '2025-10-17 14:52:24', NULL, NULL, 'choices', 'choice', '102', 'update', '{\"old\":{\"choice_id\":102,\"choice_name\":\"Samsung Experience Store\",\"email\":\"hello@samsungstore.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":102,\"choice_name\":\"Samsung Experience Store\",\"email\":\"hello@samsungstore.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(216, '2025-10-17 14:52:32', NULL, NULL, 'choices', 'choice', '89', 'update', '{\"old\":{\"choice_id\":89,\"choice_name\":\"Shakey\'s Pizza\",\"email\":\"service@shakeys.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":89,\"choice_name\":\"Shakey\'s Pizza\",\"email\":\"service@shakeys.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(217, '2025-10-17 14:52:49', NULL, NULL, 'choices', 'choice', '76', 'update', '{\"old\":{\"choice_id\":76,\"choice_name\":\"SM Supermarket\",\"email\":\"info@smsupermarket.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":76,\"choice_name\":\"SM Supermarket\",\"email\":\"info@smsupermarket.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(218, '2025-10-17 14:53:05', NULL, NULL, 'choices', 'choice', '100', 'update', '{\"old\":{\"choice_id\":100,\"choice_name\":\"The Body Shop\",\"email\":\"contact@thebodyshop.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":100,\"choice_name\":\"The Body Shop\",\"email\":\"contact@thebodyshop.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(219, '2025-10-17 14:53:13', NULL, NULL, 'choices', 'choice', '71', 'update', '{\"old\":{\"choice_id\":71,\"choice_name\":\"Starbucks\",\"email\":\"info@starbucks.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":71,\"choice_name\":\"Starbucks\",\"email\":\"info@starbucks.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(220, '2025-10-17 14:53:30', NULL, NULL, 'choices', 'choice', '105', 'update', '{\"old\":{\"choice_id\":105,\"choice_name\":\"test\",\"email\":\"gucelarysha@gmail.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":105,\"choice_name\":\"test\",\"email\":\"gucelarysha@gmail.c\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":{\"email\":{\"old\":\"gucelarysha@gmail.com\",\"new\":\"gucelarysha@gmail.c\"}}},\"links\":{\"old\":[76,78],\"new\":[63,76,78]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(221, '2025-10-17 14:53:37', NULL, NULL, 'choices', 'choice', '106', 'update', '{\"old\":{\"choice_id\":106,\"choice_name\":\"test est\",\"email\":\"amfcapacio@gmail.com\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":106,\"choice_name\":\"test est\",\"email\":\"amfcapacio@gmail.com\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[84],\"new\":[63,84]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(222, '2025-10-17 14:53:43', NULL, NULL, 'choices', 'choice', '100', 'update', '{\"old\":{\"choice_id\":100,\"choice_name\":\"The Body Shop\",\"email\":\"contact@thebodyshop.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":100,\"choice_name\":\"The Body Shop\",\"email\":\"contact@thebodyshop.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(223, '2025-10-17 14:53:48', NULL, NULL, 'choices', 'choice', '91', 'update', '{\"old\":{\"choice_id\":91,\"choice_name\":\"Yellow Cab Pizza\",\"email\":\"info@yellowcab.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":91,\"choice_name\":\"Yellow Cab Pizza\",\"email\":\"info@yellowcab.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(224, '2025-10-17 14:53:54', NULL, NULL, 'choices', 'choice', '74', 'update', '{\"old\":{\"choice_id\":74,\"choice_name\":\"Watsons\",\"email\":\"care@watsons.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":74,\"choice_name\":\"Watsons\",\"email\":\"care@watsons.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(225, '2025-10-17 14:53:58', NULL, NULL, 'choices', 'choice', '79', 'update', '{\"old\":{\"choice_id\":79,\"choice_name\":\"Uniqlo\",\"email\":\"service@uniqlo.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":79,\"choice_name\":\"Uniqlo\",\"email\":\"service@uniqlo.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]},\"links\":{\"old\":[],\"new\":[63]}}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(226, '2025-10-18 09:21:30', NULL, 'tocca_admin2025', 'choices', 'choice', '72', 'update', '{\"old\":{\"choice_id\":72,\"choice_name\":\"7-Eleven\",\"email\":\"support@7eleven.example\",\"status\":1,\"event_id\":7},\"new\":{\"choice_id\":72,\"choice_name\":\"7-Eleven\",\"email\":\"support@7eleven.example\",\"status\":1,\"event_id\":7},\"diff\":{\"changed\":[]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(227, '2025-10-18 12:45:48', NULL, NULL, 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-16 15:35:00\",\"nomination_end\":\"2025-10-16 22:36:00\",\"voting_start\":\"2025-10-17 00:43:00\",\"voting_end\":\"2025-10-17 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 15:35:00\",\"nomination_end\":\"2025-10-19 22:36:00\",\"voting_start\":\"2025-10-20 00:43:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"diff\":{\"changed\":{\"nomination_start\":{\"old\":\"2025-10-16 15:35:00\",\"new\":\"2025-10-18 15:35:00\"},\"nomination_end\":{\"old\":\"2025-10-16 22:36:00\",\"new\":\"2025-10-19 22:36:00\"},\"voting_start\":{\"old\":\"2025-10-17 00:43:00\",\"new\":\"2025-10-20 00:43:00\"},\"voting_end\":{\"old\":\"2025-10-17 21:02:00\",\"new\":\"2025-10-21 21:02:00\"}}}}', NULL, NULL),
(228, '2025-10-18 12:46:24', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 15:35:00\",\"nomination_end\":\"2025-10-19 22:36:00\",\"voting_start\":\"2025-10-20 00:43:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 21:35:00\",\"nomination_end\":\"2025-10-19 22:36:00\",\"voting_start\":\"2025-10-20 00:43:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"diff\":{\"changed\":{\"nomination_start\":{\"old\":\"2025-10-18 15:35:00\",\"new\":\"2025-10-18 21:35:00\"}}}}', NULL, NULL),
(229, '2025-10-18 12:46:53', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 21:35:00\",\"nomination_end\":\"2025-10-19 22:36:00\",\"voting_start\":\"2025-10-20 00:43:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 09:35:00\",\"nomination_end\":\"2025-10-19 22:36:00\",\"voting_start\":\"2025-10-20 00:43:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"diff\":{\"changed\":{\"nomination_start\":{\"old\":\"2025-10-18 21:35:00\",\"new\":\"2025-10-18 09:35:00\"}}}}', NULL, NULL),
(230, '2025-10-18 12:59:03', NULL, NULL, 'choices', 'choice', '70', 'delete', '{\"old\":{\"choice_id\":70,\"choice_name\":\"McDonald\'s\",\"email\":\"hello@mcdonalds.example\",\"status\":1,\"event_id\":7,\"links\":{\"old\":[63]}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(231, '2025-10-18 13:02:10', NULL, NULL, 'choices', 'choice', '107', 'create', '{\"new\":{\"choice_id\":107,\"choice_name\":\"Test Establisment\",\"email\":\"afmcapacio@gmail.com\",\"status\":1,\"event_id\":7},\"links\":{\"new\":[63]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(232, '2025-10-18 13:25:04', NULL, NULL, 'choices', 'choice', '108', 'create', '{\"new\":{\"choice_id\":108,\"choice_name\":\"hfwehfuwiew\",\"email\":\"fewfewef@gmail.com\",\"status\":1,\"event_id\":7,\"establishment_type_id\":4},\"links\":{\"new\":[77]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(233, '2025-10-18 13:26:07', NULL, NULL, 'choices', 'choice', '109', 'create', '{\"new\":{\"choice_id\":109,\"choice_name\":\"McDonalds\",\"email\":\"mcdo@gmail.com\",\"status\":1,\"event_id\":7,\"establishment_type_id\":5},\"links\":{\"new\":[63]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(234, '2025-10-18 13:26:55', NULL, NULL, 'choices', 'choice', '110', 'create', '{\"new\":{\"choice_id\":110,\"choice_name\":\"Another test\",\"email\":\"another@gmail.com\",\"status\":1,\"event_id\":7,\"establishment_type_id\":5},\"links\":{\"new\":[63]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(235, '2025-10-18 13:38:28', NULL, NULL, 'choices', 'choice', '111', 'create', '{\"new\":{\"choice_id\":111,\"choice_name\":\"testttttttt\",\"email\":\"testtttt@gmail.com\",\"status\":1,\"event_id\":7,\"establishment_type_id\":5},\"links\":{\"new\":[63]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(236, '2025-10-18 13:46:03', NULL, NULL, 'choices', 'choice', '112', 'create', '{\"new\":{\"choice_id\":112,\"choice_name\":\"plsplsplsGod\",\"email\":\"plspls@gmail.com\",\"status\":1,\"event_id\":7,\"establishment_type_id\":5},\"links\":{\"new\":[63,67]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(237, '2025-10-18 14:28:39', NULL, 'testuser', 'choices', 'choice', '113', 'create', '{\"new\":{\"choice_id\":113,\"choice_name\":\"Bigby\'s Restaurant\",\"email\":\"bigbys@gmail.com\",\"status\":1,\"event_id\":7,\"establishment_type_id\":6},\"links\":{\"new\":[64,76]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(238, '2025-10-18 14:29:29', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 09:35:00\",\"nomination_end\":\"2025-10-19 22:36:00\",\"voting_start\":\"2025-10-20 00:43:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 09:35:00\",\"nomination_end\":\"2025-10-18 22:36:00\",\"voting_start\":\"2025-10-19 00:43:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-19 22:36:00\",\"new\":\"2025-10-18 22:36:00\"},\"voting_start\":{\"old\":\"2025-10-20 00:43:00\",\"new\":\"2025-10-19 00:43:00\"}}}}', NULL, NULL),
(239, '2025-10-18 14:30:11', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 09:35:00\",\"nomination_end\":\"2025-10-18 22:36:00\",\"voting_start\":\"2025-10-19 00:43:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 09:35:00\",\"nomination_end\":\"2025-10-18 10:36:00\",\"voting_start\":\"2025-10-18 15:43:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-18 22:36:00\",\"new\":\"2025-10-18 10:36:00\"},\"voting_start\":{\"old\":\"2025-10-19 00:43:00\",\"new\":\"2025-10-18 15:43:00\"}}}}', NULL, NULL),
(240, '2025-10-18 14:30:45', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 09:35:00\",\"nomination_end\":\"2025-10-18 10:36:00\",\"voting_start\":\"2025-10-18 15:43:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 09:35:00\",\"nomination_end\":\"2025-10-18 10:36:00\",\"voting_start\":\"2025-10-18 14:30:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"diff\":{\"changed\":{\"voting_start\":{\"old\":\"2025-10-18 15:43:00\",\"new\":\"2025-10-18 14:30:00\"}}}}', NULL, NULL),
(241, '2025-10-18 14:34:14', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 09:35:00\",\"nomination_end\":\"2025-10-18 10:36:00\",\"voting_start\":\"2025-10-18 14:30:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 09:35:00\",\"nomination_end\":\"2025-10-19 10:36:00\",\"voting_start\":\"2025-10-20 14:30:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"diff\":{\"changed\":{\"nomination_end\":{\"old\":\"2025-10-18 10:36:00\",\"new\":\"2025-10-19 10:36:00\"},\"voting_start\":{\"old\":\"2025-10-18 14:30:00\",\"new\":\"2025-10-20 14:30:00\"}}}}', NULL, NULL),
(242, '2025-10-18 16:27:52', NULL, 'testuser', 'choices', 'choice', '122', 'create', '{\"new\":{\"choice_id\":122,\"choice_name\":\"New Establishment\",\"email\":\"example@gmail.com\",\"status\":1,\"event_id\":7,\"establishment_type_id\":7},\"links\":{\"new\":[84]}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0'),
(243, '2025-10-29 20:15:29', NULL, 'testuser', 'events', 'event', '7', 'update', '{\"event_id\":7,\"old\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 09:35:00\",\"nomination_end\":\"2025-10-19 10:36:00\",\"voting_start\":\"2025-10-20 14:30:00\",\"voting_end\":\"2025-10-21 21:02:00\"},\"new\":{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"year\":2025,\"description\":\"This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024\",\"is_active\":1,\"is_archived\":0,\"created_at\":\"2025-10-16 06:53:48\",\"nomination_start\":\"2025-10-18 09:35:00\",\"nomination_end\":\"2025-10-19 10:36:00\",\"voting_start\":\"2025-10-20 14:30:00\",\"voting_end\":\"2025-10-31 21:02:00\"},\"diff\":{\"changed\":{\"voting_end\":{\"old\":\"2025-10-21 21:02:00\",\"new\":\"2025-10-31 21:02:00\"}}}}', NULL, NULL),
(244, '2025-10-29 20:22:04', NULL, 'testuser', 'categories', 'category', '14', 'deactivate', '{\"old\":{\"category_id\":14,\"category_name\":\"Bagong Category\",\"status\":1,\"event_id\":7},\"new\":{\"category_id\":14,\"category_name\":\"Bagong Category\",\"status\":0,\"event_id\":7},\"diff\":{\"changed\":{\"status\":{\"old\":1,\"new\":0}}}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_categories`
--

CREATE TABLE `tbl_categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '1 = active, 0 = inactive',
  `event_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_categories`
--

INSERT INTO `tbl_categories` (`category_id`, `category_name`, `status`, `event_id`) VALUES
(10, 'Food', 1, 7),
(11, 'Service', 1, 7),
(12, 'Retail', 1, 7),
(13, 'Feelings', 1, 7),
(14, 'Bagong Category', 0, 7);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_choices`
--

CREATE TABLE `tbl_choices` (
  `choice_id` int(11) NOT NULL,
  `choice_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '1 = active, 0 = inactive',
  `event_id` int(11) DEFAULT NULL,
  `establishment_type_id` int(10) UNSIGNED DEFAULT NULL,
  `qr_sent` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_choices`
--

INSERT INTO `tbl_choices` (`choice_id`, `choice_name`, `email`, `status`, `event_id`, `establishment_type_id`, `qr_sent`) VALUES
(64, 'Angel\'s Burger', 'ampcapacio@gmail.com', 1, 7, NULL, 0),
(65, 'Gemma\'s Store', 'rinyqekyv@mailinator.com', 1, 7, NULL, 0),
(66, 'Sloane Sweeney', 'gucelarysha@gmail.com', 1, 7, NULL, 0),
(67, 'Gray Shelton', 'gucelarysha@gmail.co', 1, 7, NULL, 1),
(68, 'Bagong Store', 'gucelarysha@gmail.com', 1, 7, NULL, 1),
(69, 'Jollibee', 'contact@jollibee.example', 1, 7, NULL, 0),
(71, 'Starbucks', 'info@starbucks.example', 1, 7, NULL, 0),
(72, '7-Eleven', 'support@7eleven.example', 1, 7, NULL, 0),
(73, 'Mercury Drug', 'service@mercurydrug.example', 1, 7, NULL, 0),
(74, 'Watsons', 'care@watsons.example', 1, 7, NULL, 0),
(75, 'National Book Store', 'contact@nationalbookstore.example', 1, 7, NULL, 0),
(76, 'SM Supermarket', 'info@smsupermarket.example', 1, 7, NULL, 0),
(77, 'Robinsons Supermarket', 'hello@robinsonssupermarket.example', 1, 7, NULL, 0),
(78, 'Puregold', 'support@puregold.example', 1, 7, NULL, 0),
(79, 'Uniqlo', 'service@uniqlo.example', 1, 7, NULL, 0),
(80, 'H&M', 'contact@hm.example', 1, 7, NULL, 0),
(81, 'Bench', 'info@bench.example', 1, 7, NULL, 0),
(82, 'Penshoppe', 'hello@penshoppe.example', 1, 7, NULL, 0),
(83, 'Nike', 'support@nike.example', 1, 7, NULL, 0),
(84, 'Adidas', 'service@adidas.example', 1, 7, NULL, 0),
(85, 'Mang Inasal', 'contact@manginasal.example', 1, 7, NULL, 0),
(86, 'Chowking', 'info@chowking.example', 1, 7, NULL, 0),
(87, 'Greenwich', 'hello@greenwich.example', 1, 7, NULL, 0),
(88, 'KFC', 'support@kfc.example', 1, 7, NULL, 0),
(89, 'Shakey\'s Pizza', 'service@shakeys.example', 1, 7, NULL, 0),
(90, 'Pizza Hut', 'contact@pizzahut.example', 1, 7, NULL, 0),
(91, 'Yellow Cab Pizza', 'info@yellowcab.example', 1, 7, NULL, 0),
(92, 'Goldilocks', 'hello@goldilocks.example', 1, 7, NULL, 0),
(93, 'Red Ribbon Bakeshop', 'support@redribbon.example', 1, 7, NULL, 0),
(94, 'Dunkin\'', 'service@dunkin.example', 1, 7, NULL, 0),
(95, 'Mister Donut', 'contact@misterdonut.example', 1, 7, NULL, 0),
(96, 'Ace Hardware', 'info@acehardware.example', 1, 7, NULL, 0),
(97, 'Handyman', 'hello@handyman.example', 1, 7, NULL, 0),
(98, 'Miniso', 'support@miniso.example', 1, 7, NULL, 0),
(99, 'Daiso Japan', 'service@daiso.example', 1, 7, NULL, 0),
(100, 'The Body Shop', 'contact@thebodyshop.example', 1, 7, NULL, 0),
(101, 'Power Mac Center', 'info@powermaccenter.example', 1, 7, NULL, 0),
(102, 'Samsung Experience Store', 'hello@samsungstore.example', 1, 7, NULL, 0),
(103, 'Globe Store', 'support@globestore.example', 1, 7, NULL, 0),
(104, 'Smart Store', 'service@smartstore.example', 1, 7, NULL, 0),
(105, 'test', 'gucelarysha@gmail.c', 1, 7, NULL, 0),
(106, 'test est', 'amfcapacio@gmail.com', 1, 7, NULL, 0),
(107, 'Test Establisment', 'afmcapacio@gmail.com', 1, 7, NULL, 0),
(108, 'hfwehfuwiew', 'fewfewef@gmail.com', 1, 7, 4, 0),
(109, 'McDonalds', 'mcdo@gmail.com', 1, 7, 5, 0),
(110, 'Another test', 'another@gmail.com', 1, 7, 5, 0),
(111, 'testttttttt', 'testtttt@gmail.com', 1, 7, 5, 0),
(112, 'plsplsplsGod', 'plspls@gmail.com', 1, 7, 5, 0),
(113, 'Bigby\'s Restaurant', 'bigbys@gmail.com', 1, 7, 6, 0),
(114, 'Eden Koch', 'qyra@mailinator.com', 1, 7, NULL, 0),
(115, 'Nomination Test', 'qubexuqin@mailinator.com', 1, 7, NULL, 0),
(121, 'Desiree Skinner', 'vaxoremo@mailinator.com', 1, 7, 6, 0),
(122, 'New Establishment', 'example@gmail.com', 1, 7, 7, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_comm_messages`
--

CREATE TABLE `tbl_comm_messages` (
  `id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `type` enum('qr_email','nomination_status','other') NOT NULL DEFAULT 'other',
  `recipient_email` varchar(255) NOT NULL,
  `recipient_name` varchar(255) DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `body_html` mediumtext NOT NULL,
  `status` enum('pending','sent','failed') NOT NULL DEFAULT 'pending',
  `error_text` text DEFAULT NULL,
  `retries` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `scheduled_at` datetime DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_comm_messages`
--

INSERT INTO `tbl_comm_messages` (`id`, `event_id`, `type`, `recipient_email`, `recipient_name`, `subject`, `body_html`, `status`, `error_text`, `retries`, `created_at`, `scheduled_at`, `sent_at`) VALUES
(113, 7, 'nomination_status', 'ampcapacio@gmail.com', 'Angel\'s Burger', 'Your nomination has been approved', '<p>Dear Angel\'s Burger,</p><p>\n        </p><p>Great news! Your nomination for Food: Best Chocolate Cake, Food: Best Cupcake/Muffin in Tatak Ormoc Consumers’ Choice Awards has been <strong>approved</strong>.</p><p>\n        </p><p>We’ll reach out with next steps soon. If you have any questions, reply to this email or contact us at support@tatakormoc.com.</p><p>\n        </p><p>— TOCCA Team</p>', 'sent', NULL, 0, '2025-10-16 11:41:00', '2025-10-16 11:41:00', '2025-10-16 11:41:04'),
(114, 7, 'nomination_status', 'rinyqekyv@mailinator.com', 'Gemma\'s Store', 'We need a bit more information', '<p>Dear Gemma\'s Store,</p><p>\n        </p><p>Thanks for your nomination for Food: Best Halo-Halo in Tatak Ormoc Consumers’ Choice Awards. Before we proceed, we need a bit more information.</p><p>\n        </p><p>Please reply to this email with the requested details. Thank you!</p><p>\n        </p><p>— TOCCA Team</p>', 'sent', NULL, 0, '2025-10-16 11:42:29', '2025-10-16 11:42:29', '2025-10-16 11:42:32'),
(115, 7, 'nomination_status', 'gucelarysha@gmail.com', 'Sloane Sweeney', 'We need a bit more information', '<p>Dear Sloane Sweeney,</p><p>\n        </p><p>Thanks for your nomination for Food: Best Chicken Barbecue, Food: Best Halo-Halo in Tatak Ormoc Consumers’ Choice Awards. Before we proceed, we need a bit more information.</p><p>\n        </p><p>Please reply to this email with the requested details. Thank you!</p><p>\n        </p><p>— TOCCA Team</p>', 'sent', NULL, 0, '2025-10-16 11:45:45', '2025-10-16 11:45:45', '2025-10-16 11:45:49'),
(116, 7, 'nomination_status', 'gucelarysha@gmail.com', 'Gray Shelton', 'Your nomination has been approved', '<p>Dear Gray Shelton,</p><p>\n        </p><p>Great news! Your nomination for Food: Best Chocolate Cake, Service: Best Catering Services in Tatak Ormoc Consumers’ Choice Awards has been <strong>approved</strong>.</p><p>\n        </p><p>We’ll reach out with next steps soon. If you have any questions, reply to this email or contact us at support@tatakormoc.com.</p><p>\n        </p><p>— TOCCA Team</p>', 'failed', 'SMTP Error: Could not connect to SMTP host. Failed to connect to server', 1, '2025-10-16 16:38:16', '2025-10-16 16:38:16', NULL),
(117, 7, 'qr_email', 'gucelarysha@gmail.com', 'Gray Shelton', 'Your QR Code for Tatak Ormoc Voting', '<div style=\"max-width:600px; font:14px/1.6 Arial, sans-serif; color:#222; word-wrap:break-word;\">\r\n           <p style=\"margin:0 0 16px;\">Dear <strong>Gray Shelton</strong>,</p>\r\n           <p style=\"margin:0 0 16px;\">Hi Gray Shelton,<br />\n<br />\nThank you for participating in the Tatak Ormoc Consumers’ Choice Awards 2024.<br />\n<br />\nAttached below is your unique QR code. Please keep it secure.<br />\n<br />\nBest regards,<br />\nTOCCA Admin</p>\r\n           <p style=\"margin:24px 0 0;\"><strong>TOCCA Team</strong></p>\r\n         </div>', 'sent', NULL, 0, '2025-10-17 04:54:47', NULL, '2025-10-17 04:54:47'),
(118, 7, 'qr_email', 'gucelarysha@gmail.com', 'Bagong Store', 'Your QR Code for Tatak Ormoc Voting', '<div style=\"max-width:600px; font:14px/1.6 Arial, sans-serif; color:#222; word-wrap:break-word;\">\r\n           <p style=\"margin:0 0 16px;\">Dear <strong>Bagong Store</strong>,</p>\r\n           <p style=\"margin:0 0 16px;\">Hi Bagong Store 11:02am,<br />\n<br />\nThank you for participating in the Tatak Ormoc Consumers’ Choice Awards 2024.<br />\n<br />\nAttached below is your unique QR code. Please keep it secure.<br />\n<br />\nBest regards,<br />\nTOCCA Admin</p>\r\n           <p style=\"margin:24px 0 0;\"><strong>TOCCA Team</strong></p>\r\n         </div>', 'sent', NULL, 0, '2025-10-17 11:03:09', NULL, '2025-10-17 11:03:09'),
(119, 7, 'nomination_status', 'qyra@mailinator.com', 'Eden Koch', 'Your nomination has been approved', '<p>Dear Eden Koch,</p><p>\n        </p><p>Great news! Your nomination for Food: Best Burger, Food: Best Chicken Barbecue in Tatak Ormoc Consumers’ Choice Awards has been <strong>approved</strong>.</p><p>\n        </p><p>We’ll reach out with next steps soon. If you have any questions, reply to this email or contact us at support@tatakormoc.com.</p><p>\n        </p><p>— TOCCA Team</p>', 'sent', NULL, 0, '2025-10-18 15:40:10', '2025-10-18 15:40:10', '2025-10-18 15:40:16'),
(120, 7, 'nomination_status', 'qubexuqin@mailinator.com', 'Nomination Test', 'Your nomination has been approved', '<p>Dear Nomination Test,</p><p>\n        </p><p>Great news! Your nomination for Food: Best Burger, Food: Best Chicken Barbecue in Tatak Ormoc Consumers’ Choice Awards has been <strong>approved</strong>.</p><p>\n        </p><p>We’ll reach out with next steps soon. If you have any questions, reply to this email or contact us at support@tatakormoc.com.</p><p>\n        </p><p>— TOCCA Team</p>', 'sent', NULL, 0, '2025-10-18 15:47:51', '2025-10-18 15:47:51', '2025-10-18 15:47:56'),
(121, 7, 'nomination_status', 'vaxoremo@mailinator.com', 'Desiree Skinner', 'Your nomination has been approved', '<p>Dear Desiree Skinner,</p><p>\n        </p><p>Great news! Your nomination for Food: Best Burger, Food: Best Chicken Barbecue in Tatak Ormoc Consumers’ Choice Awards has been <strong>approved</strong>.</p><p>\n        </p><p>We’ll reach out with next steps soon. If you have any questions, reply to this email or contact us at support@tatakormoc.com.</p><p>\n        </p><p>— TOCCA Team</p>', 'sent', NULL, 0, '2025-10-18 16:13:08', '2025-10-18 16:13:08', '2025-10-18 16:13:14');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_config`
--

CREATE TABLE `tbl_config` (
  `id` int(11) NOT NULL,
  `config_key` varchar(100) NOT NULL,
  `config_value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_config`
--

INSERT INTO `tbl_config` (`id`, `config_key`, `config_value`) VALUES
(1, 'favicon_path', 'img/1757121797_tatak_ormoc_logo.png'),
(4, 'navbar_bg_color', '#0d47a1'),
(5, 'sidebar_bg_color', '#1976d2'),
(6, 'sidebar_text_color', '#ffffff'),
(10, 'voter_logo_path', 'img/default-voter-logo.png'),
(19, 'voter_header_logo', '../e-vote-final-enhanced/img/1756911665_tocca_banner.jpg'),
(24, 'voter_bg_color', '#ffffff'),
(25, 'voter_text_color', '#202020'),
(26, 'voter_font_size', '15px'),
(28, 'logo_path', 'img/1760669152_images.png'),
(32, 'mini_logo_path', 'img/1757121762_tatak_ormoc_logo.png'),
(267, 'login_side_logo', 'img/tatak ormoc logo.png'),
(268, 'login_banner', 'img/tocca_banner.jpg'),
(269, 'login_title', 'Tatak Ormoc Consumers’ Choice Awards 2024'),
(270, 'login_bg_color', '#0d47a1'),
(289, 'nominationBanner', 'img/1760669040_gwen.jpg'),
(306, 'nominationBgColor', '#e2eee3'),
(402, 'notif_nomination_end_hours', '-24,0'),
(403, 'notif_pending_deadline_hours', '-24,0,1,24,48,72'),
(404, 'notif_voting_start_hours', '-24,0,24,72,168'),
(405, 'notif_voting_end_hours', '-24,0,24,72,168'),
(406, 'notif_pending_min_total', '1'),
(407, 'notif_pending_warning_hours', '1'),
(426, 'notif_nomination_start_hours', '-24,0,24');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_draft_choice`
--

CREATE TABLE `tbl_draft_choice` (
  `draft_choice_id` int(11) NOT NULL,
  `voters_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `choice_id` int(11) NOT NULL,
  `saved_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_draft_freetext`
--

CREATE TABLE `tbl_draft_freetext` (
  `draft_freetext_id` int(11) NOT NULL,
  `voters_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `freetext` varchar(255) NOT NULL,
  `saved_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_establishment_types`
--

CREATE TABLE `tbl_establishment_types` (
  `type_id` int(10) UNSIGNED NOT NULL,
  `type_name` varchar(255) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `display_order` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_establishment_types`
--

INSERT INTO `tbl_establishment_types` (`type_id`, `type_name`, `status`, `display_order`, `created_at`, `updated_at`) VALUES
(2, 'Fast Food Chain', 1, NULL, '2025-10-18 03:34:46', '2025-10-18 03:34:46'),
(4, 'Cafe', 1, NULL, '2025-10-18 03:45:07', '2025-10-18 03:45:07'),
(5, 'Eatery', 1, NULL, '2025-10-18 03:58:19', '2025-10-18 03:58:19'),
(6, 'Restaurant', 1, NULL, '2025-10-18 06:27:20', '2025-10-18 06:27:20'),
(7, 'New type', 1, NULL, '2025-10-18 08:26:56', '2025-10-18 08:26:56');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_establishment_type_awards`
--

CREATE TABLE `tbl_establishment_type_awards` (
  `id` int(11) NOT NULL,
  `type_id` int(10) UNSIGNED NOT NULL,
  `question_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_establishment_type_awards`
--

INSERT INTO `tbl_establishment_type_awards` (`id`, `type_id`, `question_id`, `created_at`) VALUES
(1, 2, 76, '2025-10-18 11:34:46'),
(2, 4, 77, '2025-10-18 11:45:07'),
(3, 5, 63, '2025-10-18 11:58:19'),
(4, 5, 67, '2025-10-18 11:58:19'),
(5, 6, 76, '2025-10-18 14:27:20'),
(6, 6, 63, '2025-10-18 14:27:20'),
(7, 6, 64, '2025-10-18 14:27:20'),
(8, 7, 84, '2025-10-18 16:26:56'),
(9, 7, 85, '2025-10-18 16:26:56');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_events`
--

CREATE TABLE `tbl_events` (
  `event_id` int(11) NOT NULL,
  `event_name` varchar(255) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `nomination_start` datetime DEFAULT NULL,
  `nomination_end` datetime DEFAULT NULL,
  `voting_start` datetime DEFAULT NULL,
  `voting_end` datetime DEFAULT NULL,
  `reminder_grace_hours` int(11) NOT NULL DEFAULT 48,
  `is_active` tinyint(1) DEFAULT 0,
  `total_votes` int(11) DEFAULT 0,
  `is_archived` tinyint(1) DEFAULT 0,
  `archived_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_events`
--

INSERT INTO `tbl_events` (`event_id`, `event_name`, `year`, `description`, `nomination_start`, `nomination_end`, `voting_start`, `voting_end`, `reminder_grace_hours`, `is_active`, `total_votes`, `is_archived`, `archived_date`, `created_at`) VALUES
(7, 'TOCCA 2024 Awards', 2025, 'This includes the nomination process of the establishments to participate, and the actual TOCCA Voting Process 2024', '2025-10-18 09:35:00', '2025-10-19 10:36:00', '2025-10-20 14:30:00', '2025-10-31 21:02:00', 48, 1, 0, 0, '2025-10-16 16:45:54', '2025-10-16 06:53:48'),
(8, 'jtyjytjjty', 2025, 'tutyuy', '2025-10-15 11:13:00', '2025-10-16 11:13:00', '2025-10-15 11:13:00', '2025-10-15 11:13:00', 48, 0, 0, 1, '2025-10-16 11:37:18', '2025-10-16 11:14:01'),
(9, 'regerg', 2025, 'ergergere', '2025-10-15 11:22:00', '2025-10-14 11:22:00', '2025-10-17 11:22:00', '2025-10-15 11:22:00', 48, 0, 0, 1, '2025-10-16 11:37:16', '2025-10-16 11:22:17'),
(10, 'test', 2025, 'tgegeer', '2025-10-15 11:27:00', '2025-10-14 11:27:00', '2025-10-15 11:27:00', NULL, 48, 0, 0, 1, '2025-10-16 11:37:12', '2025-10-16 11:27:57'),
(11, 'Bagong Awards', 2025, '', '2025-10-17 10:36:00', '2025-10-18 10:36:00', '2025-10-19 10:37:00', '2025-10-20 10:37:00', 48, 0, 0, 0, NULL, '2025-10-17 10:38:17');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_feedback`
--

CREATE TABLE `tbl_feedback` (
  `feedback_id` int(11) NOT NULL,
  `feedback_type` enum('voter','nominee') NOT NULL,
  `voters_id` int(11) DEFAULT NULL,
  `nomination_id` int(11) DEFAULT NULL,
  `event_id` int(11) NOT NULL,
  `feedback` text NOT NULL,
  `is_anonymous` tinyint(1) NOT NULL DEFAULT 1,
  `submitted_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_feedback`
--

INSERT INTO `tbl_feedback` (`feedback_id`, `feedback_type`, `voters_id`, `nomination_id`, `event_id`, `feedback`, `is_anonymous`, `submitted_at`) VALUES
(25, 'nominee', NULL, 63, 7, 'satisfied transaction', 0, '2025-10-16 08:32:44'),
(26, 'nominee', NULL, 64, 7, 'odd UI', 1, '2025-10-16 09:44:22'),
(27, 'nominee', NULL, 65, 7, 'chares', 0, '2025-10-16 10:11:24'),
(28, 'nominee', NULL, 66, 7, 'easy navigation but no proper validations and mayor permit number format', 1, '2025-10-16 11:45:24'),
(29, 'voter', 27, NULL, 7, 'test test test feedback', 0, '2025-10-16 13:18:49'),
(30, 'nominee', NULL, 67, 7, 'feebcack', 1, '2025-10-16 14:06:10'),
(31, 'nominee', NULL, 70, 7, 'this is my feedback', 0, '2025-10-16 16:29:30'),
(32, 'nominee', NULL, 71, 7, 'feedback Oct 1, 2025', 1, '2025-10-16 22:28:31'),
(33, 'voter', 28, NULL, 7, 'this is good', 0, '2025-10-17 05:45:19'),
(34, 'voter', 29, NULL, 7, 'hehe this is my feedback', 1, '2025-10-17 07:41:43'),
(35, 'nominee', NULL, 75, 7, 'test feddaac', 1, '2025-10-18 16:23:22');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_nominations`
--

CREATE TABLE `tbl_nominations` (
  `nomination_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `establishment_type_id` int(11) NOT NULL,
  `status` enum('pending','in_review','needs_info','approved','rejected','merged') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `reference_no` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_nominations`
--

INSERT INTO `tbl_nominations` (`nomination_id`, `event_id`, `establishment_type_id`, `status`, `created_at`, `updated_at`, `reference_no`) VALUES
(63, 7, 0, 'approved', '2025-10-16 08:32:08', '2025-10-16 11:41:00', 'NOM-2025-000063'),
(64, 7, 0, 'rejected', '2025-10-16 09:42:41', '2025-10-16 11:50:03', 'NOM-2025-000064'),
(65, 7, 0, 'approved', '2025-10-16 10:11:13', '2025-10-16 11:42:29', 'NOM-2025-000065'),
(66, 7, 0, 'approved', '2025-10-16 11:44:31', '2025-10-16 14:31:36', 'NOM-2025-000066'),
(67, 7, 0, 'pending', '2025-10-16 14:05:25', '2025-10-16 14:05:25', 'NOM-2025-000067'),
(68, 7, 0, 'in_review', '2025-10-16 14:50:52', '2025-10-17 05:48:31', 'NOM-2025-000068'),
(69, 7, 0, 'in_review', '2025-10-16 14:58:03', '2025-10-16 15:27:14', 'NOM-2025-000069'),
(70, 7, 0, 'approved', '2025-10-16 16:28:45', '2025-10-16 16:38:16', 'NOM-2025-000070'),
(71, 7, 0, 'in_review', '2025-10-16 22:28:08', '2025-10-17 02:03:44', 'NOM-2025-7JC6KT'),
(72, 7, 0, 'approved', '2025-10-18 15:39:27', '2025-10-18 15:40:10', 'NOM-2025-DG3FHR'),
(73, 7, 6, 'approved', '2025-10-18 15:47:31', '2025-10-18 15:47:51', 'NOM-2025-P2U35W'),
(74, 7, 6, 'approved', '2025-10-18 16:04:23', '2025-10-18 16:13:08', 'NOM-2025-K8QSU4'),
(75, 7, 5, 'pending', '2025-10-18 16:23:14', '2025-10-18 16:23:14', 'NOM-2025-HQ2MSX');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_nomination_answers`
--

CREATE TABLE `tbl_nomination_answers` (
  `id` int(11) NOT NULL,
  `nomination_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `answer` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_nomination_answers`
--

INSERT INTO `tbl_nomination_answers` (`id`, `nomination_id`, `field_id`, `answer`, `created_at`) VALUES
(170, 63, 24, 'Angel\'s Burger', '2025-10-16 08:32:08'),
(171, 63, 25, 'Angel Mae Flores', '2025-10-16 08:32:08'),
(172, 63, 26, '09668024716', '2025-10-16 08:32:08'),
(173, 63, 27, 'Sole Proprietorship', '2025-10-16 08:32:08'),
(174, 63, 28, 'MP-2025-ORM-123456', '2025-10-16 08:32:08'),
(175, 63, 29, 'ampcapacio@gmail.com', '2025-10-16 08:32:08'),
(176, 63, 31, 'Dayhagan, Ormoc City', '2025-10-16 08:32:08'),
(177, 63, 32, '/TOCCA_RECENT_NEWEST_2/nomination/uploads/nominations/2025/558296552-798461722895581-8702286845320515753-n-63-47fdd0d63ff2.jpg', '2025-10-16 08:32:08'),
(178, 64, 24, 'Pater ni Borj', '2025-10-16 09:42:41'),
(179, 64, 25, 'Patin Putin', '2025-10-16 09:42:41'),
(180, 64, 26, '09706823228', '2025-10-16 09:42:41'),
(181, 64, 27, 'Partnership', '2025-10-16 09:42:41'),
(182, 64, 28, 'MP-2025-ORM-123455', '2025-10-16 09:42:41'),
(183, 64, 31, 'Alegria, Ormoc City', '2025-10-16 09:42:41'),
(184, 64, 32, '/TOCCA_RECENT_NEWEST_2/nomination/uploads/nominations/2025/558883218-673042482521105-9017109491018737790-n-64-4362cd760d28.jpg', '2025-10-16 09:42:41'),
(185, 65, 24, 'Gemma\'s Store', '2025-10-16 10:11:13'),
(186, 65, 25, 'Gemma Lamang', '2025-10-16 10:11:13'),
(187, 65, 26, '09668024716', '2025-10-16 10:11:13'),
(188, 65, 27, 'Partnership', '2025-10-16 10:11:13'),
(189, 65, 28, 'MP-2025-ORM-123457', '2025-10-16 10:11:13'),
(190, 65, 29, 'rinyqekyv@mailinator.com', '2025-10-16 10:11:13'),
(191, 65, 30, 'https://www.hunafaxyzyqa.tv', '2025-10-16 10:11:13'),
(192, 65, 31, 'Owak, Ormoc City', '2025-10-16 10:11:13'),
(193, 65, 32, '/TOCCA_RECENT_NEWEST_2/nomination/uploads/nominations/2025/558853010-673042762521077-7007806752442365494-n-65-ed941130d697.jpg', '2025-10-16 10:11:13'),
(194, 66, 24, 'Sloane Sweeney', '2025-10-16 11:44:31'),
(195, 66, 25, 'Thane Gentry', '2025-10-16 11:44:31'),
(196, 66, 26, '09668024715', '2025-10-16 11:44:31'),
(197, 66, 27, 'Sole Proprietorship', '2025-10-16 11:44:31'),
(198, 66, 28, 'MP-2025-ORM-123451', '2025-10-16 11:44:31'),
(199, 66, 29, 'gucelarysha@gmail.com', '2025-10-16 11:44:31'),
(200, 66, 30, 'https://www.podiky.mobi', '2025-10-16 11:44:31'),
(201, 66, 31, 'Whitehead Dixon Inc', '2025-10-16 11:44:31'),
(202, 66, 32, '/TOCCA_RECENT_NEWEST_2/nomination/uploads/nominations/2025/560316028-673042979187722-5973173306101687287-n-66-884f50eaabfd.jpg', '2025-10-16 11:44:31'),
(203, 67, 24, 'Victor Velasquez', '2025-10-16 14:05:25'),
(204, 67, 25, 'Akeem Adams', '2025-10-16 14:05:25'),
(205, 67, 26, '09668024716', '2025-10-16 14:05:25'),
(206, 67, 27, 'Limited Liability Company', '2025-10-16 14:05:25'),
(207, 67, 28, 'MP-2025-ORM-123453', '2025-10-16 14:05:25'),
(208, 67, 29, 'bobem@mailinator.com', '2025-10-16 14:05:25'),
(209, 67, 30, 'https://www.cugexexofifav.org', '2025-10-16 14:05:25'),
(210, 67, 31, 'Gates and Lynn Traders', '2025-10-16 14:05:25'),
(211, 67, 32, '/TOCCA_RECENT_NEWEST_2/nomination/uploads/nominations/2025/download-1--67-2aea7446b8b0.jpg', '2025-10-16 14:05:25'),
(212, 68, 24, 'Angel\'s Pandesal', '2025-10-16 14:50:52'),
(213, 68, 25, 'Angel Mae FFlores', '2025-10-16 14:50:52'),
(214, 68, 26, '09668014721', '2025-10-16 14:50:52'),
(215, 68, 27, 'Partnership', '2025-10-16 14:50:52'),
(216, 68, 28, 'MP-2025-ORM-123456', '2025-10-16 14:50:52'),
(217, 68, 29, 'amfcapacio@gmail.com', '2025-10-16 14:50:52'),
(218, 68, 30, 'https://www.jaxecug.co', '2025-10-16 14:50:52'),
(219, 68, 31, 'Patterson and Fleming LLC', '2025-10-16 14:50:52'),
(220, 68, 32, '/TOCCA_RECENT_NEWEST_2/nomination/uploads/nominations/2025/538116481-1138082314832752-5124605941024705023-n-68-a0a05774454b.jpg', '2025-10-16 14:50:52'),
(221, 69, 24, 'Angel\'s Turon', '2025-10-16 14:58:03'),
(222, 69, 25, 'Angel Mae Capacio', '2025-10-16 14:58:03'),
(223, 69, 26, '09768232281', '2025-10-16 14:58:03'),
(224, 69, 27, 'Sole Proprietorship', '2025-10-16 14:58:03'),
(225, 69, 28, 'MP-2025-ORM-123452', '2025-10-16 14:58:03'),
(226, 69, 29, 'nula@mailinator.com', '2025-10-16 14:58:03'),
(227, 69, 30, 'https://www.faqifelys.tv', '2025-10-16 14:58:03'),
(228, 69, 31, 'Dayhagan, O.C', '2025-10-16 14:58:03'),
(229, 69, 32, '/TOCCA_RECENT_NEWEST_2/nomination/uploads/nominations/2025/4adf3079-e87e-4780-ad3f-d6fe389ce3a9-69-14bb9953bbe5.jpg', '2025-10-16 14:58:03'),
(230, 70, 24, 'Gray Shelton', '2025-10-16 16:28:45'),
(231, 70, 25, 'Ora Olsen', '2025-10-16 16:28:45'),
(232, 70, 26, '09768232281', '2025-10-16 16:28:45'),
(233, 70, 27, 'Limited Liability Company', '2025-10-16 16:28:45'),
(234, 70, 28, 'MP-2025-ORM-123452', '2025-10-16 16:28:45'),
(235, 70, 29, 'gucelarysha@gmail.com', '2025-10-16 16:28:45'),
(236, 70, 30, 'https://www.qoniwopy.co', '2025-10-16 16:28:45'),
(237, 70, 31, 'Livingston Mooney LLC', '2025-10-16 16:28:45'),
(238, 70, 32, '/TOCCA_RECENT_NEWEST_2/nomination/uploads/nominations/2025/558296552-798461722895581-8702286845320515753-n-70-abf5f4c53ff4.jpg', '2025-10-16 16:28:45'),
(239, 71, 24, 'Buck Barker', '2025-10-16 22:28:08'),
(240, 71, 25, 'Rysha Gucela', '2025-10-16 22:28:08'),
(241, 71, 26, '09668014721', '2025-10-16 22:28:08'),
(242, 71, 27, 'Sole Proprietorship', '2025-10-16 22:28:08'),
(243, 71, 28, 'MP-2025-ORM-123459', '2025-10-16 22:28:08'),
(244, 71, 29, 'gucelarysha@gmail.com', '2025-10-16 22:28:08'),
(245, 71, 30, 'https://www.vowa.org', '2025-10-16 22:28:08'),
(246, 71, 31, 'Coleman and Alford LLC', '2025-10-16 22:28:08'),
(247, 72, 24, 'Eden Koch', '2025-10-18 15:39:27'),
(248, 72, 25, 'Zephania Vaughn', '2025-10-18 15:39:27'),
(249, 72, 26, '09567937489', '2025-10-18 15:39:27'),
(250, 72, 27, 'Sole Proprietorship', '2025-10-18 15:39:27'),
(251, 72, 28, 'MP-2025-ORM-123456', '2025-10-18 15:39:27'),
(252, 72, 29, 'qyra@mailinator.com', '2025-10-18 15:39:27'),
(253, 72, 30, 'https://www.sysedazanugera.org.uk', '2025-10-18 15:39:27'),
(254, 72, 31, 'Mcdaniel and Hoffman Inc', '2025-10-18 15:39:27'),
(255, 73, 24, 'Nomination Test', '2025-10-18 15:47:31'),
(256, 73, 25, 'Aristotle Zamora', '2025-10-18 15:47:31'),
(257, 73, 26, '09368745267', '2025-10-18 15:47:31'),
(258, 73, 27, 'Sole Proprietorship', '2025-10-18 15:47:31'),
(259, 73, 28, 'MP-2025-ORM-123456', '2025-10-18 15:47:31'),
(260, 73, 29, 'qubexuqin@mailinator.com', '2025-10-18 15:47:31'),
(261, 73, 30, 'https://www.rykukynowyxufif.me.uk', '2025-10-18 15:47:31'),
(262, 73, 31, 'House and Santos Traders', '2025-10-18 15:47:31'),
(263, 74, 24, 'Desiree Skinner', '2025-10-18 16:04:23'),
(264, 74, 25, 'Wade Waters', '2025-10-18 16:04:23'),
(265, 74, 26, '09876785647', '2025-10-18 16:04:23'),
(266, 74, 27, 'Limited Liability Company', '2025-10-18 16:04:23'),
(267, 74, 28, 'MP-2025-ORM-123456', '2025-10-18 16:04:23'),
(268, 74, 29, 'vaxoremo@mailinator.com', '2025-10-18 16:04:23'),
(269, 74, 30, 'https://www.xyjo.me', '2025-10-18 16:04:23'),
(270, 74, 31, 'Wynn Ramsey Co', '2025-10-18 16:04:23'),
(271, 75, 24, 'Nene\'s Eatery', '2025-10-18 16:23:14'),
(272, 75, 25, 'Nene Wilde', '2025-10-18 16:23:14'),
(273, 75, 26, '09668024711', '2025-10-18 16:23:14'),
(274, 75, 27, 'Sole Proprietorship', '2025-10-18 16:23:14'),
(275, 75, 28, 'MP-2025-ORM-123454', '2025-10-18 16:23:14'),
(276, 75, 29, 'miraflor.lianne26@gmail.com', '2025-10-18 16:23:14'),
(277, 75, 31, 'Owak, Ormoc City', '2025-10-18 16:23:14');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_nomination_audit`
--

CREATE TABLE `tbl_nomination_audit` (
  `audit_id` int(11) NOT NULL,
  `nomination_id` int(11) NOT NULL,
  `action` varchar(32) NOT NULL,
  `details` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_nomination_audit`
--

INSERT INTO `tbl_nomination_audit` (`audit_id`, `nomination_id`, `action`, `details`, `created_at`) VALUES
(121, 0, 'system_nomination_start', '{\"event_id\":1,\"event_name\":\"TOCCA 2024 Awards\",\"start\":\"September 1, 2025 1:00 AM\",\"start_iso\":\"2025-09-01T01:00:00+08:00\",\"threshold_days\":-1,\"href\":\"system_utilities.php\",\"marker\":\"nom_start:1:202509010100:-1\",\"generated_at\":\"2025-10-15T21:04:07+08:00\"}', '2025-10-15 21:04:07'),
(122, 0, 'system_nomination_deadline', '{\"event_id\":1,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 16, 2025 1:40 AM\",\"deadline_iso\":\"2025-10-16T01:40:00+08:00\",\"threshold_days\":1,\"pending_count\":0,\"href\":\"nominations.php?status=pending\",\"marker\":\"nom_end:1:202510160140:1\",\"generated_at\":\"2025-10-15T21:04:07+08:00\",\"dismissed\":true,\"dismissed_at\":\"2025-10-16T06:37:54+08:00\"}', '2025-10-15 21:04:07'),
(123, 0, 'system_voting_start', '{\"event_id\":1,\"event_name\":\"TOCCA 2024 Awards\",\"start\":\"October 16, 2025 3:29 AM\",\"start_iso\":\"2025-10-16T03:29:00+08:00\",\"threshold_days\":1,\"href\":\"system_utilities.php\",\"marker\":\"vote_start:1:202510160329:1\",\"generated_at\":\"2025-10-15T21:04:07+08:00\",\"dismissed\":true,\"dismissed_at\":\"2025-10-16T06:37:54+08:00\"}', '2025-10-15 21:04:07'),
(124, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":1,\"new_entries\":1,\"recent_total\":1,\"generated_at\":\"2025-10-16T08:45:44+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:1:1:1\",\"dismissed\":true,\"dismissed_at\":\"2025-10-16T13:56:58+08:00\"}', '2025-10-16 08:45:44'),
(125, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":2,\"new_entries\":2,\"recent_total\":2,\"generated_at\":\"2025-10-16T09:42:46+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:2:2:2\",\"dismissed\":true,\"dismissed_at\":\"2025-10-16T13:56:58+08:00\"}', '2025-10-16 09:42:46'),
(126, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":3,\"new_entries\":3,\"recent_total\":3,\"generated_at\":\"2025-10-16T10:11:15+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:3:3:3\",\"dismissed\":true,\"dismissed_at\":\"2025-10-16T13:56:58+08:00\"}', '2025-10-16 10:11:15'),
(127, 63, 'approve', 'Approved → choice_id=64', '2025-10-16 11:41:00'),
(128, 63, 'email_send_attempt', 'status=sent; id=113', '2025-10-16 11:41:04'),
(129, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":2,\"new_entries\":2,\"recent_total\":3,\"generated_at\":\"2025-10-16T11:41:05+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:2:2:3\",\"dismissed\":true,\"dismissed_at\":\"2025-10-16T13:56:58+08:00\"}', '2025-10-16 11:41:05'),
(130, 65, 'approve', 'Approved → choice_id=65', '2025-10-16 11:42:29'),
(131, 65, 'email_send_attempt', 'status=sent; id=114', '2025-10-16 11:42:32'),
(132, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":1,\"new_entries\":1,\"recent_total\":3,\"generated_at\":\"2025-10-16T11:42:34+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:1:1:3\",\"dismissed\":true,\"dismissed_at\":\"2025-10-16T13:56:58+08:00\"}', '2025-10-16 11:42:34'),
(133, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":2,\"new_entries\":2,\"recent_total\":4,\"generated_at\":\"2025-10-16T11:44:33+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:2:2:4\",\"dismissed\":true,\"dismissed_at\":\"2025-10-16T13:56:57+08:00\"}', '2025-10-16 11:44:33'),
(134, 66, 'email_send_attempt', 'status=sent; id=115', '2025-10-16 11:45:49'),
(135, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":1,\"new_entries\":1,\"recent_total\":4,\"generated_at\":\"2025-10-16T11:50:04+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:1:1:4\",\"dismissed\":true,\"dismissed_at\":\"2025-10-16T13:56:57+08:00\"}', '2025-10-16 11:50:04'),
(136, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":2,\"new_entries\":2,\"recent_total\":5,\"generated_at\":\"2025-10-16T14:05:26+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:2:2:5\"}', '2025-10-16 14:05:26'),
(137, 66, 'approve', 'Approved → choice_id=66', '2025-10-16 14:31:36'),
(138, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":1,\"new_entries\":1,\"recent_total\":5,\"generated_at\":\"2025-10-16T14:31:42+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:1:1:5\"}', '2025-10-16 14:31:42'),
(139, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":2,\"unapproved_count\":2,\"new_entries\":2,\"recent_total\":6,\"generated_at\":\"2025-10-16T14:50:52+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:2:2:6\"}', '2025-10-16 14:50:52'),
(140, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":3,\"unapproved_count\":3,\"new_entries\":3,\"recent_total\":7,\"generated_at\":\"2025-10-16T14:58:05+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:3:3:7\"}', '2025-10-16 14:58:05'),
(141, 0, 'system_pending_deadline', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 16, 2025 3:02 PM\",\"deadline_iso\":\"2025-10-16T15:02:00+08:00\",\"threshold_hours\":1,\"threshold_days\":0.041666666666666664,\"pending_count\":3,\"unapproved_count\":3,\"href\":\"nominations.php?status=pending\",\"marker\":\"pending_deadline:7:202510161502:1:3\",\"generated_at\":\"2025-10-16T14:59:30+08:00\"}', '2025-10-16 14:59:30'),
(142, 0, 'system_pending_deadline', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 17, 2025 3:02 PM\",\"deadline_iso\":\"2025-10-17T15:02:00+08:00\",\"threshold_hours\":24,\"threshold_days\":1,\"pending_count\":3,\"unapproved_count\":3,\"href\":\"nominations.php?status=pending\",\"marker\":\"pending_deadline:7:202510171502:24:3\",\"generated_at\":\"2025-10-16T15:30:08+08:00\"}', '2025-10-16 15:30:08'),
(143, 0, 'system_pending_deadline', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 16, 2025 3:38 PM\",\"deadline_iso\":\"2025-10-16T15:38:00+08:00\",\"threshold_hours\":1,\"threshold_days\":0.041666666666666664,\"pending_count\":3,\"unapproved_count\":3,\"href\":\"nominations.php?status=pending\",\"marker\":\"pending_deadline:7:202510161538:1:3\",\"generated_at\":\"2025-10-16T15:37:07+08:00\"}', '2025-10-16 15:37:07'),
(144, 0, 'system_nomination_deadline', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 16, 2025 3:38 PM\",\"deadline_iso\":\"2025-10-16T15:38:00+08:00\",\"threshold_hours\":0,\"threshold_days\":0,\"pending_count\":3,\"unapproved_count\":3,\"href\":\"nominations.php?status=pending\",\"marker\":\"nom_end:7:202510161538:0\",\"generated_at\":\"2025-10-16T15:38:00+08:00\"}', '2025-10-16 15:38:00'),
(145, 0, 'system_pending_deadline', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 16, 2025 3:38 PM\",\"deadline_iso\":\"2025-10-16T15:38:00+08:00\",\"threshold_hours\":0,\"threshold_days\":0,\"pending_count\":3,\"unapproved_count\":3,\"href\":\"nominations.php?status=pending\",\"marker\":\"pending_deadline:7:202510161538:0:3\",\"generated_at\":\"2025-10-16T15:38:00+08:00\"}', '2025-10-16 15:38:00'),
(146, 0, 'system_pending_deadline', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 16, 2025 5:20 PM\",\"deadline_iso\":\"2025-10-16T17:20:00+08:00\",\"threshold_hours\":1,\"threshold_days\":0.041666666666666664,\"pending_count\":3,\"unapproved_count\":3,\"href\":\"nominations.php?status=pending\",\"marker\":\"pending_deadline:7:202510161720:1:3\",\"generated_at\":\"2025-10-16T16:23:01+08:00\"}', '2025-10-16 16:23:01'),
(147, 0, 'system_voting_start', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"start\":\"October 17, 2025 3:39 PM\",\"start_iso\":\"2025-10-17T15:39:00+08:00\",\"threshold_hours\":24,\"threshold_days\":1,\"href\":\"system_utilities.php\",\"marker\":\"vote_start:7:202510171539:24\",\"generated_at\":\"2025-10-16T16:23:01+08:00\"}', '2025-10-16 16:23:01'),
(148, 0, 'system_pending_deadline', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 16, 2025 5:20 PM\",\"deadline_iso\":\"2025-10-16T17:20:00+08:00\",\"threshold_hours\":1,\"threshold_days\":0.041666666666666664,\"pending_count\":4,\"unapproved_count\":4,\"href\":\"nominations.php?status=pending\",\"marker\":\"pending_deadline:7:202510161720:1:4\",\"generated_at\":\"2025-10-16T16:32:22+08:00\"}', '2025-10-16 16:32:22'),
(149, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":4,\"recent_total\":8,\"generated_at\":\"2025-10-16T16:32:22+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:4:4:8\"}', '2025-10-16 16:32:22'),
(150, 70, 'approve', 'Approved → choice_id=67', '2025-10-16 16:38:16'),
(151, 70, 'email_send_attempt', 'status=failed; id=116', '2025-10-16 16:38:16'),
(152, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":3,\"unapproved_count\":3,\"new_entries\":3,\"recent_total\":8,\"generated_at\":\"2025-10-16T16:38:17+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:3:3:8\"}', '2025-10-16 16:38:17'),
(153, 0, 'system_voting_start', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"start\":\"October 16, 2025 8:39 PM\",\"start_iso\":\"2025-10-16T20:39:00+08:00\",\"threshold_hours\":-1,\"threshold_days\":-0.041666666666666664,\"href\":\"system_utilities.php\",\"marker\":\"vote_start:7:202510162039:-1\",\"generated_at\":\"2025-10-16T20:54:05+08:00\"}', '2025-10-16 20:54:05'),
(154, 0, 'system_voting_end', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"end\":\"October 17, 2025 9:00 PM\",\"end_iso\":\"2025-10-17T21:00:00+08:00\",\"threshold_hours\":24,\"threshold_days\":1,\"href\":\"system_utilities.php\",\"marker\":\"vote_end:7:202510172100:24\",\"generated_at\":\"2025-10-16T20:59:42+08:00\"}', '2025-10-16 20:59:42'),
(155, 0, 'system_voting_end', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"end\":\"October 16, 2025 9:02 PM\",\"end_iso\":\"2025-10-16T21:02:00+08:00\",\"threshold_hours\":0,\"threshold_days\":0,\"href\":\"system_utilities.php\",\"marker\":\"vote_end:7:202510162102:0\",\"generated_at\":\"2025-10-16T21:00:14+08:00\"}', '2025-10-16 21:00:14'),
(156, 0, 'system_voting_end', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"end\":\"October 16, 2025 9:02 PM\",\"end_iso\":\"2025-10-16T21:02:00+08:00\",\"threshold_hours\":-1,\"threshold_days\":-0.041666666666666664,\"href\":\"system_utilities.php\",\"marker\":\"vote_end:7:202510162102:-1\",\"generated_at\":\"2025-10-16T21:02:03+08:00\"}', '2025-10-16 21:02:03'),
(157, 0, 'system_voting_end', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"end\":\"October 17, 2025 9:02 PM\",\"end_iso\":\"2025-10-17T21:02:00+08:00\",\"threshold_hours\":24,\"threshold_days\":1,\"href\":\"system_utilities.php\",\"marker\":\"vote_end:7:202510172102:24\",\"generated_at\":\"2025-10-16T21:20:20+08:00\"}', '2025-10-16 21:20:20'),
(158, 0, 'system_pending_deadline', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 16, 2025 9:25 PM\",\"deadline_iso\":\"2025-10-16T21:25:00+08:00\",\"threshold_hours\":1,\"threshold_days\":0.041666666666666664,\"pending_count\":3,\"unapproved_count\":3,\"href\":\"nominations.php?status=pending\",\"marker\":\"pending_deadline:7:202510162125:1:3\",\"generated_at\":\"2025-10-16T21:20:40+08:00\"}', '2025-10-16 21:20:40'),
(159, 0, 'system_pending_deadline', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 16, 2025 10:25 PM\",\"deadline_iso\":\"2025-10-16T22:25:00+08:00\",\"threshold_hours\":1,\"threshold_days\":0.041666666666666664,\"pending_count\":3,\"unapproved_count\":3,\"href\":\"nominations.php?status=pending\",\"marker\":\"pending_deadline:7:202510162225:1:3\",\"generated_at\":\"2025-10-16T21:40:18+08:00\"}', '2025-10-16 21:40:18'),
(160, 0, 'system_pending_deadline', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 16, 2025 10:36 PM\",\"deadline_iso\":\"2025-10-16T22:36:00+08:00\",\"threshold_hours\":1,\"threshold_days\":0.041666666666666664,\"pending_count\":3,\"unapproved_count\":3,\"href\":\"nominations.php?status=pending\",\"marker\":\"pending_deadline:7:202510162236:1:3\",\"generated_at\":\"2025-10-16T22:27:16+08:00\"}', '2025-10-16 22:27:16'),
(161, 0, 'system_pending_deadline', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"deadline\":\"October 16, 2025 10:36 PM\",\"deadline_iso\":\"2025-10-16T22:36:00+08:00\",\"threshold_hours\":1,\"threshold_days\":0.041666666666666664,\"pending_count\":4,\"unapproved_count\":4,\"href\":\"nominations.php?status=pending\",\"marker\":\"pending_deadline:7:202510162236:1:4\",\"generated_at\":\"2025-10-16T22:28:54+08:00\"}', '2025-10-16 22:28:54'),
(162, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":4,\"recent_total\":9,\"generated_at\":\"2025-10-16T22:28:54+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251016:4:4:9\"}', '2025-10-16 22:28:54'),
(163, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":4,\"recent_total\":9,\"generated_at\":\"2025-10-17T02:00:35+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251017:4:4:9\",\"dismissed\":true,\"dismissed_at\":\"2025-10-17T03:14:23+08:00\"}', '2025-10-17 02:00:35'),
(164, 0, 'system_voting_start', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"start\":\"October 17, 2025 12:43 AM\",\"start_iso\":\"2025-10-17T00:43:00+08:00\",\"threshold_hours\":-1,\"threshold_days\":-0.041666666666666664,\"href\":\"system_utilities.php\",\"marker\":\"vote_start:7:202510170043:-1\",\"generated_at\":\"2025-10-17T02:00:35+08:00\"}', '2025-10-17 02:00:35'),
(165, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":4,\"recent_total\":6,\"generated_at\":\"2025-10-17T10:34:48+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251017:4:4:6\"}', '2025-10-17 10:34:48'),
(166, 0, 'system_voting_end', '{\"event_id\":11,\"event_name\":\"Bagong Awards\",\"end\":\"October 20, 2025 10:37 AM\",\"end_iso\":\"2025-10-20T10:37:00+08:00\",\"threshold_hours\":72,\"threshold_days\":3,\"href\":\"system_utilities.php\",\"marker\":\"vote_end:11:202510201037:72\",\"generated_at\":\"2025-10-17T10:38:18+08:00\"}', '2025-10-17 10:38:18'),
(167, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":4,\"recent_total\":5,\"generated_at\":\"2025-10-17T11:44:37+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251017:4:4:5\",\"dismissed\":true,\"dismissed_at\":\"2025-10-18T08:15:42+08:00\"}', '2025-10-17 11:44:37'),
(168, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":3,\"recent_total\":4,\"generated_at\":\"2025-10-17T14:11:53+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251017:4:3:4\",\"dismissed\":true,\"dismissed_at\":\"2025-10-18T08:15:41+08:00\"}', '2025-10-17 14:11:53'),
(169, 0, 'system_nomination_start', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"start\":\"October 16, 2025 3:35 PM\",\"start_iso\":\"2025-10-16T15:35:00+08:00\",\"threshold_hours\":-24,\"threshold_days\":-1,\"href\":\"system_utilities.php\",\"marker\":\"nom_start:7:202510161535:-24\",\"generated_at\":\"2025-10-17T14:37:23+08:00\"}', '2025-10-17 14:37:23'),
(170, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":2,\"recent_total\":3,\"generated_at\":\"2025-10-17T14:51:02+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251017:4:2:3\",\"dismissed\":true,\"dismissed_at\":\"2025-10-18T08:15:41+08:00\"}', '2025-10-17 14:51:02'),
(171, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":1,\"recent_total\":2,\"generated_at\":\"2025-10-17T14:58:59+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251017:4:1:2\",\"dismissed\":true,\"dismissed_at\":\"2025-10-18T08:15:41+08:00\"}', '2025-10-17 14:58:59'),
(172, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":1,\"recent_total\":1,\"generated_at\":\"2025-10-17T17:46:10+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251017:4:1:1\",\"dismissed\":true,\"dismissed_at\":\"2025-10-18T08:15:40+08:00\"}', '2025-10-17 17:46:10'),
(173, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":0,\"recent_total\":0,\"generated_at\":\"2025-10-18T08:15:26+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251018:4:0:0\",\"dismissed\":true,\"dismissed_at\":\"2025-10-18T08:15:40+08:00\"}', '2025-10-18 08:15:26'),
(174, 0, 'system_voting_start', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"start\":\"October 18, 2025 3:43 PM\",\"start_iso\":\"2025-10-18T15:43:00+08:00\",\"threshold_hours\":1,\"threshold_days\":0.041666666666666664,\"href\":\"system_utilities.php\",\"marker\":\"vote_start:7:202510181543:1\",\"generated_at\":\"2025-10-18T14:30:12+08:00\"}', '2025-10-18 14:30:12'),
(175, 0, 'system_voting_start', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"start\":\"October 18, 2025 2:30 PM\",\"start_iso\":\"2025-10-18T14:30:00+08:00\",\"threshold_hours\":-1,\"threshold_days\":-0.041666666666666664,\"href\":\"system_utilities.php\",\"marker\":\"vote_start:7:202510181430:-1\",\"generated_at\":\"2025-10-18T14:31:51+08:00\"}', '2025-10-18 14:31:51'),
(176, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":5,\"unapproved_count\":5,\"new_entries\":1,\"recent_total\":1,\"generated_at\":\"2025-10-18T15:39:31+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251018:5:1:1\"}', '2025-10-18 15:39:31'),
(177, 72, 'approve', 'Approved → choice_id=114', '2025-10-18 15:40:10'),
(178, 72, 'email_send_attempt', 'status=sent; id=119', '2025-10-18 15:40:16'),
(179, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":0,\"recent_total\":1,\"generated_at\":\"2025-10-18T15:40:17+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251018:4:0:1\"}', '2025-10-18 15:40:17'),
(180, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":5,\"unapproved_count\":5,\"new_entries\":1,\"recent_total\":2,\"generated_at\":\"2025-10-18T15:47:35+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251018:5:1:2\"}', '2025-10-18 15:47:35'),
(181, 73, 'approve', 'Approved → choice_id=115', '2025-10-18 15:47:51'),
(182, 73, 'email_send_attempt', 'status=sent; id=120', '2025-10-18 15:47:56'),
(183, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":0,\"recent_total\":2,\"generated_at\":\"2025-10-18T15:47:56+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251018:4:0:2\"}', '2025-10-18 15:47:56'),
(184, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":5,\"unapproved_count\":5,\"new_entries\":1,\"recent_total\":3,\"generated_at\":\"2025-10-18T16:04:38+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251018:5:1:3\"}', '2025-10-18 16:04:38'),
(185, 74, 'approve', 'Approved → choice_id=121', '2025-10-18 16:13:08'),
(186, 74, 'email_send_attempt', 'status=sent; id=121', '2025-10-18 16:13:14'),
(187, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":4,\"unapproved_count\":4,\"new_entries\":0,\"recent_total\":3,\"generated_at\":\"2025-10-18T16:13:15+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251018:4:0:3\"}', '2025-10-18 16:13:15'),
(188, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":5,\"unapproved_count\":5,\"new_entries\":1,\"recent_total\":4,\"generated_at\":\"2025-10-18T16:23:23+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251018:5:1:4\"}', '2025-10-18 16:23:23'),
(189, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":5,\"unapproved_count\":5,\"new_entries\":0,\"recent_total\":0,\"generated_at\":\"2025-10-29T20:15:05+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251029:5:0:0\"}', '2025-10-29 20:15:05'),
(190, 0, 'system_pending_nomination', '{\"event_id\":7,\"event_name\":\"TOCCA 2024 Awards\",\"pending_count\":5,\"unapproved_count\":5,\"new_entries\":0,\"recent_total\":0,\"generated_at\":\"2025-11-14T19:42:04+08:00\",\"href\":\"nominations.php?status=pending\",\"marker\":\"pending:7:20251114:5:0:0\"}', '2025-11-14 19:42:04');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_nomination_fields`
--

CREATE TABLE `tbl_nomination_fields` (
  `id` int(11) NOT NULL,
  `label` varchar(255) NOT NULL,
  `name` varchar(128) NOT NULL,
  `type` enum('text','textarea','select','checkbox','radio','file','email','tel','url','number','date') NOT NULL DEFAULT 'text',
  `options` text DEFAULT NULL,
  `is_required` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `sort_order` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_nomination_fields`
--

INSERT INTO `tbl_nomination_fields` (`id`, `label`, `name`, `type`, `options`, `is_required`, `is_active`, `sort_order`, `created_at`, `updated_at`) VALUES
(24, 'Business Name', 'business_name', 'text', NULL, 1, 1, 0, '2025-10-16 08:17:46', '2025-10-16 09:34:35'),
(25, 'Owner/President/General Manager', 'name_of_ownder_president_general_manager', 'text', NULL, 1, 1, 1, '2025-10-16 08:18:19', '2025-10-16 10:33:25'),
(26, 'Mobile Number', 'mobile_number', 'tel', NULL, 1, 1, 3, '2025-10-16 08:18:34', '2025-10-16 08:18:34'),
(27, 'Designation in the Business/Company', 'designation_in_the_business_company', 'select', '[\"Sole Proprietorship\",\"Partnership\",\"Limited Liability Company\",\"Corporation\"]', 1, 1, 4, '2025-10-16 08:20:57', '2025-10-16 08:23:57'),
(28, 'Mayor\'s Permit Number', 'mayor_s_permit_number', 'text', NULL, 1, 1, 5, '2025-10-16 08:21:21', '2025-10-16 08:21:21'),
(29, 'Email', 'email', 'email', NULL, 1, 1, 6, '2025-10-16 08:21:36', '2025-10-16 11:43:43'),
(30, 'Website', 'website', 'url', NULL, 0, 1, 7, '2025-10-16 08:21:54', '2025-10-16 08:21:54'),
(31, 'Business/Company Address', 'business_company_address', 'text', NULL, 1, 1, 8, '2025-10-16 08:22:24', '2025-10-16 08:22:24'),
(32, 'Business/Company Logo', 'business_company_logo', 'file', NULL, 0, 1, 9, '2025-10-16 08:22:41', '2025-10-16 08:26:03');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_nomination_questions`
--

CREATE TABLE `tbl_nomination_questions` (
  `nomination_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_nomination_questions`
--

INSERT INTO `tbl_nomination_questions` (`nomination_id`, `question_id`) VALUES
(63, 64),
(63, 66),
(64, 63),
(64, 69),
(65, 65),
(66, 63),
(66, 65),
(67, 63),
(67, 65),
(68, 63),
(69, 64),
(69, 69),
(70, 64),
(70, 69),
(71, 67),
(71, 69),
(72, 63),
(72, 76),
(73, 63),
(73, 76),
(74, 63),
(74, 76),
(75, 63),
(75, 67);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_nomination_question_audit`
--

CREATE TABLE `tbl_nomination_question_audit` (
  `audit_id` int(11) NOT NULL,
  `nomination_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `action` enum('REMOVED') NOT NULL,
  `changed_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_nomination_question_audit`
--

INSERT INTO `tbl_nomination_question_audit` (`audit_id`, `nomination_id`, `question_id`, `action`, `changed_at`) VALUES
(10, 63, 65, 'REMOVED', '2025-10-16 10:58:02'),
(11, 70, 63, 'REMOVED', '2025-10-16 16:36:16');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_nomination_texts`
--

CREATE TABLE `tbl_nomination_texts` (
  `id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `section` enum('intro','instructions') NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `body_html` mediumtext DEFAULT NULL,
  `bullets_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`bullets_json`)),
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_nomination_texts`
--

INSERT INTO `tbl_nomination_texts` (`id`, `event_id`, `section`, `title`, `subtitle`, `body_html`, `bullets_json`, `is_active`, `updated_at`) VALUES
(32, 1, 'intro', NULL, NULL, 'The City Government of Ormoc through the Tatak Ormoc Business Awards Organizing Committee in partnership with the Ormoc City Chamber of Commerce and Industry and STI College – Ormoc is pleased to inform the public of the opening of the 2024 Tatak Ormoc Consumers’ Choice Awards (TOCCA)\r\n\r\nThe 2024 TOCCA determines which Ormocanon products and services are top of mind to the citizens, and recognizes the best among them.', NULL, 0, '2025-10-15 21:53:35'),
(33, 1, 'instructions', 'Instructions', NULL, NULL, '[\"Please complete all required fields before submitting.\",\"Select the category and awards that best fit your business.\",\"Use the address search to auto-fill your exact location.\",\"Prepare your official business or company name.\",\"Have a high-resolution company logo ready (PNG\\/JPG\\/WEBP, max 10MB).\",\"Keep your current Mayor\'s Permit number on hand.\",\"Provide a complete business address: Street, Barangay, City\\/Municipality, Province, and Postal Code.\",\"Know the full name of the owner, president, or general manager.\",\"Ensure you have a mobile number in 09XXXXXXXXX format.\"]', 1, '2025-10-15 21:54:40'),
(34, 7, 'intro', NULL, NULL, 'The City Government of Ormoc through the **Tatak Ormoc Business Awards Organizing Committee** in partnership with the Ormoc City Chamber of Commerce and Industry and STI College – Ormoc is pleased to inform the public of the opening of the **2024 Tatak Ormoc Consumers’ Choice Awards (TOCCA)**\r\n\r\nThe 2024 TOCCA determines which Ormocanon products and services are top of mind to the citizens, and recognizes the best among them.', NULL, 1, '2025-10-16 00:13:06'),
(35, 7, 'instructions', 'Instructions', NULL, NULL, '[\"Please complete all required fields before submitting.\",\"Select the category and awards that best fit your business.\",\"Use the address search to auto-fill your exact location.\",\"Prepare your official business or company name.\",\"Have a high-resolution company logo ready (PNG\\/JPG\\/WEBP, max 10MB).\",\"Keep your current Mayor\'s Permit number on hand.\",\"Provide a complete business address: Street, Barangay, City\\/Municipality, Province, and Postal Code.\",\"Know the full name of the owner, president, or general manager.\",\"Ensure you have a mobile number in **09XXXXXXXXX** format.\"]', 1, '2025-10-16 00:15:16');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_poll_choice`
--

CREATE TABLE `tbl_poll_choice` (
  `poll_choice_id` int(11) NOT NULL,
  `voters_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `choice_id` int(11) NOT NULL,
  `vote_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_poll_choice`
--

INSERT INTO `tbl_poll_choice` (`poll_choice_id`, `voters_id`, `question_id`, `choice_id`, `vote_at`) VALUES
(214, 27, 64, 64, '2025-10-16 13:17:59'),
(215, 27, 66, 64, '2025-10-16 13:18:04'),
(216, 27, 78, 66, '2025-10-17 05:31:35'),
(217, 27, 79, 66, '2025-10-17 05:31:38'),
(218, 28, 64, 64, '2025-10-17 05:41:31'),
(219, 28, 68, 66, '2025-10-17 05:41:31'),
(220, 28, 69, 64, '2025-10-17 05:41:31'),
(221, 29, 83, 64, '2025-10-17 07:41:06'),
(222, 29, 84, 68, '2025-10-17 11:06:21'),
(223, 28, 84, 68, '2025-10-17 11:58:31'),
(224, 27, 84, 64, '2025-10-17 11:59:50'),
(225, 1, 84, 68, '2025-10-17 12:03:45'),
(226, 2, 84, 68, '2025-10-17 12:04:26'),
(227, 3, 84, 64, '2025-10-17 12:05:17'),
(228, 4, 84, 64, '2025-10-17 12:06:03'),
(229, 5, 84, 65, '2025-10-17 12:07:07'),
(230, 6, 84, 65, '2025-10-17 12:07:43'),
(231, 7, 84, 65, '2025-10-17 12:09:09'),
(232, 8, 84, 67, '2025-10-17 12:39:33'),
(233, 9, 84, 67, '2025-10-17 12:45:01'),
(234, 10, 84, 67, '2025-10-17 12:45:33'),
(235, 11, 84, 66, '2025-10-17 12:50:40'),
(236, 11, 63, 72, '2025-10-17 14:54:25'),
(237, 12, 63, 81, '2025-10-17 14:55:18'),
(238, 13, 63, 91, '2025-10-17 14:56:06'),
(239, 14, 63, 74, '2025-10-17 14:57:00'),
(240, 15, 63, 79, '2025-10-17 14:57:39'),
(241, 16, 63, 100, '2025-10-17 14:58:20'),
(242, 17, 63, 80, '2025-10-17 14:58:57'),
(243, 18, 63, 92, '2025-10-17 15:00:14'),
(244, 19, 63, 103, '2025-10-17 15:00:53'),
(245, 20, 63, 85, '2025-10-17 15:01:28'),
(246, 27, 63, 82, '2025-10-17 15:02:28'),
(247, 28, 65, 64, '2025-10-17 15:03:25'),
(248, 1, 63, 102, '2025-10-17 15:05:32'),
(249, 2, 63, 99, '2025-10-17 15:06:14'),
(250, 3, 63, 73, '2025-10-17 15:06:56'),
(251, 4, 63, 78, '2025-10-17 15:08:01'),
(252, 5, 63, 83, '2025-10-17 15:08:39'),
(253, 6, 63, 75, '2025-10-17 15:10:02'),
(254, 7, 63, 102, '2025-10-17 15:10:43'),
(255, 8, 63, 65, '2025-10-17 15:12:41');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_poll_freetext`
--

CREATE TABLE `tbl_poll_freetext` (
  `poll_freetext_id` int(11) NOT NULL,
  `voters_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `freetext` varchar(255) NOT NULL,
  `vote_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_poll_freetext`
--

INSERT INTO `tbl_poll_freetext` (`poll_freetext_id`, `voters_id`, `question_id`, `freetext`, `vote_at`) VALUES
(276, 28, 63, 'Eco\'s Grill and Bbq', '2025-10-17 05:41:31'),
(277, 28, 70, 'Dongski Barbershop', '2025-10-17 05:41:31'),
(278, 28, 77, '25th Lane', '2025-10-17 05:41:31'),
(279, 29, 71, 'mang inasal - cogon', '2025-10-17 07:43:55'),
(280, 29, 72, 'one - hss', '2025-10-17 07:43:55'),
(281, 29, 73, 'gss - ysys', '2025-10-17 07:43:55'),
(282, 29, 74, 'hssh - gsgs', '2025-10-17 07:43:55'),
(283, 29, 75, 'gshsg - gsgsg', '2025-10-17 07:43:55');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_questions`
--

CREATE TABLE `tbl_questions` (
  `question_id` int(255) NOT NULL,
  `question_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category_id` int(255) NOT NULL,
  `choice_type` int(11) NOT NULL DEFAULT 1 COMMENT '1 = dropdown + freeform, 0 = freeform'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_questions`
--

INSERT INTO `tbl_questions` (`question_id`, `question_name`, `category_id`, `choice_type`) VALUES
(63, 'Best Chicken Barbecue', 10, 1),
(64, 'Best Chocolate Cake', 10, 1),
(65, 'Best Halo-Halo', 10, 1),
(66, 'Best Cupcake/Muffin', 10, 1),
(67, 'Best Pancit', 10, 1),
(68, 'Best Hair Salon', 11, 1),
(69, 'Best Catering Services', 11, 1),
(70, 'Best Barbershop', 11, 1),
(71, 'Best Break - up Food', 13, 0),
(72, 'Best Date Place', 13, 0),
(73, 'Best Hangover Food', 13, 0),
(74, 'Best Hairstylist', 13, 0),
(75, 'Best Recvoery Dood', 13, 0),
(76, 'Best Burger', 10, 1),
(77, 'Best Café', 11, 1),
(78, 'Best Dried Fish', 12, 1),
(79, 'Best Flower Shop', 12, 1),
(80, 'Best Grocery Shop', 12, 1),
(81, 'Best Meat Shop', 12, 1),
(82, 'Best Fruit Stand', 12, 1),
(83, 'Best Recovery Food', 13, 1),
(84, 'Bagong Award', 14, 1),
(85, 'New Award', 14, 1),
(87, 'Change Award', 10, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_question_choices`
--

CREATE TABLE `tbl_question_choices` (
  `id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `choice_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_question_choices`
--

INSERT INTO `tbl_question_choices` (`id`, `question_id`, `choice_id`) VALUES
(368, 84, 68),
(369, 63, 68),
(370, 84, 64),
(371, 76, 64),
(372, 77, 64),
(373, 69, 64),
(374, 63, 64),
(375, 64, 64),
(376, 66, 64),
(377, 78, 64),
(378, 82, 64),
(379, 80, 64),
(380, 65, 64),
(381, 81, 64),
(382, 67, 64),
(383, 83, 64),
(394, 84, 66),
(395, 70, 66),
(396, 76, 66),
(397, 77, 66),
(398, 69, 66),
(399, 63, 66),
(400, 64, 66),
(401, 66, 66),
(402, 78, 66),
(403, 79, 66),
(404, 82, 66),
(405, 80, 66),
(406, 68, 66),
(407, 65, 66),
(408, 81, 66),
(409, 67, 66),
(410, 83, 66),
(417, 63, 96),
(418, 63, 84),
(419, 63, 81),
(420, 63, 86),
(421, 63, 99),
(422, 63, 94),
(423, 84, 65),
(424, 64, 65),
(425, 79, 65),
(426, 82, 65),
(427, 80, 65),
(428, 65, 65),
(429, 83, 65),
(430, 63, 65),
(431, 63, 103),
(432, 63, 92),
(433, 84, 67),
(434, 69, 67),
(435, 64, 67),
(436, 63, 67),
(437, 63, 80),
(438, 63, 97),
(439, 63, 69),
(440, 63, 88),
(441, 63, 85),
(443, 63, 73),
(444, 63, 98),
(445, 63, 95),
(446, 63, 75),
(447, 63, 83),
(448, 63, 93),
(449, 63, 78),
(450, 63, 101),
(451, 63, 82),
(452, 63, 90),
(453, 63, 77),
(454, 63, 102),
(455, 63, 89),
(456, 63, 76),
(458, 63, 71),
(459, 76, 105),
(460, 78, 105),
(461, 63, 105),
(462, 84, 106),
(463, 63, 106),
(464, 63, 100),
(465, 63, 91),
(466, 63, 74),
(467, 63, 79),
(468, 84, 72),
(469, 63, 72),
(470, 63, 107),
(471, 77, 108),
(472, 63, 109),
(473, 63, 110),
(474, 63, 111),
(475, 63, 112),
(476, 67, 112),
(477, 76, 113),
(478, 64, 113),
(479, 63, 114),
(480, 76, 114),
(481, 63, 115),
(482, 76, 115),
(483, 63, 121),
(484, 76, 121),
(485, 84, 122);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_question_establishment_types`
--

CREATE TABLE `tbl_question_establishment_types` (
  `id` int(10) UNSIGNED NOT NULL,
  `type_id` int(10) UNSIGNED NOT NULL,
  `question_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_settings`
--

CREATE TABLE `tbl_settings` (
  `id` int(11) NOT NULL,
  `logo_path` varchar(255) NOT NULL,
  `mini_logo_path` varchar(255) DEFAULT NULL,
  `navbar_bg_color` varchar(20) DEFAULT NULL,
  `sidebar_bg_color` varchar(20) DEFAULT NULL,
  `sidebar_text_color` varchar(20) DEFAULT NULL,
  `favicon_path` varchar(255) DEFAULT 'img/tatakormoclogo.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_settings`
--

INSERT INTO `tbl_settings` (`id`, `logo_path`, `mini_logo_path`, `navbar_bg_color`, `sidebar_bg_color`, `sidebar_text_color`, `favicon_path`) VALUES
(1, 'img/1745212618_1744887100_tatakormoclogo.png', 'img/1745397690_1744879046_lguormoc.png', '#010066', '#d7d8e0', '#000000', 'img/1745423588_1744879046_lguormoc.png');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sms_reminders`
--

CREATE TABLE `tbl_sms_reminders` (
  `reminder_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `voters_id` int(11) DEFAULT NULL,
  `mobile_number_snapshot` varchar(32) NOT NULL,
  `status` enum('sent','failed','skipped') NOT NULL,
  `provider_msg_id` varchar(128) DEFAULT NULL,
  `attempt_at` datetime NOT NULL DEFAULT current_timestamp(),
  `send_day` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE `tbl_user` (
  `userID` int(11) NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `firstname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `lastname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`userID`, `username`, `password`, `firstname`, `lastname`, `email`) VALUES
(5, 'testuser', '$2y$10$Lv0KXfZQD8YxONzQqljNAeduCwB07WAOsG9YBDmVVGQuwmd6J6Wae', 'fhjhfejwkh', 'hfwekhfewjk', 'hfke@gmail.com'),
(6, 'toccaAdmin', '$2y$10$lbOdsJMRbI7OEU7UfcV8aOwrI3vKxVEvltJb5VZvraxjapFQvedE.', 'Test', 'Test', 'test@gmail.com'),
(0, 'tatakormoc', '$2y$10$p8mnRd6//cgbuxq7PwhmX.VRkFOmbTlpXDbbJk1ADLZcm95fW6Zmy', 'user', 'user', 'amfcapacio@gmail.com'),
(0, 'tocca_admin2025', '$2y$10$CxI5tl4rIxAt/c40/H17YOu5kr.Kjb9jB0lzs0lSpWE3XqguIo6LW', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_voters`
--

CREATE TABLE `tbl_voters` (
  `voters_id` int(11) NOT NULL,
  `mobile_number` varchar(15) NOT NULL,
  `draft_code` char(4) DEFAULT NULL,
  `date_verified` date DEFAULT curdate(),
  `is_archived` tinyint(1) DEFAULT 0,
  `has_voted` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_voters`
--

INSERT INTO `tbl_voters` (`voters_id`, `mobile_number`, `draft_code`, `date_verified`, `is_archived`, `has_voted`) VALUES
(1, '09171234567', '4821', '2025-06-12', 0, 0),
(2, '09281234568', '5294', '2025-06-13', 0, 0),
(3, '09391234569', '1830', '2025-06-13', 0, 0),
(4, '09451234570', '7358', '2025-06-14', 0, 0),
(5, '09561234571', '6274', '2025-06-15', 0, 0),
(6, '09681234572', '9182', '2025-06-15', 0, 0),
(7, '09791234573', '2309', '2025-06-16', 0, 0),
(8, '09981234574', '7035', '2025-06-17', 0, 0),
(9, '09181234575', '1542', '2025-06-18', 0, 0),
(10, '09291234576', '8765', '2025-06-19', 0, 0),
(11, '09172345677', '4128', '2025-06-20', 0, 0),
(12, '09283345678', '9056', '2025-06-21', 0, 0),
(13, '09394345679', '2715', '2025-06-21', 0, 0),
(14, '09455345670', '6384', '2025-06-22', 0, 0),
(15, '09566345671', '5479', '2025-06-23', 1, 0),
(16, '09687345672', '1023', '2025-06-23', 0, 0),
(17, '09798345673', '7860', '2025-06-24', 0, 0),
(18, '09989345674', '3297', '2025-06-25', 0, 0),
(19, '09180345675', '6541', '2025-06-26', 0, 0),
(20, '09291345676', '8783', '2025-06-27', 0, 0),
(27, '09668024716', '1234', '2025-10-16', 0, 0),
(28, '09465018358', '1234', '2025-10-17', 0, 0),
(29, '09362073512', '1111', '2025-10-17', 0, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_admin_audit_log`
--
ALTER TABLE `tbl_admin_audit_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_time` (`event_time`),
  ADD KEY `idx_module_action` (`module`,`action`),
  ADD KEY `idx_entity` (`entity_type`,`entity_id`),
  ADD KEY `idx_admin` (`admin_id`);

--
-- Indexes for table `tbl_categories`
--
ALTER TABLE `tbl_categories`
  ADD PRIMARY KEY (`category_id`),
  ADD KEY `fk_event_id` (`event_id`);

--
-- Indexes for table `tbl_choices`
--
ALTER TABLE `tbl_choices`
  ADD PRIMARY KEY (`choice_id`),
  ADD KEY `fk_choices_event` (`event_id`),
  ADD KEY `fk_choices_type` (`establishment_type_id`);

--
-- Indexes for table `tbl_comm_messages`
--
ALTER TABLE `tbl_comm_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_event` (`event_id`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created` (`created_at`),
  ADD KEY `idx_sent` (`sent_at`),
  ADD KEY `idx_recipient` (`recipient_email`);

--
-- Indexes for table `tbl_config`
--
ALTER TABLE `tbl_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `config_key` (`config_key`);

--
-- Indexes for table `tbl_draft_choice`
--
ALTER TABLE `tbl_draft_choice`
  ADD PRIMARY KEY (`draft_choice_id`),
  ADD UNIQUE KEY `uniq_voter_question_choice` (`voters_id`,`question_id`),
  ADD KEY `voters_id` (`voters_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `choice_id` (`choice_id`);

--
-- Indexes for table `tbl_draft_freetext`
--
ALTER TABLE `tbl_draft_freetext`
  ADD PRIMARY KEY (`draft_freetext_id`),
  ADD UNIQUE KEY `uniq_voter_question_text` (`voters_id`,`question_id`),
  ADD KEY `voters_id` (`voters_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `tbl_establishment_types`
--
ALTER TABLE `tbl_establishment_types`
  ADD PRIMARY KEY (`type_id`),
  ADD UNIQUE KEY `uniq_type_name` (`type_name`);

--
-- Indexes for table `tbl_establishment_type_awards`
--
ALTER TABLE `tbl_establishment_type_awards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_type_question` (`type_id`,`question_id`),
  ADD KEY `ix_question_id` (`question_id`);

--
-- Indexes for table `tbl_events`
--
ALTER TABLE `tbl_events`
  ADD PRIMARY KEY (`event_id`);

--
-- Indexes for table `tbl_feedback`
--
ALTER TABLE `tbl_feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD KEY `fk_feedback_voters` (`voters_id`),
  ADD KEY `fk_feedback_nomination` (`nomination_id`),
  ADD KEY `fk_feedback_event` (`event_id`);

--
-- Indexes for table `tbl_nominations`
--
ALTER TABLE `tbl_nominations`
  ADD PRIMARY KEY (`nomination_id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `status` (`status`),
  ADD KEY `idx_nom_est_type` (`establishment_type_id`);

--
-- Indexes for table `tbl_nomination_answers`
--
ALTER TABLE `tbl_nomination_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nomination_id` (`nomination_id`),
  ADD KEY `field_id` (`field_id`),
  ADD KEY `idx_ans_nom` (`nomination_id`),
  ADD KEY `idx_ans_field` (`field_id`);

--
-- Indexes for table `tbl_nomination_audit`
--
ALTER TABLE `tbl_nomination_audit`
  ADD PRIMARY KEY (`audit_id`),
  ADD KEY `nomination_id` (`nomination_id`);

--
-- Indexes for table `tbl_nomination_fields`
--
ALTER TABLE `tbl_nomination_fields`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_name` (`name`);

--
-- Indexes for table `tbl_nomination_questions`
--
ALTER TABLE `tbl_nomination_questions`
  ADD PRIMARY KEY (`nomination_id`,`question_id`),
  ADD KEY `idx_nq_question` (`question_id`);

--
-- Indexes for table `tbl_nomination_question_audit`
--
ALTER TABLE `tbl_nomination_question_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indexes for table `tbl_nomination_texts`
--
ALTER TABLE `tbl_nomination_texts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_event_section` (`event_id`,`section`);

--
-- Indexes for table `tbl_poll_choice`
--
ALTER TABLE `tbl_poll_choice`
  ADD PRIMARY KEY (`poll_choice_id`),
  ADD KEY `voters_id` (`voters_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `choice_id` (`choice_id`);

--
-- Indexes for table `tbl_poll_freetext`
--
ALTER TABLE `tbl_poll_freetext`
  ADD PRIMARY KEY (`poll_freetext_id`),
  ADD KEY `voters_id` (`voters_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `tbl_questions`
--
ALTER TABLE `tbl_questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `fk_category_id` (`category_id`);

--
-- Indexes for table `tbl_question_choices`
--
ALTER TABLE `tbl_question_choices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_choice` (`choice_id`),
  ADD KEY `fk_question` (`question_id`);

--
-- Indexes for table `tbl_question_establishment_types`
--
ALTER TABLE `tbl_question_establishment_types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type_id` (`type_id`),
  ADD KEY `idx_question_id` (`question_id`);

--
-- Indexes for table `tbl_sms_reminders`
--
ALTER TABLE `tbl_sms_reminders`
  ADD PRIMARY KEY (`reminder_id`),
  ADD UNIQUE KEY `uq_event_voter_day` (`event_id`,`voters_id`,`send_day`),
  ADD KEY `idx_event_status_day` (`event_id`,`status`,`send_day`),
  ADD KEY `fk_smsrem_voter` (`voters_id`);

--
-- Indexes for table `tbl_voters`
--
ALTER TABLE `tbl_voters`
  ADD PRIMARY KEY (`voters_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_admin_audit_log`
--
ALTER TABLE `tbl_admin_audit_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=245;

--
-- AUTO_INCREMENT for table `tbl_categories`
--
ALTER TABLE `tbl_categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `tbl_choices`
--
ALTER TABLE `tbl_choices`
  MODIFY `choice_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123;

--
-- AUTO_INCREMENT for table `tbl_comm_messages`
--
ALTER TABLE `tbl_comm_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=122;

--
-- AUTO_INCREMENT for table `tbl_config`
--
ALTER TABLE `tbl_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=569;

--
-- AUTO_INCREMENT for table `tbl_draft_choice`
--
ALTER TABLE `tbl_draft_choice`
  MODIFY `draft_choice_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2723;

--
-- AUTO_INCREMENT for table `tbl_draft_freetext`
--
ALTER TABLE `tbl_draft_freetext`
  MODIFY `draft_freetext_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6149;

--
-- AUTO_INCREMENT for table `tbl_establishment_types`
--
ALTER TABLE `tbl_establishment_types`
  MODIFY `type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_establishment_type_awards`
--
ALTER TABLE `tbl_establishment_type_awards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tbl_events`
--
ALTER TABLE `tbl_events`
  MODIFY `event_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tbl_feedback`
--
ALTER TABLE `tbl_feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `tbl_nominations`
--
ALTER TABLE `tbl_nominations`
  MODIFY `nomination_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `tbl_nomination_answers`
--
ALTER TABLE `tbl_nomination_answers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=278;

--
-- AUTO_INCREMENT for table `tbl_nomination_audit`
--
ALTER TABLE `tbl_nomination_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=191;

--
-- AUTO_INCREMENT for table `tbl_nomination_fields`
--
ALTER TABLE `tbl_nomination_fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `tbl_nomination_question_audit`
--
ALTER TABLE `tbl_nomination_question_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tbl_nomination_texts`
--
ALTER TABLE `tbl_nomination_texts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `tbl_poll_choice`
--
ALTER TABLE `tbl_poll_choice`
  MODIFY `poll_choice_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=256;

--
-- AUTO_INCREMENT for table `tbl_poll_freetext`
--
ALTER TABLE `tbl_poll_freetext`
  MODIFY `poll_freetext_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=284;

--
-- AUTO_INCREMENT for table `tbl_questions`
--
ALTER TABLE `tbl_questions`
  MODIFY `question_id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `tbl_question_choices`
--
ALTER TABLE `tbl_question_choices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=486;

--
-- AUTO_INCREMENT for table `tbl_question_establishment_types`
--
ALTER TABLE `tbl_question_establishment_types`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_sms_reminders`
--
ALTER TABLE `tbl_sms_reminders`
  MODIFY `reminder_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_voters`
--
ALTER TABLE `tbl_voters`
  MODIFY `voters_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_categories`
--
ALTER TABLE `tbl_categories`
  ADD CONSTRAINT `fk_event_id` FOREIGN KEY (`event_id`) REFERENCES `tbl_events` (`event_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_choices`
--
ALTER TABLE `tbl_choices`
  ADD CONSTRAINT `fk_choices_event` FOREIGN KEY (`event_id`) REFERENCES `tbl_events` (`event_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_choices_type` FOREIGN KEY (`establishment_type_id`) REFERENCES `tbl_establishment_types` (`type_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `tbl_draft_choice`
--
ALTER TABLE `tbl_draft_choice`
  ADD CONSTRAINT `tbl_draft_choice_ibfk_1` FOREIGN KEY (`voters_id`) REFERENCES `tbl_voters` (`voters_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_draft_choice_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `tbl_questions` (`question_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_draft_choice_ibfk_3` FOREIGN KEY (`choice_id`) REFERENCES `tbl_choices` (`choice_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_draft_freetext`
--
ALTER TABLE `tbl_draft_freetext`
  ADD CONSTRAINT `tbl_draft_freetext_ibfk_1` FOREIGN KEY (`voters_id`) REFERENCES `tbl_voters` (`voters_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_draft_freetext_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `tbl_questions` (`question_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_establishment_type_awards`
--
ALTER TABLE `tbl_establishment_type_awards`
  ADD CONSTRAINT `fk_awards_question` FOREIGN KEY (`question_id`) REFERENCES `tbl_questions` (`question_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_awards_type` FOREIGN KEY (`type_id`) REFERENCES `tbl_establishment_types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_nomination_answers`
--
ALTER TABLE `tbl_nomination_answers`
  ADD CONSTRAINT `fk_nom_answers_field` FOREIGN KEY (`field_id`) REFERENCES `tbl_nomination_fields` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_nom_answers_nom` FOREIGN KEY (`nomination_id`) REFERENCES `tbl_nominations` (`nomination_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_nomination_questions`
--
ALTER TABLE `tbl_nomination_questions`
  ADD CONSTRAINT `fk_nq_nomination` FOREIGN KEY (`nomination_id`) REFERENCES `tbl_nominations` (`nomination_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_nq_question` FOREIGN KEY (`question_id`) REFERENCES `tbl_questions` (`question_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_poll_choice`
--
ALTER TABLE `tbl_poll_choice`
  ADD CONSTRAINT `tbl_poll_choice_ibfk_1` FOREIGN KEY (`voters_id`) REFERENCES `tbl_voters` (`voters_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_poll_choice_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `tbl_questions` (`question_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_poll_choice_ibfk_3` FOREIGN KEY (`choice_id`) REFERENCES `tbl_choices` (`choice_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_poll_freetext`
--
ALTER TABLE `tbl_poll_freetext`
  ADD CONSTRAINT `tbl_poll_freetext_ibfk_1` FOREIGN KEY (`voters_id`) REFERENCES `tbl_voters` (`voters_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_poll_freetext_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `tbl_questions` (`question_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_questions`
--
ALTER TABLE `tbl_questions`
  ADD CONSTRAINT `fk_category_id` FOREIGN KEY (`category_id`) REFERENCES `tbl_categories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbl_question_choices`
--
ALTER TABLE `tbl_question_choices`
  ADD CONSTRAINT `fk_choice` FOREIGN KEY (`choice_id`) REFERENCES `tbl_choices` (`choice_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_question` FOREIGN KEY (`question_id`) REFERENCES `tbl_questions` (`question_id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_sms_reminders`
--
ALTER TABLE `tbl_sms_reminders`
  ADD CONSTRAINT `fk_smsrem_event` FOREIGN KEY (`event_id`) REFERENCES `tbl_events` (`event_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_smsrem_voter` FOREIGN KEY (`voters_id`) REFERENCES `tbl_voters` (`voters_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
