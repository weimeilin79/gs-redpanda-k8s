Next, you'll need to create the input and output topics. You'll create four topics total:

- `market-news` will contain news headlines about certain companies.

  It will also include sentiment scores that were pre-computed using the <a href="https://www.nltk.org/howto/sentiment.html" target="_blank">`nltk`{{}}</a> library.

- `price-updates` will contain historical stock prices for `TSLA`{{}}.

  It includes pricing data between `2022-09-01` and `2023-01-01`. This is the time frame we initially used in the <a href="https://university.redpanda.com/courses/use-cases-algorithmic-trading" target="_blank">the Redpanda University course</a>, so we have kept it the same for consistency.

- `trade-signals` will contain the raw trade signals that the Flink app will generate
- `single-position-trade-signals` will contain a second set of signals that ensures only a single position is open at a time.

To create these topics, you'll use Redpanda's commandline interface: `rpk`{{}}. Run the following command to set an alias for `rpk`{{}}.

```
alias rpk="docker-compose exec -T redpanda-1 rpk"
```{{exec}}

Then, create the topics:

```
# create the input topics
rpk topic create  \
  market-news price-updates \
  trade-signals single-position-trade-signals
```{{exec}}
