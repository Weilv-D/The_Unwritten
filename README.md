# The Unwritten

> 长篇小说创作工作空间

---

## 项目简介

待新作品确定后填写。

---

## 目录结构

```
TheUnwritten/
├── CLAUDE.md               ← AI工作指令（入口文件，Claude Code 自动读取）
├── README.md               项目导航（本文件）
├── .claude/
│   ├── rules/              分层规则文件（按路径自动激活）
│   ├── skills/             自定义 Skills（渐进式加载）
│   ├── hooks/              自动化 Hook 脚本
│   └── settings.local.json Hooks 配置
│
├── 00_项目基础/            决策记录·进度追踪·任务清单·变更日志
├── 01_世界观/              地理·势力·力量体系·文化·历史·种族
├── 02_人物/                角色档案·人物速查·关系图谱·角色模板
├── 03_大纲/                梗概·粗纲·卷细纲
├── 04_章纲/                按"卷1/ch001.md"组织
├── 05_正文/                按"卷1/ch001.md"组织
├── 06_追踪/                创作日志·伏笔追踪·审查报告
└── 08_灵感/                剧情构思·场景灵感·对话碎片·研究资料
```

---

## 快速导航

| 用途 | 路径 |
|------|------|
| AI工作指令 | `CLAUDE.md` |
| 详细写作风格 | `.claude/rules/writing-style.md` |
| 12条禁止规则 | `.claude/rules/forbidden-rules.md` |
| 创作哲学 | `.claude/rules/creative-philosophy.md` |
| 世界观索引 | `01_世界观/INDEX.md` |
| 人物速查 | `02_人物/人物速查.md` |
| 角色模板 | `02_人物/角色模板.md` |
| 章纲模板 | `04_章纲/章纲模板.md` |
| 故事梗概 | `03_大纲/故事梗概.md` |
| 创作日志 | `06_追踪/创作日志.md` |
| 伏笔追踪 | `06_追踪/伏笔追踪.md` |

---

## 自定义 Skills

| 命令 | 用途 |
|------|------|
| `/daily-start` | 每日创作启动，自动加载上下文 |
| `/design-world 势力` | 世界观设计（涟漪展开法） |
| `/design-outline 卷1` | 设计卷次大纲（节拍器理论） |
| `/design-detail-outline 卷1` | 设计卷次细纲（逐章分配） |
| `/design-chapter-outline 卷1/ch003` | 设计单章章纲 |
| `/write-chapter 卷1/ch003` | 按流程创作一章正文 |
| `/review-chapter 卷1/ch003` | 审阅章节质量 |
| `/check-consistency 卷1` | 一致性检查（单章或全卷） |
| `/create-character 主角_姓名` | 创建新人物档案 |
| `/capture-idea 灵感内容` | 灵感速记，自动分类归档 |

---

## 创作链路

```
世界观构建 → 人物设计 → 大纲体系 → 卷细纲 → 章纲 → 正文
（人类主导）  （人机共创） （人机共创） （AI主导） （AI主导） （人机共创）
```

每一步的详细分工见 `CLAUDE.md` 第五节。

---

## 风格规范速查

- **文风**：半文半白，古典简练，严禁现代口语
- **段落公式**：[景-人-心] 三段式递进
- **内心独白**：『』包裹，表里反差（嘴上恭敬，心里算计）
- **12条禁止规则**：详见 `.claude/rules/forbidden-rules.md`
- **节拍器理论**：十大序列 × 八大要素，详见 `.claude/rules/writing-methodology.md`

---

## 版本控制

- **远程仓库**：https://github.com/Weilv-D/The_Unwritten.git
- **提交规范**：
  ```
  feat(vol1/ch001): 完成第001章初稿（7500字）
  fix(世界观): 修正力量体系等级描述不一致
  docs(人物): 新增主角_姓名角色档案
  review(vol1): 完成第一卷一致性审查
  ```

---

## 许可证

本项目内容版权归作者所有。未经授权，请勿转载或使用。



