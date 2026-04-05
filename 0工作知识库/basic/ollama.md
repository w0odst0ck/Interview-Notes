###  Ollama架构概述

Ollama是一个本地运行大型语言模型(LLM)的工具，主要架构组件包括：

1. **模型管理**
   - 本地模型仓库
   - 模型下载和版本控制
   - 模型优化和量化

2. **推理引擎**
   - 基于GGML/GGUF格式的推理
   - CPU/GPU加速支持
   - 内存优化

3. **API服务层**
   - REST API接口
   - WebSocket支持
   - 兼容OpenAI API格式

4. **命令行界面**
   - 交互式聊天
   - 模型管理命令
   - 脚本集成

### 安装与基本使用

#### 1. 安装
```bash
# Linux/macOS
curl -fsSL https://ollama.com/install.sh | sh

# Windows (PowerShell)
irm https://ollama.com/install.ps1 | iex
```

#### 2. 下载模型
```bash
ollama pull llama2
ollama pull mistral
```

#### 3. 运行模型
```bash
# 交互式聊天
ollama run llama2

# 单次问答
ollama run llama2 "解释量子力学"
```

### 常用命令

#### 模型管理
```bash
# 列出本地模型
ollama list

# 删除模型
ollama rm llama2

# 创建自定义模型
ollama create my-model -f Modelfile
```

#### 服务器控制
```bash
# 启动服务器
ollama serve

# 作为守护进程运行
ollama serve --daemon
```

#### API使用
```bash
# 获取模型列表
curl http://localhost:11434/api/tags

# 生成文本
curl http://localhost:11434/api/generate -d '{
  "model": "llama2",
  "prompt": "为什么天空是蓝色的?"
}'
```

### 高级功能

1. **自定义模型**
   创建`Modelfile`:
   ```
   FROM llama2
   SYSTEM "你是一个专业的物理学家"
   TEMPLATE """[INST] {{ .Prompt }} [/INST]"""
   ```
   然后运行:
   ```bash
   ollama create physicist -f Modelfile
   ```

2. **Python集成**
   ```python
   import ollama
   
   response = ollama.generate(
       model="llama2",
       prompt="解释相对论"
   )
   print(response["response"])
   ```

3. **Docker支持**
   ```bash
   docker run -d -p 11434:11434 --name ollama ollama/ollama
   docker exec ollama ollama pull llama2
   ```

### 性能优化

1. 使用GPU加速:
   ```bash
   ollama serve --gpu
   ```

2. 量化模型减小内存占用:
   ```bash
   ollama pull llama2:7b-q4_0
   ```

3. 限制内存使用:
   ```bash
   ollama serve --max-memory 8GB
   ```
        