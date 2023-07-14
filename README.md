## All in one Joystream Storage/Distribution Instance

All you need to run a storage or distributor node for Joystream mainnet, on a single host machine with docker/docker-compose is in this repo.

### Requirements

[Docker](https://docs.docker.com/get-docker/)
[Docker Compose](https://docs.docker.com/compose/install/#install-compose) v2.0.0+

### Setup

```sh
git clone https://github.com/mnaamani/storage-production
cd storage-production/
cp env.example .env
```

### Start joystream-node, query-node and monitoring services

```sh
docker compose up -d
```

You now have a joystream-node and query-node up and running.
A working graphql endpoint should be accessible at http://localhost:8081/graphql

You should wait for nodes to fully sync up before using it in production.

Both services only listen on localhost as they are not intended to be used publicly and reserved for the storage/distributors running on the same host.

For more options configuring the [QueryNode](QUERYNODE.md)

A basic open telemetry collector and Jaeger dashboard is also up and running.
Access the [Jaeger](https://www.jaegertracing.io/) telemetry dashboard at http://localhost:16686

By default only the caddy service is configued to send trace logs to the local collector.

### Distributor Node
If you want to run a Distributor node check the following [instructions](DISTRIBUTOR.md)

### Storage Node
If you want to run a Storage node check the following [instructions](STORAGE.md)

### Caddy
Once you have setup your storage or distributor nodes, you will need to make them acessible with a reverse proxy such as nginx or caddy. check followinf [instructions](./caddy/README.md).
