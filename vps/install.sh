#!/bin/bash
# ============================================================
# 电子图书馆 - Linux 云服务器一键部署脚本 (Ubuntu 20.04/22.04 / Debian 11+)
# 用法: 在解压后的 library-deploy 目录里执行
#       sudo bash vps/install.sh
# ============================================================
set -e

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOMCAT_VERSION="10.1.24"
TOMCAT_DIR="/opt/tomcat"
APP_NAME="library"

if [ "$(id -u)" -ne 0 ]; then
    echo "请使用 root 权限运行: sudo bash vps/install.sh"
    exit 1
fi

echo "==> [1/6] 安装 Java 11 与 MariaDB..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y openjdk-11-jdk-headless mariadb-server mariadb-client curl

echo "==> [2/6] 启动并初始化 MariaDB..."
systemctl enable --now mariadb
if mysql -uroot < "$BASE_DIR/db/init_db.sql" 2>/dev/null; then
    echo "     数据库 library 已创建（表: users / book / comments）"
elif mysql -uroot -p1234 < "$BASE_DIR/db/init_db.sql" 2>/dev/null; then
    echo "     数据库 library 已创建（复用已有 root 密码）"
else
    echo "     警告：数据库初始化失败，请检查 MariaDB 是否正常启动"
fi

echo "==> [3/6] 下载 Tomcat ${TOMCAT_VERSION}..."
if [ ! -d "$TOMCAT_DIR" ]; then
    curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" -o /tmp/tomcat.tar.gz
    tar xzf /tmp/tomcat.tar.gz -C /opt
    mv "/opt/apache-tomcat-${TOMCAT_VERSION}" "$TOMCAT_DIR"
    rm -f /tmp/tomcat.tar.gz
fi

echo "==> [4/6] 部署网站到 Tomcat..."
rm -rf "$TOMCAT_DIR/webapps/$APP_NAME"
cp -r "$BASE_DIR/webapp" "$TOMCAT_DIR/webapps/$APP_NAME"

echo "==> [5/6] 创建 Tomcat 系统服务..."
cat > /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target mariadb.service

[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
Environment=CATALINA_HOME=$TOMCAT_DIR
Environment=CATALINA_BASE=$TOMCAT_DIR
ExecStart=$TOMCAT_DIR/bin/startup.sh
ExecStop=$TOMCAT_DIR/bin/shutdown.sh
Restart=on-failure
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now tomcat

echo "==> [6/6] 放行 8080 端口..."
if command -v ufw >/dev/null 2>&1; then
    ufw allow 8080/tcp >/dev/null 2>&1 || true
fi

sleep 5
echo ""
echo "============================================================"
echo " 部署完成！"
echo " 本机验证:   curl http://localhost:8080/library/"
echo " 公网地址:   http://<你的服务器公网IP>:8080/library/"
echo ""
echo " 管理员账号: admin   密码: Admin#2026 (部署后请尽快修改)"
echo " 数据库:     library 库, 账号 library / 密码 1234"
echo "============================================================"
