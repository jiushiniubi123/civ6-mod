# CSE_Modifications.sql 城邦效果修改详细对比报告

> 生成时间: 2026-07-06
> 源文件: `/MOD/游戏模式与玩法大修/1331757859-CIVITAS City-States-城邦拓展/Core/CSE_Modifications.sql`
> 加载顺序: LoadOrder 68 (在所有城邦定义文件之后加载)
> 修改条目总数: 12

---

## 概述

`CSE_Modifications.sql` 是 CIVITAS City-States Expanded 模组中对已有城邦效果进行平衡性调整的 SQL 文件。它在模组加载顺序中处于 LoadOrder 68，晚于所有城邦核心定义文件（LoadOrder 60-67），因此其 UPDATE 和 INSERT 操作会覆盖所有之前的定义。

文件中包含 12 条修改记录，涉及 12 个城邦（2 个原版城邦 + 10 个 CSE 新增城邦）。

---

## 修改详情

### 1. 日内瓦 (Geneva) - 原版城邦

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_GENEVA` |
| **中文名** | 日内瓦 |
| **英文名** | Geneva |
| **CSE类型** | CSE_CONSULAR (领事型) |
| **原版类型** | SCIENTIFIC (科技型) |
| **修改类型** | ModifierArgument Amount 值修改 |

#### 修改前效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 未与任何主要文明交战时，所有城市 **+15%** 科技值产出 |

#### 修改后效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 未与任何主要文明交战时，所有城市 **+10%** 科技值产出 |

#### 技术细节

```
修改目标: ModifierId = 'GENEVA_SCIENCE_BONUS_PEACE'
修改参数: Name = 'Amount', Value = 15 → 10
修改操作: UPDATE ModifierArguments SET Value = '10' WHERE ModifierId='GENEVA_SCIENCE_BONUS_PEACE' AND Name='Amount'
```

#### 影响分析

- 日内瓦的科技加成从 15% 降低到 10%，削弱幅度为 33%
- 配合类型的重新分类（从 SCIENTIFIC 变为 CONSULAR），日内瓦的纯科技价值大幅下降
- 新类型 CSE_CONSULAR 提供外交支持加成，使日内瓦转向外交玩法

---

### 2. 安塔那那利佛 (Antananarivo) - DLC城邦

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_ANTANANARIVO` |
| **中文名** | 安塔那那利佛 |
| **英文名** | Antananarivo |
| **类型** | CULTURAL (文化型) |
| **来源** | DLC2 (迭起兴衰) |
| **修改类型** | ModifierArgument Amount 值修改 |

#### 修改前效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 每获得 1 位伟人，所有城市文化值产出 **+2%**，最多 **+30%** |

#### 修改后效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 每获得 1 位伟人，所有城市文化值产出 **+1%**，最多 **+30%** |

#### 技术细节

```
修改目标: ModifierId = 'ANTANANARIVO_CULTURE_BONUS'
修改参数: Name = 'Amount', Value = 2 → 1
修改操作: UPDATE ModifierArguments SET Value = '1' WHERE ModifierId='ANTANANARIVO_CULTURE_BONUS' AND Name='Amount'
```

#### 影响分析

- 每次伟人带来的文化加成从 2% 降低到 1%，削弱幅度为 50%
- 达到 30% 上限需要的伟人数量从 15 位增加到 30 位
- 在伟人产量较少的游戏中，该城邦的实际价值大幅降低

---

### 3. 伊萨帕 (Izapa) - CSE XP1 新增城邦

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_CSE_IZAPA` |
| **中文名** | 伊萨帕 |
| **英文名** | Izapa |
| **类型** | SCIENTIFIC (科技型) |
| **来源** | CSE XP1 |
| **修改类型** | ModifierArgument Amount 值修改 |

#### 修改前效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 黄金时代: 每次尤里卡触发时额外获得 **+10%** 科技值 |
| 宗主权 | 黑暗时代: 每回合额外获得 **+1** 时代分数 |

#### 修改后效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 黄金时代: 每次尤里卡触发时额外获得 **+5%** 科技值 |
| 宗主权 | 黑暗时代: 每回合额外获得 **+1** 时代分数 |

#### 技术细节

```
修改目标: ModifierId = 'CSE_IZAPA_GOLDEN_SCIENCE_MODIFIER'
修改参数: Name = 'Amount', Value = 10 → 5
修改操作: UPDATE ModifierArguments SET Value = '5' WHERE ModifierId='CSE_IZAPA_GOLDEN_SCIENCE_MODIFIER' AND Name='Amount'
```

#### 影响分析

- 黄金时代尤里卡科技加成从 10% 降低到 5%，削弱幅度为 50%
- 黑暗时代时代分数加成保持不变（+1/回合）
- 该城邦在黄金时代的价值显著降低，但仍保留黑暗时代的保底收益

---

### 4. 多多纳 (Dodona) - CSE XP1 新增城邦

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_CSE_DODONA` |
| **中文名** | 多多纳 |
| **英文名** | Dodona |
| **类型** | CULTURAL (文化型) |
| **来源** | CSE XP1 |
| **修改类型** | ModifierArgument Amount 值修改 |

#### 修改前效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 黄金时代: 每次灵感触发时额外获得 **+10%** 市政值 |
| 宗主权 | 黑暗时代: 每回合额外获得 **+1** 时代分数 |

#### 修改后效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 黄金时代: 每次灵感触发时额外获得 **+5%** 市政值 |
| 宗主权 | 黑暗时代: 每回合额外获得 **+1** 时代分数 |

#### 技术细节

```
修改目标: ModifierId = 'CSE_DODONA_GOLDEN_CULTURE_MODIFIER'
修改参数: Name = 'Amount', Value = 10 → 5
修改操作: UPDATE ModifierArguments SET Value = '5' WHERE ModifierId='CSE_DODONA_GOLDEN_CULTURE_MODIFIER' AND Name='Amount'
```

#### 影响分析

- 与伊萨帕对称，多多纳是文化侧的对应版本
- 黄金时代灵感市政加成从 10% 降低到 5%，削弱幅度为 50%
- 两者在修改后保持精妙的对称设计：伊萨帕(科技)↔多多纳(文化)

---

### 5. 撒马尔罕 (Samarqand) - CSE Base 新增城邦

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_CSE_SAMARQAND` |
| **中文名** | 撒马尔罕 |
| **英文名** | Samarqand |
| **类型** | SCIENTIFIC (科技型) |
| **来源** | CSE Base |
| **修改类型** | ModifierArgument Amount 值修改 |

#### 修改前效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 每获得 1 位伟人，所有城市科技值产出 **+2%**，最多 **+30%** |

#### 修改后效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 每获得 1 位伟人，所有城市科技值产出 **+1%**，最多 **+30%** |

#### 技术细节

```
修改目标: ModifierId = 'CSE_SAMARQAND_SCIENCE_MODIFIER'
修改参数: Name = 'Amount', Value = 2 → 1
修改操作: UPDATE ModifierArguments SET Value = '1' WHERE ModifierId='CSE_SAMARQAND_SCIENCE_MODIFIER' AND Name='Amount'
```

#### 影响分析

- 撒马尔罕是安塔那那利佛的科技侧对应版本
- 每次伟人科技加成从 2% 降低到 1%，与安塔那那利佛的削弱保持一致
- 达到 30% 上限需要的伟人数量从 15 位增加到 30 位
- 注意：CSE 新增的撒马尔罕与 NF4 原版撒马尔罕（TRADE 型，建造商队旅馆）是不同城邦。CSE 将原版撒马尔罕的城市名改为布哈拉(Bukhara)

---

### 6. 沙赫尔苏赫特 (Shahr-e-Sukhte) - CSE Base 新增城邦

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_CSE_SHAHR_E_SUKHTE` |
| **中文名** | 沙赫尔苏赫特 |
| **英文名** | Shahr-e-Sukhte |
| **类型** | CULTURAL (文化型) |
| **来源** | CSE Base |
| **修改类型** | ModifierArgument Amount 值修改 |

#### 修改前效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 不处于战争状态时，所有城市文化值产出 **+15%** |

#### 修改后效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 不处于战争状态时，所有城市文化值产出 **+10%** |

#### 技术细节

```
修改目标: ModifierId = 'CSE_SHAHR_E_SUKHTE_CULTURE_MODIFIER_PEACE'
修改参数: Name = 'Amount', Value = 15 → 10
修改操作: UPDATE ModifierArguments SET Value = '10' WHERE ModifierId='CSE_SHAHR_E_SUKHTE_CULTURE_MODIFIER_PEACE' AND Name='Amount'
```

#### 影响分析

- 沙赫尔苏赫特是日内瓦的文化侧对应版本
- 文化加成从 15% 降低到 10%，与日内瓦的削弱保持一致
- 两者形成对称设计：日内瓦(科技+和平)↔沙赫尔苏赫特(文化+和平)

---

### 7. 贡迪沙普尔 (Gundeshapur) - CSE XP2 新增城邦

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_CSE_GUNDESHAPUR` |
| **中文名** | 贡迪沙普尔 |
| **英文名** | Gundeshapur |
| **类型** | CSE_CONSULAR (领事型) |
| **来源** | CSE XP2 |
| **修改类型** | ModifierArgument Amount 值修改 |

#### 修改前效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 进入新时代时获得 **2个** 免费尤里卡 (科技提升) |
| 宗主权 | 学院区每相邻 2 个区域获得 **+1** 科技值 |

#### 修改后效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 进入新时代时获得 **1个** 免费尤里卡 (科技提升) |
| 宗主权 | 学院区每相邻 2 个区域获得 **+1** 科技值 |

#### 技术细节

```
修改目标: ModifierId = 'CSE_GUNDESHAPUR_FREE_EUREKA_MODIFIER'
修改参数: Name = 'Amount', Value = 2 → 1
修改操作: UPDATE ModifierArguments SET Value = '1' WHERE ModifierId='CSE_GUNDESHAPUR_FREE_EUREKA_MODIFIER' AND Name='Amount'
```

#### 影响分析

- 新时代免费尤里卡数量从 2 减为 1，削弱幅度为 50%
- 学院区相邻加成效果保持不变
- 该城邦仍然提供科技辅助，但新时代的爆发力大幅降低

---

### 8. 丹吉尔 (Tangier) - CSE XP2 新增城邦

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_CSE_TANGIER` |
| **中文名** | 丹吉尔 |
| **英文名** | Tangier |
| **类型** | CSE_CONSULAR (领事型) |
| **来源** | CSE XP2 |
| **修改类型** | ModifierArgument Amount 值修改 |

#### 修改前效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 进入新时代时获得 **2个** 免费灵感 (市政提升) |
| 宗主权 | 剧院广场每相邻 2 个区域获得 **+1** 文化值 |

#### 修改后效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 进入新时代时获得 **1个** 免费灵感 (市政提升) |
| 宗主权 | 剧院广场每相邻 2 个区域获得 **+1** 文化值 |

#### 技术细节

```
修改目标: ModifierId = 'CSE_TANGIER_FREE_INSPIRATION_MODIFIER'
修改参数: Name = 'Amount', Value = 2 → 1
修改操作: UPDATE ModifierArguments SET Value = '1' WHERE ModifierId='CSE_TANGIER_FREE_INSPIRATION_MODIFIER' AND Name='Amount'
```

#### 影响分析

- 丹吉尔是贡迪沙普尔的文化侧对应版本
- 新时代免费灵感数量从 2 减为 1，与贡迪沙普尔的削弱保持一致
- 两者形成对称：贡迪沙普尔(科技+新时代)↔丹吉尔(文化+新时代)

---

### 9. 加拉马 (Garama) - CSE Base 新增城邦

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_CSE_GARAMA` |
| **中文名** | 加拉马 |
| **英文名** | Garama |
| **类型** | TRADE (贸易型) |
| **来源** | CSE Base |
| **修改类型** | ModifierArgument Amount 值修改 |

#### 修改前效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 绿洲地块及其相邻地块获得 **+2** 食物 |
| 宗主权 | 距离绿洲两格远的空地块获得 **+1** 食物 |

#### 修改后效果

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 绿洲地块及其相邻地块获得 **+1** 食物 |
| 宗主权 | 距离绿洲两格远的空地块获得 **+1** 食物 |

#### 技术细节

```
修改目标: ModifierId = 'CSE_GARAMA_OASIS_FOOD_MODIFIER'
修改参数: Name = 'Amount', Value = 2 → 1
修改操作: UPDATE ModifierArguments SET Value = '1' WHERE ModifierId='CSE_GARAMA_OASIS_FOOD_MODIFIER' AND Name='Amount'
```

#### 影响分析

- 绿洲及相邻地块食物加成从 +2 降低到 +1，削弱幅度为 50%
- 两格远地块的加成保持不变（+1食物）
- 该城邦在沙漠地形中的食物价值大幅降低，但仍保留基础增益

---

### 10. 利马 (Lima) - CSE Base 新增城邦（完全重新设计）

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_CSE_LIMA` |
| **中文名** | 利马 |
| **英文名** | Lima |
| **类型** | SCIENTIFIC (科技型) |
| **来源** | CSE Base |
| **修改类型** | 完全重新设计（DELETE + INSERT） |

#### 修改前效果（原始CSE设计）

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 拥有学院区的城市可以额外建造 **1个** 区域（超出人口限制） |
| 宗主权 | 学院区建造时获得 **+20%** 生产力 |

#### 修改后效果（CSE_Modifications.sql 重新设计）

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 学院区及其建筑建造时获得 **+20%** 生产力 |
| 宗主权 | 学院区额外获得 **+3** 生产力 |

#### 技术细节

```
修改前Modifier:
  - CSE_LIMA_EXTRA_DISTRICT_MODIFIER: 拥有学院的城市额外+1区域容量
  - CSE_LIMA_CAMPUS_PRODUCTION_MODIFIER: 学院+20%生产力

修改后Modifier:
  - CSE_LIMA_CAMPUS_PRODUCTION_MODIFIER: 学院及建筑+20%生产力 (保留但效果扩展)
  - CSE_LIMA_CAMPUS_PRODUCTION_MODIFIER_2: 学院+3生产力 (新增)

操作:
  DELETE FROM Modifiers WHERE ModifierId='CSE_LIMA_EXTRA_DISTRICT_MODIFIER'
  INSERT INTO Modifiers ... CSE_LIMA_CAMPUS_PRODUCTION_MODIFIER_2
  INSERT INTO ModifierArguments ... Amount=3 ...
```

#### 影响分析

- **最大的设计变更**：完全移除了「额外区域容量」机制
- 修改前：注重区域扩展灵活性（额外区域+学院建造加速）
- 修改后：注重纯生产力收益（学院建造加速+学院产出）
- 移除了一个可能过于强大的机制（额外区域容量在特定情况下非常强力）
- 改为更直接的生产力加成，使利马的价值更稳定可控

---

### 11. 伐拉彼 (Valabhi) - CSE Base 新增城邦（效果重做）

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_CSE_VALABHI` |
| **中文名** | 伐拉彼 |
| **英文名** | Valabhi |
| **类型** | SCIENTIFIC (科技型) |
| **来源** | CSE Base |
| **修改类型** | 效果重做（DELETE + INSERT） |

#### 修改前效果（原始CSE设计）

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 学院区产出等同于其相邻加成的 **信仰值** |
| 宗主权 | 学院区建筑可用 **信仰** 购买 |

#### 修改后效果（CSE_Modifications.sql 重新设计）

| 使者等级 | 加成效果 |
|----------|----------|
| 宗主权 | 学院区获得 **+2** 信仰值 |
| 宗主权 | 学院区建筑可用 **信仰** 购买 |

#### 技术细节

```
修改前Modifier:
  - CSE_VALABHI_CAMPUS_FAITH_ADJACENCY: 学院产出等同于相邻加成的信仰
  - CSE_VALABHI_CAMPUS_FAITH_PURCHASE: 学院建筑可用信仰购买

修改后Modifier:
  - CSE_VALABHI_CAMPUS_FAITH_MODIFIER: 学院+2信仰 (从相邻加成改为固定值)
  - CSE_VALABHI_CAMPUS_FAITH_PURCHASE: 学院建筑可用信仰购买 (保留)

操作:
  DELETE FROM Modifiers WHERE ModifierId='CSE_VALABHI_CAMPUS_FAITH_ADJACENCY'
  INSERT INTO Modifiers ... CSE_VALABHI_CAMPUS_FAITH_MODIFIER
  INSERT INTO ModifierArguments ... Amount=2 ...
```

#### 影响分析

- 信仰产出从「变量」（取决于相邻加成）变为「固定值」（+2）
- 修改前：高相邻加成时（如+6）可以产出大量信仰，但低相邻加成时收益有限
- 修改后：稳定的 +2 信仰，无论相邻加成如何
- 对于大多数情况来说，+2 固定值通常低于高相邻加成时的收益，但更稳定
- 建筑用信仰购买功能保留，这是该城邦的核心特色

---

### 12. 室利差呾罗 (Sri Ksetra) - CSE Base 新增城邦（类型+效果重做）

| 属性 | 详情 |
|------|------|
| **内部ID** | `CIVILIZATION_CSE_SRI_KSETRA` |
| **中文名** | 室利差呾罗 |
| **英文名** | Sri Ksetra |
| **类型 (修改前)** | CSE_AGRICULTURAL (农业型) |
| **类型 (修改后)** | RELIGIOUS (宗教型) |
| **来源** | CSE Base |
| **修改类型** | 类型变更 + 效果重做（DELETE + INSERT） |

#### 修改前效果（原始CSE设计）

| 属性 | 详情 |
|------|------|
| 城邦类型 | CSE_AGRICULTURAL (农业型) |
| 使者加成 | 1使者: 首都+2食物; 3使者: 每水磨+2食物; 6使者: 每下水道+2食物 |
| 宗主权效果 | 圣地区域的食物产出等同于其信仰相邻加成 |

#### 修改后效果（CSE_Modifications.sql 重新设计）

| 属性 | 详情 |
|------|------|
| 城邦类型 | RELIGIOUS (宗教型) |
| 使者加成 | 1使者: 首都+2信仰; 3使者: 每神社+2信仰; 6使者: 每寺庙+2信仰 |
| 宗主权效果 | 圣地区域获得 **+3** 食物 |

#### 技术细节

```
修改前:
  - 类型: CSE_AGRICULTURAL
  - Modifier: CSE_SRI_KSETRA_HOLY_SITE_FOOD_ADJACENCY (圣地食物=信仰相邻加成)

修改后:
  - 类型: RELIGIOUS
  - Modifier: CSE_SRI_KSETRA_HOLY_SITE_FOOD_MODIFIER (圣地+3食物)

操作:
  DELETE FROM Modifiers WHERE ModifierId='CSE_SRI_KSETRA_HOLY_SITE_FOOD_ADJACENCY'
  INSERT INTO Modifiers ... CSE_SRI_KSETRA_HOLY_SITE_FOOD_MODIFIER
  INSERT INTO ModifierArguments ... Amount=3 ...
```

#### 影响分析

- **类型变更**: 从 AGRICULTURAL 变为 RELIGIOUS，使者加成体系完全改变
  - 修改前: 提供食物加成（首都+2食物/水磨+2/下水道+2）
  - 修改后: 提供信仰加成（首都+2信仰/神社+2/寺庙+2）
- **宗主权效果变更**: 从「变量」变为「固定值」
  - 修改前: 圣地食物 = 信仰相邻加成（高相邻加成时可达+6或更多）
  - 修改后: 圣地固定 +3 食物
- 这是本次修改中**唯一一个同时改变城邦类型和宗主权效果**的条目
- 修改后该城邦从「农业型(食物使者)+变量食物」变为「宗教型(信仰使者)+固定食物」
- 整体设计更偏向宗教玩法，但保留了食物产出的特色

---

## 修改模式总结

### 按修改类型分类

| 修改类型 | 条目数 | 涉及城邦 |
|----------|:------:|----------|
| 仅 Amount 值削弱 | 8 | 日内瓦, 安塔那那利佛, 伊萨帕, 多多纳, 撒马尔罕, 沙赫尔苏赫特, 贡迪沙普尔, 丹吉尔, 加拉马 |
| 完全重新设计 | 1 | 利马 |
| 效果重做 | 1 | 伐拉彼 |
| 类型+效果重做 | 1 | 室利差呾罗 |

### 按削弱幅度分类

| 削弱幅度 | 条目数 | 涉及城邦 |
|----------|:------:|----------|
| -50% (Amount 值减半) | 6 | 安塔那那利佛(2→1), 伊萨帕(10→5), 多多纳(10→5), 撒马尔罕(2→1), 贡迪沙普尔(2→1), 丹吉尔(2→1) |
| -33% (Amount 值削减) | 3 | 日内瓦(15→10), 沙赫尔苏赫特(15→10), 加拉马(2→1) |
| 完全重新设计 | 3 | 利马, 伐拉彼, 室利差呾罗 |

### 对称设计模式

修改后保持了清晰的对称设计关系：

| 科学侧 | 文化侧 | 对称关系 |
|--------|--------|----------|
| 日内瓦 (+10%科技,和平) | 沙赫尔苏赫特 (+10%文化,和平) | 和平百分比加成 |
| 伊萨帕 (+5%尤里卡,黄金) | 多多纳 (+5%灵感,黄金) | 时代爆发加成 |
| 撒马尔罕 (+1%科技/伟人) | 安塔那那利佛 (+1%文化/伟人) | 伟人百分比加成 |
| 贡迪沙普尔 (1尤里卡,新时代) | 丹吉尔 (1灵感,新时代) | 新时代免费推进 |

---

## 加载顺序说明

CSE 模组内部加载顺序：

```
LoadOrder 1:  CSE_Master.sql          (框架和类型定义)
LoadOrder 40: CSE_Types/*.sql          (城邦类型使者加成定义)
LoadOrder 60: CSE_CityStates.sql      (主城邦定义)
LoadOrder 62: CSE_CityStates_XP2.sql  (XP2额外城邦)
LoadOrder 65: City-States/Base/*.sql  (Base新增城邦个体)
LoadOrder 66: City-States/XP1/*.sql   (XP1新增城邦个体)
LoadOrder 67: City-States/XP2/*.sql   (XP2新增城邦个体)
LoadOrder 68: CSE_Modifications.sql   ← 本文件在此加载
LoadOrder 1000: CSE_Globals.sql       (全局设置)
```

**关键点**: CSE_Modifications.sql 在 LoadOrder 68 加载，晚于所有城邦定义文件（60-67），因此其 UPDATE/DELETE/INSERT 操作会完全覆盖所有之前的 Modifier 和 ModifierArgument 定义。最终游戏中的效果是修改后的版本。

---

## 相关文件

| 文件 | 用途 |
|------|------|
| `Core/CSE_Modifications.sql` | 本文件中记录的修改定义 |
| `Core/CSE_Localisation_Modifications.sql` | 对应修改后的本地化文本更新 |
| `Core/City-States/Base/CSE_Lima.sql` | 利马修改前定义 |
| `Core/City-States/Base/CSE_Valabhi.sql` | 伐拉彼修改前定义 |
| `Core/City-States/Base/CSE_SriKsetra.sql` | 室利差呾罗修改前定义 |
| `Core/City-States/Base/CSE_Samarqand.sql` | 撒马尔罕修改前定义 |
| `Core/City-States/Base/CSE_ShahrESukhte.sql` | 沙赫尔苏赫特修改前定义 |
| `Core/City-States/Base/CSE_Garama.sql` | 加拉马修改前定义 |
| `Core/City-States/XP1/CSE_Izapa.sql` | 伊萨帕修改前定义 |
| `Core/City-States/XP1/CSE_Dodona.sql` | 多多纳修改前定义 |
| `Core/City-States/XP2/CSE_Gundeshapur.sql` | 贡迪沙普尔修改前定义 |
| `Core/City-States/XP2/CSE_Tangier.sql` | 丹吉尔修改前定义 |