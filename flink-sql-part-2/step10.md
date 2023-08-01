Now, you'll populate that table with an `INSERT`{{}} statement. This will actually create the Flink job to implement the strategy.

Here's the entire statement. Go ahead and copy it into the SQL shell and press `<ENTER>`{{}}, and then read through the comments for an explanation.


```sql
-- Implement the sentiment strategy by creating the following signals:
-- BUY whenever sentiment > 0.4
-- SELL whenever sentiment < -0.4
INSERT INTO trade_signals
WITH 
  sentiment_strategy_signals AS (
    SELECT
        -- set a name and version for this strategy so that we can distinguish
        -- between future versions
        'sentiment' as strategy,
        '0.1.0' as strategy_version,
        price_updates.symbol,
        -- include the close price so we can see what the stock price was at the time
        -- the signal was generated
        price_updates.price_close as close_price,
        -- configure the number of shares to buy or sell. this is our "stake"
        5 as shares,
        -- implement the logic for the sentiment strategy
        CASE
            WHEN market_news.sentiment > 0.4 THEN 'BUY'
            WHEN market_news.sentiment < -0.4 THEN 'SELL'
            ELSE 'HOLD'
        END as signal,
        -- capture some additional metadata about the article that triggered the trade
        -- signal. future strategies could have their own, unique metadata fields
        JSON_OBJECT(
            'headline' VALUE headline,
            'sentiment' VALUE sentiment
        ) AS metadata,
        data_provider,
        market_news.time_ltz as time_ltz
    FROM market_news
    JOIN price_updates
    ON price_updates.symbol = market_news.symbol
    AND (
      -- use minute-level precision for the join
      DATE_FORMAT(price_updates.time_ltz, 'yyyy-MM-dd HH:mm:00') = DATE_FORMAT(market_news.time_ltz, 'yyyy-MM-dd HH:mm:00')
      -- we use a news simulator in the RPU version of the tutorial. this line just ensures anything picked up by the news simulator is also included.
      OR
        (data_provider = 'news simulator' AND price_updates.time_ltz = '2022-12-31 00:59:00.000')
    )
)
SELECT
  strategy,
  strategy_version,
  symbol,
  close_price,
  -- create a signed version of the amount (e.g. $500, -$500) based on the signal.
  -- this will help with backtesting later
  CASE
    WHEN signal = 'SELL' THEN close_price * shares
    ELSE close_price * shares * -1
  END as amount,
  shares,
  signal,
  metadata,
  data_provider,
  time_ltz
FROM sentiment_strategy_signals
WHERE signal IN ('BUY', 'SELL');
```{{copy}}

The logic of our pipeline is actually pretty simple, and is encapsulated in the `CASE`{{}} statement.

```sql
  CASE
      WHEN market_news.sentiment > 0.4 THEN 'BUY'
      WHEN market_news.sentiment < -0.4 THEN 'SELL'
      ELSE 'HOLD'
  END as signal
```{{}}

You'll issue a `BUY`{{}} signal when the market sentiment (as determined by the news articles) is above `0.4`. You'll issue a `SELL`{{}} signals when the sentiment is below `-0.4`{{}}. Otherwise, you'll `HOLD`{{}}.

The simplicity of this particular strategy is great for demoing Flink, but you'd want to supplement this with additional signals before deploying this to a live trading environment.

One operation that makes this pipeline stateful is the windowed join, which we use to pull the stock's most recent price at the time an article was published:

```sql
FROM market_news
JOIN price_updates
ON price_updates.symbol = market_news.symbol
AND (
  -- use minute-level precision for the join
  DATE_FORMAT(price_updates.time_ltz, 'yyyy-MM-dd HH:mm:00') 
  = DATE_FORMAT(market_news.time_ltz, 'yyyy-MM-dd HH:mm:00')
  ...
)
```{{}}

Joining streams like this is a powerful feature of Flink, and you can bookmark <a href="https://nightlies.apache.org/flink/flink-docs-master/docs/dev/table/sql/queries/joins/" target="_blank">this page</a> to read more about them after the tutorial.