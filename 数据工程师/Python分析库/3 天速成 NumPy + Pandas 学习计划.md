
你有**Python 基础 + 算法刷题功底**，学习这两个库会**极快**—— 不用学基础语法，直接聚焦**数据处理核心用法**，3 天完全足够掌握**数据分析 90% 高频操作**（AI / 算法岗日常数据处理全覆盖）。

## 学习前提

- 已安装 Python，直接安装依赖：`pip install numpy pandas matplotlib`
- 工具：Jupyter Notebook（推荐，交互式运行）/ PyCharm

---

# 整体学习思路

**NumPy**：AI 核心底层库，负责**数值计算、数组操作、矩阵运算**（深度学习张量基础）

**Pandas**：负责**表格数据处理**（读取、清洗、筛选、统计、聚合）

学习顺序：先 NumPy（底层基础）→ 再 Pandas（上层应用）

---

# Day 1：NumPy 通关（4~5 小时）

目标：**掌握数组操作、矩阵运算、索引切片、常用数学函数**（AI 必用）

## 上午（2h）：核心基础 + 创建数组

1. **核心概念**（10min）
    
    - NumPy 数组（ndarray） vs Python 列表：**速度快、内存小、支持向量化运算**
    - 维度：标量 (0D)、向量 (1D)、矩阵 (2D)、张量 (3D+)（和深度学习张量完全一致）
    
2. **必学 API**（直接敲代码练习）
    
    ```python
    import numpy as np
    # 1. 创建数组（高频）
    arr = np.array([1,2,3])  # 列表转数组
    zeros = np.zeros((3,3)) # 全0矩阵
    ones = np.ones((2,4))   # 全1矩阵
    rand = np.random.randn(5) # 标准正态分布（AI最常用）
    arange = np.arange(0,10,2) # 等差数组
    ```
    
3. **关键属性**（5min）：`shape`(形状)、`dtype`(数据类型)、`ndim`(维度)

## 下午（2h）：索引切片 + 运算

1. **索引 & 切片**（1h，和 Python 列表语法一致，重点学多维）
    
    ```python
    # 2D矩阵索引
    mat = np.array([[1,2],[3,4],[5,6]])
    mat[0]    # 第一行
    mat[:,1]  # 第二列
    mat[1:,0] # 第2行及以后，第一列
    ```
    
2. **向量化运算**（30min，核心优势！不用写 for 循环）
    
    - 加减乘除、广播机制（必理解，AI 推理 / 训练基础）
    - 矩阵乘法：`np.dot()` / `@`
    
3. **统计函数**（30min）：`sum()、mean()、max()、min()、argmax()、argmin()`

## 晚上（1h）：刷题巩固

做 5 道高频练习题（不用多，覆盖核心）：

1. 创建 3x3 单位矩阵
2. 对随机数组做归一化（(x-mean)/std）
3. 矩阵乘法运算
4. 按行 / 列求和、求均值
5. 布尔索引筛选大于 5 的元素

---

# Day 2：Pandas 基础核心（5 小时）

目标：**Series/DataFrame、数据读取、基础筛选、统计**

## 上午（2h）：核心数据结构

1. **两个核心对象**（30min）
    
    - `Series`：带索引的一维数据（对标 Python 字典）
    - `DataFrame`：表格型二维数据（Excel 表格，数据分析核心）
    
2. **创建 & 查看数据**（30min）
    
    ```python
    import pandas as pd
    # 创建DataFrame（最常用）
    df = pd.DataFrame({
        'name': ['张三','李四','王五'],
        'score': [85,92,78],
        'age': [22,23,21]
    })
    # 查看数据（必用）
    df.head()    # 前5行
    df.info()    # 数据类型/缺失值
    df.describe()# 统计汇总（均值、方差等）
    df.shape     # 行列数
    ```
    
3. **索引与列操作**（1h）：新增列、删除列、重命名列

## 下午（2h）：数据筛选 + 数据清洗

1. **数据筛选**（1h，高频！）
    
    - 按列选取：`df['score']`
    - 按行筛选：`df.loc[0]` / `df.iloc[0]`
    - 条件筛选：`df[df['score'] > 80]`（AI 数据过滤必用）
    
2. **数据清洗**（1h，工作核心）
    
    - 缺失值处理：`df.isnull()、df.dropna()、df.fillna()`
    - 重复值处理：`df.drop_duplicates()`
    - 数据类型转换：`df['age'].astype(float)`
    

## 晚上（1h）：实战练习

1. 读取 CSV 文件（`pd.read_csv()`）
2. 查看数据基本信息
3. 筛选指定条件的数据
4. 处理缺失值 / 重复值
5. 计算某一列的统计指标

---

# Day 3：Pandas 高阶 + 综合实战（4 小时）

目标：**分组聚合、数据合并、时间序列、完整实战流程**（求职 / 工作直接用）

## 上午（2h）：高阶操作

1. **分组聚合**（1h，数据分析灵魂）
    
    ```python
    # 按列分组，求均值/求和
    df.groupby('category')['value'].mean()
    ```
    
2. **数据合并**（30min）：`pd.concat()、pd.merge()`（多表拼接）
3. **数据导出**（30min）：`df.to_csv()`、`df.to_excel()`

## 下午（2h）：**端到端综合实战**（必做，检验学习成果）

用一个数据集完成**全流程数据分析**：

1. 读取数据（CSV/Excel）
2. 数据探索（查看信息、统计值）
3. 数据清洗（缺失值、重复值、异常值）
4. 数据筛选、分组、计算
5. 简单统计分析并导出结果

---

# 超精简速记 API 清单（直接背，3 天够用）

## NumPy 高频（20 个以内）

`np.array()、np.zeros()、np.ones()、np.random.randn()、np.arange()、reshape()、shape、sum()、mean()、max()、argmax()、dot()、@、astype()、bool索引`

## Pandas 高频（30 个以内）

`pd.DataFrame()、pd.read_csv()、head()、info()、describe()、loc/iloc、isnull()、dropna()、fillna()、drop_duplicates()、groupby()、concat()、merge()、value_counts()、sort_values()`

---

# 学习小贴士（适配你的 AI 背景）

1. **不用死记硬背**：理解用法，用到时查即可，你有算法基础，逻辑一看就懂
2. **重点练向量化操作**：避免写 for 循环（NumPy/Pandas 核心优势，也是 AI 数据处理标准写法）
3. **结合你的场景**：把 LeetCode 思维迁移过来 ——**数据 = 输入，操作 = 算法，结果 = 输出**

---

### 总结

1. **Day1**：搞定 NumPy（数组、运算、索引）→ 深度学习张量基础
2. **Day2**：搞定 Pandas 基础（表格、筛选、清洗）→ 数据处理核心
3. **Day3**：搞定 Pandas 高阶 + 实战 → 独立完成数据分析任务
    
    全程**13 小时左右**，每天 4~5 小时，完全适配你的 Python / 算法基础，学完直接胜任 AI 岗日常数据处理工作。