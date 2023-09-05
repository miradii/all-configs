#!/usr/bin/env bash

export PATH="$HOME/.local/share/nvim/mason/bin/:$PATH"

# yarn path
export PATH="$(yarn global bin):$PATH"

export PATH="$PATH:$(go env GOPATH)/bin"

export PATH="$PATH:$HOME/.cargo/bin"

export PATH="$PATH:$HOME/.local/bin"
