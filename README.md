## All in one Joystream Storage/Distribution Instance

All you need to run a storage or distributor node for Joystream mainnet, on a single host machine with docker is in this repo.

### Requirements

- [Docker Server](https://docs.docker.com/engine/install/#server)
- [Docker Compose](https://docs.docker.com/compose/install/#install-compose) v2+

You can also use docker desktop but is not the recommended way to run a production instance :)

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

If you enabled telemetry (by setting `ENABLE_TELEMETRY=yes` in your `.env` file) start the telemetry services.

```sh
docker compose up -d collector
```
Access the Jaeger UI dashboard at http://localhost:16686

Before going further, you should wait for nodes to fully sync up before using them production for your storage or distributor nodes.

### Distributor Node
To run a Distributor node check the following [instructions](./docs/DISTRIBUTOR.md)

### Storage Node
To run a Storage node check the following [instructions](./docs/STORAGE.md)

### Caddy
Once you have setup your storage or distributor node, you will need to make them acessible with a caddy webserver. 

All you need to do is set your `CADDY_DOMAIN` and `CADDY_EMAIL` in [.env](./.env) then start it up:

```sh
docker compose up -d caddy
```

You can make any necessary changes in the [Caddyfile](./Caddyfile). Then to gracefully reload the configuration:

```sh
docker exec caddy caddy reload --config /etc/caddy/Caddyfile
```
