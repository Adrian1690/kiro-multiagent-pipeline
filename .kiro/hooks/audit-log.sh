#!/usr/bin/env bash
# PostToolUse hook — logs every file read/write to .kiro/audit.log
# Learning goal: understand how hooks intercept tool calls

INPUT=$(cat)
TOOL=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name','unknown'))")
SESSION=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('session_id','unknown'))")
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

LOG_DIR="$(pwd)/.kiro"
mkdir -p "$LOG_DIR"

echo "$TIMESTAMP | session=$SESSION | tool=$TOOL" >> "$LOG_DIR/audit.log"

exit 0
