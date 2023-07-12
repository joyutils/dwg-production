## Caddy webserver

A caddy service is already prepared for you.
All you need to do is set your `CADDY_DOMAIN` and `CADDY_EMAIL` in [.env](./.env) then start it up:

```sh
docker compose up -d caddy
```

The [Caddyfile](./Caddyfile) only exposes storage and distributor nodes.
