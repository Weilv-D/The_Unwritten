#!/bin/bash
# word-count-check.sh — 正文写入后自动检查字数
# 由 PostToolUse hook 自动调用
# 仅对 05_正文/ 目录下的文件生效

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4)

# 只检查正文目录
if [[ "$FILE_PATH" == *05_正文* ]] && [[ -f "$FILE_PATH" ]]; then
  # 统计中文字符数（排除空白和标点的纯汉字）
  CHAR_COUNT=$(cat "$FILE_PATH" | tr -d '[:space:][:punct:]' | wc -m)

  if [[ $CHAR_COUNT -lt 5500 ]]; then
    echo "WARNING: 字数不足！当前约 ${CHAR_COUNT} 字，目标 6000 字（最低 5500）" >&2
  elif [[ $CHAR_COUNT -gt 6500 ]]; then
    echo "WARNING: 字数超标！当前约 ${CHAR_COUNT} 字，目标 6000 字（最高 6500）" >&2
  fi
fi

exit 0
