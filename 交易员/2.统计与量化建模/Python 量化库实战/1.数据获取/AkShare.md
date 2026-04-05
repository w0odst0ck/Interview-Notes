**AkShare** 是目前国内最流行、免费、开源的 Python 财经数据接口库，专为量化研究、统计套利、配对交易、数据分析设计，**完全免费、无需 API Key、无需注册**AKShare。

你之前一直在学 **ADF / Johansen / ECM / 配对交易**，AkShare 就是给这些策略**直接提供数据源**的最佳工具。

---

# 一、核心特点（适合你做统计套利）

- **免费开源（MIT）**
- **数据覆盖：**
    
    - A 股、港股、美股、期货、期权、基金、债券、外汇、指数、宏观、资金流向
    - **日线 / 分钟线 / 实时行情、财务、资金流、龙虎榜、行业数据**
    
- **统一接口：** 全部返回 **Pandas DataFrame**
- **中文友好：** 字段中文、文档中文
- **更新极快：** 维护活跃，适配网站变更AKShare

---

# 二、安装（一行）

```bash
pip install akshare --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple
```

要求：**Python 3.9+ 64 位**

---

# 三、基础用法（你做配对交易最常用）

```python
import akshare as ak
import pandas as pd
```

## 1. 获取 A 股历史日线（配对交易必备）

```python
# 贵州茅台 & 五粮液（经典配对）
df1 = ak.stock_zh_a_hist(
    symbol="600519",
    period="daily",
    start_date="20230101",
    end_date="20260101",
    adjust="qfq"  # 前复权（回测必须）
)

df2 = ak.stock_zh_a_hist(
    symbol="000858",
    period="daily",
    start_date="20230101",
    end_date="20260101",
    adjust="qfq"
)
```

返回字段：

`日期、开盘、最高、最低、收盘、成交量、成交额、振幅、涨跌幅、换手率`

## 2. 合并为配对价格表

```python
price1 = df1.set_index("日期")["收盘"]
price2 = df2.set_index("日期")["收盘"]
pair = pd.DataFrame({"A": price1, "B": price2}).dropna()
```

**直接用于 Johansen 协整检验、ADF、ECM、配对交易！**

---

# 四、你做统计套利常用接口（直接抄）

### 1. A 股列表

```python
stock_list = ak.stock_zh_a_spot_em()  # 沪深A股
```

### 2. 交易日历

```python
trade_dates = ak.stock_zh_a_trade_date_hist_sina()
```

### 3. 分钟线（高频套利）

```python
df_mins = ak.stock_zh_a_minute(
    symbol="600519",
    period="1",  # 1/5/15/30/60分钟
    start_date="2026-03-01 09:30:00",
    end_date="2026-03-31 15:00:00"
)
```

### 4. 期货数据（商品期货配对）

```python
# 沪铜连续
df_fut = ak.futures_main_sina(symbol="CU", start_date="20230101", end_date="20260101")
```

### 5. 基金 / ETF（ETF 期现套利）

```python
# ETF历史数据
df_etf = ak.fund_etf_hist_em(
    symbol="510300",  # 沪深300ETF
    period="daily",
    start_date="20230101",
    end_date="20260101",
    adjust="qfq"
)
```

### 6. 主力资金流向（辅助择时）

```python
money_flow = ak.stock_zh_a_money_flow_em(symbol="600519")
```

---

# 五、实战：用 AkShare + Johansen 做配对（完整流程）

```python
import akshare as ak
import pandas as pd
from statsmodels.tsa.vector_ar.vecm import coint_johansen

# 1. 获取两只股票数据
def get_pair(symbol1, symbol2, start, end):
    p1 = ak.stock_zh_a_hist(symbol1, "daily", start, end, "qfq")["收盘"]
    p2 = ak.stock_zh_a_hist(symbol2, "daily", start, end, "qfq")["收盘"]
    df = pd.DataFrame({"A": p1.values, "B": p2.values}, index=p1.index)
    return df.dropna()

df = get_pair("600519", "000858", "20230101", "20260101")

# 2. Johansen 协整检验
jres = coint_johansen(df, det_order=1, k_ar_diff=1)

# 3. 最优对冲比例（第一列协整向量）
beta = jres.yot[:, 0]
spread = beta[0] * df["A"] + beta[1] * df["B"]

# 4. ADF 检验价差平稳
from statsmodels.tsa.stattools import adfuller
print("ADF p-value:", adfuller(spread)[1])  # <0.05 可套利
```

---

# 六、你做统计套利的完整数据链

**AkShare → 价格 → Johansen → 对冲比例 → 价差 → ADF → ECM → Z-score → 配对交易信号**

---

# 七、常见坑（避坑指南）

- **symbol 必须纯 6 位数字**（不加 .SH/.SZ）
- **日期格式：YYYYMMDD**
- **复权：回测用 qfq（前复权）**
- **非交易日返回空**：先查交易日历
- **网络问题**：换时段、升级 akshare、换网络