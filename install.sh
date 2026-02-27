#!/bin/bash

# Deck Wizard Skill Installer
# Creates professional HTML presentations with Claude Code

set -e

SKILL_NAME="deck-wizard"
SKILL_DIR="$HOME/.claude/skills/$SKILL_NAME"
DECKS_DIR="$HOME/Documents/decks"

echo "Installing $SKILL_NAME skill..."

# Create skill directory if it doesn't exist
mkdir -p "$SKILL_DIR"

# Copy SKILL.md
if [ -f "SKILL.md" ]; then
    cp SKILL.md "$SKILL_DIR/"
    echo "✓ SKILL.md installed"
else
    echo "⚠ SKILL.md not found in current directory"
fi

# Copy README.md
if [ -f "README.md" ]; then
    cp README.md "$SKILL_DIR/"
    echo "✓ README.md installed"
fi

# Create decks output directory
mkdir -p "$DECKS_DIR"
echo "✓ Created decks directory: $DECKS_DIR"

# Check for optional dependency: socratico skill
if [ -d "$HOME/.claude/skills/socratico" ]; then
    echo "✓ Dependency found: socratico skill"
else
    echo ""
    echo "⚠ Optional dependency not found: socratico skill"
    echo "  The deck-wizard works without it, but it's recommended for deep analysis."
    echo "  To install:"
    echo "    gh repo clone sancrisoft/socratico-skill"
    echo "    cd socratico-skill && ./install.sh"
    echo ""
fi

echo ""
echo "✓ $SKILL_NAME skill installed successfully!"
echo ""
echo "Usage:"
echo "  /deck-wizard    - Start the interactive wizard"
echo "  /deck           - Shorthand"
echo ""
echo "Output directory: $DECKS_DIR"
echo ""
echo "Restart Claude Code to load the skill."
