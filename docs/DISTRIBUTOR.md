## Instructions For Distributor node operators

### Setup

```sh
mkdir -p ./distributor/config
mkdir -p ./distributor/keystore
mkdir -p ./distributor/scratch

cp distributor.example.config.yml ./distributor/config/config.yml
```

- Copy your distributor role key to the keystore as `./distributor/keystore/distributor-role-key.json`, or set a `suri` or `mnemonic` key in the keys list of the `config.yml` file if you intend to run lead/operator commands from this instance.

- Edit your `config.yml` file and set the correct workerId, and any other settings the lead might ask for.

### Startup your node

```sh
docker compose up -d distributor
```

### Running operator, lead and node commands

```sh
docker compose run --rm distributor operator --help
docker compose run --rm distributor leader --help
docker compose run --rm distributor node --help
```

Remember the commands are running within the container, so if you are passing any arguments such as a path to an input file it should be on a reachable volume like the `/scratch` volume.

Examples:

#### Starting/Stopping the public api.
Notice we use the docker service name to reach the endpoint:

```sh
docker compose run --rm distributor \
  node:stop-public-api --url http://distributor:3335/
```

```sh
docker compose run --rm distributor \
  node:start-public-api --url http://distributor:3335/
```

### Accepting invitation

```sh
docker compose run --rm distributor \
  operator:accept-invitation -B 1:4 -w 3
```

#### Setting operator metadata
Say you have the metadata file in your home directory `~/metadata.json`.
copy it to the scratch volume path

```sh
cp ~/metadata.json ./distributor/scratch/metadata.json
docker compose run --rm distributor \
  operator:set-metadata -B 0:1 -w 13 --input /scratch/metadata.json
```

Or you can mount the file directly.

```sh
docker compose run --rm \
  -v ~/metadata.json:/metadata.json \
  distributor operator:set-metadata -B 0:1 -w 13 --input /metadata.json
```
