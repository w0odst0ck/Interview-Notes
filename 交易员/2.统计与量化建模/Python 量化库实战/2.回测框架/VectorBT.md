**VectorBT（Vectorized BackTesting）** 是目前 Python 生态中**速度最快、最简洁、最适合统计套利 / 配对交易**的量化回测库。

它完全基于 **Pandas/NumPy/Numba** 向量化运算，**回测速度比 Backtrader 快 10~100 倍**，代码量少 80%，特别适合你做 **Johansen 协整、Z-score、ECM、配对交易** 的快速验证与参数优化。

---

## 一、核心优势（对比 Backtrader）

### 1. 速度爆炸（Numba 加速）

- 向量化 + JIT 编译：**秒级回测 10 年日线、万组参数**vectorbt
- Backtrader 逐行循环，VectorBT 整列矩阵运算

### 2. 极简代码（3 行回测）

- 不需要写 Strategy 类
- 直接用 **布尔信号（entries/exits）** 驱动组合vectorbt

### 3. 配对交易 / 套利天生友好

- 完美支持 **多资产、对冲、价差、Z-score、双向持仓**
- 内置 **协整、平稳性、滚动统计** 函数vectorbt
- **参数优化（网格搜索）一键生成热力图**

### 4. 全链路一体化

- 数据 → 指标 → 信号 → 回测 → 分析 → 可视化 → 报告
- 全部在 Pandas 生态内完成vectorbt

---

## 二、安装

```bash
pip install vectorbt --upgrade
# 完整功能（含可视化、TA-Lib、Plotly）
pip install vectorbt[full]
```

---

## 三、核心概念（一句话）

- **vbt.Indicator**：技术指标（MA、BBANDS、Z-score、MACD）
- **vbt.Signals**：入场 / 出场布尔信号
- **vbt.Portfolio**：核心回测引擎（自动算收益、回撤、手续费）
- **vbt.YFData / vbt.data**：数据获取（可对接 Tushare）vectorbt

---

## 四、配对交易完整实现（Tushare + Johansen + VectorBT）

### 步骤 1：获取数据（Tushare）

```python
import vectorbt as vbt
import pandas as pd
import numpy as np
import tushare as ts

# 初始化 Tushare
ts.set_token("你的Token")
pro = ts.pro_api()

def get_ts_data(ts_code, start, end):
    df = pro.daily(ts_code=ts_code, start_date=start, end_date=end)
    df = df.set_index("trade_date")
    df.index = pd.to_datetime(df.index)
    df = df.sort_index()
    return df[["close"]]

# 获取两只股票（茅台 & 五粮液）
df1 = get_ts_data("600519.SH", "20230101", "20260101")
df2 = get_ts_data("000858.SZ", "20230101", "20260101")

# 合并为配对价格
prices = pd.DataFrame({
    "A": df1["close"],
    "B": df2["close"]
}).dropna()
```

### 步骤 2：Johansen 协整 → 计算对冲比例 β

```python
from statsmodels.tsa.vector_ar.vecm import coint_johansen

# Johansen 检验
jres = coint_johansen(prices, det_order=1, k_ar_diff=1)
beta = jres.yot[:, 0]  # 协整向量
print(f"对冲比例 β: {beta[0]:.3f} : {beta[1]:.3f}")

# 计算价差 & Z-score
spread = beta[0] * prices["A"] + beta[1] * prices["B"]
window = 60
mu = spread.rolling(window).mean()
sigma = spread.rolling(window).std()
z = (spread - mu) / sigma
```

### 步骤 3：VectorBT 生成信号（核心）

```python
# 入场/出场阈值
entry_z = 2.0
exit_z = 0.5

# 信号：
# 当 Z > entry_z → 空A 多B
# 当 Z < -entry_z → 多A 空B
# 当 |Z| < exit_z → 平仓
entries_short_A = z > entry_z
entries_long_A = z < -entry_z
exits = abs(z) < exit_z

# 合并信号（VectorBT 支持多资产信号）
entries = pd.DataFrame({
    "A": entries_long_A,
    "B": entries_short_A  # 反向配对
})

exits_df = pd.DataFrame({
    "A": exits,
    "B": exits
})
```

### 步骤 4：回测（3 行代码）

```python
# 回测引擎
pf = vbt.Portfolio.from_signals(
    prices,
    entries=entries,
    exits=exits_df,
    init_cash=100000,        # 初始资金
    fees=0.0001,             # 手续费万1
    slippage=0.0001,         # 滑点万1
    freq="1D",               # 日线
    size_type="percent",     # 按资金比例
    size=0.5                 # 单腿50%仓位（双向对冲）
)

# 输出结果
print(pf.stats())
```

### 步骤 5：可视化（一键出专业图表）

```python
pf.plot().show()          # 净值曲线
pf.plot_drawdowns().show() # 回撤
pf.plot_trades().show()    # 交易点
```

![](data:image/svg+xml,%3csvg%20xmlns=%27http://www.w3.org/2000/svg%27%20version=%271.1%27%20width=%27256%27%20height=%27192%27/%3e)![image](https://p3-flow-imagex-sign.byteimg.com/isp-i18n-media/img/9eab2cf56b3c9129e0caee9c93ca9514~tplv-a9rns2rl98-pc_smart_face_crop-v1:512:384.image?lk3s=8e244e95&rcl=202604011531232D40249FC244FB3C7BF1&rrcfp=cee388b0&x-expires=2090388710&x-signature=7WbGcBHyLxNA7jvHQQwFFTWygIE%3D)

---

## 五、超级功能：参数优化（热力图）

你可以**同时扫描 1000 组 window/entry_z/exit_z**，秒出最优参数：

```python
# 定义参数网格
windows = np.arange(30, 90, 10)
entry_zs = np.arange(1.5, 3.0, 0.5)

# 向量化批量计算
def backtest_window_entry(window, entry_z):
    mu = spread.rolling(window).mean()
    sigma = spread.rolling(window).std()
    z = (spread - mu) / sigma
    entries = pd.DataFrame({
        "A": z < -entry_z,
        "B": z > entry_z
    })
    exits = abs(z) < 0.5
    pf = vbt.Portfolio.from_signals(
        prices, entries, exits, init_cash=100000, fees=0.0001
    )
    return pf.total_return()

# 网格搜索
returns = vbt.apply_grid(
    backtest_window_entry,
    window=windows,
    entry_z=entry_zs
)

# 画热力图
returns.vbt.heatmap(x_level="window", y_level="entry_z").show()
```

![](data:image/svg+xml,%3csvg%20xmlns=%27http://www.w3.org/2000/svg%27%20version=%271.1%27%20width=%27256%27%20height=%27192%27/%3e)![image](https://p11-flow-imagex-sign.byteimg.com/isp-i18n-media/img/9cce8e1f8355d918a36bde32203658f2~tplv-a9rns2rl98-pc_smart_face_crop-v1:512:384.image?lk3s=8e244e95&rcl=202604011531232D40249FC244FB3C7BF1&rrcfp=cee388b0&x-expires=2090388715&x-signature=vprU7RRusAso1VXNQQeYPQjQCCg%3D)

---

## 六、VectorBT vs Backtrader（你做配对交易）

表格

|特性|VectorBT|Backtrader|
|---|---|---|
|**代码量**|极简（3–10 行）|繁琐（类、next）|
|**回测速度**|⚡️ 秒级（Numba）|🐢 分钟级|
|**配对交易**|✅ 原生多资产、对冲|✅ 支持但复杂|
|**参数优化**|✅ 一键网格 / 热力图|❌ 需自己写循环|
|**信号生成**|✅ Pandas 布尔向量化|❌ 逐 K 判断|
|**学习成本**|⭐⭐|⭐⭐⭐⭐⭐|
|**适合场景**|**研究、套利、快速迭代**|复杂事件驱动|

---

## 七、你现在的完整工作流（最强组合）

1. **Tushare Pro** → 取 A 股日线
2. **Johansen / ADF** → 找协整对 + 计算 β
3. **VectorBT** → 价差 → Z-score → 信号 → **秒级回测**
4. **参数优化** → 热力图 → 最优参数
5. **ECM** → 误差修正 → 改进信号
6. **实盘**

