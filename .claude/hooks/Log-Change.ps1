# Log-Change.ps1 — 记录文件修改到创作日志
# 由 PostToolUse hook 自动调用
# stdin 接收 JSON: {"tool_name":"...","tool_input":{...},"transcript_path":"..."}

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

$tool = $data.tool_name
if ([string]::IsNullOrWhiteSpace($tool)) { $tool = "Unknown" }

if ([string]::IsNullOrWhiteSpace($filePath)) { exit 0 }

# 规范化路径
$normalized = $filePath.Replace('\', '/')

# 获取项目根目录
$projectRoot = $null
if ($env:CLAUDE_PROJECT_DIR) {
    $projectRoot = $env:CLAUDE_PROJECT_DIR.Replace('\', '/').TrimEnd('/')
}

# 从路径推导项目根目录
if (-not $projectRoot) {
    $pattern = '^(.*)/(00_项目基础|01_世界观|02_人物|03_大纲|04_章纲|05_正文|06_追踪|08_灵感|\.claude)/.*$'
    if ($normalized -match $pattern) {
        $projectRoot = $matches[1]
    }
}

if (-not $projectRoot) { exit 0 }

# 只记录创作相关目录下的文件
$creativeDirs = @('/05_正文/', '/04_章纲/', '/03_大纲/', '/01_世界观/', '/02_人物/', '/06_追踪/', '/08_灵感/')
$isCreative = $false
foreach ($dir in $creativeDirs) {
    if ($normalized -like "*$dir*") { $isCreative = $true; break }
}

if (-not $isCreative) { exit 0 }
if ($normalized -like '*/.git/*') { exit 0 }

# 计算相对路径
$relPath = $normalized.Substring($projectRoot.Length + 1)
$logPath = "$projectRoot/06_追踪/创作日志.md"

# 确保日志文件存在且包含标题
if (-not (Test-Path $logPath)) {
    $header = @"
# 创作日志

> 自动记录所有创作相关文件的修改。由 `Log-Change.ps1` hook 维护。
> 本文件是**辅助日志**，用于回顾近期变更，不作为会话事实的唯一来源。

---

"@
    $header | Set-Content -Path $logPath -Encoding UTF8
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$entry = @"

### [$timestamp] $tool`: $relPath
- 动作类型：$tool
- 相对路径：$relPath
- 备注：hook 自动记录，仅供会话回顾辅助
"@

$entry | Add-Content -Path $logPath -Encoding UTF8

exit 0
