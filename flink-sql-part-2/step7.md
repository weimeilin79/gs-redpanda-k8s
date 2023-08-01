Next, you'll register the two source tables: `price_updates` and `market_news`. These correspond with the topics you just hydrated.

> Note: due to limitations of this environment, you'll need to copy each statement into the SQL shell and press `<Enter>`{{}} on your keyboard to submit the statement. It won't work if you forget to press `<Enter>`.

```sql
-- create the first table
CREATE OR REPLACE TABLE price_updates (
    symbol VARCHAR,
    price_open FLOAT,
    high FLOAT,
    low FLOAT,
    price_close FLOAT,
    volume DECIMAL,
    trade_count FLOAT,
    vwap DECIMAL,
    timestamp_ms BIGINT,
    time_ltz AS TO_TIMESTAMP_LTZ(timestamp_ms, 3),
    -- declare time_ltz as event time attribute and use 5 seconds delayed watermark strategy
    WATERMARK FOR time_ltz AS time_ltz - INTERVAL '5' SECOND
) WITH (
    'connector' = 'kafka',
    'topic' = 'price-updates',
    'properties.bootstrap.servers' = 'redpanda-1:29092',
    'properties.group.id' = 'dev',
    'properties.auto.offset.reset' = 'earliest',
    'format' = 'json'
);
```{{copy}}

and...

```sql
-- create the second table
CREATE OR REPLACE TABLE market_news (
    id BIGINT,
    author VARCHAR,
    headline VARCHAR,
    source VARCHAR,
    summary VARCHAR,
    data_provider VARCHAR,
    article_url VARCHAR,
    symbol VARCHAR,
    sentiment DECIMAL,
    timestamp_ms BIGINT,
    time_ltz AS TO_TIMESTAMP_LTZ(timestamp_ms, 3),
    -- declare time_ltz as event time attribute and use 5 seconds delayed watermark strategy
    WATERMARK FOR time_ltz AS time_ltz - INTERVAL '5' SECOND
) WITH (
    'connector' = 'kafka',
    'topic' = 'market-news',
    'properties.bootstrap.servers' = 'redpanda-1:29092',
    'properties.group.id' = 'dev',
    'properties.auto.offset.reset' = 'earliest',
    'format' = 'json'
);
```{{copy}}

Once the tables have been created, click proceed to the next step.