Finally, it's time to use an `INSERT`{{}} statement, in combination with the `LAG`{{}} function, to create the signle-position trade signals.

Start by setting a name for the new pipeline by copy and pasting the following command into the SQL shell, followed by `<ENTER>`{{}}.

```sql
-- set the name of our Flink job
SET 'pipeline.name' = 'Single Position Generate Trade Signals';
```{{copy}}

Then, submit the Flink job by running this `INSERT`{{}} statement in the SQL shell. Read through the comments to understand how it works.

```sql
-- Insert the single-position trade signals. These will be the signals we actually act upon
INSERT INTO single_position_trade_signals
WITH
    raw_signals AS (
        SELECT
            *,
            -- get the signal of the record right before the current record
            LAG(signal) OVER (PARTITION BY symbol ORDER BY time_ltz) as prev_signal
        FROM trade_signals
    )
    SELECT
        strategy,
        strategy_version,
        symbol,
        close_price,
        amount,
        shares,
        signal,
        metadata,
        data_provider,
        time_ltz
    FROM raw_signals
    WHERE
        -- a BUY is valid anytime, as long as the previous signal wasn't a BUY.
        -- e.g. the previous_signal could be a SELL (open position) or NULL (no position)
        -- for a BUY signal to be issued
        (signal = 'BUY' AND prev_signal <> 'BUY')
        OR
        -- a SELL is valid only if the previous signal was a BUY
        (signal = 'SELL' AND prev_signal = 'BUY');
```{{copy}}

You'll see the job ID printed to the screen, and if you visit the Flink UI (which you opened in another tab at the beginning of this lesson), you'll see the Flink jobs running under __Jobs -> Running Jobs__.
