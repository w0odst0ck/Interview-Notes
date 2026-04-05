**Tushare Pro** 是目前国内**数据质量最高、最稳定、机构 / 个人量化最常用**的财经数据平台（Python 库），专为**A 股量化、配对交易、统计套利、因子研究、回测**设计。

你之前学的 **Johansen/ADF/ECM/ 配对交易**，用 Tushare Pro 做数据源是**最稳、最专业**的选择。

---

# 一、核心定位（和 AkShare 对比）

- **Tushare Pro = 稳定、权威、结构化、A 股深度数据**
- **AkShare = 完全免费、无需注册、覆盖更广（含海外 / 加密）**

### 对比表（你做配对交易最关心）

表格

|维度|Tushare Pro|AkShare|
|---|---|---|
|**注册 / Token**|✅ 需要（免费注册）|❌ 不需要|
|**数据质量**|⭐⭐⭐⭐⭐ 交易所级、清洗完整|⭐⭐⭐⭐ 良好，偶有波动|
|**稳定性**|⭐⭐⭐⭐⭐ 官方服务器、生产级|⭐⭐⭐ 依赖第三方网站|
|**A 股深度**|⭐⭐⭐⭐⭐ 财务 / 资金 / 龙虎榜 / 因子|⭐⭐⭐⭐ 基础行情足够|
|**积分 / 付费**|基础免费；高级 / 高频需积分|完全免费|
|**配对交易**|**首选：稳定、回测可靠**|备选：快速测试、免费|

**结论**：做**A 股配对交易、回测、实盘** → **优先 Tushare Pro**

---

# 二、安装 + 注册（5 分钟）

### 1. 安装

```bash

pip install tushare --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple
```

### 2. 注册 + 获取 Token（必须）

1. 访问：[https://tushare.pro/register](https://tushare.pro/register)
2. 手机号注册 → 登录 → **个人中心 → 接口 Token** → 复制
3. 免费积分：新用户≈**100 积分**，足够日常日线 / 财务

### 3. 初始化（代码）

```python
import tushare as ts
import pandas as pd

# 设置你的Token
ts.set_token("你的Token")
pro = ts.pro_api()  # 核心接口
```

---

# 三、配对交易最常用接口（直接抄）

## 1. A 股日线（配对交易必备）

```python
# 贵州茅台 (600519.SH) & 五粮液 (000858.SZ)
df1 = pro.daily(ts_code="600519.SH", start_date="20230101", end_date="20260101")
df2 = pro.daily(ts_code="000858.SZ", start_date="20230101", end_date="20260101")

# 整理为收盘价序列
def get_close(df):
    return df.set_index("trade_date")["close"].sort_index()

p1 = get_close(df1)
p2 = get_close(df2)
pair = pd.DataFrame({"A": p1, "B": p2}).dropna()
```

**直接用于 Johansen 协整、ADF、ECM、配对交易！**

## 2. 股票列表（筛选可配对标的）

```python
# 沪深A股列表
stock_list = pro.stock_basic(exchange="", list_status="L")
```

## 3. 交易日历

```python
trade_cal = pro.trade_cal(exchange="SSE", start_date="20230101", end_date="20260101")
```

## 4. 分钟线（高频套利）

```python
# 1分钟线（需积分）
df_min = pro.bar(ts_code="600519.SH", freq="1min", start_date="2026-03-01 09:30:00", end_date="2026-03-31 15:00:00")
```

## 5. 财务数据（基本面筛选）

```python
# 利润表
income = pro.income(ts_code="600519.SH", start_date="20230101", end_date="20260101")
```

## 6. 指数 / ETF（指数配对）

```python
# 沪深300日线
hs300 = pro.index_daily(ts_code="399300.SZ", start_date="20230101", end_date="20260101")
```

---

# 四、实战：Tushare + Johansen 配对交易（完整流程）

```python
import tushare as ts
import pandas as pd
from statsmodels.tsa.vector_ar.vecm import coint_johansen
from statsmodels.tsa.stattools import adfuller

# 1. 初始化Tushare
ts.set_token("你的Token")
pro = ts.pro_api()

# 2. 获取两只股票
def get_pair(ts1, ts2, start, end):
    df1 = pro.daily(ts_code=ts1, start_date=start, end_date=end)
    df2 = pro.daily(ts_code=ts2, start_date=start, end_date=end)
    p1 = df1.set_index("trade_date")["close"]
    p2 = df2.set_index("trade_date")["close"]
    return pd.DataFrame({"A": p1, "B": p2}).dropna()

df = get_pair("600519.SH", "000858.SZ", "20230101", "20260101")

# 3. Johansen协整检验
jres = coint_johansen(df, det_order=1, k_ar_diff=1)
beta = jres.yot[:, 0]  # 最优对冲比例
spread = beta[0] * df["A"] + beta[1] * df["B"]

# 4. ADF检验价差平稳
adf_p = adfuller(spread)[1]
print(f"ADF p-value: {adf_p:.4f} → {'可套利' if adf_p < 0.05 else '不可套利'}")
```

---

# 五、积分规则（避坑）

- **免费积分**：注册 + 完善资料≈**120 分**
- **日线 / 财务 / 指数**：**免费**（0 积分）
- **分钟线 / L2 行情 / 因子**：需**积分 / 付费**
- **赚积分**：分享、贡献数据、实名认证

---

# 六、配对交易最佳实践

1. **Tushare Pro 取日线** → 稳定、无缺失
2. **Johansen 找对冲比例 β**
3. **ADF 验证价差平稳**
4. **ECM 建模长期均衡**
5. **Z-score 生成交易信号**
6. **回测 → 实盘**