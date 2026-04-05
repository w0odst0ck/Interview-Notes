### Python Requests 库的基本命令与架构

Python 的`requests`库是一个广泛使用的 HTTP 客户端库，它提供了简单而优雅的 API 来发送各种 HTTP 请求。下面介绍其基本命令和架构。
### 基本命令
`requests`库支持所有 HTTP 方法：GET、POST、PUT、DELETE、HEAD、OPTIONS 等。以下是一些基本用法：

```python
import requests

# GET请求
response = requests.get('https://api.example.com/data')

# POST请求
data = {'key': 'value'}
response = requests.post('https://api.example.com/submit', data=data)

# 带参数的GET请求
params = {'param1': 'value1', 'param2': 'value2'}
response = requests.get('https://api.example.com/search', params=params)

# 带请求头的请求
headers = {'Authorization': 'Bearer token123'}
response = requests.get('https://api.example.com/protected', headers=headers)

# 带JSON数据的请求
json_data = {'name': 'John', 'age': 30}
response = requests.post('https://api.example.com/json', json=json_data)

# 处理响应
print(response.status_code)     # 响应状态码
print(response.text)            # 响应文本
print(response.json())          # 解析JSON响应
print(response.headers)         # 响应头
```
### 高级用法
`requests`还支持更复杂的功能：

```python
# 会话保持（用于保持Cookie等状态）
session = requests.Session()
session.get('https://example.com/login')  # 登录
response = session.get('https://example.com/profile')  # 获取个人资料

# 文件上传
files = {'file': open('report.xls', 'rb')}
response = requests.post('https://httpbin.org/post', files=files)

# 超时设置
response = requests.get('https://example.com', timeout=5)  # 5秒超时

# 错误处理
try:
    response = requests.get('https://nonexistent.com')
    response.raise_for_status()  # 抛出异常如果状态码不是200
except requests.exceptions.HTTPError as http_err:
    print(f'HTTP错误: {http_err}')
except requests.exceptions.ConnectionError as conn_err:
    print(f'连接错误: {conn_err}')
except requests.exceptions.Timeout as timeout_err:
    print(f'超时错误: {timeout_err}')
except requests.exceptions.RequestException as req_err:
    print(f'其他请求错误: {req_err}')
```
### 架构概述
`requests`库的架构主要包含以下几个部分：
1. **请求接口层**：提供简单易用的 API（如`requests.get()`、`requests.post()`等）
2. **会话层**：`Session`类管理会话状态，包括 Cookie、连接池等
3. **适配器层**：`HTTPAdapter`处理不同传输协议（如 HTTP、HTTPS）
4. **发送层**：负责实际发送请求并接收响应
5. **响应处理层**：解析和处理服务器响应

`requests`库的核心优势在于：

- 简洁的 API 设计，易于使用
- 自动处理 HTTP 连接、Cookie 和重定向
- 支持 SSL/TLS 加密连接
- 完整的异常处理机制
- 支持流式请求和响应

在构建基于 HTTP 的 SDK 时，通常会基于`requests`进行二次封装，添加认证、重试、日志等功能，同时保持`requests`的核心优势。
```python
import requests
import logging
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class APIClient:
    def __init__(self, base_url, api_key=None, timeout=10, max_retries=3):
        self.base_url = base_url
        self.api_key = api_key
        self.timeout = timeout
        
        # 创建会话并配置重试策略
        self.session = requests.Session()
        retry_strategy = Retry(
            total=max_retries,
            backoff_factor=1,
            status_forcelist=[429, 500, 502, 503, 504],
            allowed_methods=["HEAD", "GET", "OPTIONS"]
        )
        adapter = HTTPAdapter(max_retries=retry_strategy)
        self.session.mount("http://", adapter)
        self.session.mount("https://", adapter)
        
        # 设置默认请求头
        self.session.headers.update({
            'Content-Type': 'application/json',
            'User-Agent': 'CustomAPIClient/1.0'
        })
        
        if api_key:
            self.session.headers.update({'Authorization': f'Bearer {api_key}'})
    
    def get(self, endpoint, params=None):
        """发送GET请求"""
        url = f"{self.base_url}/{endpoint}"
        logger.info(f"GET请求: {url}, 参数: {params}")
        
        try:
            response = self.session.get(url, params=params, timeout=self.timeout)
            response.raise_for_status()  # 抛出异常如果状态码不是200
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"请求失败: {e}")
            raise
    
    def post(self, endpoint, data=None, json=None):
        """发送POST请求"""
        url = f"{self.base_url}/{endpoint}"
        logger.info(f"POST请求: {url}, 数据: {json or data}")
        
        try:
            response = self.session.post(url, data=data, json=json, timeout=self.timeout)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"请求失败: {e}")
            raise
    
    def close(self):
        """关闭会话"""
        self.session.close()
        logger.info("会话已关闭")

# 使用示例
if __name__ == "__main__":
    client = APIClient(base_url="https://api.example.com/v1", api_key="your_api_key")
    
    try:
        # 获取数据
        data = client.get("users")
        print(f"获取到 {len(data)} 个用户")
        
        # 创建新用户
        new_user = client.post("users", json={"name": "John", "email": "john@example.com"})
        print(f"创建用户: {new_user}")
    finally:
        client.close()
```