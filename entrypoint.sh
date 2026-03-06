#!/bin/bash

if [ -n "${DOKANALYSE_CACHE_ON_STARTUP+x}" ] && [ "$DOKANALYSE_CACHE_ON_STARTUP" = "true" ]; then
    /venv/bin/build-dokanalyse-cache
fi

/entrypoint.sh