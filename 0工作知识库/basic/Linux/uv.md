以下是uv的常用命令和使用方法：

### 1. 安装和更新

```bash
# 在Windows上安装
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

# 使用pip安装
pip install uv

# 使用pipx安装
pipx install uv

# 更新uv（如果是通过独立安装程序安装的）
uv self update
```

### 2. 虚拟环境管理

```bash
# 创建虚拟环境
uv venv
# 或指定Python版本
uv venv --python 3.12.0

# 激活虚拟环境（Windows）
.venv\Scripts\activate
```

### 3. 包管理

```bash
# 安装单个包
uv pip install package_name

# 从requirements.txt安装
uv pip install -r requirements.txt

# 添加包到项目
uv add package_name

# 编译requirements文件
uv pip compile requirements.in

# 同步依赖
uv sync
```

### 4. Python版本管理

```bash
# 安装指定Python版本
uv python install 3.10 3.11 3.12

# 设置当前目录的Python版本
uv python pin 3.11
```

### 5. 项目管理

```bash
# 初始化新项目
uv init project_name

# 锁定依赖版本
uv lock

# 运行Python脚本
uv run script.py

# 运行带依赖的命令
uv pip run pytest
```

### 6. 工具管理

```bash
# 运行一次性工具（类似pipx run）
uvx tool_name

# 安装全局工具
uv tool install tool_name
```

### 主要特点：

1. 速度快：比传统工具快10-100倍
2. 全能型：集成了pip、pip-tools、pipx、poetry、pyenv、virtualenv等多个工具的功能
3. 磁盘效率：使用全局缓存进行依赖去重
4. 跨平台：支持Windows、Linux和macOS
5. 依赖管理：支持版本覆盖、依赖解析策略和冲突追踪
6. 工作区支持：可以处理大规模项目
 
 .venv\Scripts\activate
uv pip install pymysql --python=.venv\Scripts\python.exe