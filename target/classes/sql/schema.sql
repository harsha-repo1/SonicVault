 

CREATE DATABASE IF NOT EXISTS sonic;
USE sonic;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
);

CREATE TABLE IF NOT EXISTS `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `price` double NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `image_path` varchar(500) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

 

CREATE TABLE IF NOT EXISTS `orders` (
    `id` int AUTO_INCREMENT PRIMARY KEY,
    `user_id` int,
    `total_price` DECIMAL(10, 2),
    `order_status` VARCHAR(20) DEFAULT 'PENDING',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
);

CREATE TABLE IF NOT EXISTS `order_items` (
    `id` int AUTO_INCREMENT PRIMARY KEY,
    `order_id` int,
    `product_id` int,
    `quantity` INT,
    `price` DECIMAL(10, 2),
    FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`),
    FOREIGN KEY (`product_id`) REFERENCES `product`(`id`)
);
 
 
INSERT IGNORE INTO `users` (`username`, `password`, `role`, `email`, `phone_number`)
VALUES
('admin', 'admin123', 'ADMIN', 'admin@sonicvault.com', '9999999999'),
('user', 'user123', 'USER', 'user@sonicvault.com', '8888888888');

 
INSERT IGNORE INTO `product` (`id`, `name`, `price`, `description`, `image_path`, `category`) VALUES
(1, 'AeroFit Wireless Headphones', 249.99, 'Over-ear ANC headphones with 40-hour battery life and studio-tuned drivers.', 'https://picsum.photos/seed/sonicvault-headphone1/600/450', 'Headphones'),
(2, 'Nimbus Studio Headphones', 189.99, 'Open-back reference headphones built for critical listening and mixing.', 'https://picsum.photos/seed/sonicvault-headphone2/600/450', 'Headphones'),
(3, 'Pulse True Wireless Earbuds', 129.99, 'Compact ANC earbuds with adaptive EQ and IPX5 sweat resistance.', 'https://picsum.photos/seed/sonicvault-earbuds1/600/450', 'Earbuds'),
(4, 'Ember Sport Earbuds', 89.99, 'Secure-fit workout earbuds with 8-hour battery and quick charge.', 'https://picsum.photos/seed/sonicvault-earbuds2/600/450', 'Earbuds'),
(5, 'Vortex Bluetooth Speaker', 159.99, '360-degree portable speaker with deep bass and 20-hour playtime.', 'https://picsum.photos/seed/sonicvault-speaker1/600/450', 'Speakers'),
(6, 'Summit Bookshelf Speakers (Pair)', 349.99, 'Powered bookshelf speakers with built-in DAC and optical input.', 'https://picsum.photos/seed/sonicvault-speaker2/600/450', 'Speakers'),
(7, 'Halo DAC/Amp', 99.99, 'Portable USB-C DAC and headphone amplifier for hi-res audio on the go.', 'https://picsum.photos/seed/sonicvault-accessory1/600/450', 'Accessories'),
(8, 'Coil Braided Audio Cable', 19.99, 'Tangle-free braided 3.5mm cable with gold-plated connectors.', 'https://picsum.photos/seed/sonicvault-accessory2/600/450', 'Accessories');

 
 
-- UPDATE `product` SET `category` = 'Headphones' WHERE `id` IN (1, 2);
-- UPDATE `product` SET `category` = 'Earbuds'     WHERE `id` IN (3, 4);
-- UPDATE `product` SET `category` = 'Speakers'    WHERE `id` IN (5, 6);
--UPDATE `product` SET `category` = 'Accessories' WHERE `id` IN (7, 8);
