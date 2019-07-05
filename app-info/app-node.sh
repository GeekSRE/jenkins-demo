#      NODE  程序
#      NODE  程序
#      NODE  程序

if [[ ${Service} == "node-visualchina-web" ]]; then
    ServiceType="node"
    GitAddress="git@git.visualchina.com:vcg/visualchina-web-build.git"
    ServiceConfig="server/config/index.js"
    GitDir=`echo ${GitAddress}|awk -F'/' '{print $2}'|awk -F'.git' '{print $1}'`
    ServiceCommandTest="yarn test"
    ServiceCommandPre="yarn preview"
    ServiceCommandPro="yarn online"
    ServiceImageFrom="registry-vpc.cn-beijing.aliyuncs.com/vcgcs/alinode"
    ServicePort="7200"
    TingyunApm="yes"
    ServiceIndex="server/index.js"
    ServiceNumPre="1"
    ServiceNumPro="10"
fi
