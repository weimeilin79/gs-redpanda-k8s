As always, you'll want to start by configuring the environment.

For example, to increase the default parallelism to match the number of input partitions, copy and paste the following statement into the prompt, followed by `<ENTER>`{{}}

```sql
SET 'parallelism.default' = '4';
```{{copy}}

It's technically not as important for this tutorial since we're only pulling data for a single stock symbol (and our partition-routing is based on this value), but this ensures work will be parallelized whenever we do add new symbols in the future.
