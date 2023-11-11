#!/usr/bin/env zsh

# Get the ID of the current pane
pane_id=$1

# Define a temporary file
tempfile=$(mktemp)

# Capture the top 2000 lines of the pane
tmux capture-pane -pS -2000 -t $pane_id | sed 's/[[:space:]]*$//' > $tempfile

# Remove trailing blank lines
sed -i '' -e :a -e '/^\n*$/{$d;N;};/\n$/ba' $tempfile

# Open the file in vim
nvim -n +$ $tempfile && rm $tempfile
