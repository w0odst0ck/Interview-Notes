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
        