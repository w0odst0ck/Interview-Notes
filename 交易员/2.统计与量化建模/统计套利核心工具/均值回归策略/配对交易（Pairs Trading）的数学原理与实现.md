# 配对交易（Pairs Trading）

**数学原理 + 代码实现 + 实战逻辑**，一次性讲全，你直接能拿去跑策略。

---

# 一、核心数学原理（极简但完整）

配对交易本质只有两件事：

**相关性 + 协整 + 均值回归**

## 1. 相关性（Correlation）

判断两个资产走势是否 “同步”

$$ \rho = \frac{\mathrm{Cov}(X,Y)}{\sigma_X \sigma_Y} $$

- 要求：**ρ > 0.8** 才适合配对

## 2. 协整（Cointegration）—— 真正核心

即使两个价格都是随机游走，

它们的**线性组合 Spread = P₁ − β・P₂** 是**平稳序列**，会围绕均值来回波动。

平稳 = 一定会均值回归

不平稳 = 可能一去不回头（大亏根源）

## 3. 价差与 Z-score（交易信号）

### 步骤 1：构造价差

$$ Spread_t = P_{A,t} - \beta P_{B,t} $$

β 是回归系数：

$P_A​=α+βP_B​+ϵ$

### 步骤 2：标准化为 Z-score

$$ Z_t = \frac{Spread_t - \mu_{spread}}{\sigma_{spread}} $$

- **Z 很大（+2 以上）**：A 相对高估 → 空 A 多 B
- **Z 很小（-2 以下）**：A 相对低估 → 多 A 空 B
- **Z 回到 0 附近**：平仓

---

# 二、标准策略流程（数学→交易）

1. 选两个高相关资产（A、B）
2. 线性回归求 **β**
3. 计算价差 Spread
4. 计算滚动均值 μ、滚动标准差 σ
5. 计算 Z-score
6. 信号规则：
    
    - Z > 阈值（如 + 2）：**空 A 多 B**
    - Z < - 阈值（如 - 2）：**多 A 空 B**
    - |Z| < 0.5 或 回归均值：**平仓**
    
7. 双向对冲，禁止裸头寸

---

# 三、Python 极简实现（可直接跑）


```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.tsa.stattools import coint
import statsmodels.api as sm

# ====================== 1. 模拟数据 / 真实价格 ======================
# 实际使用时替换成 A、B 价格序列
np.random.seed(42)
t = np.arange(1000)
P_b = 100 + np.cumsum(np.random.randn(1000))  # 资产B
beta = 1.2
P_a = beta * P_b + np.random.randn(1000) * 2  # 资产A（协整关系）

# ====================== 2. 回归求 β ======================
model = sm.OLS(P_a, sm.add_constant(P_b))
res = model.fit()
alpha, beta = res.params

# ====================== 3. 计算价差 ======================
spread = P_a - beta * P_b

# ====================== 4. 计算 Z-score ======================
window = 60
mu = pd.Series(spread).rolling(window).mean()
sigma = pd.Series(spread).rolling(window).std()
z_score = (spread - mu) / sigma

# ====================== 5. 交易信号 ======================
sig_long  = (z_score < -2.0)    # 多A空B
sig_short = (z_score >  2.0)    # 空A多B
sig_exit  = (abs(z_score) < 0.5)# 平仓
```

## 配套仓位计算（对冲关键）

```python
# 目标对冲市值：两边相等
cash = 100000
risk_pct = 0.01

pos_b = int(cash * 0.5 / P_b[-1])
pos_a = int(pos_b * beta)  # 按β配比
```

---

# 四、必须懂的实战数学细节

## 1. β 是什么？

β 是**对冲比例**

- 买 1 份 A，要空 β 份 B
- 不按 β 对冲 = 对冲不干净 = 有方向敞口 = 裸头寸风险

## 2. 为什么要用 Z-score？

不同价格量级（100 元 vs 5000 元）不能直接比价差，

**Z-score 标准化后，统一用 “偏离几倍标准差” 判断高估低估。**

## 3. 阈值为什么常用 ±2？

正态分布下：

- ±2σ 覆盖 95% 区间
- 超出就是小概率异常 → 适合做回归

## 4. 协整检验（避免伪配对）

```python
score, pvalue, _ = coint(P_a, P_b)
# pvalue < 0.05 → 协整成立，适合配对
```

---

# 五、完整策略一句话总结

**找到协整对 → 算 β → 构造价差 → 算 Z-score → 高抛低吸 → 回归平仓**

全程**双向对冲、控制单笔风险、禁止裸头寸**。