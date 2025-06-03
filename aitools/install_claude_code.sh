#!/bin/bash
set -e

echo "=== Installing nvm ==="
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "=== Installing Node.js 18 (or higher) ==="
nvm install 18
nvm use 18
nvm alias default 18

echo "=== Installing Claude Code ==="
npm install -g @anthropic-ai/claude-code
