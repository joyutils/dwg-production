## All in one Joystream Storage/Distribution Instance

All you need to run a storage or distributor node for Joystream mainnet, on a single host machine with docker is in this repo.

### Requirements

- [Docker Server](https://docs.docker.com/engine/install/#server)
- [Docker Compose](https://docs.docker.com/compose/install/#install-compose) v2+

You can also use docker desktop but is not the recommended way to run a production instance :)

Docker provides a [convenience script](https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script) to make installation process a little easier.

### Walkthrough

Prepare a top level `.env` for some configurable values.

```sh
cp env.example .env
```

Start a joystream-node

```sh
docker compose up -d joystream-node
```

Start the QueryNode indexing services

```sh
docker compose up -d db
docker compose up -d indexer
docker compose up -d hydra-indexer-gateway
```

Start QueryNode processor and GraphQL frontend

```sh
docker compose up -d processor
docker compose up -d graphql-server
```

A working graphql endpoint should be accessible at http://localhost:8081/graphql
For additional configuring options for the query node check the [docs](./docs/QUERYNODE.md)

Start tracing and monitoring

```sh
docker compose up -d collector
docker compose up -d metricbeat
```

Before going further, you should wait for the processor to fully sync up before using them production for your storage or distributor nodes.

You can track its progress by looking at the logs:

```sh
docker logs --tail 100 --follow processor
```

### Distributor Node

To run a Distributor node follow these [instructions](./docs/DISTRIBUTOR.md)

### Storage Node

To run a Storage node follow these [instructions](./docs/STORAGE.md)

### Caddy

Once you have setup your storage or distributor node, you will need to make them publicly acessible with a caddy webserver.

All you need to do is set your `CADDY_DOMAIN` in [.env](./.env) then start it up:

```sh
docker compose up -d caddy
```

If you set `CADDY_DOMAIN=https://mydistributor.cooldomain.net` your can check their status at:

`https://mydistributor.cooldomain.net/distributor/api/v1/status` if you setup the distributor node.
`https://mydistributor.cooldomain.net/storage/api/v1/status` if you setup the storage node.

You can make any necessary changes in the [Caddyfile](./Caddyfile). Then to gracefully reload the configuration:

```sh
docker exec caddy caddy reload --config /etc/caddy/Caddyfile
```
