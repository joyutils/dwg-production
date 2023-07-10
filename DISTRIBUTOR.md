## Instructions For Distributor node operators

### Setup

- Edit `distributor.compose.yml` to customize volume locations and endpoints for joystream node and query-node. The default configuration assumes you are running joystream node and query-node on the same docker-compose stack on your host. Update the endpoints section if you are using a different setup.
- If you have not modified volume paths create the default:
```sh
mkdir -p ./distributor/config
mkdir -p ./distributor/keystore
```
- Copy `distributor.example.config.yml` and rename it `config.yml`, place into folder location specified in compose file that maps to `/config` volume. If you haven't changed volumes then it would go in `./distributor/config/config.yml`
- Copy your distributor role key to the keystore as `./distributor/keystore/distributor-role-key.json`, or set a `suri` or `mnemonic` key in the keys list of the `config.yml` file.
- Edit your `config.yml` file and set the correct workerId, and any other settings the lead might ask for.

### Startup your node

```sh
docker compose -f ./distributor.compose.yml up -d
```

### Running operator, lead and node commands

```sh
docker compose -f ./distributor.compose.yml run --rm distributor operator --help
docker compose -f ./distributor.compose.yml run --rm distributor lead --help
docker compose -f ./distributor.compose.yml run --rm distributor node --help
```

Remember the commands are running within the container, so if you are passing any arguments such as a path to an input file it should be on a reachable volume like the `/scratch` volume.

Examples:

#### Starting/Stopping the public api.
Notice we use the docker service name to reach the endpoint:

```sh
docker compose -f ./distributor.compose.yml run --rm distributor node:stop-public-api --url http://distributor:3335/
```

```sh
docker compose -f ./distributor.compose.yml run --rm distributor node:start-public-api --url http://distributor:3335/
```

### Accepting invitation

```sh
docker compose -f ./distributor.compose.yml run --rm distributor operator:accept-invitation -B 1:4 -w 3
```

#### Setting operator metadata
Say you have the metadata file in your home directory.
`~/metadata.json` to the scratch volume path

```sh
cp ~/metadata.json ./distributor/scratch/metadata.json
docker compose -f ./distributor.compose.yml run --rm distributor operator:set-metadata -B 0:1 -w 13 --input /scratch/metadata.json
```

Or you can mount the file directly.

```sh
docker compose -f ./distributor.compose.yml run --rm -v ~/metadata.json:/metadata.json distributor operator:set-metadata -B 0:1 -w 13 --input /metadata.json
```
