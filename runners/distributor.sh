#!/usr/bin/env bash

# docker entrypoint fot distributor node, to allow running with telemetry
if [[ "$ENABLE_TELEMETRY" = "yes" ]] && [[ $1 = "start" ]]; then
    node --require @joystream/opentelemetry ./bin/run $*
else
    ./bin/run $*
fi
