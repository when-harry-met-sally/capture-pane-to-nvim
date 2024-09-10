#!/usr/bin/env bash

tmux_bin=${TMUX_BIN:-tmux}

pane_id=$("$tmux_bin" display-message -p '#{pane_id}')
if [[ -z "$pane_id" ]]; then
  echo "Error: Could not fetch the current tmux pane."
  exit 1
fi

# Capture the pane's output
capture_output=$("$tmux_bin" capture-pane -pS -2000 -t "$pane_id" 2>/dev/null)
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to capture pane. Make sure the current pane is valid."
  exit 1
fi

# Process the captured output to remove trailing spaces
cleaned_output=$(echo "$capture_output" | sed 's/[[:space:]]*$//')

# Remove any blank lines at the end
final_output=$(echo "$cleaned_output" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba')

# Open the processed output in nvim in a temporary nofile buffer
if [[ -n "$final_output" ]]; then
  echo "$final_output" | nvim -n -c "setlocal buftype=nofile" -
else
  echo "Warning: The captured pane is empty or has no output after processing."
fi
