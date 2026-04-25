$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$failures = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-Failure {
    param([string]$Message)
    $failures.Add($Message)
}

function Add-Warning {
    param([string]$Message)
    $warnings.Add($Message)
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

    $matches = Get-ChildItem -Path . -Recurse -File -Exclude 'audit-structure.ps1' |
        Select-String -Pattern $Pattern -SimpleMatch -ErrorAction SilentlyContinue
    if ($matches) {
        $lines = $matches | ForEach-Object { "$($_.Path):$($_.LineNumber):$($_.Line)" }
        Add-Failure "$Message`n$($lines -join "`n")"
    }
}

function Check-Contains {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Message
    )

    $matches = Select-String -Path $Path -Pattern $Pattern -SimpleMatch -ErrorAction SilentlyContinue
    if (-not $matches) {
        Add-Failure $Message
    }
}

function Check-NotContains {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Message
    )

    $matches = Select-String -Path $Path -Pattern $Pattern -SimpleMatch -ErrorAction SilentlyContinue
    if ($matches) {
        $lines = $matches | ForEach-Object { "$($_.Path):$($_.LineNumber):$($_.Line)" }
        Add-Failure "$Message`n$($lines -join "`n")"
    }
}

function Normalize-IndexEntry {
    param([string]$Text)

    $entry = $Text.Trim()
    $entry = $entry.Trim('`')
    $entry = $entry.Trim()
    return $entry
}

function Check-IndexFileEntries {
    param(
        [string]$IndexPath,
        [string]$BasePath
    )

    if (-not (Test-Path -LiteralPath $IndexPath)) {
        Add-Failure "缺失索引，无法检查条目：$IndexPath"
        return
    }

    $lines = Get-Content -Path $IndexPath -Encoding UTF8
    foreach ($line in $lines) {
        if ($line -notmatch '^\|') { continue }
        if ($line -match '^\|\s*-') { continue }

        $cells = $line.Trim('|').Split('|') | ForEach-Object { Normalize-IndexEntry $_ }
        if ($cells.Count -lt 2) { continue }

        $entry = $cells[0]
        if ([string]::IsNullOrWhiteSpace($entry)) { continue }
        if ($entry -in @('文件', '文件/目录', '卷次', '目录')) { continue }
        if ($entry -like '（暂无*') { continue }
        if ($entry -eq '—') { continue }
        if ($entry -notmatch '(\.md|/)$') { continue }
        if ($line -match '未开始|待定（预留') { continue }

        $candidate = Join-Path $BasePath $entry
        if (-not (Test-Path -LiteralPath $candidate)) {
            Add-Failure "INDEX 条目指向不存在的文件或目录：$IndexPath -> $entry"
        }
    }
}

function Check-WarningMatches {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Message
    )

    $matches = Select-String -Path $Path -Pattern $Pattern -SimpleMatch -ErrorAction SilentlyContinue
    if ($matches) {
        $count = ($matches | Measure-Object).Count
        Add-Warning "$Message（$count 处）"
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

Check-Path '06_追踪/审查报告/审查报告模板.md' '缺失审查报告模板：06_追踪/审查报告/审查报告模板.md'
Check-Path '04_章纲/章纲模板.md' '缺失章纲模板：04_章纲/章纲模板.md'

Check-IndexFileEntries '02_人物/INDEX.md' '02_人物'
Check-IndexFileEntries '06_追踪/INDEX.md' '06_追踪'
Check-IndexFileEntries '08_灵感/INDEX.md' '08_灵感'

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
$rawMatches = $commandFiles | Select-String -Pattern '(?<=`)/[a-z]+(?:-[a-z]+)+(?=`)' -AllMatches -ErrorAction SilentlyContinue
$commandAllowList = @('hooks', 'skill-name')
$commands = @()

if ($rawMatches) {
    $commands = $rawMatches.Matches |
        ForEach-Object { $_.Value.Trim() } |
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
Check-NotContains '.claude/hooks/Guard-Sensitive.ps1' '/update-config' 'Guard-Sensitive.ps1 仍引用不存在的 /update-config'

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
Check-Contains '00_项目基础/统一方法论与工作流指导.md' '写作质量闭环' '统一方法论未声明写作质量闭环'

# 写作质量 workflow 检查
Check-Contains '.claude/skills/design-chapter-outline/SKILL.md' '写作契约' 'design-chapter-outline 未要求输出写作契约'
Check-Contains '.claude/skills/design-chapter-outline/SKILL.md' '需查证来源' 'design-chapter-outline 未要求列出需查证来源'
Check-Contains '.claude/skills/design-chapter-outline/SKILL.md' '来源清单' 'design-chapter-outline 未要求来源清单'

Check-Contains '.claude/skills/write-chapter/SKILL.md' '上下文清单' 'write-chapter 未声明上下文清单'
Check-Contains '.claude/skills/write-chapter/SKILL.md' '写作契约' 'write-chapter 未读取写作契约'
Check-Contains '.claude/skills/write-chapter/SKILL.md' '反思修订' 'write-chapter 未包含反思修订步骤'
Check-Contains '.claude/skills/write-chapter/SKILL.md' 'FAIL级硬规则' 'write-chapter 未执行 FAIL级硬规则自检'
Check-Contains '.claude/skills/write-chapter/SKILL.md' '作者确认后存档' 'write-chapter 未要求作者确认后存档'
Check-Contains '.claude/skills/write-chapter/SKILL.md' '正式采纳 / 试笔参考 / 不入库' 'write-chapter 未要求短篇 canon 状态'

Check-Contains '.claude/skills/review-chapter/SKILL.md' '证据优先' 'review-chapter 未采用证据优先报告'
Check-Contains '.claude/skills/review-chapter/SKILL.md' '需作者决策' 'review-chapter 未要求标注需作者决策项'
Check-Contains '.claude/skills/edit-chapter/SKILL.md' '证据优先修订' 'edit-chapter 未采用证据优先修订'
Check-Contains '.claude/skills/edit-chapter/SKILL.md' 'FAIL级硬规则' 'edit-chapter 未执行 FAIL级硬规则自检'
Check-Contains '.claude/skills/check-consistency/SKILL.md' '来源取证' 'check-consistency 未声明来源取证'
Check-Contains '.claude/skills/check-consistency/SKILL.md' '作者确认后' 'check-consistency 未要求作者确认后再更新追踪'
Check-Contains '.claude/skills/review-volume/SKILL.md' '证据优先' 'review-volume 未采用证据优先报告'

# 当前作品规格未锁定时，只提示占位字段，不作为结构失败
Check-WarningMatches '02_人物/*.md' '待定' '人物档案仍存在待定字段'
Check-WarningMatches '03_大纲/故事梗概.md' '待填充' '故事梗概仍存在待填充字段'

if ($failures.Count -gt 0) {
    Write-Host '结构审计未通过：' -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host ''
        Write-Host $failure -ForegroundColor Yellow
    }
    exit 1
}

if ($warnings.Count -gt 0) {
    Write-Host '结构审计警告：' -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host ''
        Write-Host $warning -ForegroundColor Yellow
    }
    Write-Host ''
}

Write-Host '结构审计通过。' -ForegroundColor Green
