#!/bin/bash
# word-count-check.sh — 正文写入后自动检查字数
# 由 PostToolUse hook 自动调用
# 仅对 05_正文/ 目录下的文件生效

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/path-utils.sh"

INPUT=$(cat)
RAW_FILE_PATH=$(extract_json_field "$INPUT" '.tool_input.file_path')
FILE_PATH=$(normalize_hook_path "$RAW_FILE_PATH")

# 只检查正文目录
if [[ "$FILE_PATH" == */05_正文/* ]] && [[ -f "$FILE_PATH" ]]; then
  # 统计中文字符数（排除ASCII、空白、中英文标点、Markdown符号后计数）
  CHAR_COUNT=$(cat "$FILE_PATH" | sed 's/[[:space:]]//g; s/[[:punct:]]//g; s/[a-zA-Z0-9]//g; s/[，。！？、；：""''（）《》【】『』「」—…·]//g' | tr -d '\n\r' | wc -m)

  if [[ $CHAR_COUNT -lt 6500 ]]; then
    echo "WARNING: 当前约 ${CHAR_COUNT} 字，低于默认参考范围。默认目标为 7500 字，常用参考区间为 6500-8500；如偏离，请在交付时说明原因。" >&2
  elif [[ $CHAR_COUNT -gt 8500 ]]; then
    echo "WARNING: 当前约 ${CHAR_COUNT} 字，高于默认参考范围。默认目标为 7500 字，常用参考区间为 6500-8500；如偏离，请在交付时说明原因。" >&2
  fi
fi

exit 0
