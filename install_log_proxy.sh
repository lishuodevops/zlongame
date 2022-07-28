#!/bin/bash


# check host
echo `hostname` |grep -qi logproxy || echo "please check host is logproxy?" && exit

# check nginx 
if [ -d /etc/nginx ];then
    echo "nginx is installed" 
else
    yum -y install nginx && echo "nginx install success" || echo "nginx install failed"
fi

# install logproxy
DNSIP=`cat /etc/resolv.conf |grep nameserver |awk '{print $2}' |head -n 1`
if [[ ! -z "$DNSIP" && ! -f /etc/nginx/conf.d/proxy.conf ]];then
    sed -i 's/80;/8080;/g'  /etc/nginx/nginx.conf
    cp proxy.conf /etc/nginx/conf.d/ && sed -i 's/DNSIP/'${DNSIP}'/g' /etc/nginx/conf.d/proxy.conf && systemctl start nginx && systemctl status nginx
else
    echo "please check DNS IP(/etc/resolv.conf) or /etc/nginx/conf.d/proxy.conf is exist ?"
    exit
fi

