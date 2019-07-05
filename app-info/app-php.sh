#      PHP  程序
#      PHP  程序
#      PHP  程序

if [[ ${Service} == "rss-api-vcg-com" ]]; then
    ServiceType="php"
    GitAddress="git@git.visualchina.com:vcgapi/rss.git"
    GitDir=`echo ${GitAddress}|awk -F'/' '{print $2}'|awk -F'.git' '{print $1}'`
    if [[ ${Scope} == "测试环境" ]]; then
      DbConf=".env.test"
    else
      DbConf=".env.rss"
    fi
    ServiceDomain="rss.api.vcg.com"
    ServicePort="80"
    ServiceNumPre="1"
    ServiceNumPro="3"
fi
