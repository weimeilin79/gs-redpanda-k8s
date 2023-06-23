Grafana is a popular open-source monitoring tool used in Kubernetes. It enables the creation of visually appealing dashboards and graphs to visualize and analyze metrics collected from various data sources, including Prometheus. Redpanda provides template Grafana dashboards with guidelines and example queries using Redpanda's public metrics to monitor it's performance and health.

Again, with limited capacity, we will adjust the storage for Grafana to 2 GB: 
```
cat <<EOF | kubectl -n monitoring apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  annotations:
    volume.beta.kubernetes.io/storage-provisioner: rancher.io/local-path
    volume.kubernetes.io/storage-provisioner: rancher.io/local-path
  name: grafana-pvc
  namespace: monitoring
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  storageClassName: local-path
  volumeMode: Filesystem
EOF
```{{exec}}

There are many ways to setup Grafana, such as helm or operator, but to make it simple, we will just use Kubernetes manifests for the setup this time:
```
cat <<EOF | kubectl -n monitoring apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: grafana
  name: grafana
spec:
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      securityContext:
        fsGroup: 472
        supplementalGroups:
          - 0
      containers:
        - name: grafana
          image: grafana/grafana:9.1.0
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 3000
              name: http-grafana
              protocol: TCP
          readinessProbe:
            failureThreshold: 3
            httpGet:
              path: /robots.txt
              port: 3000
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 30
            successThreshold: 1
            timeoutSeconds: 2
          livenessProbe:
            failureThreshold: 3
            initialDelaySeconds: 30
            periodSeconds: 10
            successThreshold: 1
            tcpSocket:
              port: 3000
            timeoutSeconds: 1
          resources:
            requests:
              cpu: 250m
              memory: 250Mi
          volumeMounts:
            - mountPath: /var/lib/grafana
              name: grafana-pv
      volumes:
        - name: grafana-pv
          persistentVolumeClaim:
            claimName: grafana-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
spec:
  ports:
    - port: 3000
      protocol: TCP
      targetPort: http-grafana
  selector:
    app: grafana
  sessionAffinity: None
EOF
```{{exec}}

Check if the Grafana pod is ready and running:
```
kubectl get pod -n monitoring
```{{exec}}

You should be able to see a grafana instance is ready and in running state:
```
NAME                                                 READY   STATUS    RESTARTS   AGE
grafana-bf6c9bd55-z8f7r                              1/1     Running   0          82s
```


Run the following command to export Grafana Dashboard:
```
kubectl -n monitoring delete Ingress prometheus-ingress
cat <<EOF | kubectl -n monitoring apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana-ingress
  annotations:
    ingress.kubernetes.io/rewrite-target: /
spec:
    rules:
    - http:
        paths:
        - backend:
            service:
              name: grafana
              port:
                number: 3000
          path: /
          pathType: ImplementationSpecific
EOF
```{{exec}}

Give it a couple of minutes to start. (Refresh it if you see 503 Service Temporarily Unavailable. This is a very limited cluster.) Click [Grafana Console]({{TRAFFIC_HOST1_80}}/) to access it in your browser. Login with ID/PWD, admin/admin
[Grafana Login](./images/step-2-grafana-login.png)

Skip the password change:
[Grafana Login](./images/step-2-grafana-skip-pwd.png)

First, configure the data source, 
http://prometheus-server:80
step-2-datasource.png

Add 3 Dashboard to Grafana