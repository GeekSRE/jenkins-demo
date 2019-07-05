#      JAVA  程序
#      JAVA  程序
#      JAVA  程序

if [[ ${Service} == "edgeservice-vcg-com" ]]; then
    ServiceType="java"
    GitAddress="git@git.visualchina.com:edit/edge.git"
    GitDir=`echo ${GitAddress}|awk -F'/' '{print $2}'|awk -F'.git' '{print $1}'`
    PomDir="edge2-parent/edge2-service"
    ServicePort="8010"
    ServiceCommandTest="java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=1${ServicePort},suspend=n -jar -Xms2000m -Xmx2000m -Dserver.port=8010 -Dspring.profiles.active=test"
    ServiceCommandPre="java -jar -Xms2000m -Xmx2000m -Dserver.port=8010 -Dspring.profiles.active=production21"
    ServiceCommandPro="java -javaagent:/application/tingyun/tingyun-agent-java.jar -jar -Xms2000m -Xmx4000m -Dspring.profiles.active=production  -Dcom.sun.management.jmxremote.port=62222 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
    ServiceDomain="edgeservice.vcg.com"
    ServiceImageFrom="registry-vpc.cn-beijing.aliyuncs.com/vcgcs/jdk8"
    ServiceStartTime="60"
    TingyunApm="yes"
    ServiceNumPre="1"
    ServiceNumPro="6"
fi
