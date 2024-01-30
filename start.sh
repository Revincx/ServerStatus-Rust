#!/bin/bash

# if env $CONF_URL is set
if [ -n "$CONF_URL" ]; then
  rm /app/config.toml
  curl -o /app/config.toml "$CONF_URL"
fi

# start the app
/app/stat_server -c /app/config.toml