#!/bin/bash
# Render 容器启动脚本：MariaDB（内存已按免费实例调优）→ 初始化数据库 → Tomcat 前台运行
set -e

# 1. 准备 MariaDB 运行目录
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# 2. 后台启动 MariaDB（调低缓存以适配小内存实例）
mysqld_safe --skip-syslog \
    --innodb-buffer-pool-size=64M \
    --key-buffer-size=8M \
    --max-connections=40 &

# 3. 等待数据库就绪
echo "Waiting for MariaDB to be ready..."
for i in $(seq 1 60); do
    if mysqladmin ping --silent 2>/dev/null; then
        break
    fi
    sleep 1
done

# 4. 初始化数据库（脚本可重复执行；首次 root 无密码，之后用已有密码）
if mysql -uroot < /opt/init_db.sql 2>/dev/null; then
    echo "Database initialized."
elif mysql -uroot -p1234 < /opt/init_db.sql 2>/dev/null; then
    echo "Database initialized (existing root password)."
else
    echo "WARNING: database init skipped, continuing..."
fi

# 5. 启动 Tomcat（限制 JVM 堆内存，前台运行保持容器存活）
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export CATALINA_HOME=/opt/tomcat
export CATALINA_OPTS="-Xms64m -Xmx256m -Djava.awt.headless=true"
exec /opt/tomcat/bin/catalina.sh run
