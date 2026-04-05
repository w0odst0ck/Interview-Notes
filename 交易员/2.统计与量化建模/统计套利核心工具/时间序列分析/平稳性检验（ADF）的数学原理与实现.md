
# 数学原理 + Python 实现 + 配对交易必用版

这是**配对交易、统计套利的 “准入门槛”**

只有**平稳序列**，才能做均值回归套利！

---

## 一、一句话讲透核心

**ADF 检验 = 检验一个时间序列是不是 “平稳序列”**

- **平稳 = 围绕固定均值波动 → 能套利（均值回归）**
- **不平稳 = 随机游走、一去不回头 → 不能套利**

配对交易里：

**价差 Spread 必须平稳 → 策略才有效**

否则价差永远不回归，直接爆仓。

---

# 二、数学原理（极简、不绕弯）

## 1. 平稳序列（Stationary）

满足三个条件：

1. **均值恒定**
2. **方差恒定**
3. **自相关只和时间差有关**

直观表现：

**总是围绕一条水平线上下波动，不会长期飘走。**

## 2. 非平稳序列（随机游走）

公式：

$$ y_t = y_{t-1} + \epsilon_t $$

特点：

**没有均值，没有归宿，飘到哪是哪。**

这种序列**绝对不能做套利**。

## 3. ADF 检验到底在检验什么？

检验序列中是否存在**单位根（Unit Root）**：

- **有单位根 = 非平稳 = 不能套利**
- **无单位根 = 平稳 = 可以套利**

## 4. 数学模型（ADF 核心式子）

$$ \Delta y_t = \alpha + \beta t + \gamma y_{t-1} + \delta_1 \Delta y_{t-1} + \dots + \epsilon_t $$

关键看：

γ

- **γ 显著 < 0 → 拒绝单位根 → 平稳 ✅**
- **γ = 0 → 有单位根 → 非平稳 ❌**

## 5. 怎么看结果（实战唯一标准）

看 **p-value**：

- **p ≤ 0.05 → 平稳 ✅（可以套利）**
- **p > 0.05 → 非平稳 ❌（不能套利）**

---

# 三、ADF 检验 Python 实现（直接复制跑）

```python
import numpy as np
import pandas as pd
from statsmodels.tsa.stattools import adfuller

# ===================== 1. 生成测试序列 =====================
# 平稳序列（套利可用）
np.random.seed(42)
stationary_series = np.random.randn(1000)  # 白噪声，平稳

# 非平稳序列（随机游走，不可套利）
non_stationary_series = np.cumsum(np.random.randn(1000))

# ===================== 2. ADF 检验函数 =====================
def adf_test(series, title=""):
    """
    ADF平稳性检验
    返回：是否平稳（True/False）
    """
    print(f"======== ADF 检验: {title} ========")
    result = adfuller(series)
    
    # 输出结果
    p_value = result[1]
    print(f"ADF 统计量: {result[0]:.4f}")
    print(f"P值:        {p_value:.4f}")
    print(f"临界值:      {result[4]}")
    
    # 判断规则
    is_stationary = p_value <= 0.05
    print(f"结论: {'✅ 平稳' if is_stationary else '❌ 非平稳'}")
    print("-"*50)
    return is_stationary

# ===================== 3. 检验 =====================
adf_test(stationary_series, "平稳序列")
adf_test(non_stationary_series, "非平稳序列")
```

---

# 四、配对交易中最关键用法

**我们不检验价格，只检验价差！**

## 完整流程：

1. 找两个相关资产 A、B
2. 线性回归求对冲比例 β
3. 构造价差：
    
    Spread=PA​−βPB​
4. **对 Spread 做 ADF 检验**
5. **Spread 平稳 → 可以做配对交易**

## 实战代码（配对交易必用）

```python
import statsmodels.api as sm

# 构造协整配对价格
P_b = np.cumsum(np.random.randn(1000))
P_a = 1.2 * P_b + np.random.randn(1000) * 2

# 回归求 β
model = sm.OLS(P_a, sm.add_constant(P_b))
beta = model.fit().params[1]

# 构造价差
spread = P_a - beta * P_b

# ADF 检验价差
adf_test(spread, "配对交易价差")
```

---

# 五、实战结论（必须记住）

1. **价格本身几乎都是非平稳的**
2. **但配对后的价差可以是平稳的**
3. **平稳价差 = 均值回归 = 套利能赚钱**
4. **不平稳 = 发散 = 套利必亏**

一句话：

**ADF 过不了，配对交易直接放弃！**

---

# 六、极简总结

- **ADF = 平稳性检验**
- **平稳 = 能均值回归 = 能套利**
- **p ≤ 0.05 = 平稳 ✅**
- **只检验价差，不检验价格**
- **配对交易的生死线**