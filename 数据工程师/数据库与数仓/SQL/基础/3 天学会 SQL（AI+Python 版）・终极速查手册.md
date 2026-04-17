
**直接存手机 / 打印，写代码随时查，3 天够用、工作也够用**

全是**AI 场景高频语法**，无冷门内容！

---

## 一、Day1 基础查询（必背）

```sql
-- 1. 基础查询（取指定列/所有列）
SELECT 字段1, 字段2 FROM 表名 LIMIT 10;  -- 取前10行（防数据卡死）
SELECT * FROM 表名 LIMIT 10;  -- * = 所有列

-- 2. 去重
SELECT DISTINCT 字段名 FROM 表名;

-- 3. 条件筛选（对应Python布尔索引）
SELECT * FROM 表名
WHERE 分数 >= 80  -- 数字筛选
  AND 班级 = 'AI'  -- 字符串用单引号
  AND 姓名 IS NOT NULL;  -- 判空必须用IS (NOT) NULL

-- 4. 模糊匹配（查文本）
SELECT * FROM 表名 WHERE 姓名 LIKE '张%';  -- 以张开头

-- 5. 排序
SELECT * FROM 表名 ORDER BY 分数 DESC;  -- DESC降序，ASC升序
```

---

## 二、Day2 进阶核心（80% 工作用这个）

### 1. 聚合 + 分组（统计数据）

```sql
-- 常用聚合：计数/求和/平均/最大/最小
SELECT 
  班级,
  COUNT(*) AS 总人数,  -- AS=别名，方便对接Python
  AVG(分数) AS 平均分
FROM 表名
GROUP BY 班级  -- 分组必须和SELECT字段对应
HAVING AVG(分数) >= 70;  -- 分组后筛选（不能用WHERE）
```

### 2. 多表连接 JOIN（重中之重）

```sql
-- LEFT JOIN 最常用（保留左表所有数据）
SELECT u.用户ID, u.姓名, b.行为
FROM 用户表 u  -- u=表别名，简化代码
LEFT JOIN 行为表 b 
  ON u.用户ID = b.用户ID;  -- 关联条件

-- INNER JOIN：只保留两张表都匹配的数据
```

### 3. 时间处理（时序数据必备）

```sql
SELECT * FROM 表名
WHERE 时间 >= '2025-01-01'  -- 筛选日期
ORDER BY 时间 DESC;
```

---

## 三、Day3 AI 实战语法（特征工程专用）

### 1. CASE WHEN（构造模型特征）

```sql
-- 把分数转成分类标签（直接喂给AI模型）
SELECT 
  姓名,
  分数,
  CASE WHEN 分数 >= 85 THEN '优秀'
       WHEN 分数 >= 60 THEN '合格'
       ELSE '不合格' END AS 等级
FROM 表名;
```

### 2. 子查询 / 复杂逻辑

```sql
-- 查分数高于平均分的学生
SELECT * FROM 表名
WHERE 分数 > (SELECT AVG(分数) FROM 表名);
```

---

## 四、Python + SQL 联动（AI 专属，直接复制用）

**一行代码把数据库数据读成 DataFrame**

```python
import pandas as pd
import sqlite3  # 轻量数据库，无需安装服务

# 1. 连接数据库
conn = sqlite3.connect('test.db')

# 2. 写SQL（直接粘贴上面的语法）
sql = """
SELECT 班级, AVG(分数) AS 平均分
FROM students
WHERE 分数 >= 60
GROUP BY 班级
"""

# 3. 直接读取为DataFrame（AI标准流程）
df = pd.read_sql(sql, conn)

# 4. 关闭连接
conn.close()

# 后续：数据清洗 → 特征工程 → 模型训练
print(df.head())
```

---

## 五、高频报错速修（3 天必遇）

1. `GROUP BY`报错：SELECT 的字段**必须包含在 GROUP BY 里**
2. 判空错：不能写`= NULL`，必须写`IS NULL`
3. 字符串错：必须用**单引号**，不能用双引号
4. 数据太多卡死：必须加`LIMIT 10/100`

---

## 六、3 天极简学习路线（照着走不迷路）

- Day1：练会 `SELECT + WHERE + ORDER BY`
- Day2：练会 `GROUP BY + LEFT JOIN`
- Day3：练会 `CASE WHEN` + **Python 读取 SQL**
