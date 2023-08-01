
Next, you'll see how well the strategy would have performed. To do so, we can calculate the profit and loss using a cumulative sum query.

Copy and paste the following query, followed by `<ENTER>`{{}}, into the SQL shell.

```sql
-- Calculate profit and loss for a strategy
-- Note: if you aren't using a commission free broker, you'll need to take
-- the broker fees into account (not shown below since we assume commission-free)
SELECT
    SUM(amount) as net_profit,
    COUNT(*) as trades
FROM single_position_trade_signals
WHERE strategy = 'sentiment'
AND strategy_version = '0.1.0'
AND symbol = 'TSLA'
AND data_provider = 'alpaca';
```{{copy}}

You can see now why it's helpful to save metadata, like the strategy, version, and other information along with the `BUY`{{}} and `SELL`{{}} signals.

If you run the query, you should see the strategy returned a modest profit. Not amazing, but also not in the red :)

If you need further intuition around how the profile / loss is calculated,  see the following queries. Otherwise, hit __Next__.

```sql
-- Intuition around the Profit / Loss query we showed earlier
-- Profit test
SELECT
  SUM(amount) as net_profit,
  COUNT(*) as trades
FROM (VALUES
  ('TSLA', 'BUY', -100, '2022-09-14 09:54:00.000'),
  ('TSLA', 'SELL', 140, '2022-09-14 10:02:00.000'), -- $40 profit
  ('TSLA', 'BUY', -110.0, '2022-09-14 10:05:00.000'),
  ('TSLA', 'SELL', 120.0, '2022-09-14 10:12:00.000') -- $10 profit
) AS NameTable(symbol, signal, amount, time_ltz);
```{{copy}}

```sql
-- Loss test
SELECT
  SUM(amount) as net_profit,
  COUNT(*) as trades
FROM (VALUES
  ('TSLA', 'BUY', -100, '2022-09-14 09:54:00.000'),
  ('TSLA', 'SELL', 90, '2022-09-14 10:02:00.000'), -- $10 loss
  ('TSLA', 'BUY', -110.0, '2022-09-14 10:05:00.000'),
  ('TSLA', 'SELL', 95.0, '2022-09-14 10:12:00.000') -- $15 loss
) AS NameTable(symbol, signal, amount, time_ltz);
```{{copy}}

```sql
-- Break even test
SELECT
  SUM(amount) as net_profit,
  COUNT(*) as trades
FROM (VALUES
  ('TSLA', 'BUY', -100, '2022-09-14 09:54:00.000'),
  ('TSLA', 'SELL', 80, '2022-09-14 10:02:00.000'), -- $20 loss
  ('TSLA', 'BUY', -140.0, '2022-09-14 10:05:00.000'),
  ('TSLA', 'SELL', 160.0, '2022-09-14 10:12:00.000') -- $20 gain
) AS NameTable(symbol, signal, amount, time_ltz);
```{{copy}}