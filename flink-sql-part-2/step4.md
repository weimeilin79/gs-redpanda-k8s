
First, you'll save the historical stock prices for Tesla (`TSLA`). To get a preview of the data you'll be saving, run this command:

```
head -n3 price-updates.txt  | cut -d " " -f2- | jq '.'
```{{exec}}

You should see some JSON records like this:

```json
{
  "symbol": "TSLA",
  "high": 271.14,
  "low": 271.14,
  "volume": 129,
  "trade_count": 1,
  "vwap": 271.14,
  "data_provider": "alpaca",
  "price_open": 271.14,
  "price_close": 271.14,
  "timestamp_ms": 1662013800000
}
```

The records are encoded as JSON strings, and each record contains the following fields:

- `symbol`{{}} - the ticker symbol for the stock (`TSLA`, `AAPL`, `COIN`, etc)
- `high`{{}} - the high price during the period
- `low`{{}} - the low price during the period
- `volume`{{}} - the total number of shares traded
- `trade_count`{{}} - the number of trades (each trade can have multiple shares traded)
- `vwap`{{}} - a trading indicator, called the volume-weighted average price
- `data_provider`{{}} - the source for this data (Alpaca)
- `price_open`{{}} - the open price for the stock during the period (we’re pulling minutely data, so the open for the given minute)
- `price_close`{{}} - the close price (this is the price point that you’ll be working with the most)
- `timestamp_ms`{{}} - the timestamp, in milliseconds, of the pricing update


To produce the records to Redpanda, run the following command:

```
cat price-updates.txt | rpk topic produce price-updates -f '%k %v\n'
```{{exec}}

To confirm the topic has been populated, run the following command:

```json
rpk topic consume price-updates -n 3 | jq '.'
```{{exec}}