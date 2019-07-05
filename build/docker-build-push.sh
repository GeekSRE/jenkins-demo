
if [[ ${ScopeName} != 'tx' ]]; then
  docker login --username="********" --password="********" registry-vpc.cn-beijing.aliyuncs.com
  docker build -t registry-vpc.cn-beijing.aliyuncs.com/vcg/${Service}:${ScopeName}-$Date $ServiceDir
  docker push registry-vpc.cn-beijing.aliyuncs.com/vcg/${Service}:${ScopeName}-$Date
  docker rmi registry-vpc.cn-beijing.aliyuncs.com/vcg/${Service}:${ScopeName}-$Date
else
  docker login --username="********" --password="********" ccr.ccs.tencentyun.com
  docker build -t ccr.ccs.tencentyun.com/vcgtx/${Service}:${ScopeName}-$Date $ServiceDir
  docker push ccr.ccs.tencentyun.com/vcgtx/${Service}:${ScopeName}-$Date
  docker rmi registry-vpc.cn-beijing.aliyuncs.com/vcg/${Service}:${ScopeName}-$Date
fi
