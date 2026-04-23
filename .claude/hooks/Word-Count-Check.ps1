# Word-Count-Check.ps1 — 正文写入后自动检查字数
# 由 PostToolUse hook 自动调用
# 仅对 05_正文/ 目录下的文件生效

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

# 只检查正文目录
$normalized = $filePath.Replace('\', '/')
if (-not ($normalized -like '*/05_正文/*')) { exit 0 }

# 检查文件是否存在
if (-not (Test-Path $filePath)) { exit 0 }

# 读取内容并统计中文字符数
$content = Get-Content -Path $filePath -Raw -Encoding UTF8

# 排除：空白、ASCII字母数字、常见标点、Markdown符号
# 定义要排除的字符模式
$excludedPattern = '[\s\p{P}a-zA-Z0-9\-*_#>`\[\](){}|!~=`@$%^&+=\\/"''。？！，、；：""''（）《》【】『』「」—…·]'
$cleaned = $content -replace $excludedPattern, ''

# 统计剩余字符（主要为汉字）
$charCount = $cleaned.Length

if ($charCount -lt 6500) {
    Write-Warning "WARNING: 当前约 ${charCount} 字，低于默认参考范围。默认目标为 7500 字，常用参考区间为 6500-8500；如偏离，请在交付时说明原因。"
} elseif ($charCount -gt 8500) {
    Write-Warning "WARNING: 当前约 ${charCount} 字，高于默认参考范围。默认目标为 7500 字，常用参考区间为 6500-8500；如偏离，请在交付时说明原因。"
}

exit 0
