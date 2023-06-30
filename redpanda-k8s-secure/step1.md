Tools in this tutorial:

- `helm`: This helps you define, install, and upgrade applications running on Kubernetes.
- `kubectl`: The Kubernetes command-line tool lets you deploy applications, inspect and manage cluster resources, and view logs in Kubernetes cluster. 
- `rpk`: The Redpanda command-line tool lets you manage your entire Redpanda cluster, without the need to run a separate script for each function, as with Apache Kafka. The `rpk` commands handle everything from configuring nodes and low-level tuning to high-level general Redpanda tasks. 

Assume you have already deploy the Redpanda cluster in Kubernetes, and everything is running smoothly, so what next? 

Let's take a look around, a Redpanda cluster with one broker has already installed for you on this single node Kubernetes environment.

![Initial State](./images/step-1-initial-state.png)

Run the following command to see what was deployed:

```
kubectl get all --namespace redpanda
```{{exec}}

you'll see a working Redpanda cluster in the _redpanda_ namespace

```
NAME                               READY   STATUS      RESTARTS   AGE
pod/redpanda-0                     2/2     Running     0          37s
pod/redpanda-configuration-4z9kw   0/1     Completed   0          37s

NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                       AGE
service/redpanda            ClusterIP   None             <none>        9644/TCP                                                      37s
service/redpanda-external   NodePort    10.108.116.179   <none>        9644:31644/TCP,9094:31092/TCP,8083:30082/TCP,8084:30081/TCP   37s

NAME                        READY   AGE
statefulset.apps/redpanda   1/1     37s

NAME                               COMPLETIONS   DURATION   AGE
job.batch/redpanda-configuration   1/1           16s        37s
```

 Securing Redpanda is crucial to protect sensitive data, maintain compliance with regulatory requirements, prevent unauthorized access and data breaches, and preserve the overall integrity and reliability of the system. First step in securing your Redpanda deployment is with Transport Layer Security (TLS). As it provides the encryption and authentication mechanisms that ensures the communication between Redpanda clients and brokers is encrypted, protecting data confidentiality. 

There are many ways to configure TLS in K8s, you have options to upload the certificates or use Cert Manager to help create and manage them. In this tutorial, we will be using Cert Manager.

*Cert Manager* is a Kubernetes controller that simplifies the process of obtaining, renewing, and using certificates.

Let's go ahead add cert-manger to the help repository:
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
```{{exec}}

And install the cert-manger:
```
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.12.0 \
  --set installCRDs=true
```{{exec}}


Redpanda helm chart allows you to configure how you want the certificate to be generated, such as setting the issuer or if the certificates are authenticated using public authorities(CA) or privately. 

```
tls:
  enabled: true
  # -- List all Certificates here,
  # then you can reference a specific Certificate's name
  # in each listener's `listeners.<listener name>.tls.cert` setting.
  certs:
    default:
      # -- To use a custom pre-installed Issuer,
      # add its name and kind to the `issuerRef` object.
      # issuerRef:
      #   name: redpanda-default-root-issuer
      #   kind: Issuer   # Can be Issuer or ClusterIssuer
      # -- To use a secret with custom tls files,
      # secretRef:
      #  name: my-tls-secret
      # -- Set the `caEnabled` flag to `true` only for Certificates
      # that are not authenticated using public authorities.
      caEnabled: true
      # duration: 43800h
    external:
      # -- To use a custom pre-installed Issuer,
      # add its name and kind to the `issuerRef` object.
      # issuerRef:
      #   name: redpanda-default-root-issuer
      #   kind: Issuer   # Can be Issuer or ClusterIssuer
      # -- To use a secret with custom tls files,
      # secretRef:
      #   name: my-tls-secret
      # -- Set the `caEnabled` flag to `true` only for Certificates
      # that are not authenticated using public authorities.
      caEnabled: true
      # duration: 43800h
```

In this tutorial, to make it simple, we'll be using the default self-signed certificate. Here is what your cluster will look like after this step

![TLS overview](./images/step-1-tls-overview.png)

Let's turn on the TLS config and leave everything as is:
```
cat <<EOF > security.yaml
tls:
  enabled: true
EOF
```{{exec}}


Let's apply the change to our current running Redpanda cluster:
```
helm upgrade --install redpanda redpanda/redpanda -n redpanda --create-namespace \
  --set force=true \
  --values security.yaml \
  --reuse-values 
```{{exec}}


Once done, you should be able to see the certificates generate, 
```
kubectl -n redpanda get certificate
```{{exec}}

```
NAME                                 READY   SECRET                               AGE
redpanda-default-cert                True    redpanda-default-cert                3m8s
redpanda-default-root-certificate    True    redpanda-default-root-certificate    3m9s
redpanda-external-cert               True    redpanda-external-cert               3m8s
redpanda-external-root-certificate   True    redpanda-external-root-certificate   3m8s
```

and the secrets that stores the actual certificate that are attached to the broker pod:

```
kubectl -n redpanda get secret -l controller.cert-manager.io/fao=true
```{{exec}}

You will see the list of the secrets:
```
NAME                                 TYPE                DATA   AGE
redpanda-default-cert                kubernetes.io/tls   3      3m38s
redpanda-default-root-certificate    kubernetes.io/tls   3      3m42s
redpanda-external-cert               kubernetes.io/tls   3      3m38s
redpanda-external-root-certificate   kubernetes.io/tls   3      3m42s
```

The certificate renewal process is handled seamlessly by cert-manager. You don't need to do anything to facilitate the renewal. However you can alway regenerate the certificate, change any spec on the certificate too: 
```
kubectl -n redpanda patch certificate redpanda-external-cert -p '[{"op": "add", "path": "/spec/dnsNames" , "value":["localhost"]}]' --type='json'
kubectl -n redpanda patch certificate redpanda-default-cert -p '[{"op": "add", "path": "/spec/dnsNames" , "value":["localhost"]}]' --type='json'
kubectl -n redpanda delete secret redpanda-external-cert
kubectl -n redpanda delete secret redpanda-default-cert
```{{exec}}

Give it a minute for the cluster to recreate the secrets, and you'll see the newly created certificate:
```
kubectl -n redpanda get secret -l controller.cert-manager.io/fao=true
```{{exec}}

Here is what you will see, a new certificate named *redpanda-external-cert* generated :
```
NAME                                 TYPE                DATA   AGE
redpanda-default-cert                kubernetes.io/tls   3      1m2s
redpanda-default-root-certificate    kubernetes.io/tls   3      7m41s
redpanda-external-cert               kubernetes.io/tls   3      1m2s
redpanda-external-root-certificate   kubernetes.io/tls   3      7m41s
```

If you have external connectivity configured for your cluster and you didn't provide an issuer in the configuration file, you must export the Certificate Authority's (CA) public certificate file from the node certificate Secret as a file named cae.crt.  

```
kubectl -n redpanda get secret redpanda-external-cert -o go-template='{{ index .data "ca.crt" | base64decode }}' > cae.crt
```{{exec}}

Let's first try connecting to the broker without the certificate, 
```
rpk cluster info  --brokers localhost:31092 
```{{exec}}

Note it will fail with error messages:
```
unable to request metadata: invalid large response size 352518912 > limit 104857600; the first three bytes received appear to be a tls alert record for TLS v1.2; is this a plaintext connection speaking to a tls endpoint?
```

Next try connect to with the exported CA certificates:
```
rpk cluster info  --brokers localhost:31092 --tls-truststore cae.crt
```{{exec}}

Result:
```
CLUSTER
=======
redpanda.43313f94-1b3d-4656-b6a0-9140ba76b6b4

BROKERS
=======
ID    HOST       PORT
0*    localhost  31092

TOPICS
======
NAME      PARTITIONS  REPLICAS
_schemas  1           1
```

*Note*, if you are seeing following error, that probably means you exported the certificate before the secret was regenerated, please delete and regenerate the certificate locally. 

```
unable to request metadata: unable to dial: x509: certificate is valid for redpanda-cluster.redpanda.redpanda.svc.cluster.local, redpanda-cluster.redpanda.redpanda.svc, redpanda-cluster.redpanda.redpanda, *.redpanda-cluster.redpanda.redpanda.svc.cluster.local, *.redpanda-cluster.redpanda.redpanda.svc, *.redpanda-cluster.redpanda.redpanda, redpanda.redpanda.svc.cluster.local, redpanda.redpanda.svc, redpanda.redpanda, *.redpanda.redpanda.svc.cluster.local, *.redpanda.redpanda.svc, *.redpanda.redpanda, not localhost
```

Do this ONLY if you see the problem above:
```
rm -f cae.crt
kubectl -n redpanda get secret redpanda-external-cert -o go-template='{{ index .data "ca.crt" | base64decode }}' > cae.crt
```{{exec}}


Next up, You can also user it for other commands, such as create topics. 
```
rpk topic create test-topic  --brokers localhost:31092 --tls-truststore cae.crt
```{{exec}}

These is the output you should see:
```
TOPIC       STATUS
test-topic  OK
```

Congrats, you have successfully secured your Redpanda with TLS in K8s.
