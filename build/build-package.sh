# 打包前：
# 1、替换测试环境数据库连接
# 2、替换数据库账号密码
# 3、替换程序连接地址

if [[ ${ServiceType} == "node" ]]; then
    cd ${GitDir}
    if [[ ${DbConf} ]]; then
      sed -i "s/192.168.0.160/rm-2ze0l8o119iodvq8b.mysql.rds.aliyuncs.com/g" ${DbConf}
      sed -i "s/port: 3310/port: 3306/g" ${DbConf}
      sed -i "s/user: 'mysql'/user: 'rm-2ze0l8o119iodvq8b_Username'/g" ${DbConf}
      sed -i "s/password: 'mysql1a2s'/password: 'rm-2ze0l8o119iodvq8b_Password'/g" ${DbConf}
      sed -i "s/192.168.23.119/c233b103f81247fd.redis.rds.aliyuncs.com/g" ${DbConf}
      sed -i "s/192.168.0.61:9100/172.16.240.15:9100/g" $DbConf
      sed -i "s/192.168.0.61:8081/172.16.240.15:8081/g" $DbConf
      sed -i "s/192.168.0.61:9102/172.16.240.15:9102/g" $DbConf
      sed -i "s/192.168.0.61:9118/172.16.240.15:9118/g" $DbConf
      sed -i "s/192.168.0.61:9120/172.16.240.15:9120/g" $DbConf
      sed -i "s/192.168.0.61:9125/172.16.240.15:9125/g" $DbConf
      sed -i "s/192.168.0.61:9130/172.16.240.15:9130/g" $DbConf
      sed -i "s/192.168.0.61:9131/172.16.240.15:9130/g" $DbConf
      # sed -i "s/192.168.0.206:8081/106.120.217.169:38081/g" $i
      sed -i "s/192.168.0.206:9108/172.16.240.15:9108/g" $DbConf
      # sed -i "s/192.168.0.61:9110/106.120.217.169:39110/g" $i
      sed -i "s/60.205.122.15/172.16.241.81/g" ${DbConf}
      for DBInstanceId in `cat $WorkDir/build/DBInstanceId.txt`; do
          sed -i "s/${DBInstanceId}_Username/*************/g" ${DbConf}
          sed -i "s/${DBInstanceId}_Password/*************/g" ${DbConf}
      done
      echo '   ######   已替换数据库信息   ######   '
    fi

    sed -i "s/apiservice.vcg.com/apiservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/authservice.vcg.com/authservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/cmsservice.vcg.com/cmsservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/downloadservice.vcg.com/downloadservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/editservice.vcg.com/editservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/enedit.service.vcg.com/eneditservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/enresource.enservice.vcg.com/enresource-enservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/edgeservice.vcg.com/edgeservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/edgeserviceweb.vcg.com/edgeserviceweb-vcg-com/g" ${ServiceConfig}
    sed -i "s/providerservice.vcg.com/providerservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/portaledgeservice.vcg.com/portaledgeservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/portalservice.vcg.com/portalservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/passportservice.vcg.com/passportservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/paservice.vcg.com/com-vcg-pa-service/g" ${ServiceConfig}
    sed -i "s/resourceservice.vcg.com/resourceservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/sellonlineservice.vcg.com/sellonlineservice-vcg-com/g" ${ServiceConfig}
    sed -i "s/utilservice.vcg.com/utilservice-vcg-com/g" ${ServiceConfig}

    sed -i "s/tools.download.vcg.com/tools-download-vcg-com/g" ${ServiceConfig}
    sed -i "s/cms.vcg.com/node-vcg-cms/g" ${ServiceConfig}
    sed -i "s/www.vcg.com/node-vcg-web/g" ${ServiceConfig}
    sed -i "s/edit.vcg.com/node-vcg-edit/g" ${ServiceConfig}
    sed -i "s/apiserver.vcg.com/node-vcg-api/g" ${ServiceConfig}

    sed -i "s/finance.veer.com/com-veer-finance/g" ${ServiceConfig}
    sed -i "s/veerservice.veer.com/com-veer-veerservice/g" ${ServiceConfig}
    sed -i "s/cmsapi.veer.com/com-veer-cms/g" ${ServiceConfig}

    sed -i "s/finance.boss.vcg.com/vcg-boss-finance/g" ${ServiceConfig}
    sed -i "s/leader.boss.vcg.com/vcg-boss-leader/g" ${ServiceConfig}
    sed -i "s/niche.boss.vcg.com/vcg-boss-niche/g" ${ServiceConfig}
    sed -i "s/account.boss.vcg.com/vcg-boss-account/g" ${ServiceConfig}
    sed -i "s/settle.boss.vcg.com/vcg-boss-settle/g" ${ServiceConfig}
    sed -i "s/common.boss.vcg.com/vcg-boss-common/g" ${ServiceConfig}
    sed -i "s/contract.boss.vcg.com/vcg-boss-contract/g" ${ServiceConfig}

    if [[ ${Service} == 'node-vcg-api-b' ]] || [[ ${Service} == 'node-visualchina-web-b' ]] || [[ ${Service} == 'node-visualchina-web3-b' ]] ; then
      sed -i "s/vcg-com/vcg-com.pre.visualchina.com/g" ${ServiceConfig}
      sed -i "s/com-vcg-pa-service/com-vcg-pa-service.pre.visualchina.com/g" ${ServiceConfig}
      sed -i "s/node-vcg-api/node-vcg-api-b/g" ${ServiceConfig}
      sed -i "s/node-vcg-web/node-vcg-web-b/g" ${ServiceConfig}
      sed -i "s/vcg-boss-finance/vcg-boss-finance.pre.visualchina.com/g" ${ServiceConfig}
      sed -i "s/vcg-boss-leader/vcg-boss-leader.pre.visualchina.com/g" ${ServiceConfig}
      sed -i "s/vcg-boss-niche/vcg-boss-niche.pre.visualchina.com/g" ${ServiceConfig}
      sed -i "s/vcg-boss-account/vcg-boss-account.pre.visualchina.com/g" ${ServiceConfig}
      sed -i "s/vcg-boss-settle/vcg-boss-settle.pre.visualchina.com/g" ${ServiceConfig}
      sed -i "s/vcg-boss-common/vcg-boss-common.pre.visualchina.com/g" ${ServiceConfig}
      sed -i "s/vcg-boss-contract/vcg-boss-contract.pre.visualchina.com/g" ${ServiceConfig}
    fi

    # node程序的node_modules缓存起来，名称为 $ServiceDir目录下的 ${Service}-node_modules.tar.gz
    # if [[ -f "$ServiceDir/${Service}-node_modules.tar.gz" ]]; then
    #     cp $ServiceDir/${Service}-node_modules.tar.gz .
    #     tar zxf ${Service}-node_modules.tar.gz
    # fi

    # 听云APM监控
    cp /jenkins/vcgapp/tingyun-agent-nodejs-1.7.1.tar.gz ./
    npm install tingyun-agent-nodejs-1.7.1.tar.gz -registry=https://registry.npm.taobao.org

    yarn config set registry https://registry.npm.taobao.org -g
    yarn config set sass_binary_site http://cdn.npm.taobao.org/dist/node-sass -g
    yarn install
    # tar zcf ${Service}-node_modules.tar.gz node_modules/
    # mv -f ${Service}-node_modules.tar.gz $ServiceDir

    # 拷贝静态资源到OSS 3月22日
    if [[ ${Service} == 'node-vcg-web' ]] || [[ ${Service} == 'node-vcg-web3' ]] || [[ ${Service} == 'node-visualchina-web' ]] || [[ ${Service} == 'node-visualchina-web3' ]] ; then
    # if [[ ${Service} == 'node-vcg-web3' ]] ; then
     echo "拷贝静态资源到OSS，命令为 ossutil cp -r server/public/res/ oss://static-vcg/res/ "
     ossutil cp -r -f server/public/res/ oss://static-vcg/res/
    fi

    if [[ ${Service} == 'node-vcg-web-app' ]] ; then
     echo "拷贝静态资源到OSS，命令为 ossutil cp -r public/res/ oss://static-vcg/res/ "
     ossutil cp -r -f public/res/ oss://static-vcg/res/
    fi

    cd ../
    tar zcf ${Service}.tar.gz ${GitDir}/ --exclude=.git
    mv -f ${Service}.tar.gz $ServiceDir
fi

if [[ ${ServiceType} == "java" ]] ; then
    cd ${GitDir}/${PomDir}
    # 测试环境修改数据库连接及配置信息
    for i in `find . -name '*.yml' |grep -v 'target'`; do
      sed -i "s/192.168.0.160:..../rm-2ze0l8o119iodvq8b.mysql.rds.aliyuncs.com/g" $i
      sed -i "s/2ze0l8o119iodvq8b5o/2ze0l8o119iodvq8b/g" $i
      sed -i "s/2ze0l8o119iodvq8b8o/2ze0l8o119iodvq8b/g" $i
      sed -i "s/rm-2ze0l8o119iodvq8b8o/rm-2ze0l8o119iodvq8b/g" $i
      sed -i "s/rm-2zec526nd9v7a99n3o/rm-2zec526nd9v7a99n3/g" $i
      sed -i "s/192.168.23.119/c233b103f81247fd.redis.rds.aliyuncs.com/g" $i
      sed -i "s/username: javaapp/username: rm-2ze0l8o119iodvq8b_Username/g" $i
      sed -i "s/username: mysql/username: rm-2ze0l8o119iodvq8b_Username/g" $i
      sed -i "s/username: bi/username: rm-2zec526nd9v7a99n3_Username/g" $i
      sed -i "s/username: leader/username: rm-2ze0l8o119iodvq8b_Username/g" $i
      sed -i "s/password: mysql1a2s/password: rm-2ze0l8o119iodvq8b_Password/g" $i
      sed -i "s/password: javaapp@123/password: rm-2ze0l8o119iodvq8b_Password/g" $i
      sed -i "s/password: javaappA_j/password: rm-2ze0l8o119iodvq8b_Password/g" $i
      sed -i "s/password: leader123/password: rm-2ze0l8o119iodvq8b_Password/g" $i
      sed -i "s/password: bi@123abc/password: rm-2zec526nd9v7a99n3_Password/g" $i
      sed -i "s/192.168.0.61:9100/172.16.240.15:9100/g" $i
      sed -i "s/192.168.0.61:8081/172.16.240.15:8081/g" $i
      sed -i "s/192.168.0.61:9102/172.16.240.15:9102/g" $i
      sed -i "s/192.168.0.61:9118/172.16.240.15:9118/g" $i
      sed -i "s/192.168.0.61:9120/172.16.240.15:9120/g" $i
      sed -i "s/192.168.0.61:9125/172.16.240.15:9125/g" $i
      sed -i "s/192.168.0.61:9130/172.16.240.15:9130/g" $i
      sed -i "s/192.168.0.61:9131/172.16.240.15:9130/g" $i
      # sed -i "s/192.168.0.206:8081/106.120.217.169:38081/g" $i
      sed -i "s/192.168.0.206:9108/172.16.240.15:9108/g" $i
      # sed -i "s/192.168.0.61:9110/106.120.217.169:39110/g" $i
      sed -i "s/192.168.23.120:9200/106.120.217.169:39200/g" $i
      sed -i "s/60.205.122.15/172.16.241.81/g" $i
    done
    # 替换数据库账号密码
    for DBInstanceId in `cat $WorkDir/build/DBInstanceId.txt`; do
        sed -i "s/${DBInstanceId}_Username/********/g" `find . -name '*.yml' |grep -v 'target'`
        sed -i "s/${DBInstanceId}_Password/********/g" `find . -name '*.yml' |grep -v 'target'`
    done
    echo "   ######   JAVA程序 ${Service}  已替换数据库信息   ######   "
    for i in `find . -name '*.yml' |grep -v 'target'`; do
      sed -i "s/apiservice.vcg.com/apiservice-vcg-com/g" $i
      sed -i "s/authservice.vcg.com/authservice-vcg-com/g" $i
      sed -i "s/cmsservice.vcg.com/cmsservice-vcg-com/g" $i
      sed -i "s/downloadservice.vcg.com/downloadservice-vcg-com/g" $i
      sed -i "s/editservice.vcg.com/editservice-vcg-com/g" $i
      sed -i "s/enedit.service.vcg.com/eneditservice-vcg-com/g" $i
      sed -i "s/enresource.enservice.vcg.com/enresource-enservice-vcg-com/g" $i
      sed -i "s/edgeservice.vcg.com/edgeservice-vcg-com/g" $i
      sed -i "s/edgeserviceweb.vcg.com/edgeserviceweb-vcg-com/g" $i
      sed -i "s/providerservice.vcg.com/providerservice-vcg-com/g" $i
      sed -i "s/portaledgeservice.vcg.com/portaledgeservice-vcg-com/g" $i
      sed -i "s/portalservice.vcg.com/portalservice-vcg-com/g" $i
      sed -i "s/passportservice.vcg.com/passportservice-vcg-com/g" $i
      sed -i "s/paservice.vcg.com/com-vcg-pa\-service/g" $i
      sed -i "s/resourceservice.vcg.com/resourceservice-vcg-com/g" $i
      sed -i "s/sellonlineservice.vcg.com/sellonlineservice-vcg-com/g" $i
      sed -i "s/utilservice.vcg.com/utilservice-vcg-com/g" $i

      sed -i "s/tools.download.vcg.com/tools-download-vcg-com/g" $i
      sed -i "s/tools.download.visualchina.com/tools-download-vcg-com/g" $i

      sed -i "s/cms.vcg.com/node-vcg-cms/g" $i
      #sed -i "s/www.vcg.com/node-vcg-web/g" $i
      sed -i "s/edit.vcg.com/node-vcg-edit/g" $i
      sed -i "s/apiserver.vcg.com/node-vcg-api/g" $i

      sed -i "s/finance.veer.com/com-veer-finance/g" $i
      sed -i "s/veerservice.veer.com/com-veer-veerservice/g" $i
      sed -i "s/cmsapi.veer.com/com-veer-cms/g" $i

      sed -i "s/finance.boss.vcg.com/vcg-boss-finance/g" $i
      sed -i "s/leader.boss.vcg.com/vcg-boss-leader/g" $i
      sed -i "s/niche.boss.vcg.com/vcg-boss-niche/g" $i
      sed -i "s/account.boss.vcg.com/vcg-boss-account/g" $i
      sed -i "s/settle.boss.vcg.com/vcg-boss-settle/g" $i
      sed -i "s/common.boss.vcg.com/vcg-boss-common/g" $i
      sed -i "s/contract.boss.vcg.com/vcg-boss-contract/g" $i
      sed -i "s/test-rss.api.vcg.com/rss-api-vcg-com/g" $i
      sed -i "s/rss.api.fotomore.com/rss-api-vcg-com/g" $i

    done
    echo "   ######   JAVA程序 ${Service}  已将域名信息替换为服务名，用于服务调用   ######   "
    # 此文件由真河提供，用于java之间调用的话，需要通过consul获取服务address，通过此文件可将服务名返回给调用方。
    # veer应用不用consul
    if [[ ${Service} != 'com-veer-veerservice' ]] && [[ ${Service} != 'com-veer-cms' ]] && [[ ${Service} != 'vcg-gateway' ]] && [[ ${Service} != 'wechatservice-vcg-com' ]]&& [[ ${Service} != 'behaviourservice-vcg-com' ]]; then
      mkdir -p src/main/java/org/springframework/cloud/consul/discovery/
      cp $WorkDir/build/ConsulServerList.java src/main/java/org/springframework/cloud/consul/discovery/ConsulServerList.java
    fi
    mvn clean package -Dmaven.test.skip=true -e -U
    mv -f `ls target/*.jar|grep -v "sources.jar"` $ServiceDir/${Service}.jar
fi

if [[ ${ServiceType} == "php" ]]; then
    cd ${GitDir}
    if [[ ${DbConf} ]]; then
      sed -i "s/192.168.0.160/rm-2ze0l8o119iodvq8b.mysql.rds.aliyuncs.com/g" ${DbConf}
      sed -i "s/port: 3310/port: 3306/g" ${DbConf}
      sed -i "s/user: 'mysql'/user: 'rm-2ze0l8o119iodvq8b_Username'/g" ${DbConf}
      sed -i "s/password: 'mysql1a2s'/password: 'rm-2ze0l8o119iodvq8b_Password'/g" ${DbConf}
      sed -i "s/192.168.23.119/c233b103f81247fd.redis.rds.aliyuncs.com/g" ${DbConf}
      sed -i "s/192.168.0.61:9100/172.16.240.15:9100/g" $DbConf
      sed -i "s/192.168.0.61:8081/172.16.240.15:8081/g" $DbConf
      sed -i "s/192.168.0.61:9102/172.16.240.15:9102/g" $DbConf
      sed -i "s/192.168.0.61:9118/172.16.240.15:9118/g" $DbConf
      sed -i "s/192.168.0.61:9120/172.16.240.15:9120/g" $DbConf
      sed -i "s/192.168.0.61:9125/172.16.240.15:9125/g" $DbConf
      sed -i "s/192.168.0.61:9130/172.16.240.15:9130/g" $DbConf
      sed -i "s/192.168.0.61:9131/172.16.240.15:9130/g" $DbConf
      # sed -i "s/192.168.0.206:8081/106.120.217.169:38081/g" $i
      sed -i "s/192.168.0.206:9108/172.16.240.15:9108/g" $DbConf
      # sed -i "s/192.168.0.61:9110/106.120.217.169:39110/g" $i
      sed -i "s/192.168.23.120:9200/106.120.217.169:39200/g" ${DbConf}
      for DBInstanceId in `cat $WorkDir/build/DBInstanceId.txt`; do
          sed -i "s/${DBInstanceId}_Username/********/g" ${DbConf}
          sed -i "s/${DBInstanceId}_Password/********/g" ${DbConf}
      done
      echo '   ######   已替换数据库信息   ######   '

      sed -i "s/apiservice.vcg.com/apiservice-vcg-com/g" ${DbConf}
      sed -i "s/authservice.vcg.com/authservice-vcg-com/g" ${DbConf}
      sed -i "s/cmsservice.vcg.com/cmsservice-vcg-com/g" ${DbConf}
      sed -i "s/downloadservice.vcg.com/downloadservice-vcg-com/g" ${DbConf}
      sed -i "s/editservice.vcg.com/editservice-vcg-com/g" ${DbConf}
      sed -i "s/enedit.service.vcg.com/eneditservice-vcg-com/g" ${DbConf}
      sed -i "s/enresource.enservice.vcg.com/enresource-enservice-vcg-com/g" ${DbConf}
      sed -i "s/edgeservice.vcg.com/edgeservice-vcg-com/g" ${DbConf}
      sed -i "s/edgeserviceweb.vcg.com/edgeserviceweb-vcg-com/g" ${DbConf}
      sed -i "s/providerservice.vcg.com/providerservice-vcg-com/g" ${DbConf}
      sed -i "s/portaledgeservice.vcg.com/portaledgeservice-vcg-com/g" ${DbConf}
      sed -i "s/portalservice.vcg.com/portalservice-vcg-com/g" ${DbConf}
      sed -i "s/passportservice.vcg.com/passportservice-vcg-com/g" ${DbConf}
      sed -i "s/paservice.vcg.com/com-vcg-pa-service/g" ${DbConf}
      sed -i "s/resourceservice.vcg.com/resourceservice-vcg-com/g" ${DbConf}
      sed -i "s/sellonlineservice.vcg.com/sellonlineservice-vcg-com/g" ${DbConf}
      sed -i "s/utilservice.vcg.com/utilservice-vcg-com/g" ${DbConf}

      sed -i "s/cms.vcg.com/node-vcg-cms/g" ${DbConf}
      sed -i "s/www.vcg.com/node-vcg-web/g" ${DbConf}
      sed -i "s/edit.vcg.com/node-vcg-edit/g" ${DbConf}
      sed -i "s/apiserver.vcg.com/node-vcg-api/g" ${DbConf}

      sed -i "s/finance.veer.com/com-veer-finance/g" ${DbConf}
      sed -i "s/veerservice.veer.com/com-veer-veerservice/g" ${DbConf}
      sed -i "s/cmsapi.veer.com/com-veer-cms/g" ${DbConf}

      sed -i "s/finance.boss.vcg.com/vcg-boss-finance/g" ${DbConf}
      sed -i "s/leader.boss.vcg.com/vcg-boss-leader/g" ${DbConf}
      sed -i "s/niche.boss.vcg.com/vcg-boss-niche/g" ${DbConf}
      sed -i "s/account.boss.vcg.com/vcg-boss-account/g" ${DbConf}
      sed -i "s/settle.boss.vcg.com/vcg-boss-settle/g" ${DbConf}
      sed -i "s/common.boss.vcg.com/vcg-boss-common/g" ${DbConf}
      sed -i "s/contract.boss.vcg.com/vcg-boss-contract/g" ${DbConf}
    fi
    cd ../
    tar zcf ${Service}.tar.gz -C ${GitDir} .
    # tar zcf ${Service}.tar.gz ${GitDir}/ --exclude=.git
    mv -f ${Service}.tar.gz $ServiceDir
fi
