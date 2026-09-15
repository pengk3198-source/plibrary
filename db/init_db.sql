-- 电子图书馆数据库初始化脚本（可重复执行，不会产生重复数据）
CREATE DATABASE IF NOT EXISTS library CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library;

-- 业务账号（loginCheck.jsp / comment.jsp / read.jsp 使用 mariadb 驱动）
CREATE USER IF NOT EXISTS 'library'@'localhost' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'library'@'127.0.0.1' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON library.* TO 'library'@'localhost';
GRANT ALL PRIVILEGES ON library.* TO 'library'@'127.0.0.1';

-- 搜索引擎连接（search.jsp 使用 mysql 驱动，root/1234）
ALTER USER 'root'@'localhost' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'root'@'127.0.0.1' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- 数据表
CREATE TABLE IF NOT EXISTS users (
  id VARCHAR(100) PRIMARY KEY,
  pw VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS book (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255) DEFAULT '',
  file VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 清理旧版可能产生的重复图书（无重复时无副作用）
DELETE b1 FROM book b1 JOIN book b2 ON b1.file = b2.file AND b1.id > b2.id;

-- 确保 file 唯一键存在（兼容已存在的旧表；已存在时跳过）
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.statistics
    WHERE table_schema='library' AND table_name='book' AND index_name='uk_book_file') = 0,
  'ALTER TABLE book ADD UNIQUE KEY uk_book_file (file)',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  book_file VARCHAR(255) NOT NULL,
  username VARCHAR(100) NOT NULL,
  content TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 初始管理员账号（部署后请修改密码）
INSERT IGNORE INTO users (id, pw) VALUES ('admin', 'Admin#2026');

-- 图书目录（与 books 文件夹对应，INSERT IGNORE 保证重复执行不产生重复数据）
INSERT IGNORE INTO book (title, author, file) VALUES
('2_《TOPIK必备单词》正序版词汇表', '', '2_《TOPIK必备单词》正序版词汇表.pdf'),
('Java', '', 'Java.pdf'),
('完全掌握·新韩国语能力考试TOPIK 2　（中高级）语法（详解+练习） (崔红花) (z-library.sk, 1lib.sk, z-lib.sk)', '崔红花', '完全掌握·新韩国语能力考试TOPIK 2　（中高级）语法（详解+练习） (崔红花) (z-library.sk, 1lib.sk, z-lib.sk).pdf'),
('数字电子技术基础 (阎石主编)', '阎石', '数字电子技术基础 (阎石主编).pdf'),
('计算机网络 (谢希仁)', '谢希仁', '计算机网络 (谢希仁).pdf');
