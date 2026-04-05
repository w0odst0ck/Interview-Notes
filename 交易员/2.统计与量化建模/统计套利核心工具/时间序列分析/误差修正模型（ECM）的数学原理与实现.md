
## 数学原理 + 直观理解 + Python 完整实现

ECM 是**配对交易 / 统计套利**里非常高级、也非常实用的模型：

它既能捕捉**长期均衡关系**（协整），又能捕捉**短期偏离修正**（均值回归），天然就是为套利而生。

---

# 一、一句话核心

**ECM = 长期均衡关系 + 短期纠错机制**

- 两个资产长期有稳定关系（协整）
- 短期偏离后，会以一定速度**拉回均衡**
- 这个 “拉回” 的过程，就是配对交易的利润来源

---

# 二、数学原理（从简单到严谨）

## 1. 先看两个资产的长期关系

设：

$$ y_t = \alpha + \beta x_t + z_t $$

- $y_t$​,$x_t​$：两个资产价格（非平稳）
- $z_t = y_t - \alpha - \beta x_t$​：**价差（误差项）**
- 如果 $z_t$​ 平稳 → **协整关系成立**

这就是你前面学的：**长期均衡**。

---

## 2. 短期变化：差分序列

金融价格非平稳，但**收益率（差分）平稳**：

$$ \begin{cases} \Delta y_t = y_t - y_{t-1} \\ \Delta x_t = x_t - x_{t-1} \end{cases} $$

---

## 3. ECM 核心公式

$$ \Delta y_t = c_0 + c_1 \Delta x_t + \gamma z_{t-1} + \epsilon_t $$

### 关键项：误差修正项

$\gamma z_{t-1}​$

- $z_{t-1}​$：**上一期偏离均衡的误差（价差）**
- γ：**修正系数（纠错速度）**

---

## 4. 最重要的参数：γ

- γ<0 且显著
    
    → 当 y 偏高时，下一阶段会**向下修正**
    
    → 当 y 偏低时，下一阶段会**向上修正**
    
    → **这就是均值回归！**
    
- γ 越接近 -1
    
    → 修正速度越快
    
    → 套利越有效、越稳
    

---

## 5. 直观理解（套利版）

- $z_{t-1}​$​ 大且正 → A 相对高估 → 未来会跌
- $z_{t-1}​$​ 大且负 → A 相对低估 → 未来会涨
- γ 告诉你：**偏离之后，多久能拉回来、拉回多少**

ECM 本质就是：

**用数学量化 “均值回归的速度”**

---

# 三、ECM 完整建模步骤（标准流程）

1. 检验 yt​,xt​ 非平稳（ADF 检验）
2. 检验协整，得到长期关系
    
    $$ y_t = \alpha + \beta x_t + z_t $$
1. 保存残差 zt−1​
2. 构建 ECM 回归：
    
    $$ \Delta y_t = c_0 + c_1 \Delta x_t + \gamma z_{t-1} + \varepsilon_t $$
1. 看 γ 是否显著为负
    
    → 确定存在**误差修正（均值回归）**

---

# 四、Python 实现（可直接跑）

```python
import numpy as np
import statsmodels.api as sm
from statsmodels.tsa.stattools import adfuller

# ===================== 1. 生成协整数据 =====================
np.random.seed(42)
t = np.arange(1000)

x = np.cumsum(np.random.randn(1000))  # 非平稳
y = 1.2 * x + 0.5 + np.random.randn(1000) * 2  # 协整
```

```python
# ===================== 2. 协整回归（长期关系） =====================
X = sm.add_constant(x)
model_coint = sm.OLS(y, X).fit()
alpha, beta = model_coint.params
z = model_coint.resid  # 价差 = 误差项
```

```python
# ===================== 3. ADF 检验价差是否平稳 =====================
def adf(series):
    return adfuller(series)[1]

print("p-value of spread:", adf(z))  # 应 <0.05
```

```python
# ===================== 4. 构建差分序列 =====================
dy = np.diff(y)
dx = np.diff(x)
z_lag = z[:-1]  # z_{t-1}
```

```python
# ===================== 5. 拟合 ECM =====================
X_ecm = sm.add_constant(np.column_stack([dx, z_lag]))
model_ecm = sm.OLS(dy, X_ecm).fit()

print(model_ecm.summary())
```

---

# 五、怎么看结果（实战重点）

在回归结果里找这一行：

```plaintext
                 coef    std err          t
const         0.0123      ...        ...
dx            1.1xxxx      ...        ...
z_lag        -0.3xxxx      ...     -xxx.xx  <--- 关键
```

- **z_lag 系数 γ 显著为负**
    
    → 存在**误差修正机制**
    
    → 配对交易有效
    
- γ ≈ -0.3
    
    → 每期修正约 30% 的偏离
    
    → 偏离后大约 3～4 期回归均衡
    

---

# 六、ECM 怎么直接用于配对交易？

1. 用 ECM 算出**预期修正方向**
2. 当 $z_{t-1}​$​ 很大 + γ 显著为负
    
    → 做空 y，做多 x
1. 当 $z_{t-1}​$​ 很小 + γ 显著为负
    
    → 做多 y，做空 x
2. 回归到 0 附近平仓

ECM 比简单 Z-score 更强：

**它不仅告诉你偏不偏，还告诉你 “多久能回来”**

---

# 七、极简总结

- **ECM = 长期协整 + 短期纠错**
- γ<0 且显著
    
    → 存在**均值回归**
- ECM 是**配对交易的理论顶配模型**
- 价差平稳 + ECM 显著
    
    → 这对资产**天生适合套利**