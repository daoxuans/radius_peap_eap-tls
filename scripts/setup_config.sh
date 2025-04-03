#!/usr/bin/env sh

set -e
umask 0027

DOCKERCOMPOSEFILE=${PWD}/docker-compose.yml
if [ ! -f "${DOCKERCOMPOSEFILE}" ]; then
    /usr/bin/printf "Run from directory where docker-compose.yml resides.\n"
    exit 1
fi

mkdir -p backup
mkdir -p provision
cp ./templates/env.j2 ./.env

# 交互式配置 .env 文件
printf "\n===== 开始配置 .env 文件 =====\n\n"

# 设置默认值
DEFAULT_TZ="Asia/Shanghai"
DEFAULT_RADIUS_BIND_IP="0.0.0.0"
DEFAULT_RADIUS_HOST="radius.intra.lan"
DEFAULT_COUNTRYNAME="CN"
DEFAULT_LOCALITYNAME="Nanjing"

# 交互式配置
printf "基本配置:\n"
printf "请输入时区 [默认: %s]: " "$DEFAULT_TZ"
read -r TZ
TZ=${TZ:-$DEFAULT_TZ}

printf "\nRadius 服务绑定IP配置:\n"
printf "请输入 Radius  绑定IP 地址 [默认: %s]: " "$DEFAULT_RADIUS_BIND_IP"
read -r RADIUS_IP
RADIUS_BIND_IP=${RADIUS_IP:-$DEFAULT_RADIUS_BIND_IP}

printf "请输入 Radius 服务器主机名 [默认: %s]: " "$DEFAULT_RADIUS_HOST"
read -r RADIUS_HOST
RADIUS_HOST=${RADIUS_HOST:-$DEFAULT_RADIUS_HOST}

printf "\n证书配置:\n"
printf "请输入国家代码 (2字母) [默认: %s]: " "$DEFAULT_COUNTRYNAME"
read -r COUNTRYNAME
COUNTRYNAME=${COUNTRYNAME:-$DEFAULT_COUNTRYNAME}

printf "请输入城市名称 [默认: %s]: " "$DEFAULT_LOCALITYNAME"
read -r LOCALITYNAME
LOCALITYNAME=${LOCALITYNAME:-$DEFAULT_LOCALITYNAME}

printf "\nnRadius服务启动配置:\n"
printf "是否启用调试模式 (yes/no) [默认: no]: "
read -r DEBUG_ENABLE
DEBUG_ENABLE=${DEBUG_ENABLE:-no}
if [ "$DEBUG_ENABLE" = "yes" ]; then
    sed -i "s|# DEBUG=yes|DEBUG=yes|g" ./.env
else
    sed -i "s|DEBUG=yes|# DEBUG=yes|g" ./.env
fi

# 更新 .env 文件 (Linux 语法)
sed -i "s|^TZ={{ timezone }}|TZ=$TZ|g" ./.env
sed -i "s|^RADIUS_IP={{ ip }}|RADIUS_IP=$RADIUS_BIND_IP|g" ./.env
sed -i "s|^RADIUS_HOST={{ hostname }}|RADIUS_HOST=$RADIUS_HOST|g" ./.env
sed -i "s|^COUNTRYNAME={{ country }}|COUNTRYNAME=$COUNTRYNAME|g" ./.env
sed -i "s|^LOCALITYNAME={{ city }}|LOCALITYNAME=$LOCALITYNAME|g" ./.env

printf "\n===== .env 文件配置完成 =====\n"
printf "配置已保存到 .env 文件。如需修改，可以直接编辑该文件。\n"
printf "接下来请执行 'docker-compose build' 和 'docker-compose up' 命令继续安装。\n"