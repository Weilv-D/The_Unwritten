#!/bin/bash
# word-count-check.sh — 正文写入后自动检查字数
# 由 PostToolUse hook 自动调用
# 仅对 05_正文/ 目录下的文件生效

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4)

# 只检查正文目录
if [[ "$FILE_PATH" == *05_正文* ]] && [[ -f "$FILE_PATH" ]]; then
  # 统计中文字符数（排除ASCII、空白、中英文标点、Markdown符号后计数）
  CHAR_COUNT=$(cat "$FILE_PATH" | sed 's/[[:space:]]//g; s/[[:punct:]]//g; s/[a-zA-Z0-9]//g; s/[，。！？、；：""''（）《》【】『』「」—…·]//g' | tr -d '\n\r' | wc -m)

  if [[ $CHAR_COUNT -lt 5500 ]]; then
    echo "WARNING: 字数不足！当前约 ${CHAR_COUNT} 字，目标 6000 字（最低 5500）" >&2
  elif [[ $CHAR_COUNT -gt 8000 ]]; then
    echo "WARNING: 字数超标！当前约 ${CHAR_COUNT} 字，目标 6000 字（最高 8000）" >&2
  fi
fi

exit 0
