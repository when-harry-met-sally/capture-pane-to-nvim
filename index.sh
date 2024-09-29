#!/usr/bin/env bash

tmux_bin=${TMUX_BIN:-tmux}

pane_id=$("$tmux_bin" display-message -p '#{pane_id}')
if [[ -z "$pane_id" ]]; then
  echo "Error: Could not fetch the current tmux pane."
  exit 1
fi

# Capture the current pane's output
capture_output=$("$tmux_bin" capture-pane -pS -2000 -t "$pane_id" 2>/dev/null)
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to capture pane. Make sure the current pane is valid."
  exit 1
fi

# Get the current scroll position, the popup height, and the total line count
scroll_position=$("$tmux_bin" display-message -p "#{scroll_position}")
popup_height=$(tput lines)   # Capture the current terminal/popup height
popup_width=$(tput cols)     # Capture the current terminal/popup width

# Default scroll position to 0 if not set
scroll_position=${scroll_position:-0}

# Calculate the target line in Neovim
line_count=$(echo "$capture_output" | wc -l)
target_line=$((line_count - scroll_position))

# Process the captured output to remove trailing spaces
cleaned_output=$(echo "$capture_output" | sed 's/[[:space:]]*$//')

# Remove any blank lines at the end
final_output=$(echo "$cleaned_output" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba')

# Open the processed output in nvim, resized to match the popup height
if [[ -n "$final_output" ]]; then
  echo "$final_output" | nvim -n -c "setlocal buftype=nofile" \
                           -c "resize $popup_height" \
                           -c "setlocal columns=$popup_width" \
                           -c "normal! ${target_line}G" \
                           -c "setlocal nowrap" \
                           -c "setlocal nospell" \
                           -c "setlocal mouse=" -  # Disable mouse interactions for this buffer
else
  echo "Warning: The captured pane is empty or has no output after processing."
fi
