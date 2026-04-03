#!/bin/bash
# log-change.sh — 记录文件修改到创作日志
# 由 PostToolUse hook 自动调用
# stdin 接收 JSON: {"tool_name":"...","tool_input":{...},"transcript_path":"..."}

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4)
TOOL=$(echo "$INPUT" | grep -o '"tool_name":"[^"]*"' | head -1 | cut -d'"' -f4)
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")

# 只记录项目目录内的文件
if [[ "$FILE_PATH" == *TheUnwritten* ]] && [[ "$FILE_PATH" != *.git/* ]]; then
  RELATIVE=$(echo "$FILE_PATH" | sed 's|.*/TheUnwritten/||')
  LOG_PATH=$(echo "$FILE_PATH" | sed 's|TheUnwritten/.*|TheUnwritten/06_追踪/创作日志.md|')

  if [[ -f "$LOG_PATH" ]]; then
    # 追加一行日志（不修改已有内容）
    echo "" >> "$LOG_PATH"
    echo "### [$TIMESTAMP] $TOOL: $RELATIVE" >> "$LOG_PATH"
  fi
fi

exit 0
