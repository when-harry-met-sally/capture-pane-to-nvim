#!/usr/bin/env bash

# Define the log file path
LOG_FILE="$HOME/tmux-to-nvim.log"

# Function to log messages
log_error() {
  local message="$1"
  echo "$(date +"%Y-%m-%d %H:%M:%S") [ERROR] $message" >> "$LOG_FILE"
}

# Check the OS type for clipboard access
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  copied_text=$(pbpaste)
elif command -v xclip &> /dev/null; then
  # Linux with xclip
  copied_text=$(xclip -selection clipboard -o)
else
  log_error "Unsupported system or clipboard utility not found."
  exit 1
fi

# Check if any text was captured from the clipboard
if [[ -z "$copied_text" ]]; then
  log_error "No text was highlighted/copied in Alacritty."
  exit 1
fi

# Open the copied text in a temporary nofile buffer in Neovim
echo "$copied_text" | nvim -n -c "setlocal buftype=nofile" -c "normal! G" -
