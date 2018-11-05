#!/usr/bin/env bash

if [ `whoami` != "root" ];then
	echo "请以 root 账号运行！"
  exit 1
fi
if [[ $(grep "release 6." /etc/redhat-release 2>/dev/null | wc -l) -eq 0 ]]; then
    echo "本脚本仅支持centos 6 系统！"
    exit 1
fi

echo -n "请输入节点ID："
read id
echo "节点ID：$id"

yum install epel-release -y
yum -y install git
yum -y install gcc
yum -y install python-devel
yum -y install libffi-devel
yum -y install openssl-devel
yum install python-pip -y
yum -y update nss curl libcurl
yum install supervisor -y

pip install pip==9.0.1
pip install setuptools==32.3.1
pip install pycparser==2.18
pip install cffi==1.11.5
pip install cryptography==1.7.2
pip install requests==2.11.0
pip install urllib3==1.20
pip install cymysql==0.8.9
pip install pyOpenSSL==16.2.0
pip install ndg-httpsclient==0.4.2
pip install pyasn1==0.2.2
pip install supervisor==3.1
chkconfig supervisord on

cd
yum -y groupinstall "Development Tools"
wget https://github.com/jedisct1/libsodium/releases/download/1.0.15/libsodium-1.0.15.tar.gz
tar xf libsodium-1.0.15.tar.gz && cd libsodium-1.0.15
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
cd
git clone https://github.com/ccwy/shadowsocks.git
cd shadowsocks
cp config.json user-config.json
wget https://rss.yunxiao.us/sssss/openssr/userapiconfig.py
sed -i "2s/1/${id}/g" /root/shadowsocks/userapiconfig.py
cd
wget https://github.com/ccwy/ssshell-jar/raw/master/supervisord.conf -O /etc/supervisord.conf
wget https://github.com/ccwy/ssshell-jar/raw/master/supervisord -O /etc/init.d/supervisord
cd
service iptables stop
chkconfig iptables off
service supervisord start
service supervisord restart

echo "节点ID：$id"
echo "chacha20系列加密方式安装成功" 
echo "守护进程启动成功"
echo "系统依赖更新成功" 
echo "关闭系统防火墙成功" 
echo "后端启动成功" 
cd
rm -rf libsodium-1.0.15.tar.gz
rm -rf libsodium-1.0.15

rm -rf ssr.sh
