-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 07, 2026 at 10:24 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `permata_kost`
--

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `title`, `content`, `created_by`, `created_at`, `updated_at`) VALUES
(4, 'Sedia Kamar', 'Sekarang kamar tersedia 4 kamar, Silahkan bisa di booking atau tanya tanya boleh.', 19, '2026-04-02 16:05:39', '2026-04-02 16:05:39');

-- --------------------------------------------------------

--
-- Table structure for table `announcement_images`
--

CREATE TABLE `announcement_images` (
  `id` int(11) NOT NULL,
  `announcement_id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `announcement_images`
--

INSERT INTO `announcement_images` (`id`, `announcement_id`, `image_path`) VALUES
(5, 4, 'announcement_69ce93d35ce48.jpeg');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `booking_date` datetime NOT NULL,
  `move_in_date` date NOT NULL,
  `duration` int(11) NOT NULL COMMENT 'Duration in months',
  `status` enum('pending','confirmed','cancelled','completed') NOT NULL DEFAULT 'pending',
  `payment_status` enum('unpaid','partially_paid','paid') NOT NULL DEFAULT 'unpaid',
  `total_amount` decimal(10,2) NOT NULL,
  `deposit_amount` decimal(10,2) NOT NULL,
  `special_requests` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `issue_date` date NOT NULL,
  `due_date` date NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `paid_amount` decimal(10,2) DEFAULT 0.00,
  `status` enum('unpaid','partially_paid','paid','overdue') NOT NULL DEFAULT 'unpaid',
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_date` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_requests`
--

CREATE TABLE `maintenance_requests` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `request_type` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `status` enum('pending','in_progress','completed','rejected') NOT NULL DEFAULT 'pending',
  `priority` enum('low','medium','high','urgent') NOT NULL DEFAULT 'medium',
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `completed_at` datetime DEFAULT NULL,
  `staff_notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `message`, `is_read`, `created_at`) VALUES
(27, 35, 19, 'Permisi mas', 1, '2026-04-05 14:43:42'),
(28, 19, 35, 'Iya mas gimana', 1, '2026-04-05 14:46:49'),
(29, 35, 19, 'Gapapa mas', 0, '2026-04-05 14:47:17');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT 'Notification',
  `message` text NOT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `scheduled_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `title`, `message`, `recipient_id`, `is_read`, `created_by`, `created_at`, `scheduled_at`) VALUES
(73, 'New Message', 'New message from Abid Faiz: halo kak saya ingin booking ru...', 19, 0, 20, '2026-04-02 16:04:32', NULL),
(74, 'New Message', 'New message from Aldi Nand: baik silahkan kak', 20, 0, 19, '2026-04-02 16:04:59', NULL),
(75, 'New Announcement', 'New announcement: Sedia Kamar', 20, 0, 19, '2026-04-02 16:05:39', NULL),
(76, 'Notification', 'Abid Faiz has booked room Room 1 - Kamar Besar (Water Heater) (Room #14)', 19, 0, 20, '2026-04-04 15:35:01', NULL),
(77, 'Notification', 'New payment: Abid Faiz has made a payment of IDR 1.500.000', 1, 0, 20, '2026-04-04 15:39:52', NULL),
(78, 'Notification', 'Your payment of IDR 1.500.000 has been successfully processed and marked as paid.', 20, 0, 1, '2026-04-04 15:39:52', NULL),
(79, 'Notification', 'Abid Faiz has booked room Room 1 - Kamar Besar (Water Heater) (Room #14)', 19, 0, 21, '2026-04-04 15:41:33', NULL),
(80, 'Notification', 'abid faiz has booked room Room 1 - Kamar Besar (Water Heater) (Room #14)', 19, 0, 22, '2026-04-04 15:42:28', NULL),
(81, 'Notification', 'abid faiz has booked room Room 6 - Kamar Kecil (Water Heater) (Room #19)', 19, 0, 23, '2026-04-04 15:43:39', NULL),
(85, 'Notification', 'New payment: aa aa has made a payment of IDR 1.500.000', 1, 0, 30, '2026-04-04 16:11:34', NULL),
(86, 'Notification', 'Your payment of IDR 1.500.000 has been successfully processed and marked as paid.', 30, 0, 1, '2026-04-04 16:11:34', NULL),
(87, 'Notification', 'New payment: aa aa has made a payment of IDR 1.500.000', 1, 0, 30, '2026-04-04 16:13:27', NULL),
(88, 'Notification', 'Your payment of IDR 1.500.000 has been successfully processed and marked as paid.', 30, 0, 1, '2026-04-04 16:13:27', NULL),
(89, 'Notification', 'New payment: AbiD Faiz has made a payment of IDR 1.500.000', 1, 0, 31, '2026-04-05 06:14:26', NULL),
(90, 'Notification', 'Your payment of IDR 1.500.000 has been successfully processed and marked as paid.', 31, 0, 1, '2026-04-05 06:14:26', NULL),
(91, 'New Message', 'New message from AbiD Faiz: p', 19, 0, 31, '2026-04-05 06:14:41', NULL),
(92, 'New Message', 'New message from AbiD Faiz: hi', 19, 0, 31, '2026-04-05 06:14:43', NULL),
(93, 'New Message', 'New message from AbiD Faiz: woi mas', 19, 0, 31, '2026-04-05 06:14:52', NULL),
(94, 'Notification', 'New payment: abid faiz has made a payment of IDR 1.500.000', 1, 0, 32, '2026-04-05 06:21:07', NULL),
(95, 'Notification', 'Your payment of IDR 1.500.000 has been successfully processed and marked as paid.', 32, 0, 1, '2026-04-05 06:21:07', NULL),
(96, 'Notification', 'New payment: abdi faiz has made a payment of IDR 1.500.000', 1, 0, 33, '2026-04-05 12:25:50', NULL),
(97, 'Notification', 'Your payment of IDR 1.500.000 has been successfully processed and marked as paid.', 33, 0, 1, '2026-04-05 12:25:50', NULL),
(98, 'New Message', 'New message from Abid Faiz: Permisi mas', 19, 0, 35, '2026-04-05 14:43:42', NULL),
(99, 'New Message', 'New message from Aldi Nand: Iya mas gimana', 35, 0, 19, '2026-04-05 14:46:49', NULL),
(100, 'New Message', 'New message from Abid Faiz: Gapapa mas', 19, 0, 35, '2026-04-05 14:47:17', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` datetime NOT NULL,
  `payment_method` enum('cash','transfer','qris','midtrans') NOT NULL,
  `status` enum('paid','unpaid','pending') NOT NULL DEFAULT 'unpaid',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `order_id` varchar(100) DEFAULT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `payment_type` varchar(50) DEFAULT NULL,
  `transaction_time` datetime DEFAULT NULL,
  `transaction_status` varchar(50) DEFAULT NULL,
  `payment_link` text DEFAULT NULL,
  `midtrans_token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `tenant_id`, `amount`, `payment_date`, `payment_method`, `status`, `created_at`, `order_id`, `transaction_id`, `payment_type`, `transaction_time`, `transaction_status`, `payment_link`, `midtrans_token`) VALUES
(75, 32, 1500000.00, '0000-00-00 00:00:00', 'cash', 'unpaid', '2026-04-05 14:44:38', 'ORDER-1775400278', NULL, NULL, NULL, NULL, NULL, '6661ef7a-7c1f-46c9-84c1-f12aea963199');

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `status` enum('available','occupied') NOT NULL DEFAULT 'available',
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`id`, `name`, `price`, `status`, `description`, `created_at`, `updated_at`) VALUES
(14, 'Room 1 - Kamar Besar (Water Heater)', 1500000.00, 'occupied', 'Kamar Besar dengan fasilitas Water Heater di WC dalam', '2026-04-02 15:32:35', '2026-04-05 14:44:38'),
(15, 'Room 2 - Kamar Besar (Water Heater)', 1500000.00, 'occupied', 'Kamar Besar dengan fasilitas Water Heater di WC dalam', '2026-04-02 15:32:39', '2026-04-02 15:55:17'),
(16, 'Room 3 - Kamar Besar (Water Heater)', 1500000.00, 'occupied', 'Kamar Besar dengan fasilitas Water Heater di WC dalam', '2026-04-02 15:32:43', '2026-04-02 15:55:34'),
(17, 'Room 4 - Kamar Besar (Water Heater)', 1500000.00, 'occupied', 'Kamar Besar dengan fasilitas Water Heater di WC dalam', '2026-04-02 15:33:37', '2026-04-02 15:55:42'),
(18, 'Room 5 - Kamar Besar (Water Heater)', 1500000.00, 'occupied', 'Kamar Besar dengan fasilitas Water Heater di WC dalam', '2026-04-02 15:33:41', '2026-04-02 15:55:53'),
(19, 'Room 6 - Kamar Kecil (Water Heater)', 1350000.00, 'available', 'Kamar Kecil dengan fasilitas Water Heater di WC dalam', '2026-04-02 15:33:45', '2026-04-04 15:44:10'),
(20, 'Room 7 - Kamar Kecil (Water Heater)', 1350000.00, 'occupied', 'Kamar Kecil dengan fasilitas Water Heater di WC dalam', '2026-04-02 15:33:52', '2026-04-02 15:57:13'),
(21, 'Room 8 - Kamar Kecil (Water Heater)', 1350000.00, 'occupied', 'Kamar Kecil dengan fasilitas Water Heater di WC dalam', '2026-04-02 15:33:57', '2026-04-02 15:57:23'),
(22, 'Room 9 - Kamar Kecil (Water Heater)', 1350000.00, 'occupied', 'Kamar Kecil dengan fasilitas Water Heater di WC dalam', '2026-04-02 15:34:02', '2026-04-02 15:57:35'),
(23, 'Room 10 - Kamar Kecil (Water Heater)', 1350000.00, 'occupied', 'Kamar Kecil dengan fasilitas Water Heater di WC dalam', '2026-04-02 15:34:06', '2026-04-02 15:57:48'),
(24, 'Room 11 - Kamar Kecil (Non Water Heater)', 1250000.00, 'available', 'Kamar Kecil tanpa fasilitas Water Heater', '2026-04-02 15:34:13', '2026-04-02 15:58:27'),
(25, 'Room 12 - Kamar Kecil (Non Water Heater)', 1250000.00, 'occupied', 'Kamar Kecil tanpa fasilitas Water Heater', '2026-04-02 15:34:17', '2026-04-02 15:58:40'),
(26, 'Room 13 - Kamar Kecil (Non Water Heater)', 1250000.00, 'occupied', 'Kamar Kecil tanpa fasilitas Water Heater', '2026-04-02 15:34:26', '2026-04-02 15:58:58'),
(27, 'Room 14 - Kamar Kecil (Non Water Heater)', 1250000.00, 'available', 'Kamar Kecil tanpa fasilitas Water Heater', '2026-04-02 15:34:40', '2026-04-02 15:59:12'),
(28, 'Room 15 - Kamar Kecil (Non Water Heater)', 1250000.00, 'occupied', 'Kamar Kecil tanpa fasilitas Water Heater', '2026-04-02 15:34:44', '2026-04-02 15:59:21'),
(29, 'Room 16 - Kamar Kecil (Non Water Heater)', 1250000.00, 'occupied', 'Kamar Kecil tanpa fasilitas Water Heater', '2026-04-02 15:34:49', '2026-04-02 15:59:30');

-- --------------------------------------------------------

--
-- Table structure for table `room_change_logs`
--

CREATE TABLE `room_change_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `old_room_id` int(11) DEFAULT NULL,
  `new_room_id` int(11) NOT NULL,
  `change_reason` text DEFAULT NULL,
  `change_date` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_features`
--

CREATE TABLE `room_features` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `feature_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_images`
--

CREATE TABLE `room_images` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room_images`
--

INSERT INTO `room_images` (`id`, `room_id`, `image_path`, `is_primary`, `created_at`) VALUES
(18, 14, 'room_14_69ce8e0eadfae.jpeg', 1, '2026-04-02 15:41:02'),
(19, 15, 'room_15_69ce8e15a0dc3.jpeg', 1, '2026-04-02 15:41:09'),
(20, 16, 'room_16_69ce8e1c31982.jpeg', 1, '2026-04-02 15:41:16'),
(21, 17, 'room_17_69ce8e2340b1e.jpeg', 1, '2026-04-02 15:41:23'),
(22, 18, 'room_18_69ce8e2b414c4.jpeg', 1, '2026-04-02 15:41:31'),
(23, 19, 'room_19_69ce8e7e4b3db.jpeg', 1, '2026-04-02 15:42:54'),
(24, 20, 'room_20_69ce8e85d3c50.jpeg', 1, '2026-04-02 15:43:01'),
(25, 21, 'room_21_69ce8e9d82200.jpeg', 1, '2026-04-02 15:43:25'),
(26, 22, 'room_22_69ce8ea4e5225.jpeg', 1, '2026-04-02 15:43:32'),
(27, 23, 'room_23_69ce8eb3c2483.jpeg', 1, '2026-04-02 15:43:47'),
(28, 24, 'room_24_69ce8fabc1a1c.jpeg', 1, '2026-04-02 15:47:55'),
(29, 25, 'room_25_69ce8fb8d6c66.jpeg', 1, '2026-04-02 15:48:08'),
(30, 26, 'room_26_69ce8fbfcdf3e.jpeg', 1, '2026-04-02 15:48:15'),
(31, 27, 'room_27_69ce8fc6c8d5b.jpeg', 1, '2026-04-02 15:48:22'),
(32, 28, 'room_28_69ce8fcbaca04.jpeg', 1, '2026-04-02 15:48:27'),
(33, 29, 'room_29_69ce8fd0e65fd.jpeg', 1, '2026-04-02 15:48:32'),
(34, 14, 'room_14_69ce9158b5e55.jpeg', 0, '2026-04-02 15:55:04'),
(35, 15, 'room_15_69ce91650e7df.jpeg', 0, '2026-04-02 15:55:17'),
(36, 16, 'room_16_69ce916f8a85a.jpeg', 0, '2026-04-02 15:55:27'),
(37, 17, 'room_17_69ce917ec94ab.jpeg', 0, '2026-04-02 15:55:42'),
(38, 18, 'room_18_69ce9189077a3.jpeg', 0, '2026-04-02 15:55:53'),
(39, 19, 'room_19_69ce91ca204be.jpeg', 0, '2026-04-02 15:56:58'),
(40, 20, 'room_20_69ce91d948157.jpeg', 0, '2026-04-02 15:57:13'),
(41, 21, 'room_21_69ce91e367474.jpeg', 0, '2026-04-02 15:57:23'),
(42, 22, 'room_22_69ce91ef5c304.jpeg', 0, '2026-04-02 15:57:35'),
(43, 23, 'room_23_69ce91fc69e4e.jpeg', 0, '2026-04-02 15:57:48'),
(44, 24, 'room_24_69ce9223a00c0.jpeg', 0, '2026-04-02 15:58:27'),
(45, 25, 'room_25_69ce9230edf2d.jpeg', 0, '2026-04-02 15:58:40'),
(46, 26, 'room_26_69ce92427446a.jpeg', 0, '2026-04-02 15:58:58'),
(47, 27, 'room_27_69ce924af0e2d.jpeg', 0, '2026-04-02 15:59:06'),
(48, 28, 'room_28_69ce9259c48dc.jpeg', 0, '2026-04-02 15:59:21'),
(49, 29, 'room_29_69ce92624e6d5.jpeg', 0, '2026-04-02 15:59:30');

-- --------------------------------------------------------

--
-- Table structure for table `tenants`
--

CREATE TABLE `tenants` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tenants`
--

INSERT INTO `tenants` (`id`, `user_id`, `room_id`, `start_date`, `end_date`, `status`) VALUES
(15, 20, 14, '2026-04-04', NULL, 'active'),
(16, 21, 14, '2026-04-04', NULL, 'active'),
(17, 22, 14, '2026-04-04', NULL, 'active'),
(18, 23, 19, '2026-04-04', NULL, 'active'),
(22, 24, 14, '2026-04-04', NULL, 'active'),
(23, 25, 14, '2026-04-04', NULL, 'active'),
(24, 26, 14, '2026-04-04', NULL, 'active'),
(25, 27, 14, '2026-04-04', NULL, 'active'),
(26, 28, 14, '2026-04-04', NULL, 'active'),
(27, 29, 14, '2026-04-04', NULL, 'active'),
(28, 30, 14, '2026-04-04', NULL, 'active'),
(29, 31, 14, '2026-04-05', NULL, 'active'),
(30, 32, 14, '2026-04-05', NULL, 'active'),
(31, 33, 14, '2026-04-05', NULL, 'active'),
(32, 35, 14, '2026-04-05', NULL, 'active');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `bio` text DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','tenant') NOT NULL DEFAULT 'tenant',
  `profile_image` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `room_id` int(11) DEFAULT NULL,
  `profile_photo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `bio`, `password`, `role`, `profile_image`, `dob`, `gender`, `street`, `city`, `postal_code`, `state`, `country`, `created_at`, `room_id`, `profile_photo`) VALUES
(19, 'Aldi', 'Nand', 'aldinandsantoso@gmail.com', '081226110079', NULL, '$2y$10$1YzH6I3QDoUM5S0.U1EeE.IPdUZwA.X5yQ0o5EdN6zSIbshkYzaLe', 'admin', 'profile_19_1775081434.jpg', NULL, NULL, '', '', '', '', '', '2026-03-31 11:20:04', NULL, NULL),
(35, 'Abid', 'Faiz', 'zhidqiabidfaiz@gmail.com', '081226110078', NULL, '$2y$10$SZ.K8Jb53AslR3Rx6SUjIehlDTJCDMoJSZNLcwETkB0mLhY3UpZ5y', 'tenant', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-05 14:41:38', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `announcement_images`
--
ALTER TABLE `announcement_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `announcement_id` (`announcement_id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tenant_id` (`tenant_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_id` (`invoice_id`);

--
-- Indexes for table `maintenance_requests`
--
ALTER TABLE `maintenance_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tenant_id` (`tenant_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `recipient_id` (`recipient_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tenant_id` (`tenant_id`),
  ADD KEY `idx_payments_order_id` (`order_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `room_change_logs`
--
ALTER TABLE `room_change_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `old_room_id` (`old_room_id`),
  ADD KEY `new_room_id` (`new_room_id`);

--
-- Indexes for table `room_features`
--
ALTER TABLE `room_features`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `room_images`
--
ALTER TABLE `room_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `tenants`
--
ALTER TABLE `tenants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `announcement_images`
--
ALTER TABLE `announcement_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `maintenance_requests`
--
ALTER TABLE `maintenance_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `room_change_logs`
--
ALTER TABLE `room_change_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `room_features`
--
ALTER TABLE `room_features`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `room_images`
--
ALTER TABLE `room_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `tenants`
--
ALTER TABLE `tenants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `announcement_images`
--
ALTER TABLE `announcement_images`
  ADD CONSTRAINT `announcement_images_ibfk_1` FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
