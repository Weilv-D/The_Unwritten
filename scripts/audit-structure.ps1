$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$failures = New-Object System.Collections.Generic.List[string]

function Add-Failure {
    param([string]$Message)
    $failures.Add($Message)
}

function Check-Path {
    param([string]$Path, [string]$Message)
    if (-not (Test-Path -LiteralPath $Path)) {
        Add-Failure $Message
    }
}

function Check-ForbiddenMatches {
    param(
        [string]$Pattern,
        [string]$Message
    )

    $matches = & rg --no-heading --line-number --fixed-strings --glob '!scripts/audit-structure.ps1' $Pattern . 2>$null
    if ($LASTEXITCODE -eq 0 -and $matches) {
        Add-Failure "$Message`n$matches"
    }
}

$requiredIndexes = @(
    '01_世界观/INDEX.md',
    '02_人物/INDEX.md',
    '03_大纲/INDEX.md',
    '04_章纲/INDEX.md',
    '05_正文/INDEX.md',
    '06_追踪/INDEX.md',
    '08_灵感/INDEX.md'
)

foreach ($path in $requiredIndexes) {
    Check-Path $path "缺失一级目录索引：$path"
}

$skillDirs = Get-ChildItem '.claude/skills' -Directory
foreach ($dir in $skillDirs) {
    $upper = Join-Path $dir.FullName 'SKILL.md'
    $lower = Join-Path $dir.FullName 'skill.md'
    if (-not (Test-Path -LiteralPath $upper)) {
        Add-Failure "Skill 缺少规范入口：$($dir.FullName)\\SKILL.md"
    }
    if ((Test-Path -LiteralPath $lower) -and ($lower -ne $upper)) {
        Add-Failure "Skill 存在非规范小写入口：$lower"
    }
}

$forbiddenStrings = @(
    'writing-style.md',
    'forbidden-rules.md',
    'creative-philosophy.md',
    'writing-methodology.md',
    '关系图谱.md',
    '文言文写作指南（AI专用）.txt',
    '12条禁止规则',
    '10个规则文件',
    '16个技能',
    '01_geography',
    '02_three_paths',
    '03_cultivation',
    '04_power_system',
    '04_history',
    '05_factions',
    '06_概念设计',
    'mcp__neo4j-memory__',
    'mcp__neo4j-cypher__get-schema',
    'mcp__neo4j-cypher__read-query',
    'mcp__neo4j-cypher__write-query'
)

foreach ($text in $forbiddenStrings) {
    Check-ForbiddenMatches $text "检测到过时引用：$text"
}

if ($failures.Count -gt 0) {
    Write-Host '结构审计未通过：' -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host ''
        Write-Host $failure -ForegroundColor Yellow
    }
    exit 1
}

Write-Host '结构审计通过。' -ForegroundColor Green

