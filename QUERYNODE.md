## Joystream QueryNode instance with docker compose

### Full Independant Configuration
Use this setup to run with no dependencies on any external services.

```sh
git clone https://github.com/mnaamani/storage-production && cd storage-production/
cp env.example .env
# edit .env file to customise database volume, username, password and chain database paths.

# Start all services
docker compose up -d
```

A working graphql endpoint should be accessible at http://localhost:8081/graphql

You should wait for nodes to fully sync up before using it in production.

### Processor Only Configuration
The slowest component in the query-node stack at the moment is indexing and it can take several hours to sync up. Its possible to use an external indexer that is already synced with the chain.

In this configuration, you will not run a joystream-node, indexer and indexer-gateway, just the database, processor and graphql-server.

There are some public indexer endpoints that can be used. (mainnet-rpc-1.joystream.org, mainnet-rpc-2.joystream.org, mainnet-rpc-3.joystream.org) by setting `PROCESSOR_INDEXER_GATEWAY` in your `.env` file.

```sh
git clone https://github.com/mnaamani/storage-production && cd storage-production/
cp env.example .env
# Edit the .env file:
# customise database volume, username, password
# and set the `PROCESSOR_INDEXER_GATEWAY` to an external url for example:
# PROCESSOR_INDEXER_GATEWAY=https://mainnet-rpc-1.joystream.org/query-node/indexer/graphql

# Bring up requried services only
docker compose up -d graphql-server
```

### Upgrading to new version of query-node
Typically newer versions of query node will modify the database schema, or perhaps mapping fixes will neccessitate re-processing all blocks. To migrate to a new version, you will need to drop the processor database.

```sh
# stop the processor and graphql-server
docker compose rm -vsf processor
docker compose rm -vsf graphql-server

# Delete the database
# Make sure to use the correct name of the databse as in our .env file PROCESSOR_DB_NAME
docker exec db psql -U postgres -c "DROP DATABASE query_node_processor;"

# Upate the version of query-node image in docker-compose.yml for the processor and query-node sevices. Then bring the services back up.
docker compose up -d processor
docker compose up -d graphql-server
```