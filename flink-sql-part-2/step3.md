Now, it's time to hydrate the source topics with data we already pulled from Alpaca.

The scripts we used to pull this data are located in Github. Killercoda environments are short-lived so you may want to bookmark <a href="https://github.com/redpanda-data-university/rp-use-cases-algo-trading/tree/main" target="_blank">the repository</a> and circle back to it after this tutorial if you're interested in these scripts.

Go ahead and switch to the directory where the data files have been saved:

```
cd 02-data-collection/
```{{exec}}

Now, ensure `jq`{{}} is installed since you'll use it to inspect the data.

```
apt-get install -y jq
```{{exec}}

You may see a message like `jq is already the newest version`{{}}. That's okay, you're good to go.