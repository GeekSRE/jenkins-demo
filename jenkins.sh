#!/bin/bash

set -e

Service=$2
Branch=$3
Scope=$4
DateTmp=$(printf "%.3f" `echo "scale=3;$5/1000"|bc`)
Date=`date -d @${DateTmp} "+%Y%m%d%H%M%S"`
BranchOrTag=$6

echo "传递的参数为：$*";

source ./app-info/app-java.sh
source ./app-info/app-node.sh
source ./app-info/app-php.sh

# 环境判断
# 当Branch 为 test 或 master 时，代表是 git webhook触发
# 当Branch 为 null，代表是 手动触发

if [[ ${Branch} == "null" ]]; then
  if [[ ${Scope} == "测试环境" ]]; then
    Branch="test"
  fi
  if [[ ${Scope} == "预发环境" ]]; then
    Branch="master"
  fi
  if [[ ${Scope} == "生产环境" ]]; then
    Branch="master"
  fi
  echo "+++ 手动触发 +++ Git分支为 ${Branch} ；部署环境为 ${Scope}"
else
  if [[ ${Branch} == "test" ]]; then
    Scope="测试环境"
  fi
  if [[ ${Branch} == "master" ]]; then
    Scope="预发环境"
  fi
  if [[ ${Branch} != "master" ]] && [[ ${Branch} != "test" ]]; then
    echo "非 master 或者 test 分支的 WebHook 不做任何操作 "
    exit 1
  fi
  echo "+++ Git WebHook触发 +++ 触发分支为 ${Branch} ；部署环境为 ${Scope} "
fi

if [[ ${Scope} == "测试环境" ]]; then
  ServiceNum=${ServiceNumPre}
  NameSpace="default"
  ServiceCommand=${ServiceCommandTest}
  ScopeEnv="su - cicd-test -c"
  ScopeName='test'
  Cloud="ali"
fi

if [[ ${Scope} == "预发环境" ]]; then
  ServiceNum=${ServiceNumPre}
  NameSpace="default"
  ServiceCommand=${ServiceCommandPre}
  ScopeEnv="su - cicd-pre -c"
  ScopeName='pre'
  Cloud="ali"
fi

if [[ ${Scope} == "生产环境" ]]; then
  ServiceNum=${ServiceNumPro}
  NameSpace="default"
  ServiceCommand=${ServiceCommandPro}
  ScopeEnv="su - cicd-pro -c"
  ScopeName='pro'
  Cloud="ali"
fi

if [[ ${Scope} == "灾备环境" ]]; then
  ServiceNum=${ServiceNumPre}
  NameSpace="default"
  ServiceCommand=${ServiceCommandTencent}
  ScopeEnv="su - cicd-tx -c"
  ScopeName='tx'
  Cloud="tx"
fi

# 当前项目 /jenkins/workspace/....
WorkDir=`pwd`
ServiceDir=/jenkins/vcgapp/${Service}/${ScopeName}
mkdir -p $ServiceDir
echo "工作目录为 : ${WorkDir} , 制品仓库目录为 : ${ServiceDir} "

CheckOut()
{
  source ./build/checkout.sh
}
BuildPackage()
{
  source ./build/build-package.sh
}

BuildDockerfile()
{
  source ./build/build-dockerfile.sh
}
DockerBuildPush()
{
  if [[ ${Scope} == "生产环境" ]]; then
    if [[ ${ServiceType} == "java" ]]; then
      rm -f ${ServiceDir}/${Service}.jar
      cp /jenkins/vcgapp/${Service}/pre/${Service}.jar ${ServiceDir}/${Service}.jar
      echo "拷贝预发布的应用包到 ${ServiceDir} "
      ls -l ${ServiceDir}/${Service}.jar
      cp ${ServiceDir}/${Service}.jar ${ServiceDir}/${Service}.jar-bak-${Date}
      echo "应用包加时间戳，用于备份"
      ls -l ${ServiceDir}/${Service}.jar-bak-${Date}
    else
      rm -f ${ServiceDir}/${Service}.tar.gz
      cp /jenkins/vcgapp/${Service}/pre/${Service}.tar.gz ${ServiceDir}/${Service}.tar.gz
      echo "拷贝预发布的应用包到 ${ServiceDir} "
      ls -l ${ServiceDir}/${Service}.tar.gz
      cp ${ServiceDir}/${Service}.tar.gz ${ServiceDir}/${Service}.tar.gz-bak-${Date}
      echo "应用包加时间戳，用于备份"
      ls -l ${ServiceDir}/${Service}.tar.gz-bak-${Date}
    fi
  fi
  source ./build/docker-build-push.sh
}

BuildK8SYaml()
{
  if [[ ${ServiceStartTime} ]]; then
    echo "程序的ServiceStartTime启动时间变量为 ${ServiceStartTime} "
  else
    if [[ ${ServiceType} == "java" ]]; then
      ServiceStartTime="100"
    else
      ServiceStartTime="30"
    fi
    echo "程序的ServiceStartTime启动时间变量为 ${ServiceStartTime} "
  fi

  if [[ ${Scope} == "测试环境" ]]; then
    source ./build/build-${Cloud}-test-k8s-yaml.sh
  fi

  if [[ ${Scope} == "预发环境" ]]; then
    if [[ -f ./app-k8s-yaml/${Service}.sh ]] && [[ ${Service} != 'com-veer-veerservice' ]]; then
      echo "./app-k8s-yaml/${Service}.sh 存在，将生成 自定义（非模板）yaml文件。"
      source ./app-k8s-yaml/${Service}.sh
    else
      source ./build/build-${Cloud}-k8s-yaml.sh
    fi
  fi

  if [[ ${Scope} == "生产环境" ]]; then
    # if [[ ${Service} == 'com-veer-veerservice' ]]; then
    #   source ./app-k8s-yaml/com-veer-veerservice.sh
    if [[ -f ./app-k8s-yaml/${Service}.sh ]]; then
      echo "./app-k8s-yaml/${Service}.sh 存在，将生成 自定义（非模板）yaml文件。"
      source ./app-k8s-yaml/${Service}.sh
    else
      source ./build/build-${Cloud}-k8s-yaml.sh
    fi
  fi

  echo "$ServiceDir/${Service}.yaml 文件内容："
  cat $ServiceDir/${Service}.yaml

}

Deploy()
{
  $ScopeEnv "kubectl apply -f $ServiceDir/${Service}.yaml"
  echo "Action:Deploy,ScopeName:${ScopeName},ServiceName:${Service},time:$Date,image:registry-vpc.cn-beijing.aliyuncs.com/vcg/${Service}:$date" >> /jenkins/vcgapp/${ScopeName}_deploy_history.txt
}

# 回滚命令 kubectl rollout undo deployment/node-vcg-web

case "$1" in
CheckOut)
  CheckOut
  ;;
BuildPackage)
  BuildPackage
  ;;
BuildDockerfile)
  BuildDockerfile
  ;;
DockerBuildPush)
  DockerBuildPush
  ;;
BuildK8SYaml)
  BuildK8SYaml
  ;;
Deploy)
  Deploy
  ;;
*)
  echo $"Usage: $0 {CheckOut|BuildPackage|BuildDockerfile|DockerBuildPush|BuildK8SYaml|Deploy}"
  exit 1
esac
