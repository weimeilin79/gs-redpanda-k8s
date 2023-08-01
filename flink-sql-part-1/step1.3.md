Apache Flink comes with a UI that provides an overview of the Flink cluster. You can use it to track the status of jobs and tasks, view cluster logs, and more.

When you started the Flink job manager at the beginning of this tutorial, you also started the UI. It's available at port `8081` by default.

Since this tutorial is running on a dynamically provisioned machine, you'll need to get the URL of the Flink UI instance by running this command.

```
sed 's/PORT/8081/g' /etc/killercoda/host
```{{exec}}

Click the link that gets printed to the terminal. The UI will open in a separate tab. If you get a `Bad Gateway` error, wait a few seconds and try again since the service may still be starting.

Keep the UI open since we'll be referencing it in future steps.