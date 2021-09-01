安装shadowsocks-libev，并且启用BBR



环境：

Ubuntu18.04



使用：

cd /home && \
git clone https://github.com/Zerobxx/config-ss && \
cd ./config-ss && \
cp YOUR_PUBLIC_KEY pub_key && \
echo PASSWORD='YOUR_PASSWORD' > ss.pass && \
bash boot.sh


