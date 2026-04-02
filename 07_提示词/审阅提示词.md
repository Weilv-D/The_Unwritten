# 审阅类提示词模板

> 用于审查和评估写作质量的标准化提示词

---

## 1. 章节质量评估

### 使用场景
完成一章后，全面评估写作质量

### 输入格式
```xml
<chapter_file>
  [章节文件路径]
</chapter_file>
<chapter_outline>
  [对应的章纲文件路径]
</chapter_outline>
```

### 评估维度

请从以下维度评估，每项1-10分：

1. **情节推进**（目标达成度）
   - 章纲中规划的情节点是否全部覆盖
   - 情节推进是否自然
   - 是否有偏离主线的内容

2. **人物表现**（符合度）
   - 人物行为是否符合设定
   - 对话风格是否一致
   - 人物情感变化是否合理

3. **场景描写**（沉浸感）
   - 环境描写是否具象
   - 五感调动是否充分
   - 氛围营造是否到位

4. **对话质量**（自然度）
   - 对话是否推动情节
   - 是否符合人物性格
   - 潜台词是否丰富

5. **节奏控制**（张弛度）
   - 节奏变化是否合理
   - 是否有拖沓或仓促的部分
   - 高潮部分是否有足够的张力

6. **文笔质量**（文学性）
   - 用词是否精准
   - 是否有陈词滥调
   - 句式是否有变化

7. **逻辑自洽**（无矛盾）
   - 时间线是否正确
   - 因果关系是否合理
   - 人物位置是否一致

### 输出格式
```xml
<chapter_review>
  <overall_score>X/10</overall_score>

  <dimensions>
    <plot_progression>分数 | 评语</plot_progression>
    <character_performance>分数 | 评语</character_performance>
    <scene_description>分数 | 评语</scene_description>
    <dialogue_quality>分数 | 评语</dialogue_quality>
    <pacing_control>分数 | 评语</pacing_control>
    <writing_quality>分数 | 评语</writing_quality>
    <logical_consistency>分数 | 评语</logical_consistency>
  </dimensions>

  <strengths>
    - [优点1]
    - [优点2]
  </strengths>

  <weaknesses>
    - [问题1]：[具体位置] | [修改建议]
    - [问题2]：[具体位置] | [修改建议]
  </weaknesses>

  <priority_fixes>
    1. [最需要修改的地方]
    2. [次需要修改的地方]
  </priority_fixes>
</chapter_review>
```

---

## 2. 节奏分析

### 使用场景
分析一段连续章节的叙事节奏

### 输入格式
```xml
<chapter_range>
  [起始章节] 到 [结束章节]
</chapter_range>
```

### 分析维度

1. **节奏曲线**
   - 绘制紧张度曲线（每章的紧张程度）
   - 识别高潮和低谷
   - 检查节奏是否过于平淡或过于紧张

2. **情节密度**
   - 每章的事件数量
   - 事件的轻重程度
   - 是否有"注水"的章节

3. **情绪变化**
   - 每章的主要情绪
   - 情绪变化是否自然
   - 是否有情绪断裂

### 输出格式
```
节奏曲线：
章节 001 ████░░░░░░ (紧张度: 4/10) - 铺垫
章节 002 ██████░░░░ (紧张度: 6/10) - 冲突升级
章节 003 █████████░ (紧张度: 9/10) - 高潮
章节 004 ███░░░░░░░ (紧张度: 3/10) - 缓和
...

总体评价：[节奏是否合理]
建议调整：[具体建议]
```

---

## 3. 全卷审查

### 使用场景
完成一卷后，进行全面的卷次审查

### 输入格式
```xml
<volume_number>[卷次]</volume_number>
<chapter_range>[章节范围]</chapter_range>
<volume_outline>[卷次细纲路径]</volume_outline>
```

### 审查清单

1. **剧情完整性**
   - 卷次故事弧是否完整
   - 开头和结尾是否呼应
   - 悬念设置是否恰当

2. **人物发展**
   - 主要人物是否有成长
   - 人物弧光是否清晰
   - 配角是否有足够的空间

3. **世界观扩展**
   - 新增设定是否合理
   - 是否与既有设定矛盾
   - 信息量是否适中

4. **伏笔管理**
   - 本卷设置的伏笔
   - 本卷回收的伏笔
   - 未回收的伏笔是否记录

5. **与后续卷的衔接**
   - 结尾是否为下卷铺垫
   - 悬念是否足够吸引人
   - 未解决的线索是否明确

### 输出格式
```xml
<volume_review>
  <overall_assessment>[总体评价]</overall_assessment>
  <plot_completeness>分数 | 评语</plot_completeness>
  <character_development>分数 | 评语</character_development>
  <world_building>分数 | 评语</world_building>
  <foreshadowing>分数 | 评语</foreshadowing>
  <continuation>分数 | 评语</continuation>

  <must_fix>
    1. [必须修改的问题]
  </must_fix>

  <should_fix>
    1. [建议修改的问题]
  </should_fix>

  <nice_to_have>
    1. [可以考虑的改进]
  </nice_to_have>
</volume_review>
```

---

## 修改记录
- 2026-04-02：创建审阅类提示词模板
