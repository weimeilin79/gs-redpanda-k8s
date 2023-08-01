We're just about finished. The last thing we'd like to show you is Redpanda Console.

Redpanda Console is the official UI for Redpanda, and was one of the services we started in the `docker-compose.yaml` file.

Since this tutorial is running on a dynamically provisioned machine, you'll need to get the URL of the Redpanda Console instance by running this command.
```
sed 's/PORT/8080/g' /etc/killercoda/host
```{{exec}}

The URL will print to the terminal. Click it and you should see the UI. Note: some features are not fully enabled in this environment. Also, if you see an error while browsing around, try reloading the link.

Anyways, feel free to look around Redpanda Console, especially on the __Overview__ and __Topics__ page, to get an idea about what sorts of features it has.