# Migrating from monorepo setup to Docker images

First, stop all your current services gracefully.

```
# Distributor node
# if running with service
systemctl disable distributor-node
systemctl stop distributor-node
# if running with docker
docker compose down distributor

# QN component by component
docker compose down graphql-server
docker compose down processor
docker compose down hydra-indexer-gateway
docker compose down indexer
docker compose down db redis

# Joystream node
# if running with service
systemctl disable joystream-node
systemctl stop joystream-node
# if running with docker
docker compose down joystream-node

# If you're going to run Caddy in Docker (recommended)
systemctl disable caddy
```

Secondly, clone the repo https://github.com/kdembler/dwg-production Follow instructions in the README.

In your `.env`, provide valid values for data volumes. Those volumes should point at where you currently keep all the chain/QN/Argus data:

- `CHAIN_VOLUME` - this is directory with Joystream Node data, it contains a single `chains/` directory, location will depend on your config, by default it may be `/root/.local/share/joystream-node`
- `DISTRIBUTOR_DATA_VOLUME` - directory with all Distributor data, it contains a bunch of files with IDs as names, default location was `<JOYSTREAM_MONOREPO>/distributor/local/data`
- `DISTRIBUTOR_CACHE_VOLUME` - directory with single `cache.json` file, default location was `<JOYSTREAM_MONOREPO>/distributor/local/cache`
- `DATABASE_VOLUME` - only set this if you were running Postgres@14 previously, otherwise keep default and sync QN fresh. If you have valid DB, set this it to your previous database location. By default it was a Docker volume called `joystream_query-node-data`.

If you need to sync QN again, to speed up QN processor sync, use external indexer until your own indexer is synced: `PROCESSOR_INDEXER_GATEWAY=https://mainnet-rpc-1.joystream.org/query-node/indexer/graphql`

If you have a Postgres@14 DB, you can extract it from Docker volume to local ./db directory:

```sh
docker run --rm -v joystream_query-node-data:/volume -v $(pwd)/db:/backup alpine tar -czvf /backup/backup.tar.gz -C /volume ./
tar -xzvf ./db/backup.tar.gz -C ./db
rm ./db/backup.tar.gz
```

Specify your domain in `CADDY_DOMAIN` if you’re going to use Caddy with Docker. If not, you will need to adjust your existing proxy based on provided `Caddyfile`.
Proceed with starting the services as specified in README.

Confirm that processor is processing new blocks. Confirm that you can connect at `https://<YOUR_DOMAIN>/query/graphql`

Once you start all the base services, follow instructions from https://github.com/kdembler/dwg-production/blob/main/docs/DISTRIBUTOR.md

Place your current distributor config based on `DISTRIBUTOR_CONFIG_VOLUME`. **Update your config, use values from https://github.com/kdembler/dwg-production/blob/main/distributor.example.config.yml for following settings:**

1. `limits` section, except `limits.storage` which should be set to your capacity.
2. `intervals` section
3. `directories` section

Now start the distributor and you should be done.

At this point you should no longer need old `joystream` monorepo. You can clean it up with (this will remove any volumes so only do that if you've migrated the data outside of Docker volumes)

```
docker compose down -v
# then you can delete the monorepo
```
