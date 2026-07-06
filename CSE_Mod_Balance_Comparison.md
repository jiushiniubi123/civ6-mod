# CSE_Mod_Balance.sql 城邦平衡修改对照文档

> **文件来源**: `CSE_Mod_Balance.sql`  
> **总计修改**: 12 个城邦 | 8 项数值调整 | 4 项完全重做

---

## 修改概览

| 修改类型 | 数量 | 城邦列表 |
|---------|:----:|---------|
| 数值调整 | 8 | 日内瓦、伊萨帕、撒马尔罕、贡德沙普尔、塔那那利佛、丹吉尔、多多纳、沙赫尔苏赫特 |
| 完全重做 | 4 | 利马、伐腊毗、加赖马、室利差呾罗 |

---

# 一、数值调整类（8项）

## 1. 日内瓦 GENEVA（原版）

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 触发条件 | 未与任何主要文明交战 | 未与任何主要文明交战 |
| 效果 | 所有城市 **+15%** 科技值 | 所有城市 **+10%** 科技值 |
| 修改方式 | — | `UPDATE ModifierArguments SET Amount = 10`（原 15） |

---

## 2. 伊萨帕 CSE_IZAPA（XP1）

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 黄金时代效果 | 尤里卡额外提供 **+10%** 科技值 | 尤里卡额外提供 **+5%** 科技值 |
| 黑暗时代效果 | 每次尤里卡额外获得时代分 | 每次尤里卡额外获得时代分（不变） |
| 修改方式 | — | `UPDATE ModifierArguments SET Amount = 5`（原 10） |

---

## 3. 撒马尔罕 CSE_SAMARQAND（Base）

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 效果 | 每个已获得伟人 **+2%** 科技值，最多 +30% | 每个已获得伟人 **+1%** 科技值，最多 +30% |
| 修改方式 | — | `UPDATE ModifierArguments SET Amount = 1`（原 2） |

---

## 4. 贡德沙普尔 CSE_GUNDESHAPUR（XP2）

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 新时代效果 | 进入新时代获得 **2** 个免费尤里卡 | 进入新时代获得 **1** 个免费尤里卡 |
| 相邻加成 | 学院区域每相邻 2 个区域 +1 科技值 | 学院区域每相邻 2 个区域 +1 科技值（不变） |
| 修改方式 | — | `UPDATE ModifierArguments SET Amount = 1`（原 2） |

---

## 5. 塔那那利佛 ANTANANARIVO（原版 DLC）

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 效果 | 每获得 1 位伟人 **+2%** 文化值，最多 +30% | 每获得 1 位伟人 **+1%** 文化值，最多 +30% |
| 修改方式 | — | `UPDATE ModifierArguments SET Amount = 1`（原 2） |

---

## 6. 丹吉尔 CSE_TANGIER（XP2）

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 新时代效果 | 进入新时代获得 **2** 个免费灵感 | 进入新时代获得 **1** 个免费灵感 |
| 相邻加成 | 剧院广场区域每相邻 2 个区域 +1 文化值 | 剧院广场区域每相邻 2 个区域 +1 文化值（不变） |
| 修改方式 | — | `UPDATE ModifierArguments SET Amount = 1`（原 2） |

---

## 7. 多多纳 CSE_DODONA（XP1）

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 黄金时代效果 | 灵感额外提供 **+10%** 市政值 | 灵感额外提供 **+5%** 市政值 |
| 黑暗时代效果 | 每次灵感额外获得时代分 | 每次灵感额外获得时代分（不变） |
| 修改方式 | — | `UPDATE ModifierArguments SET Amount = 5`（原 10） |

---

## 8. 沙赫尔苏赫特 CSE_SHAHR_E_SUKHTE（Base）

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 触发条件 | 不处于战争状态时 | 不处于战争状态时 |
| 效果 | 所有城市 **+15%** 文化值产出 | 所有城市 **+10%** 文化值产出 |
| 修改方式 | — | `UPDATE ModifierArguments SET Amount = 10`（原 15） |

---

# 二、完全重做类（4项）

## 9. 利马 CSE_LIMA（Base）⭐ 完全重做

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 效果 A | 有学院的城市可以建造比人口限制多 **1** 个的区域 | ❌ 删除 |
| 效果 B | 学院建造速度 **+20%** | ✅ 保留并扩展：学院区域 +20% 建造速度 |
| 效果 C | — | ✅ 新增：学院内的建筑（图书馆/大学/研究实验室）建造速度 +20% |
| 效果 D | — | ✅ 新增：学院区域 **+3 生产力** |

**修改方式**：
- `DELETE` 旧数据：TraitModifiers、Modifiers、ModifierArguments、RequirementSets、RequirementSetRequirements
- `INSERT` 新数据：
  - `MODIFIER_PLAYER_CITIES_ADJUST_DISTRICT_PRODUCTION` → 学院 +20% 建造速度
  - `MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION` → 图书馆/大学/研究实验室 +20% 建造速度
  - `MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE` → 学院 +3 生产力

---

## 10. 伐腊毗 CSE_VALABHI（Base）⭐ 完全重做

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 效果 A | 学院区域提供等同于其科技相邻加成的**信仰值**（信仰镜像） | ❌ 删除 |
| 效果 B | 学院内的建筑可用信仰购买 | ✅ 保留 |
| 效果 C | — | ✅ 新增：学院区域 **+2 信仰** |

**修改方式**：
- `DELETE` 旧数据：TraitModifiers、Modifiers、ModifierArguments、RequirementSets、RequirementSetRequirements
- `INSERT` 新数据：
  - 旧：`MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS`（`YieldTypeToMirror=SCIENCE, YieldTypeToGrant=FAITH`）→ 替换为
  - 新：`MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE`（`Amount=2`，固定 +2 信仰）
  - 信仰购买功能保留

---

## 11. 加赖马 CSE_GARAMA（Base）⭐ 完全重做

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 效果 | 三个独立 Modifier 叠加：<br>• 绿洲本身 +2 食物（range 0）<br>• 相邻地块 +1 食物（range 1）<br>• 两格范围地块 +1 食物（range 1-2）<br>⚠️ **range 1 的地块实际获得 +2 食物（1+1 叠加）** | 单一 Modifier：<br>• 绿洲及其两格范围内所有单元格 **+1 食物**（MinRange=0, MaxRange=2）<br>✅ 不再叠加 |
| 修改方式 | — | 删除三个独立 Modifier，插入单一 Modifier（`MinRange=0, MaxRange=2, Amount=1`） |

---

## 12. 室利差呾罗 CSE_SRI_KSETRA（Base）⭐ 完全重做

| 对比项 | 修改前 | 修改后 |
|-------|--------|--------|
| 效果 | 圣地区域提供等同于其信仰相邻加成的**食物值**（食物镜像） | 圣地区域 **+3 食物** |
| 修改方式 | — | `DELETE` 旧数据（`MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_BASED_ON_ADJACENCY_BONUS`, `YieldTypeToMirror=FAITH, YieldTypeToGrant=FOOD`），`INSERT` 新数据（`MODIFIER_PLAYER_DISTRICTS_ADJUST_YIELD_CHANGE`, `Amount=3`） |

---

# 附录：修改模式总结

## 数值调整模式

| 模式 | 涉及城邦 | 调整幅度 |
|------|---------|---------|
| 百分比加成减半（15%→10%） | 日内瓦、沙赫尔苏赫特 | -5% |
| 百分比加成减半（10%→5%） | 伊萨帕、多多纳 | -5% |
| 百分比加成减半（2%→1%） | 撒马尔罕、塔那那利佛 | -1%/伟人 |
| 免费次数减半（2→1） | 贡德沙普尔、丹吉尔 | -1 次 |

## 完全重做模式

| 城邦 | 旧设计 | 新设计 | 设计意图 |
|------|--------|--------|---------|
| 利马 | 额外区域槽 + 学院建造速度 | 学院及建筑建造速度 + 学院生产力 | 从"扩张"向"产出"转型 |
| 伐腊毗 | 科技相邻→信仰镜像 | 学院固定 +2 信仰 | 消除相邻加成的不确定性 |
| 加赖马 | 三范围叠加食物加成 | 统一范围单一加成 | 修复叠加漏洞，简化机制 |
| 室利差呾罗 | 信仰相邻→食物镜像 | 圣地固定 +3 食物 | 消除相邻加成的不确定性 |