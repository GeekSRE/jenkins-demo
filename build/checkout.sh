echo "Git地址是 ${GitAddress}, 分支为 ${Branch} "
if [[ -d "${GitDir}" ]]; then
  rm -rf ${GitDir}
fi

if [[ ${BranchOrTag} ]]; then
  #先判断是branch还是tag
  git clone ${GitAddress}
  cd ${GitDir}
  if [[ `git branch --remote |grep ${BranchOrTag} |wc -l` -gt 0 ]]; then
    echo '${BranchOrTag} 变量是branch类型'
    git checkout ${BranchOrTag}
  elif [[ `git tag |grep ${BranchOrTag} |wc -l` -gt 0 ]]; then
    echo '${BranchOrTag} 变量是tag类型'
    git checkout ${BranchOrTag}
  else
    echo '${BranchOrTag} 变量错误，请重新输入'
    exit 1
  fi
else
  if [[ ${Branch} == "master" ]] || [[ ${Branch} == "test" ]]; then
    git clone -b ${Branch} ${GitAddress}
  fi
fi
cd ${WorkDir}
cd ${GitDir}
git rev-parse HEAD
cd ..
# if [[ -d "${GitDir}" ]] && [[ -d "${GitDir}/.git" ]] ; then
#   cd ${GitDir}
#   git status
#   git reset --hard
#   git checkout ${Branch}
#   git pull
#   echo 'git pull 更新完成'
# else
#   if [[ ${Branch} == "master" ]] || [[ ${Branch} == "test" ]] || [[ ${Branch} == "k8s" ]]; then
#     rm -rf ${GitDir}
#     git clone -b ${Branch} ${GitAddress}
#   fi
# fi
