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

function Check-Contains {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Message
    )

    $matches = & rg --no-heading --line-number --fixed-strings $Pattern $Path 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $matches) {
        Add-Failure $Message
    }
}

function Check-NotContains {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Message
    )

    $matches = & rg --no-heading --line-number --fixed-strings $Pattern $Path 2>$null
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
        Add-Failure "Skill 缺少规范入口：$($dir.FullName)\SKILL.md"
    }
    if ((Test-Path -LiteralPath $lower) -and ($lower -ne $upper)) {
        Add-Failure "Skill 存在非规范小写入口：$lower"
    }
}

$referenceFiles = @(
    'README.md',
    'CLAUDE.md',
    '00_项目基础/使用指导书.md',
    '00_项目基础/统一方法论与工作流指导.md'
)

$commandFiles = $referenceFiles + (Get-ChildItem '.claude/skills' -Recurse -Filter 'SKILL.md' | ForEach-Object { $_.FullName })
$rawCommands = & rg --no-filename --only-matching --pcre2 '(?<=`)/[a-z]+(?:-[a-z]+)+(?=`)' $commandFiles 2>$null
$commandAllowList = @('hooks', 'skill-name')
$commands = @()

if ($LASTEXITCODE -eq 0 -and $rawCommands) {
    $commands = $rawCommands |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ } |
        Sort-Object -Unique
}

foreach ($command in $commands) {
    $name = $command.TrimStart('/')
    if ($commandAllowList -contains $name) {
        continue
    }

    $skillPath = Join-Path '.claude/skills' $name
    if (-not (Test-Path -LiteralPath $skillPath)) {
        Add-Failure "检测到不存在的命令引用：$command"
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

# 工作流契约检查
Check-NotContains '.claude/hooks/guard-sensitive.sh' '/update-config' 'guard-sensitive.sh 仍引用不存在的 /update-config'

Check-NotContains '.claude/skills/daily-start/SKILL.md' '3,000,000' 'daily-start 仍硬编码总目标字数'
Check-NotContains '.claude/skills/daily-start/SKILL.md' 'X/100' 'daily-start 仍硬编码章节总数'
Check-Contains '.claude/skills/daily-start/SKILL.md' '未锁定' 'daily-start 未声明目标字数未锁定时的输出规则'

Check-NotContains '.claude/skills/design-detail-outline/SKILL.md' '默认100章' 'design-detail-outline 仍把 100 章写成默认前提'
Check-NotContains '.claude/skills/design-detail-outline/SKILL.md' '001-005' 'design-detail-outline 仍保留固定 100 章分段模板'
Check-Contains '.claude/skills/design-detail-outline/SKILL.md' '章节范围建议' 'design-detail-outline 未要求在卷规模未锁定时先给章节范围建议'

Check-Contains '.claude/skills/review-chapter/SKILL.md' '06_追踪/审查报告/' 'review-chapter 未声明审查报告落盘路径'
Check-Contains '.claude/skills/review-volume/SKILL.md' '06_追踪/审查报告/' 'review-volume 未声明审查报告落盘路径'
Check-Contains '06_追踪/INDEX.md' '卷X_chNNN_章节审查.md' '追踪索引未登记单章审查报告命名规范'

Check-Contains '.claude/skills/end-session/SKILL.md' 'git status --short' 'end-session 未结合 Git 状态回顾本次会话'
Check-Contains '.claude/skills/check-consistency/SKILL.md' '作者确认后' 'check-consistency 未要求作者确认后再更新追踪'

Check-Contains '00_项目基础/统一方法论与工作流指导.md' '硬规则' '统一方法论未声明硬规则层'
Check-Contains '00_项目基础/统一方法论与工作流指导.md' '默认模板' '统一方法论未声明默认模板层'
Check-Contains '00_项目基础/统一方法论与工作流指导.md' '参考技法' '统一方法论未声明参考技法层'

if ($failures.Count -gt 0) {
    Write-Host '结构审计未通过：' -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host ''
        Write-Host $failure -ForegroundColor Yellow
    }
    exit 1
}

Write-Host '结构审计通过。' -ForegroundColor Green
