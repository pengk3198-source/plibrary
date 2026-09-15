# 电子图书馆 - Render 部署镜像
# 说明：本文件必须位于 GitHub 仓库根目录；webapp/ 与 db/ 与 start.sh 同在根目录
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# 1. 基础依赖：JRE 11（JSP 编译由 Tomcat 自带 ECJ 完成，无需完整 JDK）+ MariaDB
#    使用 jre-headless 减小镜像体积，适配 Render 免费实例 512MB 内存
RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-11-jre-headless \
        mariadb-server \
        curl \
        ca-certificates \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

# 2. 下载并解压 Tomcat 10.1（网站使用 Jakarta Servlet，需要 Tomcat 10+）
ARG TOMCAT_VERSION=10.1.24
RUN curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" -o /tmp/tomcat.tar.gz \
    && tar xzf /tmp/tomcat.tar.gz -C /opt \
    && mv "/opt/apache-tomcat-${TOMCAT_VERSION}" /opt/tomcat \
    && rm -f /tmp/tomcat.tar.gz

# 3. 部署网站、数据库脚本与启动脚本
COPY webapp /opt/tomcat/webapps/library
COPY db/init_db.sql /opt/init_db.sql
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 4. Tomcat 监听 8080，Render 依据 EXPOSE 自动路由公网流量
EXPOSE 8080

CMD ["/start.sh"]
