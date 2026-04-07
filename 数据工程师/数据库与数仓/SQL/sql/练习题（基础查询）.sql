-- 1. 查询所有学生的姓名、班级、分数，只显示前 3 行
-- 2. 查询所有班级名称（不重复）
-- 3. 查询分数≥80 的学生，按分数降序排列
-- 4. 查询姓 “张” 的学生
-- 5. 查询年龄在 20-21 岁之间的女学生

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
