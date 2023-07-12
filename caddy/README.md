## Caddy webserver

A caddy service is already prepared for you.
All you need to do is update your `CADDY_DOMAIN` and `CADDY_EMAIL` in `.env` then start it up:

```sh
docker compose up -d caddy
```

The `caddy/Caddyfile` only exposes storage and distributor nodes.

## OpenTelemetry for caddy

```sh
docker compose up -d jaeger collector
```