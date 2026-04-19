# The Unwritten

> Claude Code 协作长篇仙侠小说创作工作台

---

## 项目定位

本仓库是长篇仙侠小说的创作工作空间，承载世界观设定、人物档案、卷次大纲、逐章章纲与正文，并为 Claude Code 提供稳定的项目上下文。

- **人类负责创作决策**：人物命运、情节走向、世界观定案均由作者拍板
- **Claude 负责流程化辅助**：格式整理、文风校验、一致性检查、索引维护
- **文档驱动**：所有资料以 Markdown 管理，Git 追踪版本

---

## 当前状态

| 模块 | 状态 | 说明 |
|------|------|------|
| 世界观 | 已建档 | 七大模块完整：地理、三玄、修行、力量体系、历史、势力、概念设计 |
| 人物 | 基础建档 | 已有基础角色档案，作品级主角与核心关系待锁定 |
| 大纲 | 待启动 | — |
| 章纲 | 待启动 | — |
| 正文 | 待启动 | — |

---

## 快速开始

### 开始一次会话

```
/daily-start
```

恢复上下文与当前状态，查看待办事项。

### 创作流程

```
/daily-start              → 恢复上下文
/design-world             → 扩展世界观
/create-character         → 创建角色
/design-outline           → 设计卷次大纲
/design-detail-outline    → 设计卷次细纲
/design-chapter-outline   → 生成单章章纲
/write-chapter            → 创作正文
/review-chapter           → 审查章节
/check-consistency        → 一致性检查
/end-session              → 收束会话
```

### 先读索引

每个一级内容目录下都有 `INDEX.md`，先看索引再进入具体文件。

---

## 目录结构

```
TheUnwritten/
├── 00_项目基础/     使用指导、方法论、进度管理
├── 01_世界观/       世界观设定（七大模块）
├── 02_人物/         角色档案
├── 03_大纲/         故事梗概与卷次大纲/细纲
├── 04_章纲/         逐章章纲
├── 05_正文/         逐卷正文章节
├── 06_追踪/         创作日志、伏笔追踪、审查报告
├── 08_灵感/         灵感碎片与研究资料
└── .claude/         规则、skills、hooks、配置
```

| 目录 | 作用 | 入口 |
|------|------|------|
| `00_项目基础/` | 使用指导、方法论、进度管理 | `使用指导书.md` |
| `01_世界观/` | 世界观设定与术语索引 | `INDEX.md` |
| `02_人物/` | 角色档案 | `INDEX.md` |
| `03_大纲/` | 故事梗概与卷次大纲/细纲 | `INDEX.md` |
| `04_章纲/` | 逐章章纲 | `INDEX.md` |
| `05_正文/` | 逐卷正文章节 | `INDEX.md` |
| `06_追踪/` | 创作日志、伏笔追踪、审查报告 | `INDEX.md` |
| `08_灵感/` | 灵感碎片与研究资料 | `INDEX.md` |

> `07_*` 为预留编号位，当前未启用。

---

## 关键文档

| 用途 | 路径 |
|------|------|
| 项目运行时约束 | `CLAUDE.md` |
| 人类维护手册 | `00_项目基础/使用指导书.md` |
| 方法论权威源（硬规则 / 默认模板 / 参考技法） | `00_项目基础/统一方法论与工作流指导.md` |
| 文风分层、FAIL级硬规则与深审项 | `.claude/rules/core-style.md` |
| 世界观方法与术语规范 | `.claude/rules/core-world.md` |
| 角色方法 | `.claude/rules/core-character.md` |
| 剧情与结构方法 | `.claude/rules/core-plot.md` |
| 文件命名与索引规范 | `.claude/rules/file-conventions.md` |

---

## Skills 速查

| 类型 | 命令 | 用途 |
|------|------|------|
| 会话 | `/daily-start` | 恢复上下文与当前状态 |
| 会话 | `/end-session` | 收束成果、记录待办 |
| 设定 | `/design-world` | 扩展世界观模块 |
| 人物 | `/create-character` | 创建角色档案 |
| 大纲 | `/design-outline` | 设计卷次大纲 |
| 大纲 | `/design-detail-outline` | 设计卷次细纲 |
| 章纲 | `/design-chapter-outline` | 生成单章章纲 |
| 正文 | `/write-chapter` | 创作章节正文 |
| 修订 | `/edit-chapter` | 修改已有章节 |
| 审查 | `/review-chapter` | 单章质量评审 |
| 审查 | `/review-volume` | 全卷综合审查 |
| 审查 | `/check-consistency` | 跨文件一致性检查 |
| 灵感 | `/capture-idea` | 归档灵感碎片 |
| 辅助 | `/unstuck` | 分析创作卡点 |
| 图谱 | `/kg-update` | 同步 Neo4j 知识图谱 |
| 文言 | `/wenyan-writing` | 文言/古风写作参考 |

---

## Claude Code 接口

| 接口 | 作用 |
|------|------|
| `CLAUDE.md` | 项目运行时约束，提供最小必要协作边界 |
| `.claude/rules/*.md` | 常驻或按路径加载的规则 |
| `.claude/skills/*/SKILL.md` | 自定义命令入口 |
| `.claude/settings.local.json` | hooks 与权限配置（版本控制特例） |

> `settings.local.json` 被版本控制是项目历史特例，不代表 Claude Code 官方推荐方式。
> 规则分层、默认模板与质量标准只在 `00_项目基础/统一方法论与工作流指导.md` 中定义；其余入口文档只做导航，不重复展开。

---

## 审计

结构变更、批量修改或 workflow 调整后运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\audit-structure.ps1
```

---

## 许可证

本项目内容版权归作者所有。未经授权，请勿转载或使用。
