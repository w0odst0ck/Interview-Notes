--1. 用 CASE WHEN 给学生打标签：≥85 优秀、60-84 合格、<60 不合格
--2. 查询分数高于全班平均分的学生
--3. **Python 代码**：把 SQL 结果读成 DataFrame（直接复制运行）

-- 1 特征构造（AI必备）
SELECT name,score,
CASE WHEN score>=85 THEN '优秀'
     WHEN score>=60 THEN '合格'
     ELSE '不合格' END AS level
FROM students;

-- 2 子查询
SELECT * FROM students
WHERE score > (SELECT AVG(score) FROM students);