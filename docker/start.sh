#!/bin/bash
# 容器启动脚本：先启动 MariaDB 并初始化数据库，再启动 Tomcat
set -e

# 1. 准备 MariaDB 运行目录
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# 2. 后台启动 MariaDB
mysqld_safe --skip-syslog &
MYSQL_PID=$!

# 3. 等待数据库就绪
echo "Waiting for MariaDB to be ready..."
for i in $(seq 1 60); do
    if mysqladmin ping --silent 2>/dev/null; then
        break
    fi
    sleep 1
done

# 4. 初始化数据库（脚本可重复执行，不会覆盖已有数据）
if mysql -uroot < /opt/init_db.sql 2>/dev/null; then
    echo "Database initialized."
elif mysql -uroot -p1234 < /opt/init_db.sql 2>/dev/null; then
    echo "Database initialized (existing root password)."
else
    echo "WARNING: database init skipped, continuing..."
fi

# 5. 启动 Tomcat（前台运行，容器保持存活）
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export CATALINA_HOME=/opt/tomcat
exec /opt/tomcat/bin/catalina.sh run
