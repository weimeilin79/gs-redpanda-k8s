Since it's hard to predict when a news article will come in about a given security, we have included a news simulator for you to run in order to test your strategy.

Keep the script running in `Tab 2`{{}}, and now go back to `Tab 1`{{}}, by clicking `Tab 1`{{}} at the top of the terminal.

Then run the following command to start the news simulator.

```
# tab 1
clear && cd 03-strategy-testing/
python -m examples.alpaca.simulate_news
```{{exec}}

You will be asked to provide a stock symbol that the simulated headline will apply to. Click the following to specify the symbol as `TSLA`{{}}.

```
TSLA
```{{exec}}

Now, for the headline itself. Click the following to generate a headline with positive sentiment that is likely to exceed our sentiment threshold of `0.4`{{}}. The idea is to create a headline that would cause Flink to issue a `BUY`{{}} signal.

```
Tesla, Nio Battery-Supplier CATL Expects Q3 Net Profit To Triple, Shares Jump 6%
```{{exec}}

Click Next.