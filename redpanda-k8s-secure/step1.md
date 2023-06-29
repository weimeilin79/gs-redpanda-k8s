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

In this tutorial, to make it simple, we'll be using the default self-signed certificate. Let's turn on the TLS config and leave everything as is:

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


```
kubectl -n redpanda patch certificate redpanda-external-cert -p '[{"op": "add", "path": "/spec/dnsNames" , "value":["localhost"]}]' --type='json'
kubectl -n redpanda delete secret redpanda-external-cert
```{{exec}}

```
kubectl -n redpanda get secret redpanda-external-cert -o go-template='{{ index .data "ca.crt" | base64decode }}' > cae.crt
```{{exec}}


```
rpk cluster info  --brokers localhost:31092 
```{{exec}}

```
rpk cluster info  --brokers localhost:31092 --tls-truststore cae.crt
```{{exec}}

```
rpk topic create test-topic  --brokers localhost:31092 --tls-truststore cae.crt
```{{exec}}

```
kubectl get nodes -o yaml
```{{exec}}

