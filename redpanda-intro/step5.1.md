In development and testing environments, it can be extremely useful to produce data to Redpanda with `rpk`. Luckily, doing so is easy.

For example, to produce data to the `names` topic, run the following command:

```
rpk topic produce names
```{{exec}}

You'll be dropped in an empty prompt. It looks like it's just hanging there, but it's just waiting on your input.

Type a few names, and hit `<Enter>` after each name.

```
Mitch
Sam
Alex
Elyse
```

When you're finished, hit `Ctrl+C` to exit.
