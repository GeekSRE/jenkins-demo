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
      hostAliases:
        - hostnames:
            - api.elephantailab.com
          ip: 172.16.237.130
      terminationGracePeriodSeconds: 30
      imagePullSecrets:
        - name: registry-vpc.cn-beijing.aliyuncs.com   ## 保密字典中的仓储认证
      containers:
        - name: ${Service}
          image: 'registry-vpc.cn-beijing.aliyuncs.com/vcg/${Service}:${ScopeName}-${Date}'   ## 镜像地址
          env:
            - name: aliyun_logs_${Service}     ## 日志服务
              value: stdout
          imagePullPolicy: Always
          resources:
            limits:
              cpu: '2'
              memory: 8Gi
            requests:
              cpu: '0.5'
              memory: 1Gi
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
