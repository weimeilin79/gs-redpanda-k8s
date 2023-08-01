In this lesson, you'll be running a local Redpanda and Flink cluster using Docker Compose. We've included the service definitions and some other material in Github. So, the first step is to simply clone the repository by running the following commands:

```
# clone the repository
git clone https://github.com/redpanda-data-university/rp-use-cases-algo-trading.git algo-trading

# change the working directory
cd algo-trading/
```{{exec}}

Next, bring up the Redpanda and Flink clusters by running:

```
docker-compose -f docker-compose-kc.yaml up -d
```{{exec}}

Wait until you see the following output before proceeding.  It may take a few seconds for the services to start.
```
Creating jobmanager ... done
Creating redpanda-1  ... done
Creating taskmanager ... done
Creating sql-client  ... done
```

The Flink UI is running on port `8081`{{}}. Since this tutorial is running on a dynamically-provisioned machine, you'll need the get the URL with the following command:

```
sed 's/PORT/8081/g' /etc/killercoda/host
```{{exec}}

Click the link that appears in the terminal, and keep the Flink UI open for the remainder of this tutorial. If you see a `Bad Gateway`{{}} error, wait a few seconds and refresh. The UI may still be spinning up.
