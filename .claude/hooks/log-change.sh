#!/bin/bash
# log-change.sh — 记录文件修改到创作日志
# 由 PostToolUse hook 自动调用
# stdin 接收 JSON: {"tool_name":"...","tool_input":{...},"transcript_path":"..."}

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4)
TOOL=$(echo "$INPUT" | grep -o '"tool_name":"[^"]*"' | head -1 | cut -d'"' -f4)
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")

# 获取项目根目录（优先使用环境变量，兼容路径变更）
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(echo "$FILE_PATH" | sed -E 's|/(0[0-8]_[^/]*/.*)||')}"

# 只记录创作相关目录下的文件
if [[ "$FILE_PATH" == "$PROJECT_ROOT"* ]] && [[ "$FILE_PATH" != *.git/* ]]; then
  # 过滤：只记录创作内容目录
  if [[ "$FILE_PATH" == */05_正文/* ]] || \
     [[ "$FILE_PATH" == */04_章纲/* ]] || \
     [[ "$FILE_PATH" == */03_大纲/* ]] || \
     [[ "$FILE_PATH" == */01_世界观/* ]] || \
     [[ "$FILE_PATH" == */02_人物/* ]] || \
     [[ "$FILE_PATH" == */06_追踪/* ]]; then
    RELATIVE="${FILE_PATH#$PROJECT_ROOT/}"
    LOG_PATH="$PROJECT_ROOT/06_追踪/创作日志.md"

    if [[ -f "$LOG_PATH" ]]; then
      echo "" >> "$LOG_PATH"
      echo "### [$TIMESTAMP] $TOOL: $RELATIVE" >> "$LOG_PATH"
    fi
  fi
fi

exit 0
