下面给你一套**直接可运行、专门用于价差均值回归可视化**的代码：

用 **Matplotlib + Seaborn** 画出：

- 价差曲线
- 滚动均值
- ±1σ、±2σ 置信区间（交易区间）
- 清晰识别：高估区、低估区、正常区

完全适配你之前的 **配对交易 / ADF / Johansen / ECM** 流程。

---

# 完整代码：价差均值回归可视化

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# —————————————— 1. 构造或加载你的价差 ——————————————
# 这里用模拟价差；你可以替换成真实 spread = P1 - β*P2
np.random.seed(42)
n = 200
spread = 0.8 * np.random.randn(n).cumsum() + np.random.randn(n)

# —————————————— 2. 计算滚动均值、标准差、Z-score ——————————————
window = 60
mu = pd.Series(spread).rolling(window=window).mean()  # 均值
sigma = pd.Series(spread).rolling(window=window).std() # 标准差

upper_2sigma = mu + 2 * sigma  # 高估区（空）
upper_1sigma = mu + 1 * sigma
lower_1sigma = mu - 1 * sigma
lower_2sigma = mu - 2 * sigma  # 低估区（多）

z_score = (spread - mu) / sigma

# —————————————— 3. Matplotlib + Seaborn 画图 ——————————————
plt.style.use('seaborn-v0_8-whitegrid')
plt.figure(figsize=(14, 7))

# 画价差
plt.plot(spread, color='#222222', lw=1.8, label='Spread 价差')

# 画滚动均值
plt.plot(mu, color='#ff7f0e', lw=2.5, label=f'{window}日 滚动均值')

# 填充分位数区间（识别均值回归区间）
plt.fill_between(range(len(spread)), upper_2sigma, lower_2sigma, 
                 color='#1f77b4', alpha=0.1, label='±2σ 区间（95%）')
plt.fill_between(range(len(spread)), upper_1sigma, lower_1sigma, 
                 color='#2ca02c', alpha=0.15, label='±1σ 区间（68%）')

# 画±2σ边界
plt.plot(upper_2sigma, color='#d62728', lw=1.5, ls='--', label='+2σ 做空区')
plt.plot(lower_2sigma, color='#2ca02c', lw=1.5, ls='--', label='-2σ 做多区')

# 标注
plt.title('价差走势 & 均值回归交易区间 (±1σ / ±2σ)', fontsize=14, pad=12)
plt.xlabel('时间')
plt.ylabel('Spread 价差')
plt.legend(loc='upper right', frameon=True)
plt.tight_layout()
plt.show()

# —————————————— 4. 额外：Z-score 分布图（Seaborn 核密度） ——————————————
plt.figure(figsize=(10, 5))
sns.kdeplot(z_score.dropna(), fill=True, color='#1f77b4', alpha=0.4)
plt.axvline(2, color='red', linestyle='--', label='+2σ')
plt.axvline(-2, color='green', linestyle='--', label='-2σ')
plt.axvline(0, color='orange', label='均值')
plt.title('Z-score 分布（识别极端偏离）')
plt.legend()
plt.tight_layout()
plt.show()
```

---

# 图里能直接看出什么（交易语言）

1. **灰色线 = 价差**
2. **橙色线 = 长期均衡中心（均值）**
3. **绿色 ±2σ = 做多区间**
    
    价差跌到这里 → 大概率反弹回归 → **多 A 空 B**
4. **红色 ±2σ = 做空区间**
    
    价差涨到这里 → 大概率回落回归 → **空 A 多 B**
5. **蓝色 / 绿色填充 = 正常波动区间**
    
    中间区域不交易，只做**极端偏离**

这就是 **均值回归策略的全部视觉逻辑**。

---

# 如果你有真实价差（来自 Johansen/AKShare/Tushare）

只需要替换这一行：

```python
spread = 你的真实价差序列 (Pandas Series / numpy 数组)
```

其余代码完全不用改，直接出专业图。
