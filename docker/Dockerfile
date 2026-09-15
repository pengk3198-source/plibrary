# 电子图书馆 - 单容器部署镜像
# 适用于 Railway / Render / Fly.io 等支持 Docker 的托管平台，或任意 Linux 服务器
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# 1. 基础依赖：Java 11 + MariaDB
RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-11-jdk-headless \
        mariadb-server \
        curl \
        ca-certificates \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

# 2. 下载并解压 Tomcat 10.1（支持 Jakarta Servlet，网站需要）
ARG TOMCAT_VERSION=10.1.24
RUN curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" -o /tmp/tomcat.tar.gz \
    && tar xzf /tmp/tomcat.tar.gz -C /opt \
    && mv "/opt/apache-tomcat-${TOMCAT_VERSION}" /opt/tomcat \
    && rm -f /tmp/tomcat.tar.gz

# 3. 部署网站与数据库脚本
COPY webapp /opt/tomcat/webapps/library
COPY db/init_db.sql /opt/init_db.sql
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
