
You've implemented the strategy, but you can improve upon it by introducing a safeguard that ensures you only open a single position of the stock at a time. In other words, you want the `BUY` and `SELL` signals to alternate such that you never open two positions at once. e.g.

```
# without safeguard
BUY
BUY
BUY
SELL

# with safeguard
BUY
SELL
BUY
SELL
```{{}}

To achieve this, you can use one of Flink's built-in functions, called `LAG`{{}}, to inspect the contents of the previous row and make a decision according to its value.

We'll show you how to do this in the next step, but first, create another table to hold the single-position trade signals. Copy and paste the following statement into the SQL shell, followed by `<ENTER>`{{}}.
```sql
-- Create a table for storing the cleaned trade signals. The idea is to filter down
-- the raw trade signals so that we only BUY if we don't currently have a position in
-- the stock.
CREATE TABLE single_position_trade_signals (
  strategy STRING,
  strategy_version STRING,
  symbol VARCHAR(255) NOT NULL,
  close_price DOUBLE PRECISION,
  amount DOUBLE PRECISION,
  shares BIGINT,
  signal VARCHAR(4),
  metadata STRING,
  data_provider STRING,
  -- the METADATA attribute ensures the ts for the Redpanda record is set to the time_ltz value
  time_ltz TIMESTAMP(3) METADATA FROM 'timestamp',
  -- declare time_ltz as event time attribute and use 5 seconds delayed watermark strategy
  WATERMARK FOR time_ltz AS time_ltz - INTERVAL '5' SECOND
) WITH (
  'connector' = 'kafka',
  'topic' = 'single-position-trade-signals',
  'properties.bootstrap.servers' = 'redpanda-1:29092',
  'properties.group.id' = 'dev',
  'properties.auto.offset.reset' = 'earliest',
  'format' = 'json'
);
```{{copy}}
