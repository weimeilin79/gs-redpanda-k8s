Now, you'll generate the raw trade signals. They are "raw" because they don't yet take into account whether or not you currently have an open position when generating the trade recommendation.

First, set the pipeline name for the Flink job by copying this into the SQL shell. Be sure to `<Enter>`{{}} after this statement and any others you run in the shell.

```sql
SET 'pipeline.name' = 'Generate Trade Signals';
```{{copy}}

Next, you'll create the table to store the raw trade signals. This primarily involves defining the schema, and configuring the `kafka` connector to tell Flink where to persist this data.

The table you'll create is shown below. Run this statement and view the comments for each column definition to understand what data the table will include.

```sql
-- Create a table for storing the raw trade signals
CREATE TABLE trade_signals (
  -- this table can hold trade signals from multiple strategies, so store the strategy name
  -- and version associated with each trade signal
  strategy STRING,
  strategy_version STRING,
  -- the stock symbol (e.g. TSLA) that the trade signal was generated for
  symbol VARCHAR(255) NOT NULL,
  -- the stock price at the time the trade signal was generated
  close_price DOUBLE PRECISION,
  -- the adjust amount (shares * close_price)
  amount DOUBLE PRECISION,
  -- the number of shares to sell or purchase
  shares BIGINT,
  -- a trade signal: BUY, SELL, or HOLD
  signal VARCHAR(4),
  -- additional metadata in the form of a JSON string "{\"headline\": \"TSLA exceeds Q4 expectations\"}"
  metadata STRING,
  data_provider STRING,
  -- the METADATA attribute ensures the ts for the Redpanda record is set to the time_ltz value
  time_ltz TIMESTAMP(3) METADATA FROM 'timestamp',
  -- declare time_ltz as event time attribute and use 5 seconds delayed watermark strategy
  WATERMARK FOR time_ltz AS time_ltz - INTERVAL '5' SECOND
) WITH (
  'connector' = 'kafka',
  'topic' = 'trade-signals',
  'properties.bootstrap.servers' = 'redpanda-1:29092',
  'properties.group.id' = 'dev',
  'properties.auto.offset.reset' = 'earliest',
  'format' = 'json'
);
```{{copy}}

Most of the fields are self-explanatory, so we won't belabor them here. The table mostly just includes what trade recommendation is being made (`BUY`, `SELL`, or `HOLD`), how many `shares` and the current `close_price`, and some metadata that could be useful down the road (`strategy`, `strategy_version`, `metadata`, and `data_provider`).

One of the most important things to note is the following declaration:

```sql
WATERMARK FOR time_ltz AS time_ltz - INTERVAL '5' SECOND
```{{}}

This enables event-time semantics and sets a watermark. Watermarks define how long you're willing to wait for delayed / unordered data. In this case, we're only willing to wait a short amount of time (5 seconds). Lower watermark values are a good idea for stock trading pipelines since you dont want to make trade decisions based on old data.