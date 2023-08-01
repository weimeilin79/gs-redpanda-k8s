Here are a few more statements to try before you proceed. Bonus points: can you tell which of these statements
will create a Flink job when executed?

- Insert a record
    ```sql
    INSERT INTO names(name, website)
    VALUES ('Round Robin Publishing', 'roundrobin.pub');
    ```{{copy}}
- View the available functions:
    ```sql
    SHOW FUNCTIONS ;
    ```{{copy}}
- Use some functions
    ```sql
     SELECT
        name,
        website,
        -- unforunately, SPLIT_INDEX doesn't support negative indexes,
        -- but reversing like this allows us to extract the tld
        REVERSE(SPLIT_INDEX(REVERSE(website), '.', 0)) as tld 
    FROM names;
    ```{{copy}}

If you guessed that the `INSERT` and `SELECT` statements would create a Flink job, then you were correct. The former created a short-lived job that produced a single record to the `names` topic. The latter created streaming job with some minor data enrichment (adding a `tld` field to represent each website's top-level domain).