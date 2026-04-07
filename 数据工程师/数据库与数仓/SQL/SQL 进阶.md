# 一、SQL 进阶（交易风控必考）

## 题型 1：窗口函数（必问：LAG/LEAD、ROW_NUMBER、SUM OVER）

### 题目 1：取每个用户**最新 1 笔交易**

表：trade

| user_id | trade_time | amount | symbol |
| ------- | ---------- | ------ | ------ |
| 1       | 09:00      | 100    | BTC    |
| 1       | 09:05      | 200    | BTC    |
| 2       | 09:01      | 50     | ETH    |


要求：每个用户只保留**最新一笔交易**

```sql
WITH t AS (
    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY trade_time DESC) AS rn
    FROM trade
)
SELECT * FROM t WHERE rn = 1;
```

### 题目 2：计算**用户累计交易额**（滑动 / 累计）

按时间升序，计算每个用户**累计交易金额**

```sql
SELECT 
    user_id,
    trade_time,
    amount,
    SUM(amount) OVER (PARTITION BY user_id ORDER BY trade_time) AS cum_amount
FROM trade;
```

---

### 题目 3：识别**异常交易**（和上一笔对比）

找出**单笔金额 > 上一笔 2 倍**的交易（风控典型题）

```sql
WITH t AS (
    SELECT *,
        LAG(amount) OVER (PARTITION BY user_id ORDER BY trade_time) AS prev_amount
    FROM trade
)
SELECT * FROM t 
WHERE amount > 2 * prev_amount;
```

---

## 题型 2：分组统计 + 时间过滤

### 题目 4：统计每个用户**每日交易次数、总金额、最大单笔**

```sql
SELECT
    user_id,
    DATE(trade_time) AS dt,
    COUNT(*) AS trade_cnt,
    SUM(amount) AS total_amt,
    MAX(amount) AS max_amt
FROM trade
GROUP BY user_id, DATE(trade_time);
```

---

# 二、Pandas 进阶（和 SQL 完全对应，面试最爱对比问）

我给你**同场景同逻辑**的 Pandas 写法，你背熟就能直接说。

```python
import pandas as pd
import numpy as np

# 构造样例数据
data = {
    'user_id': [1,1,2],
    'trade_time': ['09:00','09:05','09:01'],
    'amount': [100,200,50],
    'symbol': ['BTC','BTC','ETH']
}
df = pd.DataFrame(data)
```

---

## 题目 1：每个用户取最新 1 笔

```python
df.sort_values('trade_time', ascending=False)\
  .groupby('user_id')\
  .first()\
  .reset_index()
```

---

## 题目 2：用户累计交易额

```python
df['cum_amount'] = df.sort_values('trade_time')\
                     .groupby('user_id')['amount']\
                     .cumsum()
```

---

## 题目 3：异常交易（单笔 > 上一笔 2 倍）

```python
df['prev_amount'] = df.groupby('user_id')['amount'].shift(1)
df[df['amount'] > 2 * df['prev_amount']]
```

---

## 题目 4：每日统计（次数、总金额、最大单笔）

```python
# 先转日期
df['dt'] = pd.to_datetime(df['trade_time'], format='%H:%M').dt.date

df.groupby(['user_id', 'dt']).agg(
    trade_cnt=('amount','count'),
    total_amt=('amount','sum'),
    max_amt=('amount','max')
).reset_index()
```

---

# 三、面试**拔高题**（你会这个直接加分）

## SQL：找出**连续 2 笔都异常**的用户

```sql
WITH t AS (
    SELECT *,
        LAG(amount) OVER (PARTITION BY user_id ORDER BY trade_time) AS prev_amt,
        CASE WHEN amount > 2 * LAG(amount) OVER (PARTITION BY user_id ORDER BY trade_time) 
             THEN 1 ELSE 0 END AS is_abnormal
    FROM trade
),
t2 AS (
    SELECT *,
        LEAD(is_abnormal) OVER (PARTITION BY user_id ORDER BY trade_time) AS next_abnormal
    FROM t
)
SELECT DISTINCT user_id 
FROM t2 
WHERE is_abnormal=1 AND next_abnormal=1;
```

## Pandas 对应

```python
df['prev_amt'] = df.groupby('user_id')['amount'].shift(1)
df['is_abnormal'] = (df['amount'] > 2 * df['prev_amt']).astype(int)
df['next_abnormal'] = df.groupby('user_id')['is_abnormal'].shift(-1)

result = df[(df['is_abnormal']==1) & (df['next_abnormal']==1)]['user_id'].unique()
```

---

# 四、你明天面试**必背一句话**

面试官问：你 SQL/Pandas 熟练到什么程度？

你直接说：

> 复杂分组、多表 JOIN、窗口函数（ROW_NUMBER/LAG/SUM OVER）都能熟练写，Pandas 的 groupby、shift、cumsum、agg 多维度统计也没问题，能直接做交易时序分析和异常监控。