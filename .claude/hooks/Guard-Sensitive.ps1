# Guard-Sensitive.ps1 — 保护敏感文件不被误编辑
# 由 PreToolUse hook 自动调用
# exit 2 = 阻断操作并反馈, exit 0 = 允许

param()

# 从标准输入读取原始字节并用 UTF-8 解码，避免控制台编码导致中文路径损坏
$stdin = [System.Console]::OpenStandardInput()
$ms = New-Object System.IO.MemoryStream
$buffer = New-Object byte[] 1024
while ($true) {
    $read = $stdin.Read($buffer, 0, $buffer.Length)
    if ($read -le 0) { break }
    $ms.Write($buffer, 0, $read)
}
$bytes = $ms.ToArray()
if ($bytes.Length -eq 0) { exit 0 }

# 去除可能的 BOM
if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    $bytes = $bytes[3..($bytes.Length - 1)]
}
$inputJson = [System.Text.Encoding]::UTF8.GetString($bytes)
if ([string]::IsNullOrWhiteSpace($inputJson)) { exit 0 }

try {
    $data = $inputJson | ConvertFrom-Json -ErrorAction Stop
} catch {
    exit 0
}

$filePath = $null
if ($data.tool_input -and $data.tool_input.file_path) {
    $filePath = $data.tool_input.file_path
} elseif ($data.file_path) {
    $filePath = $data.file_path
}

if ([string]::IsNullOrWhiteSpace($filePath)) { exit 0 }

# 规范化路径（统一分隔符，统一大小写比较）
$normalized = $filePath.Replace('\', '/').ToLowerInvariant()

# 阻断：编辑 settings.local.json
if ($normalized -match '/\.claude/settings\.local\.json$') {
    Write-Error "BLOCKED: 不允许直接编辑 settings.local.json。如需修改 hooks 配置，请手动编辑后重启会话或重新加载配置快照。"
    exit 2
}

# 警告：编辑 rules 文件
if ($normalized -match '/\.claude/rules/') {
    Write-Warning "WARNING: 你正在编辑系统规则文件。确认这是有意的修改。"
    exit 0
}

# 警告：编辑 CLAUDE.md
if ($normalized -match '/CLAUDE\.md$') {
    Write-Warning "WARNING: 你正在编辑主指令文件 CLAUDE.md。"
    exit 0
}

exit 0
