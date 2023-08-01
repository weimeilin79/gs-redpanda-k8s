You will work with a few of the `rpk` sub-commands in the next few steps. You can also view more information about the commands we don't cover yourself (e.g. `rpk cloud`, `rpk iotune`, etc), by running
`rpk cluster [command] --help`{{}}. For example:

```
rpk cloud --help
```{{exec}}

Since you just started the Redpanda cluster in the previous step, start by simply printing
some information about the running cluster.

```
rpk cluster info
```{{exec}}

We'll come back to `rpk` momentarily. Let's learn about topics next.