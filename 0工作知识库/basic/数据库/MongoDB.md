MongoDB 是一个强大的 NoSQL 数据库，以下是 MongoDB 中一些常见的命令，按功能分类介绍：

### 1. **数据库操作**
- **查看当前数据库**
  ```bash
  db
  ```
- **切换数据库**
  ```bash
  use <database_name>
  ```
- **显示所有数据库**
  ```bash
  show dbs
  ```
- **创建数据库**
  ```bash
  use <database_name>
  ```
  （MongoDB 会在插入数据时自动创建数据库）
- **删除数据库**
  ```bash
  db.dropDatabase()
  ```

### 2. **集合操作**
- **显示当前数据库中的集合**
  ```bash
  show collections
  ```
- **创建集合**
  ```bash
  db.createCollection("<collection_name>")
  ```
- **删除集合**
  ```bash
  db.<collection_name>.drop()
  ```

### 3. **文档操作**
- **插入文档**
  ```bash
  db.<collection_name>.insertOne({<document>})
  ```
  ```bash
  db.<collection_name>.insertMany([{<document1>}, {<document2>}, ...])
  ```
- **查询文档**
  ```bash
  db.<collection_name>.find()
  ```
  ```bash
  db.<collection_name>.find({<query>})
  ```
  ```bash
  db.<collection_name>.findOne({<query>})
  ```
- **更新文档**
  ```bash
  db.<collection_name>.updateOne({<query>}, {<update>})
  ```
  ```bash
  db.<collection_name>.updateMany({<query>}, {<update>})
  ```
- **删除文档**
  ```bash
  db.<collection_name>.deleteOne({<query>})
  ```
  ```bash
  db.<collection_name>.deleteMany({<query>})
  ```

### 4. **索引操作**
- **创建索引**
  ```bash
  db.<collection_name>.createIndex({<field>: 1})  // 升序索引
  db.<collection_name>.createIndex({<field>: -1}) // 降序索引
  ```
- **查看索引**
  ```bash
  db.<collection_name>.getIndexes()
  ```
- **删除索引**
  ```bash
  db.<collection_name>.dropIndex({<field>: 1})
  ```

### 5. **聚合操作**
- **聚合管道**
  ```bash
  db.<collection_name>.aggregate([
    { $match: {<query>} },
    { $group: { _id: "$<field>", <field>: { $sum: 1 } } },
    { $sort: { <field>: 1 } }
  ])
  ```

### 6. **其他操作**
- **查看当前数据库的统计信息**
  ```bash
  db.stats()
  ```
- **查看集合的统计信息**
  ```bash
  db.<collection_name>.stats()
  ```
- **查看服务器状态**
  ```bash
  db.serverStatus()
  ```
- **退出 MongoDB Shell**
  ```bash
  exit
  ```

### 示例
假设有一个名为 `students` 的集合，存储学生的成绩信息，以下是具体操作示例：

#### 创建数据库和集合
```bash
use mydb
db.createCollection("students")
```

#### 插入文档
```bash
db.students.insertMany([
  { name: "Alice", age: 20, score: 85 },
  { name: "Bob", age: 22, score: 90 },
  { name: "Charlie", age: 21, score: 78 }
])
```

#### 查询文档
```bash
db.students.find()
db.students.find({ age: 21 })
db.students.findOne({ name: "Alice" })
```

#### 更新文档
```bash
db.students.updateOne({ name: "Alice" }, { $set: { score: 92 } })
```

#### 删除文档
```bash
db.students.deleteOne({ name: "Bob" })
```

#### 创建索引
```bash
db.students.createIndex({ score: -1 })
```

