#!/bin/bash

# Daily Backup Script for Obsidian PARA Vault + OpenClaw Config
# Runs at 23:00 daily via LaunchAgent

set -e

LOG_FILE="/tmp/openclaw-backup.log"
ERROR_LOG="/tmp/openclaw-backup-error.log"
DATE=$(date '+%Y-%m-%d %H:%M')

echo "=== Backup started at $DATE ===" >> "$LOG_FILE"

# 1. Backup Obsidian Vault (1. openclaw/)
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw"

# Check for changes
if [[ -n $(git status --porcelain) ]]; then
    git add -A
    git commit -m "Daily backup - $DATE" >> "$LOG_FILE" 2>> "$ERROR_LOG" || true
    git push origin main >> "$LOG_FILE" 2>> "$ERROR_LOG" || true
    echo "✅ Obsidian Vault: backed up at $(date '+%H:%M')" >> "$LOG_FILE"
else
    echo "ℹ️ Obsidian Vault: no changes to commit" >> "$LOG_FILE"
fi

# 2. Backup OpenClaw Config (sanitized)
mkdir -p "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/openclaw-config"
cp ~/.openclaw/openclaw.json "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/openclaw-config/openclaw.json"

# Sanitize secrets
sed -i '' 's/"token": "[^"]*"/"token": "[REDACTED]"/g' "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/openclaw-config/openclaw.json"
sed -i '' 's/"apiKey": "[^"]*"/"apiKey": "[REDACTED]"/g' "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw/openclaw-config/openclaw.json"

# Commit OpenClaw config if changed
cd "/Users/jarvis/Mac-Mini-Obsidian-Vault/1. openclaw"
if [[ -n $(git status --porcelain openclaw-config/) ]]; then
    git add openclaw-config/
    git commit -m "OpenClaw config backup - $DATE" >> "$LOG_FILE" 2>> "$ERROR_LOG" || true
    git push origin main >> "$LOG_FILE" 2>> "$ERROR_LOG" || true
    echo "✅ OpenClaw config: backed up at $(date '+%H:%M')" >> "$LOG_FILE"
else
    echo "ℹ️ OpenClaw config: no changes" >> "$LOG_FILE"
fi

echo "=== Backup completed ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
