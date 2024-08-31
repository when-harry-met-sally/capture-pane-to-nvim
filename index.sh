#!/usr/bin/env bash

pane_id=$1
tempfile=$(mktemp)

tmux capture-pane -pS -2000 -t "$pane_id" | sed 's/[[:space:]]*$//' > "$tempfile"

if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' -e :a -e '/^\n*$/{$d;N;};/\n$/ba' "$tempfile"
else
  sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' "$tempfile"
fi

nvim -n -c "setlocal buftype=nofile" + "$tempfile" && rm "$tempfile"
