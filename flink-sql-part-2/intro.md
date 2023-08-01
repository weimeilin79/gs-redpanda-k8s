
<br>

### Welcome !

![Graduate Panda](./images/graduate-panda.png)

In this tutorial, you’ll be implementing a sentiment-based trading strategy using Flink SQL.

This strategy uses natural language processing to determine how people feel about a security (e.g. from news headlines), and makes investment decisions based on this information. The way it works is simple:

- You’ll create a Flink query that consumes a continuous stream of market news.
- Whenever the sentiment for a symbol is particularly high (> 0.4), you’ll issue a buy signal if you don’t already have an open position.
- Similarly, if the sentiment is particularly low (< -0.4), you’ll issue a sell signal.

The market data you'll be using was sourced from <a href="https://alpaca.markets" target="_blank">Alpaca</a>.

This exercise includes a subset of the material presented in <a href="https://university.redpanda.com/courses/use-cases-algorithmic-trading" target="_blank">this Redpanda University course</a>.
