在使用 Streamlit 进行 Python 开发时，除了前面提到的命令行工具外，还需要掌握一些 Python 中的 Streamlit API 命令。这些命令用于构建交互式 Web 应用的核心功能。以下是 Streamlit Python 开发中常见的命令及其用途：

### 1. **基本界面元素**
- **标题和文本**
  ```python
  st.title("主标题")
  st.header("副标题")
  st.subheader("子标题")
  st.write("普通文本内容")
  ```

- **显示 Markdown**
  ```python
  st.markdown("这是一个 **Markdown** 文本")
  ```

- **显示代码**
  ```python
  st.code("print('Hello, Streamlit!')", language="python")
  ```

- **显示表格**
  ```python
  import pandas as pd
  df = pd.DataFrame({
      "列1": [1, 2, 3],
      "列2": [4, 5, 6]
  })
  st.table(df)
  ```

- **显示图表**
  ```python
  import matplotlib.pyplot as plt
  import numpy as np

  fig, ax = plt.subplots()
  ax.plot(np.random.randn(10))
  st.pyplot(fig)
  ```

### 2. **交互式控件**
- **按钮**
  ```python
  if st.button("点击我"):
      st.write("按钮被点击了！")
  ```

- **文本输入框**
  ```python
  user_input = st.text_input("请输入内容")
  st.write("你输入的内容是：", user_input)
  ```

- **选择框**
  ```python
  options = ["选项1", "选项2", "选项3"]
  selected_option = st.selectbox("请选择一个选项", options)
  st.write("你选择了：", selected_option)
  ```

- **复选框**
  ```python
  if st.checkbox("勾选我"):
      st.write("复选框被勾选了！")
  ```

- **滑块**
  ```python
  age = st.slider("选择你的年龄", 0, 100, 25)
  st.write("你的年龄是：", age)
  ```

### 3. **文件上传**
- **上传文件**
  ```python
  uploaded_file = st.file_uploader("上传文件")
  if uploaded_file is not None:
      # 读取文件内容
      bytes_data = uploaded_file.getvalue()
      st.write("文件内容：", bytes_data)
  ```

### 4. **缓存**
- **缓存函数**
  ```python
  @st.cache_data
  def expensive_function(param):
      # 模拟耗时操作
      return param * 2

  result = expensive_function(10)
  st.write("缓存结果：", result)
  ```

### 5. **侧边栏**
- **创建侧边栏**
  ```python
  st.sidebar.header("侧边栏标题")
  side_input = st.sidebar.text_input("侧边栏输入")
  st.sidebar.write("你输入的内容是：", side_input)
  ```

### 6. **布局**
- **列布局**
  ```python
  col1, col2 = st.columns(2)
  col1.write("这是第一列")
  col2.write("这是第二列")
  ```

- **展开器**
  ```python
  with st.expander("点击展开"):
      st.write("这里是隐藏的内容")
  ```

### 7. **显示数据**
- **显示 DataFrame**
  ```python
  st.dataframe(df)
  ```

- **显示 JSON**
  ```python
  st.json({"key": "value"})
  ```

### 8. **显示警告和通知**
- **显示警告**
  ```python
  st.warning("这是一个警告")
  ```

- **显示错误**
  ```python
  st.error("这是一个错误")
  ```

- **显示成功**
  ```python
  st.success("操作成功")
  ```

### 示例：完整的 Streamlit 应用
以下是一个完整的 Streamlit 应用示例，展示了多种常见功能：
```python
import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

# 设置标题
st.title("我的 Streamlit 应用")

# 创建侧边栏
st.sidebar.header("输入参数")
user_input = st.sidebar.text_input("请输入内容")
st.sidebar.write("你输入的内容是：", user_input)

# 创建按钮
if st.button("点击我"):
    st.write("按钮被点击了！")

# 创建滑块
age = st.slider("选择你的年龄", 0, 100, 25)
st.write("你的年龄是：", age)

# 创建选择框
options = ["选项1", "选项2", "选项3"]
selected_option = st.selectbox("请选择一个选项", options)
st.write("你选择了：", selected_option)

# 创建文件上传
uploaded_file = st.file_uploader("上传文件")
if uploaded_file is not None:
    bytes_data = uploaded_file.getvalue()
    st.write("文件内容：", bytes_data)

# 创建图表
fig, ax = plt.subplots()
ax.plot([1, 2, 3], [4, 5, 6])
st.pyplot(fig)

# 创建 DataFrame
df = pd.DataFrame({
    "列1": [1, 2, 3],
    "列2": [4, 5, 6]
})
st.dataframe(df)
```

运行命令：
```bash
streamlit run app.py
```

通过这些命令，你可以快速构建出功能丰富的交互式 Web 应用。