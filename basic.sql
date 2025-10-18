-- DATABASE ----------------------
CREATE DATABASE IF NOT EXISTS `demo_2`

DROP DATABASE IF EXISTS `demo_2`

USE `demo`

-- TABLE ----------------------
CREATE TABLE `Users` (
	`id` INT,
	`fullName` VARCHAR(255),
	`otp` CHAR (5),
	`avatar` VARCHAR(255)
)

RENAME TABLE `Users` TO `User_Ten_moi`

-- Xoá table
DROP TABLE `User_Ten_moi`

-- Xoá dữ liệu bên trong table Users, nhưng không xoá table
-- Reset auto_increament
TRUNCATE TABLE `Users`

-- Khi table đã được tạo: thì dùng ALTER
ALTER TABLE `Users`
ADD `age` INT;

-- RÀNG BUỘC 
-- DEFAULT: đặt giá trị mặc định cho cột, khi không truyền gì hết
CREATE TABLE `Foods` (
	`id` INT,
	`name` VARCHAR(255),
	`description` VARCHAR(255) DEFAULT "Chưa có thông tin"
)

-- NOT NULL: không được rỗng, bắt buộc phải có dữ liệu
ALTER TABLE `Foods`
MODIFY `name` VARCHAR(255) NOT NULL

ALTER TABLE `Foods`
ADD `price` INT NOT NULL DEFAULT 10000

-- Thêm dữ liệu
INSERT INTO `Foods` (`id`, `name`, `description`) VALUES 
					(3, "gỏi heo", "gỏi làm từ heo"),
					(4, "gỏi vịt", "gỏi làm từ vịt"),
					(5, "gỏi cá", "gỏi làm từ cá")
					
					
INSERT INTO `Users` (`fullName`) VALUES 
					("Nguyễn Văn A"),
					("Nguyễn Văn B"),
					("Nguyễn Văn C"),
					("Nguyễn Văn D"),
					("Nguyễn Văn E")
	
-- UPDATE DỮ Liẹue
UPDATE `Users` SET `fullName` = "Nguyễn Văn A" WHERE `id` = 1

-- PRIMARY KEY
	-- là sự kết hợp của NOT NULL và UNIQUE
	-- 1 bảng chỉ tổn tại 1 PRIMARY KEY
	-- 1 PRIMARY KEY sẽ có thể gom được nhiều cột(composite)					
ALTER TABLE `Users`
MODIFY `id` INT PRIMARY KEY AUTO_INCREMENT

-- `id` VARCHAR(255) PRIMARY KEY

ALTER TABLE `Foods`
MODIFY `id` INT PRIMARY KEY AUTO_INCREMENT

-- FOREIGN KEY
	-- Tham chiếu tới khoá chinhs
CREATE TABLE `Orders` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	--
	`userId` INT,
	`foodId` INT,
	
	FOREIGN KEY (`userId`) REFERENCES `Users` (`id`),
	FOREIGN KEY (`foodId`) REFERENCES `Foods` (`id`)
)					

-- QUERY dữ liệu
SELECT * 
FROM `Orders`
WHERE `id` = 4

-- INER JOIN: lấy thêm dữ liệu
SELECT * 
FROM `Orders`
INNER JOIN `Users` ON `Orders`.`userId` = `Users`.`id`

-- LEFT JOIN / RIGHT JOIN
-- LEFT: lấy table bên trái làm chuẩn để lấy hết tất cả dữ liệu, ngya khi cả không tồn tại bên bảng bên phải (Orders)
SELECT *
FROM `Orders`    
RIGHT JOIN `Users` ON `Orders`.`userId` = `Users`.`id`

-- CROSS JOIN: lấy full 2 table
SELECT * 
FROM `Orders`
CROSS JOIN `Users`

-- Giải bài tập
-- Tìm 5 người đã order (like) food (nhà hàng) nhiều nhất
-- hướng xử lí: nhóm lại và đếm số lượng tồn tại trong bảng, sắp xếp lại từ lớn tới bé, lấy vị trí đầu tiên

-- Bước 1: lấy ra tất cả dữ liệu trong bảng order 
SELECT *
FROM `Orders`

-- Bước 2: lấy thêm thông tin user
SELECT * 
FROM `Orders`
INNER JOIN `Users` ON `Orders`.`userId` = `Users`.`id`

-- GROUP BY
-- Bước 3: nhóm các userId giống nhau
-- lỗi: Query 1 ERROR at Line 121: : Expression #1 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'demo.Orders.id' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
SELECT * 
FROM `Orders`
INNER JOIN `Users` ON `Orders`.`userId` = `Users`.`id`
GROUP BY `Orders`.`userId`

-- Bước 4: fix lỗi (bước 3)
-- do chứa các cột có giá trị khác nhau so với (cột gốc GROUP BY cot_goc)
-- Query 1 ERROR at Line 129: : Column 'id' in field list is ambiguous
SELECT `userId`, `id`, `fullName`
FROM `Orders`
INNER JOIN `Users` ON `Orders`.`userId` = `Users`.`id`
GROUP BY `Orders`.`userId`   

-- Bước 5: fix lỗi bước 4
-- do có 2 cột id giống nhau, nên bị lỗi ambiguous, cần chỉ định rõ cột của table nào
SELECT `userId`, `Users`.`id`, `fullName`
FROM `Orders`
INNER JOIN `Users` ON `Orders`.`userId` = `Users`.`id`
GROUP BY `Orders`.`userId`  

-- COUNT()
	-- MAX(), MIN(), SUM(), AVG()
-- Bước 6: Đếm số lượng trong lúc nhóm
SELECT `userId`, `Users`.`id`, `fullName`, COUNT(`userId`) AS "Số lượng"
FROM `Orders`
INNER JOIN `Users` ON `Orders`.`userId` = `Users`.`id`
GROUP BY `Orders`.`userId`  

-- ORDER BY
-- Bước 7: sắp xếp
-- ASC từ bé tới lớn -> tăng dần
-- DESC: Từ lớn tới bé -> giảm dần
SELECT  `userId`, `Users`.`id`, `fullName`, COUNT(`userId`) AS "Số lượng"
FROM `Orders`
INNER JOIN `Users` ON `Orders`.`userId` = `Users`.`id`
GROUP BY `Orders`.`userId`
ORDER BY `Số Lượng` DESC 

-- LIMIT
-- Bước 8: lấy vị trí đầu tiên
SELECT  `userId`, `Users`.`id`, `fullName`, COUNT(`userId`) AS "Số lượng"
FROM `Orders`
INNER JOIN `Users` ON `Orders`.`userId` = `Users`.`id`
GROUP BY `Orders`.`userId`
ORDER BY `Số Lượng` DESC
LIMIT 2


-- Câu 2: Tìm người dùng không hoạt động trong hệ thống (không đặt hàng, không like, không đánh giá nhà hàng)
SELECT * 
FROM `Orders`
RIGHT JOIN `Users` ON `Orders`.`userId` = `Users`.`id`
RIGHT JOIN `Foods` ON `Orders`.`foodId` = `Foods`.`id`
WHERE `Orders`.`id` IS NULL AND `Foods`.`id` IS NULL


