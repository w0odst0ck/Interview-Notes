# 用 **Pandas** 处理配对交易数据：价差、相关性、协整（全套可直接运行）

我给你一套**纯 Pandas + 统计工具**的完整流程，专门用于：

1. 加载 / 清洗两只股票 / ETF 行情
2. 计算**价差 Spread**
3. 计算**相关系数**
4. 计算**协整关系（Engle-Granger + Johansen）**
5. 输出**能否做配对交易**的结论

完全对接你前面学的 **VectorBT、Backtrader、Matplotlib 可视化**。

---

# 一、完整代码（可直接复制运行）

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.tsa.stattools import coint, adfuller
from statsmodels.regression.linear_model import OLS
from statsmodels.tsa.vector_ar.vecm import coint_johansen

# ==========================================
# 1. 构造模拟行情（你可替换为 Tushare/AkShare 真实数据）
# ==========================================
np.random.seed(42)
n = 1000

# 资产B
b = 100 + np.cumsum(np.random.randn(n))

# 资产A（与B协整）
beta = 1.2
a = beta * b + np.random.randn(n) * 2

# 构建 Pandas DataFrame
dates = pd.date_range(start="2023-01-01", periods=n, freq="D")
df = pd.DataFrame({
    "A": a,
    "B": b
}, index=dates)

# ==========================================
# 2. Pandas 计算：价差 Spread
# ==========================================
# 回归求对冲比例 β
model = OLS(df["A"], df["B"]).fit()
beta = model.params[0]

# 计算价差
df["spread"] = df["A"] - beta * df["B"]

print("==== 对冲比例 β ====")
print(f"β = {beta:.3f}")

# ==========================================
# 3. Pandas 计算：相关系数
# ==========================================
corr = df[["A", "B"]].corr().iloc[0,1]
print("\n==== 相关系数 ====")
print(f"Corr = {corr:.3f}")

# 滚动相关性（可选）
df["roll_corr"] = df["A"].rolling(60).corr(df["B"])

# ==========================================
# 4. 协整检验 A：Engle-Granger 两步法
# ==========================================
# 检验价差是否平稳（ADF）
adf_p = adfuller(df["spread"].dropna())[1]

print("\n==== ADF 平稳性检验（价差）====")
print(f"ADF p-value = {adf_p:.4f}")
print(f"价差平稳 → 可套利 ✅" if adf_p < 0.05 else "价差不平稳 → 不可套利 ❌")

# ==========================================
# 5. 协整检验 B：Johansen 检验（多资产专业版）
# ==========================================
jres = coint_johansen(df[["A", "B"]], det_order=1, k_ar_diff=1)
trace_stat = jres.trace[0]
trace_crit = jres.cvt[0,2]

print("\n==== Johansen 协整检验 ====")
print(f"Trace统计量 = {trace_stat:.2f}, 95%临界值 = {trace_crit:.2f}")
print(f"协整成立 ✅" if trace_stat > trace_crit else "协整不成立 ❌")

# 输出 Johansen 对冲比例
johansen_beta = jres.yot[:,0][1] / jres.yot[:,0][0]
print(f"Johansen 最优对冲比例 β = {johansen_beta:.3f}")

# ==========================================
# 6. 最终结论：能不能做配对交易
# ==========================================
print("\n" + "="*50)
can_trade = (corr > 0.7) and (adf_p < 0.05) and (trace_stat > trace_crit)
print("【最终结论】")
if can_trade:
    print("✅ 高相关 + 协整 + 价差平稳 → 适合配对交易！")
else:
    print("❌ 不满足配对交易条件，放弃！")
```

---

# 二、核心功能讲解（Pandas 重点）

## 1. 计算价差（Spread）

```python
df["spread"] = df["A"] - beta * df["B"]
```

- 这是配对交易的**核心序列**
- 必须平稳，才能均值回归套利

## 2. 计算相关性

```python
df[["A", "B"]].corr()
```

- 实战要求：**> 0.8**
- 滚动相关性可观察**稳定性**

## 3. 协整（配对交易的灵魂）

协整 = **价格非平稳，但价差平稳**

- Engle-Granger：ADF 检验价差
- Johansen：专业多资产检验，直接输出**对冲比例**

---

# 三、如果你用 **真实行情（Tushare/AkShare）**

只需要把前面的**模拟数据**替换成：

```python
# 真实数据示例（AkShare）
import akshare as ak

def get_data(symbol, start, end):
    df = ak.stock_zh_a_hist(symbol=symbol, start_date=start, end_date=end, adjust="qfq")
    return df.set_index("日期")["收盘"]

# 获取两只股票
df = pd.DataFrame({
    "A": get_data("600519", "20230101", "20260101"),
    "B": get_data("000858", "20230101", "20260101")
}).dropna()
```

---

# 四、输出结果你会看到

1. **对冲比例 β**
2. **相关系数**
3. **ADF 平稳性 p 值**
4. **Johansen 协整结果**
5. **最终判断：能不能做配对交易**