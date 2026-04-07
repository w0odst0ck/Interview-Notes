### 一、SQL 核心数据类型（通用：MySQL、SQLite、PostgreSQL）

1. 数值类型（存数字）

- **INT / INTEGER**：整数（id、年龄、计数）
- **FLOAT / REAL**：小数（分数、概率、特征值）
- **DECIMAL(m,n)**：精确小数（金额，AI 少用）
- **BOOLEAN**：真 / 假（1/0，常用 0/1 代替）

2. 字符串类型（存文本）

- **VARCHAR(n)**：变长字符串（姓名、类别、文本）**最常用**
- **TEXT**：长文本（文章、描述、大段特征）

3. 日期时间类型（时序数据必备）

- **DATE**：日期 `2025-01-01`
- **DATETIME / TIMESTAMP**：日期 + 时间 `2025-01-01 12:30:45`
- **TIME**：仅时间

4. 特殊常用

- **NULL**：空值（不是 0，不是空字符串）

---

### 二、你做 AI 最常用的 5 个（背这 5 个就够）

1. **INT** → 用户 ID、样本序号、计数
2. **FLOAT** → 模型输出概率、分数、连续特征
3. **VARCHAR** → 分类标签、类别、姓名
4. **TEXT** → 文本数据（NLP）
5. **DATETIME** → 时间序列、行为数据

---

### 三、和 Python 对应关系（一眼看懂）

|SQL 类型|Python 对应类型|用途（AI）|
|---|---|---|
|INT|int|id、数量、标签|
|FLOAT|float|预测概率、连续特征|
|VARCHAR/TEXT|str|分类、文本、类别特征|
|DATE|str/datetime|时间特征|
|BOOLEAN|bool|二分类标签|

---

### 四、极简记忆口诀

**数字用 INT/FLOAT，文本用 VARCHAR，时间用 DATE/DATETIME，空值是 NULL。**

---

以下是常用的 SQL 命令参考：

### 1. 数据库操作
```sql
-- 查看所有数据库
SHOW DATABASES;

-- 创建数据库
CREATE DATABASE database_name;

-- 使用数据库
USE database_name;

-- 删除数据库
DROP DATABASE database_name;
```

### 2. 表操作
```sql
-- 查看所有表
SHOW TABLES;

-- 创建表
CREATE TABLE table_name (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    age INT,
    email VARCHAR(100) UNIQUE
);

-- 查看表结构
DESC table_name;
-- 或
SHOW COLUMNS FROM table_name;

-- 删除表
DROP TABLE table_name;

-- 修改表结构
ALTER TABLE table_name ADD column_name datatype;
ALTER TABLE table_name MODIFY column_name new_datatype;
ALTER TABLE table_name DROP column_name;
```

### 3. 数据操作
```sql
-- 插入数据
INSERT INTO table_name (column1, column2) VALUES (value1, value2);

-- 查询数据
SELECT * FROM table_name;
SELECT column1, column2 FROM table_name;

-- 条件查询
SELECT * FROM table_name WHERE condition;

-- 更新数据
UPDATE table_name SET column1 = value1 WHERE condition;

-- 删除数据
DELETE FROM table_name WHERE condition;
```

### 4. 高级查询
```sql
-- 排序
SELECT * FROM table_name ORDER BY column_name ASC/DESC;

-- 分组
SELECT column_name, COUNT(*) FROM table_name GROUP BY column_name;

-- 限制结果数量
SELECT * FROM table_name LIMIT number;

-- 连接查询
SELECT * FROM table1
INNER JOIN table2 ON table1.id = table2.id;

SELECT * FROM table1
LEFT JOIN table2 ON table1.id = table2.id;

-- 子查询
SELECT * FROM table_name
WHERE column_name IN (SELECT column_name FROM another_table);

--  去重
SELECT DISTINCT 字段名 FROM 表名;
```

### 5. 索引操作
```sql
-- 创建索引
CREATE INDEX index_name ON table_name (column_name);

-- 查看表的索引
SHOW INDEX FROM table_name;

-- 删除索引
DROP INDEX index_name ON table_name;
```

### 6. 权限管理
```sql
-- 创建用户
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';

-- 授予权限
GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'localhost';

-- 刷新权限
FLUSH PRIVILEGES;

-- 查看用户权限
SHOW GRANTS FOR 'username'@'localhost';
```

注意事项：
1. 在执行删除和更新操作时，建议先用 SELECT 语句测试条件是否正确
2. 在处理大量数据时，建议使用 LIMIT 限制结果数量
3. 创建表时要合理设计字段类型和约束
4. 在进行重要操作前最好先备份数据
5. 注意 SQL 注入安全问题，使用参数化查询
6. 合理使用索引来提高查询性能
        