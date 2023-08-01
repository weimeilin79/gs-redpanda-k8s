There are many ways to deploy Redpanda, but the simplest way is to leverage the official Docker
images that the Redpanda team maintains. With these images, you can easily deploy Redpanda clusters
using Docker Compose or Kubernetes.

For development and testing environments, Docker Compose is the easiest method. It's also the
method you'll use in this scenario.

To view the relevant images and services you'll be deploying, run the following command to inspect
the `docker-compose.yaml`{{}} file:

```
grep -B1 image docker-compose.yaml
```{{exec}}

You'll see two services:

- `redpanda-1`{{}} is the name of the broker. Brokers store data and handle communication with clients. In development environments like this one, it's perfectly fine to run a single broker. In production environments, you'll run multiple brokers to achieve high availability, fault tolerance, and scalability.

- `redpanda-console` corresponds with the <a href="https://github.com/redpanda-data/console" target="_blank">Redpanda Console</a>, the official UI for Redpanda. You'll get a peek at this shortly.

Now, it's time to start the services. To do so, run the following command:
```
docker-compose up -d
```{{exec}}


Wait until you see the following output before proceeding. It may take a few seconds to spin up the services.

```
Creating redpanda-1 ... done
Creating redpanda-console ... done
```{{}}

Once the services have started, click Next to proceed to the next step.



