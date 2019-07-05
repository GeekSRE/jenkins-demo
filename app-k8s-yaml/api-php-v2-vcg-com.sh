cat > $ServiceDir/${Service}.yaml <<EOF
---
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: ${Service}
  labels:
    app: ${Service}
  namespace: ${NameSpace}
spec:
  replicas: $ServiceNum
  selector:
    matchLabels:
      app: ${Service}
  template:
    metadata:
      labels:
        app: ${Service}
    spec:
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
      hostAliases:
        - hostnames:
          - api.elephantailab.com
          ip: 172.16.237.130
      imagePullSecrets:
        - name: registry-vpc.cn-beijing.aliyuncs.com   ## 保密字典中的仓储认证
      # affinity:
      #   nodeAffinity:
      #     preferredDuringSchedulingIgnoredDuringExecution:
      #       - preference: {}
      #         weight: 100
      #     requiredDuringSchedulingIgnoredDuringExecution:
      #       nodeSelectorTerms:
      #         - matchExpressions:
      #             - key: vcgapp
      #               operator: In
      #               values:
      #                 - veerlogagent     ## node节点亲和性
      containers:
        - name: ${Service}
          image: 'registry-vpc.cn-beijing.aliyuncs.com/vcg/${Service}:${ScopeName}-${Date}'   ## 镜像地址
          env:
            - name: aliyun_logs_${Service}     ## 日志服务
              value: stdout
            - name: aliyun_logs_${Service}-apiguzzlehttp
              value: /var/workspace/php_api/storage/logs/ApiGuzzleHttp.log
            - name: aliyun_logs_${Service}-lumen
              value: /var/workspace/php_api/storage/logs/lumen.log
            - name: aliyun_logs_${Service}-search_micro_data
              value: /var/workspace/php_api/storage/logs/search_micro_data.log
          imagePullPolicy: Always
          # volumeMounts:
          #   - mountPath: /var/log/veerservice_log   # 容器内路径
          #     name: volume-veerservice
          resources:
            limits:
              cpu: '1'
              memory: 4Gi
            requests:
              cpu: 500m
              memory: 1000Mi
          livenessProbe:        ## 存活检测
            initialDelaySeconds: ${ServiceStartTime}
            periodSeconds: 10
            timeoutSeconds: 1
            successThreshold: 1
            failureThreshold: 3
            # httpGet:
            #   path: /
            #   port: ${ServicePort}
            #   scheme: HTTP
            tcpSocket:
              port: ${ServicePort}
          readinessProbe:         ## 就绪检测
            initialDelaySeconds: ${ServiceStartTime}
            periodSeconds: 10
            timeoutSeconds: 1
            successThreshold: 1
            failureThreshold: 3
            tcpSocket:
              port: ${ServicePort}
            # httpGet:
            #   scheme: HTTP
            #   path: /
            #   port: ${ServicePort}
      # volumes:
      #   - hostPath:
      #       path: /var/log/veerservice  # 主机路径
      #       type: ''
      #     name: volume-veerservice
          # livenessProbe:        ## 存活检测
          #   failureThreshold: 3
          #   httpGet:
          #     path: /
          #     port: ${ServicePort}
          #     scheme: HTTP
          #   initialDelaySeconds: 3
          #   periodSeconds: 50
          #   successThreshold: 1
          #   timeoutSeconds: 1
          # readinessProbe:         ## 就绪检测
          #   initialDelaySeconds: 3
          #   periodSeconds: 50
          #   timeoutSeconds: 1
          #   successThreshold: 1
          #   failureThreshold: 3
          #   httpGet:
          #     scheme: HTTP
          #     path: /
          #     port: ${ServicePort}
---
apiVersion: v1
kind: Service
metadata:
  name: ${Service}
  labels:
    app: ${Service}
  namespace: ${NameSpace}
spec:
  selector:
    app: ${Service}
  ports:
    - port: 80
      protocol: TCP
      targetPort: ${ServicePort}
  type: ClusterIP
EOF
