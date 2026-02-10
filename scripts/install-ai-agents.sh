#!/bin/bash
set -e

echo "=== AI Agent Tools Setup ==="

# Claude Code
if command -v claude &> /dev/null; then
    echo "[Claude Code] Already installed: $(claude --version 2>/dev/null || echo 'installed')"
else
    echo "[Claude Code] Installing..."
    curl -fsSL https://claude.ai/install.sh | sh
    echo "[Claude Code] Installed. Run 'claude login' to authenticate."
fi

# OpenAI Codex CLI
if command -v codex &> /dev/null; then
    echo "[Codex] Already installed: $(codex --version 2>/dev/null || echo 'installed')"
else
    if command -v npm &> /dev/null; then
        echo "[Codex] Installing via npm..."
        npm install -g @openai/codex
        echo "[Codex] Installed. Run 'codex --login' to authenticate."
    else
        echo "[Codex] Skipped: npm not found. Run 'home-manager switch' first."
    fi
fi

# mgrep (semantic grep for AI agents)
if command -v mgrep &> /dev/null; then
    echo "[mgrep] Already installed: $(mgrep --version 2>/dev/null || echo 'installed')"
else
    if command -v npm &> /dev/null; then
        echo "[mgrep] Installing via npm..."
        npm install -g @mixedbread/mgrep
        echo "[mgrep] Installed. Run 'mgrep login' to authenticate."
    else
        echo "[mgrep] Skipped: npm not found. Run 'home-manager switch' first."
    fi
fi

# GitHub CLI authentication check
if command -v gh &> /dev/null; then
    if gh auth status &> /dev/null; then
        echo "[GitHub CLI] Already authenticated"
    else
        echo "[GitHub CLI] Not authenticated. Run 'gh auth login' to authenticate."
    fi
else
    echo "[GitHub CLI] Not found. Run 'home-manager switch' first."
fi

echo ""
echo "=== Setup Complete ==="
echo "Next steps:"
echo "  claude login     # Authenticate Claude Code"
echo "  codex --login    # Authenticate Codex (if installed)"
echo "  mgrep login      # Authenticate mgrep (if installed)"
echo "  gh auth login    # Authenticate GitHub CLI"
