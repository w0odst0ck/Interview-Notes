
---

你有**SQL+Python**、AI 专业背景，**完全可以 3 天拿下 Hive 核心**，直接对接 AI 大数据（数仓清洗、特征工程、离线训练数据）。我给你做**最精简、最高效、直奔就业**的路线，每天 4-6 小时即可。

## 整体定位（先搞懂你学 Hive 用来干嘛）

Hive = **基于 Hadoop 的 SQL 数仓引擎**

你学它就是为了：

- 从大数据集群**拉取 / 清洗特征数据**
- 写 SQL 做**离线特征工程**
- 对接 Spark/Flink 做 AI 训练数据预处理
- 进 AI 大数据 / 数据仓库 / 特征平台必备技能

---

# 第 1 天：Hive 基础 + 环境 + 建库建表（必学）

## 目标

- 理解 Hive 是什么、为什么 AI 要用
- 会建库、建表、分区、分桶（面试必考）
- 会基础 DDL/DML，和 MySQL 对比记忆

## 核心内容（只学这些）

1. **Hive 架构一句话**
    
    - 元数据存 MySQL/Derby
    - 实际数据存 HDFS
    - 你写 HQL → 转成 MapReduce/Tez/Spark 执行
    
2. **环境（最快方式）**
    
    - 用 **Docker 一键起 Hive**（最省事）

    ```bash
    # 直接复制跑（有 Docker 就行）
    docker run -d --name hive -p 10000:10000-p 9083:9083 apache/hive:3.1.3
    docker exec -it hive beeline -u jdbc:hive2://localhost:10000
    ```
    
3. **库操作**

```sql
CREATE DATABASE ai_feature;
USE ai_feature;
```

4. **建表（AI 方向最常用：内部表 + 分区表）**

```sql
CREATE TABLE user_behavior(
    user_id BIGINT,
    item_id BIGINT,
    category_id INT,
    behavior STRING,
    ts BIGINT
) 
PARTITIONED BY (dt STRING)  -- 按日期分区（大数据标配）
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
```

5. **加载数据**

```sql
LOAD DATA LOCAL INPATH '/tmp/data.csv' INTO TABLE user_behavior PARTITION(dt='2026-03-29');
```

## 当天作业

- 建 2 张表：一张普通表，一张**分区表**
- 造 1 万条模拟用户 / 特征数据导入

---

# 第 2 天：Hive SQL 核心（90% 工作都用这些）

## 目标

- 把你的 SQL 迁移到 Hive
- 掌握**大数据特征清洗常用函数**
- 会 JOIN、开窗函数（特征工程高频）

## 必学语法（和 MySQL 几乎一样，只记差异）

1. **SELECT / WHERE / GROUP BY / ORDER BY**
    
    完全和 SQL 一样，直接写。
    
2. **重点函数（AI 特征必备）**
    

- 时间函数

```sql
from_unixtime(ts, 'yyyy-MM-dd HH:mm:ss')
date_format(dt, 'yyyy-MM-dd')
datediff(end, start)
```

- 字符串 / 清洗

```sql
split(col, ',')[0]
get_json_object(json_col, '$.age')
nvl(col, 0)  -- 空值填充（特征工程超常用）
coalesce(a,b,c)
```

- 聚合

```sql
count(distinct user_id)
sum(score) over(partition by user_id order by ts rows between unbounded preceding and current row)
```

3. **开窗函数（面试 + 特征工程必考）**

```sql
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY ts DESC) AS rn
```

用途：取用户**最近一次行为**、**TopN 特征**。

4. **JOIN**
    
    支持 LEFT / INNER / FULL，和 SQL 一致。

## 当天作业

用 `user_behavior` 表做：

1. 按天统计 UV、点击数
2. 计算每个用户**最近 3 次行为**（row_number）
3. 做一次空值填充、类型转换

---

# 第 3 天：AI 大数据实战 + 性能 + 面试重点

## 目标

- 学会**Hive 做特征工程标准流程**
- 懂分区 / 分桶 / 分文件优化
- 能说清楚 Hive 在 AI 架构里的位置

## 核心内容

### 1. 分区表（重中之重）

- 为什么分区：**剪枝查询，提速 10~100 倍**
- 你做 AI 特征一定按 `dt` / `country` / `user_group` 分区

### 2. 分桶（简单了解即可）

```sql
CLUSTERED BY (user_id) INTO 10 BUCKETS
```

作用：Join 更快，抽样更均匀。

### 3. AI 大数据实战：从 Hive 导出特征到 Python

标准工作流：

**Hive 清洗 → 导出 CSV/Parquet → Python 读入训练**

方式 1：导出 HDFS 再拉到本地

```sql
INSERT OVERWRITE DIRECTORY '/tmp/feature'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT user_id, count(*) as click_cnt, max(ts)
FROM user_behavior
WHERE dt='2026-03-29'
GROUP BY user_id;
```

方式 2（更常用）：

用 **PyHive** 直接 Python 连 Hive 拿 DataFrame

```python
from pyhive import hive
import pandas as pd

conn = hive.connect(host='localhost', port=10000, database='ai_feature')
df = pd.read_sql("""
    SELECT user_id, behavior, ts FROM user_behavior WHERE dt='2026-03-29'
""", conn)
```

**这就是你 AI 大数据的核心链路！**

### 4. 面试必背（3 句话）

1. Hive 是**基于 Hadoop 的 SQL 数仓**，不存数据只存元数据。
2. 分区是**横向切分数据**，用于加速查询。
3. 做特征工程常用：**分区表 + 开窗函数 + NVL 空值填充**。

---

# 3 天速成学习材料（只看这些）

- 文档：Apache Hive 官方快速入门（10 分钟）
- 视频：B 站「Hive 3 小时入门」（只看前 1.5 小时）
- 命令：我上面给的所有 SQL 直接背熟

