# 电子图书馆 · 云端部署包

把你的 JSP 电子图书馆网站部署到任意云服务器 / 托管平台，全球可访问。

---

## 一、包里有什么

```
library-deploy/
├── webapp/                # 网站完整目录（含图书PDF、封面、已修复的JSP）
│   └── books/  covers/  *.jsp  WEB-INF/
├── db/
│   └── init_db.sql        # 数据库初始化脚本（建库/建表/初始账号/图书目录）
├── docker/
│   ├── Dockerfile         # 单容器镜像（Tomcat 10.1 + MariaDB）
│   └── start.sh           # 容器启动脚本
└── vps/
    └── install.sh         # Linux 云服务器一键部署脚本
```

> 需要 WAR 包时，在 `webapp/` 目录下执行 `zip -r ../library.war .` 即可生成（或用任何压缩工具把目录打成 zip 改名为 .war）。
> 想减小体积：可先删掉 `webapp/books/` 里的 PDF，部署后再用网页上传功能传书。

---

## 二、我对代码做的必要修复（部署前必须处理的问题）

| 文件 | 问题 | 修复 |
|---|---|---|
| `index.jsp` | 写死了 Windows 路径 `C:/jsp/.../books`，换环境后首页图书列表为空 | 改为 `application.getRealPath("/books")` 动态获取 |
| `index.jsp` | 登录弹窗字段名 `userId/userPw` 与校验页 `id/pw` 不匹配，首页登录永远失败 | 字段名改为 `id/pw` |
| `loginCheck.jsp` | 登录失败时也提示"登录成功"（复制粘贴笔误） | 失败时提示"登录失败，请检查账号密码" |
| `read.jsp` | `file` 参数未过滤，存在路径穿越漏洞（公网暴露后风险高） | 仅允许纯文件名，拒绝 `..`、`/`、`\` |
| `index.jsp` | 首页搜索框无提交行为 | 接入 `search.jsp` 搜索页 |
| `index.jsp` | 封面图缺失时显示裂图 | 添加 `onerror` 兜底隐藏 |

> 未改动：网站原有功能逻辑、页面设计、数据库连接方式均保持原样。

**已知遗留问题（原代码本身就有，未擅自改动）**：首页导航的"회원가입（注册）"链接指向 `form.jsp`，该文件未包含在你的压缩包里，点击会 404。需要的话我可以帮你补一个完整的注册页面。

---

## 三、方案 A：Linux 云服务器（推荐，最简单）

适用：阿里云 / 腾讯云 / AWS / Vultr / 谷歌云 等任意 Linux 服务器（Ubuntu 20.04/22.04、Debian 11+）。

1. 把整个 `library-deploy` 文件夹上传到服务器（`scp`、宝塔面板、或 `git` 均可）；
2. SSH 登录服务器，执行：

```bash
cd library-deploy
sudo bash vps/install.sh
```

3. 脚本会自动完成：安装 Java + MariaDB → 建库建表 → 下载 Tomcat → 部署网站 → 注册开机自启服务 → 放行 8080 端口。

4. 访问：`http://<你的服务器公网IP>:8080/library/`

> 注意：云厂商安全组/防火墙里也要放行 **8080** 端口（阿里云/腾讯云在控制台操作）。想要 `https://` 或隐藏端口的域名，可在服务器上装 Nginx/Caddy 反向代理 + 域名，需要的话我再给你配置。

## 四、方案 B：Windows 云服务器

1. 安装 **Tomcat 10.1**（官网下载 zip 版，解压即可）：https://tomcat.apache.org/download-10
2. 安装 **MariaDB**：https://mariadb.org/download 一路默认安装，端口 3306；
3. 用命令行或 HeidiSQL 执行 `db/init_db.sql`（连接 root 后运行）：
   ```
   mysql -uroot -p < db\init_db.sql
   ```
4. 把 `webapp` 文件夹复制到 `Tomcat 安装目录\webapps\library`；
5. 双击 `Tomcat 安装目录\bin\startup.bat`；
6. 访问：`http://<服务器IP>:8080/library/`，并在云控制台防火墙放行 8080。

## 五、方案 C：Docker 托管平台（Railway / Render / Fly.io）

这些平台免费额度内即可跑，无需自己维护服务器，且自带公网 HTTPS 域名。

1. 把 `library-deploy` 上传到你的 GitHub 仓库；
2. **Railway**：New Project → Deploy from GitHub repo → 自动识别 Dockerfile → 部署；
3. **Render**：New → Web Service → 选仓库 → Runtime 选 Docker → 部署；
4. **Fly.io**：`fly launch` 后选择 Dockerfile 方式部署。

平台会返回给你一个公网地址（形如 `https://xxx.up.railway.app`）。

---

## 六、部署后必做

1. **修改管理员密码**（当前默认 `admin / Admin#2026`，这是临时的，公网必须改）：
   ```sql
   mysql -uroot -p library -e "UPDATE users SET pw='你的新密码' WHERE id='admin';"
   ```
2. 如需新增用户，直接往 `users` 表插入即可（明文密码，与代码逻辑一致）：
   ```sql
   INSERT INTO users (id, pw) VALUES ('新用户名', '密码');
   ```
3. 图书管理：把 PDF 放进 `webapps/library/books/`、封面图放进 `covers/`（jpg，文件名与 PDF 同名）；也可直接用网页里的"업로드"上传功能。上传新书后，如需搜索可见，同步向 `book` 表插入一条记录。

---

## 七、数据库信息（与代码保持一致）

- 数据库名：`library`（utf8mb4）
- 表：`users(id, pw)`、`book(title, author, file)`、`comments(book_file, username, content, created_at)`
- 应用账号：`library / 1234`（登录、评论用）
- 搜索页使用 root 账号：`root / 1234`
