
**全部可直接复制运行**，带答案 + 解析，做完 = 精通工作级 SQL

---

## 前置准备（1 分钟）

直接用**在线 SQL 运行工具**（无需安装、无需注册）：

👉 [SQLite Online 运行工具](https://sqliteonline.com/)

打开后直接粘贴代码运行即可。

先执行**建表语句**（3 张表通用所有练习）：

```sql
-- 学生表（基础信息）
CREATE TABLE students (
    id INT, name TEXT, class TEXT, score FLOAT, 
    age INT, create_time TEXT, gender TEXT
);
INSERT INTO students VALUES
(1,'张三','AI',92,20,'2025-01-15','男'),
(2,'李四','AI',76,21,'2025-01-16','女'),
(3,'王五','大数据',85,20,'2025-01-17','男'),
(4,'赵六','大数据',58,22,'2025-01-18','女'),
(5,'钱七','AI',63,19,'2025-01-19','男'),
(6,'孙八','大数据',88,21,'2025-01-20','女');

-- 行为表（学习记录，用于JOIN）
CREATE TABLE behavior (
    user_id INT, study_minutes INT, behavior TEXT
);
INSERT INTO behavior VALUES
(1,120,'刷题'),
(2,80,'听课'),
(3,150,'刷题'),
(5,60,'听课');
```

---

# Day1 练习题（基础查询）

## 目标：SELECT/WHERE/ORDER BY/LIKE/ 去重

### 练习题

1. 查询所有学生的姓名、班级、分数，只显示前 3 行
2. 查询所有班级名称（不重复）
3. 查询分数≥80 的学生，按分数降序排列
4. 查询姓 “张” 的学生
5. 查询年龄在 20-21 岁之间的女学生

### 答案（可直接运行）

```sql
-- 1
SELECT name,class,score FROM students LIMIT 3;
-- 2
SELECT DISTINCT class FROM students;
-- 3
SELECT * FROM students WHERE score>=80 ORDER BY score DESC;
-- 4
SELECT * FROM students WHERE name LIKE '张%';
-- 5
SELECT * FROM students WHERE age BETWEEN 20 AND 21 AND gender='女';
```

---

# Day2 练习题（聚合 + JOIN）

## 目标：GROUP BY / 聚合函数 / LEFT JOIN / 时间筛选

### 练习题

1. 统计每个班级的人数、平均分、最高分
2. 查询平均分≥75 分的班级
3. **左连接**：查询所有学生的姓名 + 学习时长（没有记录显示 NULL）
4. 查询 2025-01-17 之后入学的学生

### 答案

```sql
-- 1 分组聚合
SELECT class,COUNT(*) AS total,AVG(score) AS avg_score,MAX(score) AS max_score
FROM students GROUP BY class;

-- 2 分组后筛选
SELECT class,AVG(score) AS avg_score
FROM students GROUP BY class HAVING avg_score>=75;

-- 3 LEFT JOIN（最核心）
SELECT s.name,b.study_minutes
FROM students s
LEFT JOIN behavior b ON s.id = b.user_id;

-- 4 日期筛选
SELECT * FROM students WHERE create_time > '2025-01-17';
```

---

# Day3 练习题（AI 实战 + Python 联动）

## 目标：CASE WHEN / 子查询 / Python 执行 SQL

### 练习题

1. 用 CASE WHEN 给学生打标签：≥85 优秀、60-84 合格、<60 不合格
2. 查询分数高于全班平均分的学生
3. **Python 代码**：把 SQL 结果读成 DataFrame（直接复制运行）

### 答案

```sql
-- 1 特征构造（AI必备）
SELECT name,score,
CASE WHEN score>=85 THEN '优秀'
     WHEN score>=60 THEN '合格'
     ELSE '不合格' END AS level
FROM students;

-- 2 子查询
SELECT * FROM students
WHERE score > (SELECT AVG(score) FROM students);
```

```python
# 3 Python + SQL 实战代码（本地运行）
import pandas as pd
import sqlite3

# 连接数据库
conn = sqlite3.connect('test.db')

# 执行SQL
sql = """
SELECT s.name,s.class,s.score,b.study_minutes,
CASE WHEN score>=85 THEN '优秀' ELSE '其他' END as level
FROM students s
LEFT JOIN behavior b ON s.id=b.user_id
"""
df = pd.read_sql(sql, conn)

# 输出结果（直接用于AI模型训练）
print(df)
conn.close()
```

---

# 通关标准（3 天验收）

1. Day1：所有基础查询**不看答案能写出来**
2. Day2：`LEFT JOIN + GROUP BY` 熟练使用
3. Day3：`CASE WHEN` + Python 读取 SQL**1 分钟写完**