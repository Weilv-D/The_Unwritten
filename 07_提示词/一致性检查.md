# 一致性检查提示词模板

> 超长篇小说专用：系统化检查人物、世界观、剧情的一致性

---

## 1. 人物一致性检查

### 使用场景
完成章节后，检查人物表现是否符合设定

### 输入格式
```xml
<chapter_file>
  [章节文件路径或内容]
</chapter_file>
<character_profiles>
  [相关人物的设定文件路径列表]
</character_profiles>
```

### 检查清单

#### 1.1 语言风格一致性
- [ ] 说话方式是否与设定一致
- [ ] 口头禅使用是否恰当
- [ ] 语气是否符合性格
- [ ] 用词是否符合教育水平/出身
- [ ] 不同场景下说话方式的差异是否合理

#### 1.2 行为模式一致性
- [ ] 行为选择是否符合性格
- [ ] 对事件的反应是否合理（基于性格和经历）
- [ ] 能力/技能使用是否在设定范围内
- [ ] 决策逻辑是否与人物智力/经验匹配
- [ ] 面对压力/危险时的反应是否一致

#### 1.3 背景设定一致性
- [ ] 提到的背景信息是否与档案矛盾
- [ ] 人际关系描述是否正确
- [ ] 过去经历的提及是否准确
- [ ] 知识/技能的展示是否符合背景
- [ ] 地点/时间的了解是否合理

#### 1.4 外貌和物理特征
- [ ] 外貌描写是否与设定一致
- [ ] 年龄、身高、体重等是否正确
- [ ] 特征性标记（伤疤、纹身等）是否一致
- [ ] 服装/装备描写是否合理

### 输出格式
```xml
<consistency_report>
  <character_name>[人物姓名]</character_name>
  <chapter>[章节号]</chapter>

  <passed_items>
    - [一致性良好的方面]
  </passed_items>

  <issues>
    <issue severity="high/medium/low">
      <category>[问题类别]</category>
      <location>[章节/段落位置]</location>
      <description>[问题描述]</description>
      <evidence>[相关设定引用]</evidence>
      <suggestion>[修正建议]</suggestion>
    </issue>
  </issues>

  <score>X/10</score>
  <summary>[总体评价]</summary>
</consistency_report>
```

---

## 2. 世界观一致性检查

### 使用场景
检查新增内容是否与世界观设定矛盾

### 输入格式
```xml
<content_file>
  [需要检查的内容文件路径]
</content_file>
<world_settings>
  [相关世界观设定文件路径列表]
</world_settings>
```

### 检查清单

#### 2.1 地理环境一致性
- [ ] 地点描述是否与地理设定一致
- [ ] 距离/方向是否正确
- [ ] 气候/天气是否合理
- [ ] 地形特征是否匹配

#### 2.2 社会规则一致性
- [ ] 政治制度描述是否正确
- [ ] 经济/货币使用是否合理
- [ ] 法律/禁忌是否被遵守
- [ ] 社会阶层/礼仪是否正确

#### 2.3 力量体系一致性
- [ ] 能力表现是否符合设定
- [ ] 能力等级是否正确
- [ ] 使用代价/限制是否体现
- [ ] 施法/使用方式是否正确

#### 2.4 文化宗教一致性
- [ ] 宗教信仰/仪式是否正确
- [ ] 文化习俗是否恰当
- [ ] 禁忌是否被遵守
- [ ] 节日/庆典是否合理

### 输出格式
```xml
<world_consistency_report>
  <content>[检查内容]</content>
  <passed_items>
    - [与设定一致的方面]
  </passed_items>
  <violations>
    <violation severity="high/medium/low">
      <setting_file>[违反的设定文件]</setting_file>
      <description>[矛盾描述]</description>
      <setting_quote>[设定原文]</setting_quote>
      <content_quote>[内容原文]</content_quote>
      <resolution>[解决方案]</resolution>
    </violation>
  </violations>
  <score>X/10</score>
</world_consistency_report>
```

---

## 3. 时间线一致性检查

### 使用场景
检查故事内时间线是否连贯正确

### 输入格式
```xml
<chapter_range>
  [起始章节] 到 [结束章节]
</chapter_range>
<timeline_file>
  [故事时间线文件路径]
</timeline_file>
```

### 检查清单

#### 3.1 时间流逝
- [ ] 章节间的时间流逝是否合理
- [ ] 季节/天气变化是否匹配
- [ ] 人物年龄变化是否正确
- [ ] 白天/黑夜是否一致

#### 3.2 事件顺序
- [ ] 事件发生顺序是否逻辑正确
- [ ] 因果关系是否成立
- [ ] 是否有时间矛盾（A在B之前发生但又依赖B）
- [ ] 旅行时间是否合理

#### 3.3 同步性
- [ ] 同时发生的不同场景是否时间一致
- [ ] 人物在不同地点的行动是否时间冲突
- [ ] 信息传递时间是否合理

### 输出格式
```xml
<timeline_report>
  <chronological_events>
    [按时间顺序排列的事件列表，标注章节]
  </chronological_events>

  <anomalies>
    <anomaly severity="high/medium/low">
      <description>[时间矛盾描述]</description>
      <location>[涉及的章节]</location>
      <details>[详细说明]</details>
      <fix>[修正建议]</fix>
    </anomaly>
  </anomalies>

  <score>X/10</score>
</timeline_report>
```

---

## 4. 全面一致性检查（卷次级别）

### 使用场景
完成一卷后，进行全面的卷次一致性审查

### 输入格式
```xml
<volume_number>[卷次]</volume_number>
<chapter_range>[章节范围]</chapter_range>
```

### 检查范围

1. **人物一致性**：所有出场人物的表现
2. **世界观一致性**：所有涉及的世界观设定
3. **时间线一致性**：全卷的时间线连贯性
4. **伏笔一致性**：伏笔的设置和回收
5. **剧情连贯性**：情节线索的推进
6. **关系一致性**：人物关系的变化记录

### 输出格式
```xml
<volume_consistency_report>
  <volume>[卷次]</volume>
  <date>[审查日期]</date>

  <summary>
    总体评分：X/10
    发现问题数：X
    严重问题：X
    中等问题：X
    轻微问题：X
  </summary>

  <character_consistency>
    [各人物的一致性检查结果]
  </character_consistency>

  <world_consistency>
    [世界观一致性检查结果]
  </world_consistency>

  <timeline_consistency>
    [时间线一致性检查结果]
  </timeline_consistency>

  <foreshadowing_status>
    [伏笔状态检查]
  </foreshadowing_status>

  <plot_continuity>
    [剧情连贯性检查]
  </plot_continuity>

  <priority_fixes>
    1. [最需要修复的问题]
    2. [次需要修复的问题]
    ...
  </priority_fixes>
</volume_consistency_report>
```

---

## 5. 快速一致性扫描

### 使用场景
日常写作中，快速检查常见的一致性问题

### 输入
直接提供章节内容

### 快速检查项
1. 人物姓名是否拼写正确
2. 人物称呼是否一致
3. 地点名称是否统一
4. 时间表述是否矛盾
5. 天气/季节是否合理
6. 人物当前所在位置是否正确
7. 物品/道具是否凭空出现或消失
8. 人物知识是否超范围（知道不该知道的事）

### 输出
```
✅ 通过项：[列表]
⚠️ 可疑项：[列表]
❌ 错误项：[列表]
```

---

## 修改记录
- 2026-04-02：创建一致性检查提示词模板（5种检查模式）
