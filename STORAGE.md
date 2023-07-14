## Instructions For Storage node operators

### Setup

```sh
mkdir -p ./storage/keystore
```

- Copy your storage transactor key to the keystore as `./storage/keystore/keyfile.json`, or pass it as a `accountUri` argument in the `storage.compose.yml`

- Make sure to set correct worker id in `storage.compose.yml`.

### Startup your node

```sh
docker compose -f ./storage.compose.yml up -d
```

### Running operator and leader commands

```sh
docker compose -f ./storage.compose.yml run --rm storage operator --help
docker compose -f ./storage.compose.yml run --rm storage lead --help
docker compose -f ./storage.compose.yml run --rm storage dev --help
```

Remember the commands are running within the container, so if you are passing any arguments such as a path to an input file it should be on a reachable volume like the `/scratch` volume.

Examples:

### Accepting invitation

```sh
docker compose -f ./storage.compose.yml run --rm storage \
  operator:accept-invitation --bucketId 3 -w 0 --transactorAccountId  ....
```

#### Setting operator metadata
Say you have the metadata file in your home directory `~/metadata.json`.

```sh
docker compose -f ./storage.compose.yml run --rm \
  -v ~/metadata.json:/metadata.json \
  storage operator:set-metadata --bucketId 3 -w 10 --jsonFile /metadata.json
```
