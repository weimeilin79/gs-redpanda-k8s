Once the source tables have been created, you can inspect them using a `SELECT` statement. For example, try running the following query. Note: it will take a few seconds to submit the job and return rows.

```sql
SELECT symbol, volume, price_close, timestamp_ms
FROM price_updates
LIMIT 20;
```{{copy}}


Then, hit `Ctrl+C`{{}} to exit, and inspect the market news table.


```sql
--- Inspect the market news
SELECT author, headline, symbol, sentiment
FROM market_news
WHERE sentiment < 0.4
LIMIT 10;
```{{copy}}

`SELECT` statements like these trigger new Flink jobs. You can verify this in the Flink UI, which should still be running in a separate tab.

Before proceeding, hit `Ctrl+C`{{}} to kill the current Flink job so that you can proceed with the rest of the tutorial.
