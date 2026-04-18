---
name: kg-update
description: 扫描项目资料并同步到 Neo4j 知识图谱，更新实体、关系与伏笔状态。用于手动执行图谱同步。
argument-hint: "[full|人物|世界观|伏笔|场景]"
disable-model-invocation: true
---

# 知识图谱同步

扫描项目文件，将人物、势力、地点、事件、伏笔等实体同步到 Neo4j 图数据库。

## 输入参数
同步范围：$ARGUMENTS（可选值：full | 人物 | 世界观 | 伏笔 | 场景）
- `full`：全量同步所有数据
- `人物`：仅同步 02_人物/ 下的角色和关系
- `世界观`：仅同步 01_世界观/ 下的势力、地点、概念
- `伏笔`：仅同步 06_追踪/伏笔追踪.md 中的伏笔链
- `场景`：仅同步 05_正文/ 已有章节的场景共现
- 不传参数：询问用户需要同步什么

## 执行步骤

### 1. 确定同步范围
向用户确认：
- 同步范围（full / 按类型）
- 是否清空已有数据重新导入
- 如有新增节点类型，先向用户确认 Schema

### 2. 扫描数据源

**人物数据**（`02_人物/`）：
- 读取每个角色文件，提取：
  - 速览信息 → Character 节点属性
  - 关键关系表 → Character-Character 关系
  - 势力归属 → BELONGS_TO 关系
  - 出场记录 → APPEARS_IN 关系

**世界观数据**（`01_世界观/`）：
- 扫描各子目录，提取：
  - 势力 → Faction 节点 + 势力间关系
  - 地理 → Location 节点 + LOCATED_IN 关系
  - 力量体系 → PowerSystem 节点
  - 概念 → Concept 节点

**伏笔数据**（`06_追踪/伏笔追踪.md`）：
- 读取伏笔追踪表，提取：
  - 活跃伏笔 → Foreshadowing 节点（status: active）
  - 已回收伏笔 → Foreshadowing 节点（status: resolved）+ RESOLVED_IN
  - 跨卷伏笔 → Foreshadowing 节点（status: long_term）

**场景数据**（`05_正文/`）：
- 扫描已写章节，提取：
  - 每章场景 → Scene 节点 + PART_OF
  - 出场角色 → APPEARS_IN
  - 关键事件 → Event 节点

### 3. 写入 Neo4j

使用 MCP 工具 `mcp__neo4j-cypher__write-query` 按顺序写入：
1. **创建节点**：批量 CREATE
2. **添加属性**：SET 补充属性
3. **创建关系**：批量 MERGE 连接

### 4. 验证与报告
- 用 `mcp__neo4j-cypher__read-query` 读取当前图谱统计
- 向用户报告同步结果：
  - 新增节点数（按类型）
  - 新增关系数（按类型）
  - 可能的冲突或遗漏

### 5. 更新图谱概览
- 更新 `06_追踪/知识图谱.md` 中的 Mermaid 图（取核心角色和势力）
- 如有新节点类型，更新 Schema 说明

## 协作边界
- **AI自主**：数据扫描、格式转换、MCP 调用
- **人类确认**：新增节点类型、关系冲突、Schema 变更
- **不自动删除**：已有关系变更需人类确认后才执行

## 错误处理
- Neo4j 未启动：提示用户启动 Neo4j 并给出启动命令
- MCP 工具不可用：提示用户检查 MCP 配置
- 数据缺失：跳过缺失字段，不猜测，报告中标注

