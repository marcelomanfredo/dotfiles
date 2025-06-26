#!/bin/bash

SESSION="nyx"
PROJECT_DIR=~/Projects/Nyx

# Check if session exists
tmux has-session -t $SESSION 2>/dev/null
if [ $? -eq 0 ]; then
  echo "Session '$SESSION' already exists. Attaching..."
  tmux attach -t $SESSION
  exit 0
fi

# Create session with dummy window 0
tmux new -d -s $SESSION -c "$PROJECT_DIR"

# Set base indexes to start at 1
tmux set-option -t $SESSION base-index 1
tmux setw -t $SESSION pane-base-index 1

# Create real Window 1: Nyx (Neovim main)
tmux neww -t $SESSION:1 -n "Nyx" -c "$PROJECT_DIR/nyx" \
  "bash -c ' \
    nvim .;
    exec zsh'"

# Window 2: Nyx-Wasm (Neovim + Trunk)
tmux neww -t $SESSION:2 -n "Nyx-Wasm" -c "$PROJECT_DIR/nyx-wasm" \
  "bash -c ' \
    nvim .; \
    exec zsh'"
tmux splitw -h -t $SESSION:2 -c "$PROJECT_DIR/nyx-wasm" \
  "bash -c ' \
    trunk serve --open -c -q;
    exec zsh'"
tmux resizep -t $SESSION:2.1 -x5

# Window 3: PostgreSQL (Check if 
tmux neww -t $SESSION:3 -n "DB" -c "$PROJECT_DIR" \
  "bash -c '\
    if ! systemctl is-active --quiet postgresql.service; then \
      sudo systemctl start postgresql.service; \
    fi; \
    psql -U sauron -d mordor; \
    exec zsh'"

# Window 4: Shell
tmux new-window -t $SESSION:4 -n "Shell" -c "$PROJECT_DIR"

# Now it's safe to delete the original Window 0
tmux kill-window -t $SESSION:0

# Focus on first real window
tmux select-window -t $SESSION:1
tmux attach -t $SESSION

