#!/bin/sh

# Root directory
PROJECT_ROOT="$HOME/Outlier/Code/Cursor"

# Repo choosing
REPO=$(ls -1d "$PROJECT_ROOT"/*/ | xargs -n 1 basename | wofi --dmenu --prompt="Open Curson in:")

# Open Cursor in selected directory
if [ -n "$REPO" ]; then
    nohup cursor "$PROJECT_ROOT/$REPO" > /dev/null 2>&1 &
fi
