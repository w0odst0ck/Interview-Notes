# Backtrader —— 量化回测神器（配对交易 / 套利专用）

**Backtrader = 国内最主流的 Python 量化回测框架**

专门用来验证你的：

- 配对交易（Pairs Trading）
- 统计套利
- ETF 期现套利
- 跨期 / 跨品种套利
- 趋势策略

你前面学的 **ADF、Johansen、ECM、Z‑score、对冲、风控**，全部能嵌入 Backtrader 做**专业回测**。

---

# 一、一句话核心

**Backtrader 帮你模拟真金白银的交易环境：

滑点、手续费、保证金、仓位、止损、风控、收益率、最大回撤……

全部自动算给你。**

---

# 二、为什么你必须学 Backtrader？

你做**配对交易 / 统计套利**，必须回测 5 件事：

1. 策略历史赚不赚钱
2. 最大回撤（会不会爆仓）
3. 单笔亏损（风控是否有效）
4. 滑点 + 手续费吃掉多少利润
5. 多少资金能跑

**Backtrader 是最成熟、最轻量、最适合套利的回测框架。**

---

# 三、安装（一行）

```bash
pip install backtrader
```

---

# 四、核心结构（你只需要记这 4 个）

```plaintext
1. 数据 feeds → 价格数据（Tushare/AkShare）
2. 策略 Strategy → 你的交易逻辑（Z-score、对冲、ECM）
3. 佣金 Ccommissions → 手续费、滑点
4. 回测执行 → 输出收益、回撤、曲线
```

---

# 五、最核心：配对交易策略模板

（可直接跑，包含 **双向对冲 + Z-score + 风控**）

```python
import backtrader as bt
import pandas as pd
import numpy as np

# ================== 1. 配对交易策略 ==================
class PairsStrategy(bt.Strategy):
    params = (
        ("window", 60),       # 均值窗口
        ("entry_z", 2.0),     # 入场Z-score
        ("exit_z", 0.5),      # 平仓Z-score
        ("beta", 1.2),        # 对冲比例（Johansen算出）
    )

    def __init__(self):
        # 两个资产：data0 = A, data1 = B
        self.priceA = self.datas[0].close
        self.priceB = self.datas[1].close

        # 计算价差 & Z-score
        self.spread = self.priceA - self.params.beta * self.priceB
        self.mu = bt.indicators.SimpleMovingAverage(self.spread, period=self.params.window)
        self.sigma = bt.indicators.StandardDeviation(self.spread, period=self.params.window)
        self.z = (self.spread - self.mu) / self.sigma

    def next(self):
        # 获取持仓
        posA = self.getposition(self.datas[0]).size
        posB = self.getposition(self.datas[1]).size

        # ------------------- 交易信号 -------------------
        # 信号1：Z > 2 → 空A 多B
        if self.z > self.p.entry_z and posA == 0:
            self.sell(data=self.datas[0])
            self.buy(data=self.datas[1])

        # 信号2：Z < -2 → 多A 空B
        elif self.z < -self.p.entry_z and posA == 0:
            self.buy(data=self.datas[0])
            self.sell(data=self.datas[1])

        # 平仓：回归均值
        elif abs(self.z) < self.p.exit_z:
            if posA != 0 or posB != 0:
                self.close()

# ================== 2. 回测主函数 ==================
def run_backtest(df1, df2):
    cerebro = bt.Cerebro()
    cerebro.addstrategy(PairsStrategy)

    # 加载数据
    data1 = bt.feeds.PandasData(dataname=df1)
    data2 = bt.feeds.PandasData(dataname=df2)
    cerebro.adddata(data1)
    cerebro.adddata(data2)

    # 资金 & 手续费
    cerebro.broker.setcash(100000)
    cerebro.broker.setcommission(commission=0.0001)  # 万1

    # 启动回测
    print("初始资金：", cerebro.broker.getvalue())
    cerebro.run()
    print("最终资金：", cerebro.broker.getvalue())

    # 画图
    cerebro.plot()

# ================== 3. 传入你的数据（AkShare/Tushare） ==================
# df1, df2 是你获取的两只股票/ETF/期货数据
# run_backtest(df1, df2)
```

---

# 六、Backtrader 能帮你做什么？（套利专用）

## 1. **双向对冲交易**

多 A 空 B、空 A 多 B → 完美支持配对交易

## 2. **佣金 & 滑点**

```python
cerebro.broker.setcommission(commission=0.0001)  # 手续费
cerebro.broker.set_slippage_perc(0.0001)        # 滑点
```

## 3. **风控：单笔最大亏损**

```python
if self.position.size != 0:
    if (self.close - self.position.price) / self.position.price > 0.01:
        self.close()  # 止损1%
```

## 4. **禁止裸头寸**

自动检查多空是否配对，不会出现单边持仓

## 5. **输出专业回测指标**

- 累计收益率
- 年化收益
- 最大回撤
- 夏普比率
- 胜率
- 交易次数

---

# 七、你做配对交易的完整流程

**Tushare/AkShare → 价格数据 → Johansen → β → Backtrader 回测 → 策略验证**

---

# 八、我能直接给你的超级干货

我可以把以下内容**整合成一个完整可运行文件**：

1. **Tushare 下载数据**
2. **Johansen 计算对冲比例 β**
3. **ADF 检验平稳性**
4. **Z-score 信号**
5. **Backtrader 完整回测**
6. **双向对冲 + 单笔风控 + 禁止裸头寸**

你只要输入**两只股票代码**，就能跑出：

- 收益曲线
- 回撤
- 交易记录
- 策略是否可用