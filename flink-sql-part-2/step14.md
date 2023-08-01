The last step is to inspect the Redpanda topics. Type `QUIT;`{{}} in the SQL shell to exit.

```sql
QUIT;
```{{copy}}

Then, view the topics with `rpk`{{}}:

```sh
rpk topic list
```{{exec}}

To consume the single-position trade signals, run this command:

```sh
rpk topic consume single-position-trade-signals \
  -f '%v' -n 3 | jq '.'
```{{exec}}

The trade signals should show up in the output. Then other services can use these signals to distribute the event, or  create notifications as needed. 