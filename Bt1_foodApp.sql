CREATE DATABASE food_app;
USE food_app;

CREATE TABLE user (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(100),
  email VARCHAR(100),
  password VARCHAR(100)
);

CREATE TABLE food_type (
  type_id INT PRIMARY KEY AUTO_INCREMENT,
  type_name VARCHAR(100)
);

CREATE TABLE food (
  food_id INT PRIMARY KEY AUTO_INCREMENT,
  food_name VARCHAR(100),
  image VARCHAR(255),
  price FLOAT,
  `desc` VARCHAR(255),
  type_id INT,
  FOREIGN KEY (type_id) REFERENCES food_type(type_id)
);

CREATE TABLE sub_food (
  sub_id INT PRIMARY KEY AUTO_INCREMENT,
  sub_name VARCHAR(100),
  sub_price FLOAT,
  food_id INT,
  FOREIGN KEY (food_id) REFERENCES food(food_id)
);

CREATE TABLE restaurant (
  res_id INT PRIMARY KEY AUTO_INCREMENT,
  res_name VARCHAR(100),
  image VARCHAR(255),
  `desc` VARCHAR(255)
);

CREATE TABLE `order` (
  user_id INT,
  food_id INT,
  amount INT,
  code VARCHAR(100),
  arr_sub_id VARCHAR(255),
  PRIMARY KEY (user_id, food_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id),
  FOREIGN KEY (food_id) REFERENCES food(food_id)
);

CREATE TABLE like_res (
  user_id INT,
  res_id INT,
  date_like DATETIME,
  PRIMARY KEY (user_id, res_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id),
  FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

CREATE TABLE rate_res (
  user_id INT,
  res_id INT,
  amount INT,
  date_rate DATETIME,
  PRIMARY KEY (user_id, res_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id),
  FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

INSERT INTO user (full_name, email, password) VALUES
('Nguyen Van A', 'a@gmail.com', '123456'),
('Tran Thi B', 'b@gmail.com', '123456'),
('Nguyen Van C', 'c@gmail.com', '123456'),
('Tran Thi D', 'd@gmail.com', '123456'),
('Nguyen Van E', 'e@gmail.com', '123456'),
('Tran Thi F', 'f@gmail.com', '123456')


INSERT INTO food_type (type_name) VALUES
('Đồ uống'), ('Đồ ăn nhanh');

INSERT INTO food (food_name, image, price, `desc`, type_id) VALUES
('Gà rán giòn', 'ga_ran.jpg', 50000, 'Gà rán giòn rụm', 2),
('Khoai tây chiên', 'khoai_tay.jpg', 30000, 'Khoai tây chiên vàng ươm', 2),
('Trà sữa', 'tra_sua.jpg', 50000, 'Trà sữa béo ngon', 1),
('Rau má', 'rau_ma.jpg', 30000, 'Rau má mát lạnh', 1)


INSERT INTO sub_food (sub_name, sub_price, food_id) VALUES
('Thêm phô mai', 20000, 17),
('Thêm tương ớt', 10000, 18),
('Thêm trân châu', 20000, 19),
('Thêm sữa', 10000, 20);

INSERT INTO restaurant (res_name, image, `desc`) VALUES
('Lotteria', 'lotteria.jpg', 'Chuỗi đồ ăn nhanh'),
('Highlands Coffee', 'highlands.jpg', 'Chuỗi cà phê nổi tiếng');

INSERT INTO `order` (user_id, food_id, amount, code, arr_sub_id) VALUES
(1, 17, 2, 'ORD001', '1'),
(2, 18, 1, 'ORD002', '2');

INSERT INTO like_res (user_id, res_id, date_like) VALUES
(1, 1, NOW()), (2, 2, NOW());

INSERT INTO rate_res (user_id, res_id, amount, date_rate) VALUES
(1, 1, 5, NOW()), (2, 2, 4, NOW());

-- Tìm 5 người like nhiều nhất---
SELECT 
    u.user_id, 
    u.full_name, 
    COUNT(lr.res_id) AS total_likes
FROM user u
JOIN like_res lr ON u.user_id = lr.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_likes DESC
LIMIT 5;

-- Tìm 2 nhà hàng có lượt like nhiều nhất---
SELECT 
    r.res_id,
    r.res_name,
    COUNT(lr.user_id) AS total_likes
FROM restaurant r
JOIN like_res lr ON r.res_id = lr.res_id
GROUP BY r.res_id, r.res_name
ORDER BY total_likes DESC
LIMIT 2;

-- Tìm người đã đặt hàng nhiều nhất---
SELECT 
    u.user_id,
    u.full_name,
    COUNT(o.food_id) AS total_orders
FROM user u
JOIN `order` o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_orders DESC
LIMIT 1;

-- Tìm người không hoạt động trên hệ thống ----
SELECT 
    u.user_id,
    u.full_name,
    u.email
FROM user u
LEFT JOIN `order` o ON u.user_id = o.user_id
LEFT JOIN like_res lr ON u.user_id = lr.user_id
LEFT JOIN rate_res rr ON u.user_id = rr.user_id
WHERE 
    o.user_id IS NULL 
    AND lr.user_id IS NULL 
    AND rr.user_id IS NULL;