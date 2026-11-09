-- ============================================================
-- 知阅图书管理系统 - 精简版数据库（无图片，秒执行）
-- ============================================================

CREATE DATABASE IF NOT EXISTS zhiyue_library DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE zhiyue_library;

-- 删除旧表
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS feedbacks;
DROP TABLE IF EXISTS browse_history;
DROP TABLE IF EXISTS collections;
DROP TABLE IF EXISTS space_reservations;
DROP TABLE IF EXISTS seat_reservations;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS borrow_records;
DROP TABLE IF EXISTS book_covers;
DROP TABLE IF EXISTS cover_templates;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- 用户表
CREATE TABLE users (
  id VARCHAR(32) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  student_id VARCHAR(20) NOT NULL UNIQUE,
  class_name VARCHAR(50) DEFAULT '未分班',
  email VARCHAR(100) DEFAULT '',
  password_hash VARCHAR(64) NOT NULL,
  is_admin TINYINT(1) DEFAULT 0,
  avatar_emoji VARCHAR(10) DEFAULT '🧑‍🎓',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_name (name),
  INDEX idx_is_admin (is_admin)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 图书表
CREATE TABLE books (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(200) NOT NULL,
  author VARCHAR(100) NOT NULL,
  isbn VARCHAR(20) DEFAULT '',
  category VARCHAR(20) NOT NULL,
  status ENUM('available','borrowed','overdue','reserved') DEFAULT 'available',
  color VARCHAR(20) DEFAULT '#4F6EF7',
  icon VARCHAR(50) DEFAULT 'fa-book',
  cover_image_path VARCHAR(500) DEFAULT NULL COMMENT '封面图片路径',
  cover_id BIGINT DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_category (category),
  INDEX idx_status (status),
  INDEX idx_title (title),
  INDEX idx_cover_id (cover_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 封面表
CREATE TABLE book_covers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  book_id BIGINT NOT NULL,
  cover_type ENUM('image_url','base64','color_icon') DEFAULT 'color_icon',
  image_url VARCHAR(500) DEFAULT NULL,
  base64_data LONGTEXT DEFAULT NULL,
  color VARCHAR(20) DEFAULT '#4F6EF7',
  icon VARCHAR(50) DEFAULT 'fa-book',
  mime_type VARCHAR(50) DEFAULT 'image/png',
  upload_user_id VARCHAR(32) DEFAULT NULL,
  is_active TINYINT(1) DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_book_id (book_id),
  INDEX idx_is_active (is_active),
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
  FOREIGN KEY (upload_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE books ADD CONSTRAINT fk_book_cover FOREIGN KEY (cover_id) REFERENCES book_covers(id) ON DELETE SET NULL;

-- 借阅记录表
CREATE TABLE borrow_records (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(32) NOT NULL,
  book_id BIGINT NOT NULL,
  book_title VARCHAR(200) NOT NULL,
  book_author VARCHAR(100) NOT NULL,
  status ENUM('active','overdue','returned','paid') DEFAULT 'active',
  borrow_date DATE NOT NULL,
  due_date DATE NOT NULL,
  return_date DATE DEFAULT NULL,
  renew_count INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_book_id (book_id),
  INDEX idx_status (status),
  INDEX idx_due_date (due_date),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 缴费表
CREATE TABLE payments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(32) NOT NULL,
  title VARCHAR(200) NOT NULL,
  amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  status ENUM('pending','paid') DEFAULT 'pending',
  type VARCHAR(50) DEFAULT 'overdue',
  book_id BIGINT DEFAULT NULL,
  borrow_id BIGINT DEFAULT NULL,
  paid_date DATETIME DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_status (status),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 座位预约表
CREATE TABLE seat_reservations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(32) NOT NULL,
  floor INT NOT NULL,
  seat_number VARCHAR(10) NOT NULL,
  reservation_date DATE NOT NULL,
  time_slot VARCHAR(20) DEFAULT NULL,
  status ENUM('active','cancelled','completed') DEFAULT 'active',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_reservation_date (reservation_date),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 空间预约表
CREATE TABLE space_reservations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(32) NOT NULL,
  space_id VARCHAR(50) NOT NULL,
  space_name VARCHAR(100) NOT NULL,
  reservation_date DATE NOT NULL,
  time_slot VARCHAR(20) DEFAULT NULL,
  status ENUM('active','cancelled','completed') DEFAULT 'active',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_reservation_date (reservation_date),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 收藏表
CREATE TABLE collections (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(32) NOT NULL,
  book_id BIGINT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_user_book (user_id, book_id),
  INDEX idx_user_id (user_id),
  INDEX idx_book_id (book_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 浏览历史表
CREATE TABLE browse_history (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(32) NOT NULL,
  book_id BIGINT NOT NULL,
  browse_time DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_browse_time (browse_time),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 反馈表
CREATE TABLE feedbacks (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(32) NOT NULL,
  type VARCHAR(50) NOT NULL,
  content TEXT NOT NULL,
  status ENUM('pending','processing','resolved') DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_status (status),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 封面模板表
CREATE TABLE cover_templates (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(500) DEFAULT '',
  template_type ENUM('color_gradient','image_pattern','custom_design') DEFAULT 'color_gradient',
  color_primary VARCHAR(20) DEFAULT NULL,
  color_secondary VARCHAR(20) DEFAULT NULL,
  color_accent VARCHAR(20) DEFAULT NULL,
  icon_name VARCHAR(50) DEFAULT NULL,
  is_preset TINYINT(1) DEFAULT 1,
  usage_count INT DEFAULT 0,
  sort_order INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_template_type (template_type),
  INDEX idx_is_preset (is_preset),
  INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 插入默认数据
-- ============================================================

-- 用户（密码都是：Abc12345）
INSERT INTO users (id, name, student_id, class_name, email, password_hash, is_admin, avatar_emoji) VALUES
('user1', '陈熠', '2023010001', '计算机2301班', 'chenyi@university.edu.cn', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 1, '🧑‍🎓'),
('user2', '李明', '2023010002', '软件2301班', 'liming@university.edu.cn', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 0, '😎');

-- 图书（10本，含封面图片路径）
INSERT INTO books (id, title, author, isbn, category, status, color, icon, cover_image_path) VALUES
(1, 'JavaScript高级程序设计', 'Matt Frisbie', '9787115545336', 'cs', 'available', '#4F6EF7', 'fa-laptop-code', 'covers/js.png'),
(2, '算法导论', 'Thomas H.Cormen', '9787111407010', 'cs', 'available', '#2ED573', 'fa-project-diagram', 'covers/algo.png'),
(3, '线性代数', '同济大学数学系', '9787040396638', 'math', 'available', '#FFA502', 'fa-square-root-alt', 'covers/math.png'),
(4, '红楼梦', '曹雪芹', '9787020002207', 'lit', 'available', '#FF6B6B', 'fa-feather-alt', 'covers/lit.png'),
(5, '经济学原理', 'N.Gregory Mankiw', '9787301150849', 'eco', 'available', '#A29BFE', 'fa-chart-line', 'covers/econ.png'),
(6, '大学物理', 'David Halliday', '9787111544937', 'phy', 'available', '#00CEC9', 'fa-atom', 'covers/phy.png'),
(7, 'Python编程', 'Eric Matthes', '9787115428028', 'cs', 'available', '#E17055', 'fa-python', 'covers/python.png'),
(8, '微积分', 'James Stewart', '9787111544104', 'math', 'available', '#6C5CE7', 'fa-square-root-alt', 'covers/calc.png'),
(9, '西游记', '吴承恩', '9787020008735', 'lit', 'available', '#FD79A8', 'fa-scroll', 'covers/lit.png'),
(10, '国富论', 'Adam Smith', '9787100016957', 'eco', 'available', '#FDCB6E', 'fa-coins', 'covers/econ.png');

-- 封面模板（8个预设）
INSERT INTO cover_templates (name, description, template_type, color_primary, color_secondary, color_accent, icon_name, is_preset, usage_count, sort_order) VALUES
('经典蓝', '深蓝色渐变封面', 'color_gradient', '#4F6EF7', '#7B93FA', '#3A56D4', 'fa-book', 1, 0, 1),
('学术绿', '清新绿色学术风格', 'color_gradient', '#2ED573', '#7BED9F', '#009B7D', 'fa-book-open', 1, 0, 2),
('活力橙', '温暖橙色活力风格', 'color_gradient', '#FFA502', '#FFD43B', '#E17055', 'fa-book-reader', 1, 0, 3),
('优雅紫', '高贵紫色优雅风格', 'color_gradient', '#6C5CE7', '#A29BFE', '#5A4BD1', 'fa-library', 1, 0, 4),
('中国红', '传统红色中国风格', 'color_gradient', '#D63031', '#FF7675', '#B71C1C', 'fa-scroll', 1, 0, 5),
('科技蓝', '科技感蓝色风格', 'color_gradient', '#0984E3', '#74B9FF', '#0652DD', 'fa-laptop-code', 1, 0, 6),
('自然青', '清新青色自然风格', 'color_gradient', '#00CEC9', '#81ECEC', '#00A8A5', 'fa-leaf', 1, 0, 7),
('暗夜黑', '深色模式风格', 'color_gradient', '#2D3436', '#636E72', '#1A1A2E', 'fa-moon', 1, 0, 8);

-- ============================================================
-- 完成！数据库已创建
-- ============================================================
-- 默认账号：
-- 管理员：学号 2023010001，密码 Abc12345
-- 普通用户：学号 2023010002，密码 Abc12345
--
-- 如需添加封面图片，请在Navicat中手动添加到 book_covers 表
-- ============================================================
