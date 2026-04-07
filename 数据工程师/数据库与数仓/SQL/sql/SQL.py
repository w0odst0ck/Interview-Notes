# 把 SQL 结果读成 DataFrame

import pandas as pd
import sqlite3
conn = sqlite3.connect('test.db')

sql = """
SELECT s.name,s.class,s.score,b.study_minutes,
CASE WHEN score>=85 THEN '优秀' ELSE '其他' END as level
FROM students s
LEFT JOIN behavior b ON s.id=b.user_id
"""

df = pd.read_sql(sql,conn)

print(df)
conn.close()
