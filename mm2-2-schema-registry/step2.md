### Start the Redpanda cluster
There are several ways to set up Redpanda; in this guide, we'll focus on using the Docker images. You can quickly get Redpanda clusters up and running with Docker Compose or Kubernetes.

You'll start three services:

**redpanda-0** : This is the broker's name. In this lab, because of limited resources, we're just spinning up a single broker. But remember, in a real-world setup, you'd have multiple brokers for high availability, fault tolerance, and better scaling.

**redpanda-console**: This links to the Redpanda Console, which is the official UI for Redpanda.

**connect**: This Docker image is used to set up managed connectors for Redpanda.

Alright, it's time to get these services going. Kick them off with the following command:
```
docker-compose -f docker-compose-rp.yaml up -d 
```{{exec}}

Please be patient for a moment. You'll know it's done when you see:

```
Creating redpanda-0     ... done
Creating root_connect_1 ... done
Creating redpanda-console ... done
```


