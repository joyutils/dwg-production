#!/usr/bin/env bash

if [[ "$ENABLE_TELEMETRY" = "yes" ]] && [[ $1 = "server" ]]; then
    node --require @joystream/opentelemetry ./bin/run $*
else
    ./bin/run $*
fi