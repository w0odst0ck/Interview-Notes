-- 1. 统计每个班级的人数、平均分、最高分
-- 2. 查询平均分≥75 分的班级
-- 3. **左连接**：查询所有学生的姓名 + 学习时长（没有记录显示 NULL）
-- 4. 查询 2025-01-17 之后入学的学生

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

