#!/bin/bash
# log-change.sh — 记录文件修改到创作日志
# 由 PostToolUse hook 自动调用
# stdin 接收 JSON: {"tool_name":"...","tool_input":{...},"transcript_path":"..."}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/path-utils.sh"

INPUT=$(cat)
RAW_FILE_PATH=$(extract_json_field "$INPUT" '.tool_input.file_path')
FILE_PATH=$(normalize_hook_path "$RAW_FILE_PATH")
TOOL=$(extract_json_field "$INPUT" '.tool_name')
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")

# 获取项目根目录（优先使用环境变量，兼容路径变更）
PROJECT_ROOT=$(normalize_hook_path "${CLAUDE_PROJECT_DIR:-}")
if [[ -z "$PROJECT_ROOT" ]]; then
  PROJECT_ROOT=$(derive_project_root "$FILE_PATH")
fi

# 只记录创作相关目录下的文件
if [[ -n "$FILE_PATH" ]] && [[ -n "$PROJECT_ROOT" ]] && [[ "$FILE_PATH" == "$PROJECT_ROOT"* ]] && [[ "$FILE_PATH" != */.git/* ]]; then
  # 过滤：只记录创作内容目录
  if [[ "$FILE_PATH" == */05_正文/* ]] || \
     [[ "$FILE_PATH" == */04_章纲/* ]] || \
     [[ "$FILE_PATH" == */03_大纲/* ]] || \
     [[ "$FILE_PATH" == */01_世界观/* ]] || \
     [[ "$FILE_PATH" == */02_人物/* ]] || \
     [[ "$FILE_PATH" == */06_追踪/* ]] || \
     [[ "$FILE_PATH" == */08_灵感/* ]]; then
    RELATIVE="${FILE_PATH#$PROJECT_ROOT/}"
    LOG_PATH="$PROJECT_ROOT/06_追踪/创作日志.md"

    if [[ -f "$LOG_PATH" ]]; then
      echo "" >> "$LOG_PATH"
      echo "### [$TIMESTAMP] $TOOL: $RELATIVE" >> "$LOG_PATH"
      echo "- 动作类型：$TOOL" >> "$LOG_PATH"
      echo "- 相对路径：$RELATIVE" >> "$LOG_PATH"
      echo "- 备注：hook 自动记录，仅供会话回顾辅助" >> "$LOG_PATH"
    fi
  fi
fi

exit 0
