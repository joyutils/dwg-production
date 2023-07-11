## All in one Joystream Storage/Distribution Instance

All you need to run a storage or distributor node for Joystream mainnet, on a single host machine with docker/docker-compose is in this repo.

### Requirements

Docker

### Setup

```sh
git clone https://github.com/mnaamani/storage-production
cd storage-production/
cp env.example .env

# Start all services
docker compose up -d
```

You now have a joystream-node and query-node up and running.
A working graphql endpoint should be accessible at http://localhost:8081/graphql

You should wait for nodes to fully sync up before using it in production.

For more options configuring the [QueryNode](QUERYNODE.md)

### Distributor Node
If you want to run a Distributor node check the following [instructions](DISTRIBUTOR.md)

### Storage Node
If you want to run a Storage node check the following [instructions](STORAGE.md)

### Caddy

Once you have setup your storage or distributor nodes, you will need to make them acessible with a reverse proxy such as nginx or caddy. A caddy service is already prepared for you.
All you need to do is update your hostname and email in `caddy.compose.yml` then start it up:

```sh
docker compose -f ./caddy.compose.yml up -d caddy
```