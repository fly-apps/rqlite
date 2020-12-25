# Example: private rqlite

## Setup

- Create a Fly app with:

```toml
[experimental]
private_network = true

[[mounts]]
source = "data"
destination = "/data"
```

- Create a volume:

```
flyctl volumes create data --region <x region>
```

- Deploy:

```
flyctl deploy
```

- Add 2 more volumes:

```
flyctl volumes create data --region <y region>
flyctl volumes create data --region <z region>
```

- Scale:

```
flyctl scale count 3
```

## Usage

Use a rqlite-compatible client to connect within your private network to `your-rqlite-app-name.internal:4001`.

### Read-only, locally replicated, database

In a different app with private networking on also, you can inject the `rqlited` binary and start it in read-only mode:

```
export PRIVATE_NET_IP=`getent hosts fly-local-6pn | cut -d ' ' -f1`
rqlited \
    -join http://your-rqlite-app-name.internal:4001 \
    -http-addr "0.0.0.0:4001" -http-adv-addr "[$PRIVATE_NET_IP]:4001" \
    -raft-addr "0.0.0.0:4002" -raft-adv-addr "[$PRIVATE_NET_IP]:4002" \
    -raft-non-voter=true
    -on-disk \
    /data/db
```

Use a standard sqlite database connector to connect to your disk database at `/data/db/db.sqlite`.

**WARNING**: ^^ this is for a read-only database only! Do not write to this database.