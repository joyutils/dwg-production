# Migrating from monorepo setup to Docker images

With successful migration there should be no need to resync anything.

First, stop all your current services gracefully.

```
# Distributor node
# if running with service
systemctl disable distributor-node
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
# if running with docker
docker compose down joystream-node

# If you're going to run Caddy in Docker (recommended)
systemctl disable caddy
```

Secondly, clone the repo https://github.com/kdembler/dwg-production Follow instructions in the README.

In your `.env`, provide valid values for `CHAIN_VOLUME`, `DATABASE_VOLUME`, `DISTRIBUTOR_DATA_VOLUME`, `DISTRIBUTOR_CACHE_VOLUME` and `DISTRIBUTOR_LOGS_VOLUME`. Those volumes should point at where you currently keep all the chain/QN/Argus data.

Specify your domain in `CADDY_DOMAIN` if you’re going to use Caddy with Docker. If not, you will need to adjust your existing proxy based on provided `Caddyfile`.
Proceed with starting the services as specified in README.

Confirm that processor is processing new blocks. Confirm that you can connect at `https://<YOUR_DOMAIN>/query/graphql`

Once you start all the base services, follow instructions from https://github.com/kdembler/dwg-production/blob/main/docs/DISTRIBUTOR.md

Place your current distributor config based on `DISTRIBUTOR_CONFIG_VOLUME`. Update your config, use values from https://github.com/kdembler/dwg-production/blob/main/distributor.example.config.yml for following settings:

1. `limits` section, except `limits.storage` which should be set to your capacity.
2. `intervals` section

Now start the distributor and you should be done.
