## Instructions For Storage node operators

### Setup

```sh
mkdir -p ./storage/keystore
```

- Copy your storage transactor key to the keystore as `./storage/keystore/keyfile.json`, or pass it as a `accountUri` argument in the `docker-compose.yml` under storage service.

- Make sure to set correct worker id in `docker-compose.yml`.

### Startup your node

```sh
docker compose up -d storage
```

### Running operator and leader commands

```sh
docker compose run --rm storage operator --help
docker compose run --rm storage leader --help
docker compose run --rm storage dev --help
```

Examples:

### Accepting invitation

```sh
docker compose run --rm storage \
  operator:accept-invitation --bucketId 3 -w 0 --transactorAccountId  ....
```

#### Setting operator metadata
Remember the commands are running within the container, so if you are passing any arguments such as a path to an input file it should be on a reachable volume.

Say you have the metadata file in your home directory `~/metadata.json`.

```sh
docker compose run --rm \
  -v ~/metadata.json:/metadata.json \
  storage operator:set-metadata --bucketId 3 -w 10 --jsonFile /metadata.json ...
```
