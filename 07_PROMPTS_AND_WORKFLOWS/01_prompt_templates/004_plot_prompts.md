# 剧情类提示词模板

> 用于构思、设计和检查剧情的标准化提示词

---

## 1. 故事梗概生成

### 使用场景
从零开始构思故事，需要生成故事梗概

### 输入格式
```xml
<context>
  <genre>[类型：奇幻/科幻/悬疑/...]</genre>
  <target_length>[目标字数]</target_length>
  <core_concept>[核心概念/灵感]</core_concept>
  <themes>[想探讨的主题]</themes>
  <references>[参考作品]</references>
</context>
```

### 任务要求
请生成200-500字的故事梗概，包含：
1. **主角介绍**（一句话概括主角和处境）
2. **激励事件**（打破现状的关键事件）
3. **主要冲突**（主角面临的核心矛盾）
4. **故事走向**（大致发展方向）
5. **高潮预览**（最终的对抗/决断）
6. **主题点题**（故事想表达什么）

---

## 2. 大纲生成

### 使用场景
从故事梗概生成详细的大纲

### 输入格式
```xml
<context>
  <story_summary>[故事梗概路径]</story_summary>
  <structure_type>三幕剧/英雄之旅/救猫咪/自定义</structure_type>
  <target_volumes>[预计卷数]</target_volumes>
  <chapters_per_volume>[每卷章节数]</chapters_per_volume>
</context>
```

### 任务要求
请生成详细的大纲，包含：

1. **结构框架**（使用指定的故事结构理论）
2. **卷次划分**（每卷的核心冲突和目标）
3. **主要情节线**（主线+2-3条支线）
4. **人物出场计划**（各人物何时出场）
5. **伏笔计划**（主要伏笔的设置和回收）
6. **节奏规划**（高潮和缓和的分布）

---

## 3. 细纲生成（分卷）

### 使用场景
从粗纲生成某一卷的详细细纲

### 输入格式
```xml
<context>
  <volume_number>[卷次]</volume_number>
  <brief_outline>[粗纲路径]</brief_outline>
  <volume_arc>[本卷故事弧]</volume_arc>
  <characters>[本卷出场人物]</characters>
  <world_settings>[相关世界观设定]</world_settings>
</context>
```

### 任务要求
请生成本卷的详细细纲（1-2万字），包含：

1. **本卷概览**（核心冲突、目标、变化）
2. **章节分解**（每章的主要事件，300-800字/章）
3. **人物在本卷的发展**
4. **本卷设置的伏笔**
5. **本卷回收的伏笔**
6. **本卷结尾的悬念**

---

## 4. 情节转折设计

### 使用场景
需要设计一个出人意料但合理的情节转折

### 输入格式
```xml
<context>
  <current_situation>[当前的情节状态]</current_situation>
  <characters_involved>[涉及的人物]</characters_involved>
  <desired_impact>[期望的读者反应]</desired_impact>
  <foreshadowing_available>[可以使用的已有伏笔]</foreshadowing_available>
</context>
```

### 任务要求
请设计情节转折，确保：

1. **出人意料**：读者事先不会猜到
2. **合乎逻辑**：回头看有线索可循
3. **情感冲击**：能引发强烈的情感反应
4. **推动故事**：转折让故事向更好的方向发展
5. **利用伏笔**：与已设置的伏笔相呼应

---

## 5. 冲突设计

### 使用场景
需要设计人物之间的冲突场景

### 输入格式
```xml
<context>
  <conflict_type>人际/内心/人vs环境/人vs社会</conflict_type>
  <parties>[冲突双方]</parties>
  <stakes>[赌注]</stakes>
  <resolution>[是否解决，如何解决]</resolution>
  <chapter_context>[在哪个章节，什么背景下]</chapter_context>
</context>
```

### 任务要求
请设计冲突场景，确保：

1. **冲突明确**：双方的目标和阻碍清晰
2. **赌注够高**：如果失败会有严重后果
3. **双方合理**：每一方都有自己的理由
4. **升级自然**：冲突逐步升级而非突然爆发
5. **结果影响**：冲突的结果改变人物或情节

---

## 6. 悬念设计

### 使用场景
需要为章节或卷次结尾设置悬念

### 输入格式
```xml
<context>
  <current_plot>[当前情节进展]</current_plot>
  <next_development>[接下来的发展方向]</next_development>
  <suspense_type>信息差/时间压力/道德困境/身份揭秘</suspense_type>
</context>
```

### 任务要求
请设计悬念，确保：

1. **钩子明确**：让读者想知道"接下来会发生什么"
2. **信息控制**：给读者足够的信息产生好奇，但不过多
3. **情感驱动**：悬念让读者为人物担忧或期待
4. **自然产生**：不刻意制造，从情节中自然产生
5. **适度承诺**：悬念必须在后续章节得到回应

---

## 修改记录
- 2026-04-02：创建剧情类提示词模板
