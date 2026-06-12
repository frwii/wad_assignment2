-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 12, 2026 at 11:20 AM
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
-- Database: `emberplate_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `first_name` varchar(60) NOT NULL,
  `last_name` varchar(60) NOT NULL,
  `email` varchar(120) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `is_registered` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `first_name`, `last_name`, `email`, `phone`, `password_hash`, `is_registered`, `created_at`) VALUES
(1, 'Ahmad', 'Rizal', 'ahmad@email.com', '0123456789', '$2y$10$exampleHash1', 1, '2026-06-12 16:58:59'),
(2, 'Siti', 'Nurhaliza', 'siti@email.com', '0119876543', '$2y$10$exampleHash2', 1, '2026-06-12 16:58:59'),
(3, 'Raj', 'Kumar', 'raj@email.com', '0161112233', '$2y$10$exampleHash3', 1, '2026-06-12 16:58:59'),
(4, 'Wong', 'Li Ying', 'wly@email.com', '0194445566', NULL, 0, '2026-06-12 16:58:59'),
(5, 'Lim', 'Mei Ling', 'lml@email.com', '0177778899', NULL, 0, '2026-06-12 16:58:59');

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `item_id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `category` enum('starters','mains','grills','pasta','desserts','drinks') NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(8,2) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`item_id`, `name`, `category`, `description`, `price`, `is_available`, `created_at`) VALUES
(1, 'Burrata & Heirloom Tomato', 'starters', 'Creamy burrata, heirloom tomatoes, fresh basil oil, sea salt flakes.', 28.00, 1, '2026-06-12 16:58:59'),
(2, 'Crispy Calamari', 'starters', 'Lightly battered squid rings, lemon aioli, smoked paprika dust.', 24.00, 1, '2026-06-12 16:58:59'),
(3, 'Lobster Bisque', 'starters', 'Rich bisque with claw meat, cognac cream & chive oil.', 32.00, 1, '2026-06-12 16:58:59'),
(4, 'Herb Roasted Chicken', 'mains', 'Half free-range chicken, rosemary jus, garlic mash & greens.', 45.00, 1, '2026-06-12 16:58:59'),
(5, 'Pan-Seared Sea Bass', 'mains', 'Crispy skin sea bass, caper butter, wilted spinach & new potatoes.', 58.00, 1, '2026-06-12 16:58:59'),
(6, 'Ember Ribeye Steak', 'grills', '250g Black Angus ribeye, truffle butter, fries & seasonal greens.', 89.00, 1, '2026-06-12 16:58:59'),
(7, 'BBQ Lamb Rack', 'grills', '3-bone lamb rack, herb crust, red wine reduction, root vegetables.', 76.00, 1, '2026-06-12 16:58:59'),
(8, 'Saffron Prawn Linguine', 'pasta', 'Tiger prawns, saffron cream, cherry tomatoes, toasted breadcrumbs.', 48.00, 1, '2026-06-12 16:58:59'),
(9, 'Wild Mushroom Pappardelle', 'pasta', 'Forest mushrooms, truffle oil, parmesan cream.', 38.00, 0, '2026-06-12 16:58:59'),
(10, 'Salted Caramel Lava Cake', 'desserts', 'Dark chocolate cake, molten salted caramel, vanilla ice cream.', 24.00, 1, '2026-06-12 16:58:59'),
(11, 'Crème Brûlée', 'desserts', 'Classic vanilla custard, caramelised crust, fresh berries.', 19.00, 1, '2026-06-12 16:58:59'),
(12, 'Ember Signature Mocktail', 'drinks', 'Passion fruit, lychee, ginger beer, fresh mint & lime.', 16.00, 1, '2026-06-12 16:58:59');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `order_ref` varchar(20) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `order_type` enum('delivery','pickup','walkin') NOT NULL,
  `status` enum('pending','preparing','ready','completed','cancelled') NOT NULL DEFAULT 'pending',
  `delivery_address` text DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `delivery_time` varchar(30) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `special_notes` text DEFAULT NULL,
  `subtotal` decimal(8,2) NOT NULL DEFAULT 0.00,
  `delivery_fee` decimal(8,2) NOT NULL DEFAULT 0.00,
  `total` decimal(8,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `order_ref`, `customer_id`, `order_type`, `status`, `delivery_address`, `delivery_date`, `delivery_time`, `payment_method`, `special_notes`, `subtotal`, `delivery_fee`, `total`, `created_at`, `updated_at`) VALUES
(1, 'EP58231', 1, 'delivery', 'preparing', 'No 12, Jalan SS2/10, PJ', '2026-06-09', '7:00 PM – 8:00 PM', 'DuitNow QR', NULL, 137.00, 5.00, 142.00, '2026-06-12 16:58:59', '2026-06-12 16:58:59'),
(2, 'EP58230', 2, 'walkin', 'ready', NULL, NULL, NULL, 'Cash on Delivery', NULL, 90.00, 0.00, 90.00, '2026-06-12 16:58:59', '2026-06-12 16:58:59'),
(3, 'EP58229', 3, 'pickup', 'completed', NULL, '2026-06-09', '7:00 PM', 'Pay at Counter', NULL, 100.00, 0.00, 100.00, '2026-06-12 16:58:59', '2026-06-12 16:58:59'),
(4, 'EP58228', 4, 'delivery', 'pending', 'No 5, Jalan PJS 7/15, PJ', '2026-06-09', '8:00 PM – 9:00 PM', 'GrabPay', NULL, 86.00, 5.00, 91.00, '2026-06-12 16:58:59', '2026-06-12 16:58:59'),
(5, 'EP58227', 5, 'pickup', 'completed', NULL, '2026-06-09', '6:30 PM', 'Touch n Go', NULL, 73.00, 0.00, 73.00, '2026-06-12 16:58:59', '2026-06-12 16:58:59');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` decimal(8,2) NOT NULL,
  `line_total` decimal(8,2) GENERATED ALWAYS AS (`quantity` * `unit_price`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `item_id`, `quantity`, `unit_price`) VALUES
(1, 1, 6, 1, 89.00),
(2, 1, 8, 1, 48.00),
(3, 2, 3, 1, 32.00),
(4, 2, 5, 1, 58.00),
(5, 3, 2, 1, 24.00),
(6, 3, 7, 1, 76.00),
(7, 4, 9, 1, 38.00),
(8, 4, 10, 2, 24.00),
(9, 5, 1, 1, 28.00),
(10, 5, 4, 1, 45.00);

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `reservation_id` int(11) NOT NULL,
  `ref_code` varchar(20) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `first_name` varchar(60) NOT NULL,
  `last_name` varchar(60) NOT NULL,
  `email` varchar(120) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `res_date` date NOT NULL,
  `res_time` varchar(20) NOT NULL,
  `num_guests` int(11) NOT NULL,
  `occasion` varchar(60) DEFAULT NULL,
  `seating_pref` varchar(60) DEFAULT NULL,
  `special_requests` text DEFAULT NULL,
  `status` enum('pending','confirmed','cancelled','completed') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`reservation_id`, `ref_code`, `customer_id`, `first_name`, `last_name`, `email`, `phone`, `res_date`, `res_time`, `num_guests`, `occasion`, `seating_pref`, `special_requests`, `status`, `created_at`) VALUES
(1, 'EP-R74821', 1, 'Ahmad', 'Rizal', 'ahmad@email.com', '0123456789', '2026-06-09', '7:00 PM', 4, 'Anniversary', 'Indoor (Air-conditioned)', NULL, 'confirmed', '2026-06-12 16:58:59'),
(2, 'EP-R74820', 2, 'Priya', 'Sharma', 'priya@email.com', '0161234567', '2026-06-09', '7:30 PM', 2, 'Date Night', 'Outdoor (Al Fresco)', NULL, 'pending', '2026-06-12 16:58:59'),
(3, 'EP-R74819', 3, 'Tan', 'Chee Keong', 'tck@email.com', '0189998877', '2026-06-09', '8:00 PM', 8, 'Birthday', 'Private Dining Room', NULL, 'pending', '2026-06-12 16:58:59'),
(4, 'EP-R74818', 4, 'Nurul', 'Ain', 'nurul@email.com', '0146665544', '2026-06-09', '8:30 PM', 3, NULL, NULL, NULL, 'confirmed', '2026-06-12 16:58:59');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD UNIQUE KEY `order_ref` (`order_ref`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`reservation_id`),
  ADD UNIQUE KEY `ref_code` (`ref_code`),
  ADD KEY `customer_id` (`customer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `reservation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE SET NULL;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `menu_items` (`item_id`);

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
