cat > $ServiceDir/${Service}.yaml <<EOF
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  creationTimestamp: null
  name: ${Service}
  namespace: ${NameSpace}
spec:
  replicas: $ServiceNum
  revisionHistoryLimit: 5
  selector:
    matchLabels:
      qcloud-app: ${Service}
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
    spec:
      containers:
      - image: ccr.ccs.tencentyun.com/vcgtx/${Service}:${ScopeName}-${Date}
        imagePullPolicy: Always
        name: ${Service}
        resources:
          limits:
            cpu: "1"
            memory: 4Gi
          requests:
            cpu: 500m
            memory: 1Gi
        securityContext:
          privileged: false
      serviceAccountName: ""
      volumes: null
status: {}

---
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  name: ${Service}
  namespace: ${NameSpace}
spec:
  ports:
  - name: tcp-${ServicePort}-${ServicePort}
    nodePort: 0
    port: 80
    protocol: TCP
    targetPort: ${ServicePort}
  selector: {}
  type: ClusterIP
status:
  loadBalancer: {}

EOF
