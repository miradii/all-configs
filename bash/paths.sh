#!/usr/bin/env bash

# yarn path
export PATH="$(yarn global bin):$PATH"

export PATH="$PATH:$(go env GOPATH)/bin"

export PATH="$PATH:$HOME/.cargo/bin"
