# 依赖说明文档

## 概述

知阅图书管理系统采用轻量级架构，最大程度减少外部依赖。主要依赖包括一个图标库（CDN 引入）和浏览器原生 API。

## 外部依赖

### 1. Font Awesome 6.4.0

**用途**：提供系统所有图标资源（图书图标、导航图标、操作按钮图标等）

**引入方式**：CDN（Content Delivery Network）

**CDN 地址**：
```html
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
```

**许可证**：
- Font Awesome Free License
- 图标字体：SIL OFL 1.1 License
- CSS 代码：MIT License
- 品牌图标：CC BY 4.0 License

**离线使用方案**：
如需离线使用，请按以下步骤操作：

1. 下载 Font Awesome 6.4.0 完整包：
   - 访问 https://fontawesome.com/download
   - 下载免费版 ZIP 包

2. 解压并将以下文件复制到项目目录：
   ```
   b9e2fa72/
   └── fontawesome/
       ├── css/
       │   └── all.min.css
       └── webfonts/
           ├── fa-solid-900.woff2
           ├── fa-regular-400.woff2
           └── fa-brands-400.woff2
   ```

3. 修改 `index.html` 中的引用路径：
   ```html
   <link rel="stylesheet" href="fontawesome/css/all.min.css">
   ```

**使用的图标列表**：
- `fa-book`, `fa-book-open`, `fa-book-reader`, `fa-library` - 图书相关
- `fa-laptop-code`, `fa-microchip`, `fa-python` - 计算机类
- `fa-square-root-alt`, `fa-chart-line`, `fa-coins` - 数学/经济类
- `fa-atom`, `fa-flask`, `fa-project-diagram` - 科学类
- `fa-feather-alt`, `fa-scroll` - 文学类
- `fa-home`, `fa-search`, `fa-calendar-alt`, `fa-building` - 导航类
- `fa-user`, `fa-cog`, `fa-palette`, `fa-database` - 设置类
- `fa-check`, `fa-times`, `fa-eye`, `fa-eye-slash` - 操作类
- 等等...

## 浏览器原生 API 依赖

### 1. localStorage API

**用途**：前端数据持久化存储

**存储内容**：
- `lib_accounts` - 用户账户信息
- `lib_books` - 图书信息
- `lib_borrowRecords` - 借阅记录
- `lib_seatReservations` - 座位预约
- `lib_spaceBookings` - 空间预订
- `lib_payments` - 缴费记录
- `lib_currentUser` - 当前登录用户
- `lib_userTheme_[userId]` - 用户主题设置
- `lib_system_backup_snapshot` - 系统备份数据
- `lib_system_backup_log` - 备份日志
- `lib_system_auto_backup` - 自动备份开关

**存储限制**：
- Chrome/Edge: 约 10 MB
- Firefox: 约 10 MB
- Safari: 约 5 MB

**浏览器兼容性**：
- Chrome 4+
- Firefox 3.5+
- Safari 4+
- Edge 12+

**API 文档**：
https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage

### 2. Web Crypto API

**用途**：密码 SHA-256 哈希加密

**使用场景**：
```javascript
async function hashPassword(pwd) {
    const encoder = new TextEncoder();
    const data = encoder.encode(pwd);
    const hash = await crypto.subtle.digest('SHA-256', data);
    return Array.from(new Uint8Array(hash))
        .map(b => b.toString(16).padStart(2, '0'))
        .join('');
}
```

**浏览器兼容性**：
- Chrome 37+
- Firefox 34+
- Safari 11+
- Edge 12+

**API 文档**：
https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API

**安全说明**：
- SHA-256 是单向哈希算法，不可逆
- 每次加密结果相同（无盐值）
- 建议生产环境添加随机盐值

### 3. CSS Custom Properties (CSS 变量)

**用途**：实现动态主题切换

**定义的变量**：
```css
:root {
    --primary: #4F6EF7;           /* 主色调 */
    --primary-light: #7B93FA;     /* 主色浅 */
    --primary-dark: #3A56D4;      /* 主色深 */
    --accent: #FF6B6B;            /* 强调色 */
    --success: #2ED573;           /* 成功色 */
    --warning: #FFA502;           /* 警告色 */
    --bg: #F5F7FC;                /* 背景色 */
    --card: #FFF;                 /* 卡片色 */
    --text: #2D3436;              /* 主文本色 */
    --text-secondary: #636E72;    /* 次要文本色 */
    --text-light: #B2BEC3;        /* 浅色文本 */
    --border: #E8ECF1;            /* 边框色 */
    --shadow: 0 2px 12px rgba(79,110,247,.08);      /* 阴影 */
    --shadow-lg: 0 8px 30px rgba(79,110,247,.12);   /* 大阴影 */
    --radius: 16px;               /* 圆角 */
    --radius-sm: 10px;            /* 小圆角 */
    --sidebar-w: 240px;           /* 侧边栏宽度 */
    --topbar-h: 60px;             /* 顶部栏高度 */
}
```

**浏览器兼容性**：
- Chrome 49+
- Firefox 31+
- Safari 9.1+
- Edge 15+

**API 文档**：
https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties

### 4. CSS Grid Layout

**用途**：页面布局（图书列表、座位图、统计卡片等）

**使用场景**：
```css
.book-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 16px;
}

.seat-grid {
    display: grid;
    grid-template-columns: repeat(10, 1fr);
    gap: 8px;
}
```

**浏览器兼容性**：
- Chrome 57+
- Firefox 52+
- Safari 10.1+
- Edge 16+

**API 文档**：
https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout

### 5. Flexbox Layout

**用途**：组件内部布局（导航栏、卡片内容、表单等）

**浏览器兼容性**：
- Chrome 29+
- Firefox 28+
- Safari 9+
- Edge 12+

**API 文档**：
https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout

### 6. Fetch API (未使用)

**说明**：当前版本未使用 Fetch API，所有数据存储在 localStorage

**未来扩展**：如需连接后端 API，可使用 Fetch API 或 XMLHttpRequest

## 可选依赖（数据库）

### MySQL 5.7+

**用途**：未来后端扩展的数据库 Schema 设计

**提供的文件**：`zhiyue_library_simple.sql`

**包含的数据表**：
1. `users` - 用户表
2. `books` - 图书表
3. `book_covers` - 封面模板表
4. `borrow_records` - 借阅记录表
5. `seat_reservations` - 座位预约表
6. `spaces` - 空间信息表
7. `space_bookings` - 空间预订表
8. `payments` - 缴费记录表
9. `notifications` - 通知消息表
10. `system_logs` - 系统日志表
11. `data_backups` - 数据备份表

**字符集**：utf8mb4

**存储引擎**：InnoDB

**执行方式**：
```bash
mysql -u root -p < zhiyue_library_simple.sql
```

或使用 Navicat 等图形化工具导入 SQL 文件。

**浏览器兼容性**：
无需浏览器支持，仅在服务端使用。

## 开发依赖

**无**

本项目无需安装 Node.js、npm 或其他开发工具。仅需：
- 文本编辑器（推荐 VS Code）
- 现代浏览器（Chrome/Firefox/Edge）

## 依赖版本管理

### 当前版本

| 依赖项 | 版本 | 更新日期 |
|--------|------|----------|
| Font Awesome | 6.4.0 | 2026-11-05 |
| HTML | 5 | - |
| CSS | 3 | - |
| JavaScript | ES6+ | - |
| MySQL Schema | 5.7+ | 2026-11-05 |

### 版本更新策略

- **Font Awesome**：定期检查官方更新，手动升级 CDN 链接
- **浏览器 API**：遵循 W3C 标准，无需手动更新
- **MySQL Schema**：根据业务需求手动调整

## 依赖冲突

**无已知冲突**

所有依赖项均为独立模块，不存在版本冲突问题。

## 离线部署

如需在无网络环境下部署：

1. 下载 Font Awesome 离线包（见上文）
2. 将 `fontawesome/` 目录放入项目根目录
3. 修改 `index.html` 中的 CDN 引用为本地路径
4. 确保图书封面图片在 `covers/` 目录中
5. 双击 `index.html` 即可运行

## 性能优化建议

### 当前优化

- ✅ CSS 变量减少重复代码
- ✅ Font Awesome 使用 CDN 加速
- ✅ localStorage 异步读写
- ✅ 防抖函数优化自动备份频率

### 未来可优化

- ⚠️ 图片懒加载（图书封面）
- ⚠️ 代码分割（将 JavaScript 提取到独立文件）
- ⚠️ Gzip 压缩（部署到服务器时）
- ⚠️ Service Worker（离线缓存）

## 安全依赖

### 密码加密

- **算法**：SHA-256
- **实现**：Web Crypto API (crypto.subtle.digest)
- **盐值**：无（建议生产环境添加）
- **迭代次数**：1 次（建议生产环境增加到 10000+）

### 登录保护

- **失败锁定**：5 次失败后锁定 3 分钟
- **锁定存储**：localStorage (lib_lock_[studentId])
- **解锁方式**：等待锁定时间结束

## 总结

本项目采用轻量级架构，主要依赖浏览器原生 API 和一个图标库。无需构建工具，无需后端服务，直接打开即可运行。这种架构适合：

- ✅ 学习和教学项目
- ✅ 快速原型开发
- ✅ 小型应用部署
- ✅ 离线环境使用

不适合：

- ❌ 大规模多用户系统
- ❌ 高并发场景
- ❌ 复杂业务逻辑
- ❌ 实时数据同步

---

**文档版本**：1.0.0  
**最后更新**：2026-11-05  
**维护者**：开发团队
