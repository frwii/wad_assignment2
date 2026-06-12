-- ============================================================
--  Ember & Plate — Restaurant Order Management System
--  Database: emberplate_db
--  MySQL / MariaDB compatible
--  Run this file in phpMyAdmin or MySQL CLI:
--    mysql -u root -p < database.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS emberplate_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE emberplate_db;

-- ============================================================
-- TABLE 1: customers
--   Stores both walk-in and registered online customers.
-- ============================================================
CREATE TABLE IF NOT EXISTS customers (
  customer_id   INT          NOT NULL AUTO_INCREMENT,
  first_name    VARCHAR(60)  NOT NULL,
  last_name     VARCHAR(60)  NOT NULL,
  email         VARCHAR(120) NOT NULL UNIQUE,
  phone         VARCHAR(20)  DEFAULT NULL,
  password_hash VARCHAR(255) DEFAULT NULL,          -- NULL for guest/walk-in
  is_registered TINYINT(1)   NOT NULL DEFAULT 0,    -- 0 = guest, 1 = registered
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (customer_id)
) ENGINE=InnoDB;

-- Sample data
INSERT INTO customers (first_name, last_name, email, phone, password_hash, is_registered) VALUES
  ('Ahmad',  'Rizal',    'ahmad@email.com', '0123456789', '$2y$10$exampleHash1', 1),
  ('Siti',   'Nurhaliza','siti@email.com',  '0119876543', '$2y$10$exampleHash2', 1),
  ('Raj',    'Kumar',    'raj@email.com',   '0161112233', '$2y$10$exampleHash3', 1),
  ('Wong',   'Li Ying',  'wly@email.com',   '0194445566', NULL,                 0),
  ('Lim',    'Mei Ling', 'lml@email.com',   '0177778899', NULL,                 0);


-- ============================================================
-- TABLE 2: menu_items
--   The restaurant's full menu catalogue.
-- ============================================================
CREATE TABLE IF NOT EXISTS menu_items (
  item_id     INT            NOT NULL AUTO_INCREMENT,
  name        VARCHAR(120)   NOT NULL,
  category    ENUM('starters','mains','grills','pasta','desserts','drinks') NOT NULL,
  description TEXT           DEFAULT NULL,
  price       DECIMAL(8,2)   NOT NULL,
  is_available TINYINT(1)    NOT NULL DEFAULT 1,
  created_at  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (item_id)
) ENGINE=InnoDB;

-- Sample data
INSERT INTO menu_items (name, category, description, price, is_available) VALUES
  ('Burrata & Heirloom Tomato', 'starters', 'Creamy burrata, heirloom tomatoes, fresh basil oil, sea salt flakes.', 28.00, 1),
  ('Crispy Calamari',           'starters', 'Lightly battered squid rings, lemon aioli, smoked paprika dust.',      24.00, 1),
  ('Lobster Bisque',            'starters', 'Rich bisque with claw meat, cognac cream & chive oil.',                32.00, 1),
  ('Herb Roasted Chicken',      'mains',    'Half free-range chicken, rosemary jus, garlic mash & greens.',         45.00, 1),
  ('Pan-Seared Sea Bass',       'mains',    'Crispy skin sea bass, caper butter, wilted spinach & new potatoes.',   58.00, 1),
  ('Ember Ribeye Steak',        'grills',   '250g Black Angus ribeye, truffle butter, fries & seasonal greens.',    89.00, 1),
  ('BBQ Lamb Rack',             'grills',   '3-bone lamb rack, herb crust, red wine reduction, root vegetables.',   76.00, 1),
  ('Saffron Prawn Linguine',    'pasta',    'Tiger prawns, saffron cream, cherry tomatoes, toasted breadcrumbs.',   48.00, 1),
  ('Wild Mushroom Pappardelle', 'pasta',    'Forest mushrooms, truffle oil, parmesan cream.',                       38.00, 0),
  ('Salted Caramel Lava Cake',  'desserts', 'Dark chocolate cake, molten salted caramel, vanilla ice cream.',       24.00, 1),
  ('Crème Brûlée',              'desserts', 'Classic vanilla custard, caramelised crust, fresh berries.',           19.00, 1),
  ('Ember Signature Mocktail',  'drinks',   'Passion fruit, lychee, ginger beer, fresh mint & lime.',               16.00, 1);


-- ============================================================
-- TABLE 3: orders
--   One row per order (delivery, pickup, or walk-in).
-- ============================================================
CREATE TABLE IF NOT EXISTS orders (
  order_id     INT          NOT NULL AUTO_INCREMENT,
  order_ref    VARCHAR(20)  NOT NULL UNIQUE,           -- e.g. EP58231
  customer_id  INT          DEFAULT NULL,              -- NULL for guest
  order_type   ENUM('delivery','pickup','walkin') NOT NULL,
  status       ENUM('pending','preparing','ready','completed','cancelled') NOT NULL DEFAULT 'pending',
  delivery_address TEXT     DEFAULT NULL,              -- delivery only
  delivery_date    DATE     DEFAULT NULL,
  delivery_time    VARCHAR(30) DEFAULT NULL,
  payment_method   VARCHAR(50) DEFAULT NULL,
  special_notes    TEXT     DEFAULT NULL,
  subtotal     DECIMAL(8,2) NOT NULL DEFAULT 0.00,
  delivery_fee DECIMAL(8,2) NOT NULL DEFAULT 0.00,
  total        DECIMAL(8,2) NOT NULL DEFAULT 0.00,
  created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Sample data
INSERT INTO orders (order_ref, customer_id, order_type, status, delivery_address, delivery_date, delivery_time, payment_method, subtotal, delivery_fee, total) VALUES
  ('EP58231', 1, 'delivery', 'preparing', 'No 12, Jalan SS2/10, PJ', '2026-06-09', '7:00 PM – 8:00 PM', 'DuitNow QR',        137.00, 5.00, 142.00),
  ('EP58230', 2, 'walkin',   'ready',     NULL,                       NULL,         NULL,                  'Cash on Delivery',  90.00,  0.00,  90.00),
  ('EP58229', 3, 'pickup',   'completed', NULL,                       '2026-06-09', '7:00 PM',             'Pay at Counter',   100.00,  0.00, 100.00),
  ('EP58228', 4, 'delivery', 'pending',   'No 5, Jalan PJS 7/15, PJ','2026-06-09', '8:00 PM – 9:00 PM',  'GrabPay',           86.00,  5.00,  91.00),
  ('EP58227', 5, 'pickup',   'completed', NULL,                       '2026-06-09', '6:30 PM',             'Touch n Go',        73.00,  0.00,  73.00);


-- ============================================================
-- TABLE 4: order_items
--   Line items linking orders to menu items.
-- ============================================================
CREATE TABLE IF NOT EXISTS order_items (
  order_item_id INT            NOT NULL AUTO_INCREMENT,
  order_id      INT            NOT NULL,
  item_id       INT            NOT NULL,
  quantity      INT            NOT NULL DEFAULT 1,
  unit_price    DECIMAL(8,2)   NOT NULL,
  line_total    DECIMAL(8,2)   GENERATED ALWAYS AS (quantity * unit_price) STORED,
  PRIMARY KEY (order_item_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)    ON DELETE CASCADE,
  FOREIGN KEY (item_id)  REFERENCES menu_items(item_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Sample data (matching orders above)
INSERT INTO order_items (order_id, item_id, quantity, unit_price) VALUES
  (1, 6, 1, 89.00),  -- Ribeye
  (1, 8, 1, 48.00),  -- Linguine
  (2, 3, 1, 32.00),  -- Lobster Bisque
  (2, 5, 1, 58.00),  -- Sea Bass
  (3, 2, 1, 24.00),  -- Calamari
  (3, 7, 1, 76.00),  -- Lamb Rack
  (4, 9, 1, 38.00),  -- Pappardelle
  (4, 10,2, 24.00),  -- Lava Cake x2
  (5, 1, 1, 28.00),  -- Burrata
  (5, 4, 1, 45.00);  -- Herb Chicken


-- ============================================================
-- TABLE 5: reservations
--   Table bookings for walk-in and advance reservations.
-- ============================================================
CREATE TABLE IF NOT EXISTS reservations (
  reservation_id INT         NOT NULL AUTO_INCREMENT,
  ref_code       VARCHAR(20) NOT NULL UNIQUE,         -- e.g. EP-R74821
  customer_id    INT         DEFAULT NULL,
  first_name     VARCHAR(60) NOT NULL,
  last_name      VARCHAR(60) NOT NULL,
  email          VARCHAR(120)NOT NULL,
  phone          VARCHAR(20) NOT NULL,
  res_date       DATE        NOT NULL,
  res_time       VARCHAR(20) NOT NULL,
  num_guests     INT         NOT NULL,
  occasion       VARCHAR(60) DEFAULT NULL,
  seating_pref   VARCHAR(60) DEFAULT NULL,
  special_requests TEXT      DEFAULT NULL,
  status         ENUM('pending','confirmed','cancelled','completed') NOT NULL DEFAULT 'pending',
  created_at     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (reservation_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Sample data
INSERT INTO reservations (ref_code, customer_id, first_name, last_name, email, phone, res_date, res_time, num_guests, occasion, seating_pref, status) VALUES
  ('EP-R74821', 1, 'Ahmad',  'Rizal',     'ahmad@email.com', '0123456789', '2026-06-09', '7:00 PM', 4, 'Anniversary', 'Indoor (Air-conditioned)', 'confirmed'),
  ('EP-R74820', 2, 'Priya',  'Sharma',    'priya@email.com', '0161234567', '2026-06-09', '7:30 PM', 2, 'Date Night',  'Outdoor (Al Fresco)',      'pending'),
  ('EP-R74819', 3, 'Tan',    'Chee Keong','tck@email.com',   '0189998877', '2026-06-09', '8:00 PM', 8, 'Birthday',   'Private Dining Room',      'pending'),
  ('EP-R74818', 4, 'Nurul',  'Ain',       'nurul@email.com', '0146665544', '2026-06-09', '8:30 PM', 3, NULL,          NULL,                        'confirmed');


-- ============================================================
-- Useful Views (optional, for reporting)
-- ============================================================

-- View: Order summary with customer name
CREATE OR REPLACE VIEW vw_orders AS
SELECT
  o.order_ref,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  c.phone,
  o.order_type,
  o.status,
  o.total,
  o.created_at
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id;

-- View: Daily revenue
CREATE OR REPLACE VIEW vw_daily_revenue AS
SELECT
  DATE(created_at) AS order_date,
  COUNT(*)          AS total_orders,
  SUM(total)        AS revenue
FROM orders
WHERE status NOT IN ('cancelled')
GROUP BY DATE(created_at)
ORDER BY order_date DESC;

-- ============================================================
-- Admin user (for login.html — admin@emberplate.com / Admin123!)
-- password_hash is bcrypt of 'Admin123!'
-- ============================================================
CREATE TABLE IF NOT EXISTS admins (
  admin_id      INT          NOT NULL AUTO_INCREMENT,
  name          VARCHAR(100) NOT NULL,
  email         VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (admin_id)
) ENGINE=InnoDB;

INSERT INTO admins (name, email, password_hash) VALUES
  ('Admin', 'admin@emberplate.com', '$2y$10$exampleAdminHashHere');
