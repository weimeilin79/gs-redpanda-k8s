curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
alias helm=/usr/local/bin/helm


helm pull redpanda/redpanda --untar
rm redpanda/values.schema.json


#wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz 
#tar xvf helm-v3.9.3-linux-amd64.tar.gz
#sudo mv linux-amd64/helm /usr/local/bin
#helm repo add redpanda https://charts.redpanda.com 




  