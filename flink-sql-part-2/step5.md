Now, you'll save the historical market news for Tesla (`TSLA`). This data was initially pulled from Alpaca, and then enriched with sentiment scores.

To view a preview of the data, run the following command:

```
clear && head -n3 market-news.txt  | cut -d " " -f2- | jq '.'
```{{exec}}

You should see some JSON records like this:

```json
{
  "author": "Benzinga Newsdesk",
  "content": "",
  "created_at": "2022-09-01T16:30:24Z",
  "headline": "Nouveau Monde Shares Up 6% After Reports Of Tesla Mine Visit",
  "id": 28721901,
  "images": [],
  "source": "benzinga",
  "summary": "",
  "updated_at": "2022-09-01T16:30:24Z",
  "timestamp_ms": 1662049824000,
  "data_provider": "alpaca",
  "sentiment": 0.296,
  "symbol": "TSLA",
  "article_url": "https://www.benzinga.com/trading-ideas/movers/22/09/28721901/nouveau-monde-shares-up-6-after-reports-of-tesla-mine-visit"
}
```

The key fields you'll be leveraging are the article's `headline`, `sentiment`, and `timestamp_ms`.

Go ahead and produce the market news to Redpanda with:

```
cat market-news.txt | rpk topic produce market-news -f '%k %v\n'
```{{exec}}

To confirm the topic has been populated, run the following command:

```json
rpk topic consume market-news -n 3 | jq '.'
```{{exec}}
