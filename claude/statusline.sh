#!/usr/bin/env bash
# Status line badge showing which Claude Code subscription this session uses.
if [ "$CLAUDE_CONFIG_DIR" = "$HOME/.claude-work" ]; then
  printf '\033[1;97;41m 🔴 WORK \033[0m'
else
  printf '\033[1;30;42m 🟢 PERSONAL \033[0m'
fi
