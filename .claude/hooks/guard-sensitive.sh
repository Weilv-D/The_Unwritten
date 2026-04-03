#!/bin/bash
# guard-sensitive.sh — 保护敏感文件不被误编辑
# 由 PreToolUse hook 自动调用
# exit 2 = 阻断操作并反馈, exit 0 = 允许

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4)
TOOL_INPUT=$(echo "$INPUT" | grep -o '"tool_input":{[^}]*}"')

# 阻断：编辑 settings.local.json
if [[ "$FILE_PATH" == *".claude/settings.local.json"* ]]; then
  echo "BLOCKED: 不允许直接编辑 settings.local.json。如需修改 hooks 配置，请使用 /update-config 或手动编辑。" >&2
  exit 2
fi

# 警告：编辑 rules 文件
if [[ "$FILE_PATH" == *".claude/rules/"* ]]; then
  echo "WARNING: 你正在编辑系统规则文件。确认这是有意的修改。" >&2
  exit 0
fi

# 警告：编辑 CLAUDE.md
if [[ "$FILE_PATH" == *"CLAUDE.md"* ]]; then
  echo "WARNING: 你正在编辑主指令文件 CLAUDE.md。" >&2
  exit 0
fi

exit 0
