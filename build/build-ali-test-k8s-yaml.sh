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
---
apiVersion: v1
kind: Service
metadata:
  name: test-${Service}
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
# ---
# apiVersion: v1
# kind: Service
# metadata:
#   annotations:
#     service.beta.kubernetes.io/alicloud-loadbalancer-address-type: "internet"
#     service.beta.kubernetes.io/alicloud-loadbalancer-id: "lb-2zehdiulv2p6jurhtab0l"
#     service.beta.kubernetes.io/alicloud-loadbalancer-force-override-listeners: "true"
#     service.beta.kubernetes.io/alicloud-loadbalancer-health-check-type: 'http'
#     service.beta.kubernetes.io/alicloud-loadbalancer-health-check-connect-port: "${ServicePort}"
#     service.beta.kubernetes.io/alicloud-loadbalancer-health-check-uri: '/health'
#   labels:
#     app: ${Service}
#   name: xdebug-${Service}
#   namespace: ${NameSpace}
# spec:
#   ports:
#   - port: 1${ServicePort}
#     protocol: TCP
#     targetPort: 1${ServicePort}
#   selector:
#     app: ${Service}
#   sessionAffinity: None
#   type: LoadBalancer
EOF
