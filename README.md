安装shadowsocks-libev，并且启用BBR



环境：

Ubuntu18.04



使用：

cd /home && \
git clone  https://github.com/Zerobxx/config-ss && \
cd ./config-ss && \
cp 你的公钥 pub_key \
echo PASSWORD='YourPassword' > ss.pass \
bash boot.sh


