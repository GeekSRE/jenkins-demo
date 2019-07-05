if [[ ${ServiceType} == "node" ]]; then
  if [[ ${TingyunApm} == "yes" ]] && [[ ${Scope} == "生产环境" ]]; then
    cat > $ServiceDir/tingyun.json <<EOF
{
  "agent_log_level": "info",
  "app_name": [
    "${Service}"
  ],
  "licenseKey": "e19e0d5031bc757598ee7872cb7f70ae",
  "host": "redirect.networkbench.com",
  "port": 443,
  "ssl": true,
  "proxy": "",
  "proxy_host": "",
  "proxy_port": "",
  "proxy_user": "",
  "proxy_pass": "",
  "audit_mode": false
}
EOF
    cat > $ServiceDir/Dockerfile <<EOF
FROM registry-vpc.cn-beijing.aliyuncs.com/vcgcs/node:8
MAINTAINER hongye.zhao@vcg.com
ADD ${Service}.tar.gz /application/
COPY tingyun.json /application/${GitDir}/
WORKDIR /application/${GitDir}/
RUN sed -i "1i require('tingyun');" ${ServiceIndex}
CMD ${ServiceCommand}
EOF
  else
    cat > $ServiceDir/Dockerfile <<EOF
FROM registry-vpc.cn-beijing.aliyuncs.com/vcgcs/node:8
MAINTAINER hongye.zhao@vcg.com
ADD ${Service}.tar.gz /application/
# ADD app-config.json /root/
WORKDIR /application/${GitDir}/
CMD ${ServiceCommand}
EOF
  fi
fi

if [[ ${ServiceType} == "java" ]]; then
  if [[ ${TingyunApm} == "yes" ]] && [[ ${Scope} == "生产环境" ]]; then
    cat > $ServiceDir/Dockerfile <<EOF
FROM registry-vpc.cn-beijing.aliyuncs.com/vcgcs/jdk8:tingyun
MAINTAINER hongye.zhao@vcg.com
ADD ${Service}.jar /application/
WORKDIR /application/
RUN sed -i "s/Java Application/${Service}/g" /application/tingyun/tingyun.properties
CMD ${ServiceCommand} -Djava.security.egd=file:/dev/./urandom -Dspring.cloud.consul.host=consul-consul ${Service}.jar
EOF
  else
    cat > $ServiceDir/Dockerfile <<EOF
FROM $ServiceImageFrom
MAINTAINER hongye.zhao@vcg.com
ADD ${Service}.jar /application/
WORKDIR /application/
CMD ${ServiceCommand} -Djava.security.egd=file:/dev/./urandom -Dspring.cloud.consul.host=consul-consul ${Service}.jar
EOF
  fi
fi

if [[ ${ServiceType} == "php" ]]; then
  if [[ -f ${GitDir}/Dockerfile ]]; then
    echo 'Git 中存在 Dockerfile ，不再生成。'
    cd ${GitDir}
    git checkout ${Branch}
    cd ../
    cat ${GitDir}/Dockerfile > $ServiceDir/Dockerfile
  else
    echo '无Dockerfile，异常退出。'
    exit 1
  fi
  if [[ ${Service} == "api-gateway-v2-vcg-com" ]] && [[ ${Scope} == "生产环境" ]]; then
    cat > $ServiceDir/Dockerfile <<EOF
FROM registry-vpc.cn-beijing.aliyuncs.com/vcgcs/lnmp
MAINTAINER dongyu.han <873379619@qq.com>

COPY api-gateway-v2-vcg-com.tar.gz /var/workspace/api-gateway-v2-vcg-com.tar.gz
RUN mkdir /var/workspace/agw/  \
  &&  tar xf /var/workspace/api-gateway-v2-vcg-com.tar.gz -C /var/workspace/agw/ \
  && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN chown -R newgame.newgame /var/workspace/agw/
RUN sed -i 's/'192.168.10.10'/'192.168.152.10'/g' /var/workspace/agw/conf/nginx.conf
RUN ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access_80.log \
&& ln -sf /dev/stderr /usr/local/openresty/nginx/logs/access_80.log
ENTRYPOINT /usr/local/openresty/nginx/sbin/nginx -g 'daemon off;' -c '/var/workspace/agw/conf/nginx.conf'
EOF
  fi
fi

cat $ServiceDir/Dockerfile
