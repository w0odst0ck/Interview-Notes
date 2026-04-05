data_labeling/ 
├── all_pkgs.txt 
├── docker-compose.yaml 
├── out.jsonl 
├── .gitignore 
├── data.jsonl 
├── data_final.jsonl 
├── requirements.txt 
├── test.py 
├── test.db 
├── runner.py 
├── streamlit.png 
├── pages/ 
	│ ├── dashboard.py 
	│ ├── prompt_list.py 
	│ ├── dataset_list.py 
	│ ├── datapoint_list.py 
	│ ├── label_manage.py 
	│ ├── data_generate.py 
	│ ├── story_gallery.py 
	│ ├── role_permission.py 
	│ ├── user.py 
	│ ├── login.py 
	│ └── setting_page.py 
├── docker/ 
├── .git/ 
├── configs/ 
├── common/ 
	│ ├── Paginator.py 
	│ ├── AuthUtils.py 
	│ ├── DataGenerate.py 
	│ └── ParsePDF.py 
├── utils/ 
	│ ├── badwords_loader.py
	│ ├── badwords_checker.py
	│ └── convert_to_concise.py 
├── image/ 
├── models/ 
	│ ├── $__init__.py$ 
	│ └── user_model.py
├── output/ 
├── badwords/ 
└── components/ 
	└── data_table.py
## pages
`pages` 目录在项目中承担着构建应用程序各个页面功能的核心作用，它包含了多个 `.py` 文件，每个文件对应着一个特定的页面或功能模块。这些页面涵盖了从用户登录、数据管理到角色和用户管理等多个方面，共同构成了整个数据标注平台的用户界面和功能逻辑。以下是对 `pages` 目录下各文件作用的详细分析： 
### 1. 登录与认证相关 
- **`login.py`** 
	- 提供用户登录和登出功能。 
	- 验证用户输入的用户名和密码，通过计算密码的 MD5 哈希值与数据库中存储的密码进行比对。 
	- 使用 `streamlit_cookies_controller` 管理用户的登录状态和信息，将登录状态和用户信息存储在 `cookies` 中。 
	- 若用户已登录，显示欢迎信息和登出按钮；若未登录，显示登录表单。 
- ### 2. 数据管理相关 
- **`dataset_list.py`** 
	- 展示数据集列表，支持按照数据集名称进行筛选。 
	- 提供创建、编辑和删除数据集的功能，用户可以设置数据集的名称、描述、类型和字段信息。 
	- 支持将数据集与 `prompt` 模板绑定，并可以将数据集导出为 `jsonl` 文件。 
	- 提供下载和预览数据集的功能。 
- **`datapoint_list.py`** 
	- 展示数据点列表，支持分页浏览和按照数据集、数据内容进行筛选。 
	- 提供创建、编辑和删除数据点的功能，用户可以设置数据点的内容、审核状态和标注状态。 
	- 支持批量导入数据文件，将文件中的数据转换为数据点。 
	- 提供预览数据点的功能。 
- **`data_generate.py`** 
	- 提供数据生成的功能，并记录数据生成的历史记录。 
	- 支持对历史记录进行筛选和排序，方便用户查找所需的数据。 
	- 支持将筛选后的数据下载为 `csv`、`json` 或 `excel` 文件。 
- ### 3. 模板与标签管理相关 
- **`prompt_list.py`** 
	- 展示 `prompt` 模板列表，支持按照模板名称进行筛选。 
	- 提供创建、编辑和删除 `prompt` 模板的功能，用户可以设置模板的名称、描述、类型和字段信息。 
	- 支持预览 `prompt` 模板的详细信息。 
- **`label_manage.py`**
	- 展示标签库管理页面，提供对标签的管理功能，可能包括创建、编辑和删除标签等操作。 
- ### 4. 场景与角色管理相关 
- **`story_gallery.py`** 
	- 展示故事场景库页面，提供对故事场景的管理功能，可能包括创建、编辑和删除故事场景等操作。 
- **`role_permission.py`** 
	- 展示角色管理页面，提供对角色的管理功能，包括创建、编辑和删除角色。 
	- 用户可以设置角色的名称、代码、等级和权限，权限包括审核权限、标注权限和只读权限。 
- **`user.py`** 
	- 展示用户管理页面，提供对用户的管理功能，包括创建、编辑和删除用户。 
	- 用户可以设置用户的登录名、密码、描述和角色。 
- ### 5. 其他页面 
- **`dashboard.py`** 
	- 作为数据标注平台的导航页，展示平台的欢迎信息和核心功能介绍。 
	- 显示数据标注的总体流程图片，帮助用户了解平台的使用方法。 
- **`t.py`** 
	- 该文件的功能不太明确，从代码来看，它将一个字典对象转换为 JSON 字符串并写入 `out.jsonl` 文件中，可能是用于测试或数据处理的临时脚本。 
## common
`common` 目录在项目中通常用于存放一些通用的、可复用的模块和工具，这些功能在项目的多个地方都会被使用到。下面是对 `data_labeling/common` 目录下各文件及功能的详细分析： 
### 1. `AuthUtils.py` 
- **功能**：主要负责用户认证和页面头部显示相关的功能。 
- **认证检查**：通过 `CookieController` 检查用户的登录状态和会话超时时间，确保用户的登录信息安全。 
- **页面头部显示**：定义了 `PageHeader` 类，用于显示页面的头部布局，包括页面标题和用户信息。 
### 2. `DataGenerate.py` 
- **功能**：提供数据处理和生成的功能，主要与调用 API 获取数据并处理相关。 
- **API 请求**：使用 `AzureOpenAI` 客户端向 API 发送请求，获取响应数据。 
- **数据处理**：处理原始文本，将其转换为结构化的数据，便于后续使用。 
- **数据存储**：将处理后的数据保存到 JSON 文件中，并处理数据去重的问题。 
### 3. `convert_pdf_single.py` 和 `convert_pdf_batch.py` 
- **功能**：用于处理 PDF 文件的转换。 
- **批量处理**：`convert_pdf_batch.py` 可以批量处理指定目录下的所有 PDF 文件，将每个 PDF 文件转换为一系列 PNG 图片，并保存到对应的新目录中。 
- **单个处理**：`convert_pdf_single.py` 可能用于处理单个 PDF 文件的转换（虽然代码中未提供，但从命名可以推测）。 
### 4. `ParsePDF.py` 
- **功能**：从 PDF 文件中提取文本信息。可能在需要对 PDF 内容进行分析或处理时使用，例如在数据标注过程中，如果 PDF 文件包含需要标注的数据，就可以使用该模块提取文本。 
### 5. `Paginator.py` 
- **功能**：实现了一个分页器组件，用于在页面上对数据进行分页显示。 
- **分页控制**：提供了上一页、下一页、跳转到指定页等功能。 
- **行数选择**：允许用户选择每页显示的行数。 
- **状态管理**：使用 `st.session_state` 管理分页器的状态，确保在页面刷新或操作后状态保持一致。 
## utils
`utils` 目录在项目中通常用于存放通用的工具函数和辅助模块，这些工具和函数可以被项目中的其他模块复用，以提高代码的可维护性和复用性。以下是 `data_labeling/utils` 目录下各文件的详细作用： 
### 1. `badwords_loader.py` 
- **功能**：负责从指定目录加载敏感词列表，并将其存储在内存中。 
- **代码分析**： 
	- 该文件使用 `@st.cache_data` 装饰器，确保敏感词列表只被加载一次，提高性能。 
	- 它会检查指定目录是否存在，如果不存在则记录错误日志并返回空列表。 
	- 遍历目录中的所有文件，读取每个文件的内容，去除多余的空格和换行符，并将非空的敏感词添加到列表中。 
	- 最后记录成功加载的敏感词数量并返回列表。 
### 2. `badwords_checker.py` 
- **功能**：用于检查文本中是否包含敏感词，并标记出敏感词的位置。 
- **代码分析**： 
	- `find_all_indexes` 函数用于查找主字符串中所有子字符串的起始索引。 
	- `badwords_check` 函数遍历敏感词列表，查找文本中是否包含敏感词。如果找到敏感词，记录其位置和内容，并将敏感词标记为红色背景。如果未找到敏感词，标记为绿色背景表示无敏感词。 
### 3. `convert_to_concise.py` 
- **功能**：从提供的代码片段中无法明确该文件的具体功能，但从命名推测，它可能用于将数据转换为简洁的格式。 
## models
`models` 目录在项目中主要用于定义和管理数据库相关的模型，通过 SQLAlchemy 库来实现数据库表结构和操作的抽象。以下是对 `data_labeling/models` 目录及其文件的详细分析： 
### 1. `__init__.py` 文件 
此文件是 Python 包的初始化文件，它包含了数据库连接配置、数据模型定义以及会话管理等重要功能，是整个 `models` 模块的核心文件。 
#### 数据库连接配置 
```python 
DATABASE_URL = "mysql+pymysql://dw_dataworks:He4lndcj#9se@rm-bp11445x25066wgb3qo.mysql.rds.aliyuncs.com:6033/data_labeling_test" 
engine = create_engine( 
DATABASE_URL, 
pool_size=10, 
max_overflow=30, 
pool_recycle=5400, 
pool_pre_ping=True, 
pool_timeout=30, 
echo=True 
) 
``` 
- **功能**：配置数据库连接信息，使用 SQLAlchemy 的 `create_engine` 函数创建数据库引擎，设置连接池大小、最大连接数、连接回收时间等参数，确保数据库连接的高效和稳定。 
#### 连接检查机制 
```python 
@event.listens_for(engine, "checkout") 
def check_connection(dbapi_connection, connection_record, connection_proxy): 
	try: 
		dbapi_connection.ping(reconnect=True) 
	except Exception: 
		raise Exception("数据库连接已失效") 
``` 
- **功能**：通过 SQLAlchemy 的事件监听机制，在每次从连接池获取连接时检查连接的有效性，如果连接失效则抛出异常。 
#### 会话管理 
```python 
LocalSession = scoped_session( 
	sessionmaker( 
		autocommit=False, 
		autoflush=False, 
		bind=engine 
	) 
) 
def get_db(): 
	db = None 
	try: 
		db = LocalSession() 
		return db 
	except Exception as e: 
		if db: 
			db.rollback() 
		raise 
``` 
- **功能**：使用 `scoped_session` 创建线程安全的会话对象，通过 `get_db` 函数获取数据库会话，确保会话的正确使用和异常处理。 
#### 数据模型定义 
```python 
class DataSet(Base):
    __tablename__ = "dataset"
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255))  # 添加长度限制
    desc = Column(String(1024))  # 描述字段可以设置更大一些
    type = Column(String(255))
    dataset_size = Column(Integer)
    meta = Column(String(1024))
    datapoints = relationship("DataPoint", back_populates="dataset")
    prompt_template = relationship("PromptTemplate", back_populates="datasets")
    prompt_template_id = Column(Integer, ForeignKey("prompt_template.id"))
    mapping = Column(String(1024))
class DataPoint(Base):
    __tablename__ = "datapoint"
    id = Column(Integer, primary_key=True, autoincrement=True)
    content = Column(String(1024))
    audit_status = Column(Integer, default=0)
    label_status = Column(Integer, default=0)
    dataset = relationship("DataSet", back_populates="datapoints")
    dataset_id = Column(Integer, ForeignKey("dataset.id"))
    create_time = Column(DateTime, default=datetime.now)
    labeled_time = Column(DateTime)
    last_audited_by = relationship("User", foreign_keys="[DataPoint.last_audited_by_id]", back_populates="audited_datapoints")
    last_audited_by_id = Column(Integer, ForeignKey("user.id"))
    last_labeled_by = relationship("User", foreign_keys="[DataPoint.last_labeled_by_id]", back_populates="labeled_datapoints")
    last_labeled_by_id = Column(Integer, ForeignKey("user.id"))
``` 
- **功能**：定义了多个数据库表对应的模型类，如 `DataSet`、`DataPoint`、`GenHistory`、`PromptTemplate`、`User`、`Role` 和 `Permission` 等。每个模型类对应一个数据库表，通过 SQLAlchemy 的 `Column` 类定义表的字段，使用 `relationship` 定义表之间的关联关系。 
### 2. `test.db` 文件 
- **功能**：这可能是一个用于测试的 SQLite 数据库文件。在开发和测试过程中，可以使用 SQLite 数据库进行快速验证和调试，避免对生产数据库造成影响。 
### 3. `user_model` 文件 
`user_model.py` 文件的主要功能是定义和管理用户及其地址的数据模型，并提供与这些模型交互的逻辑。以下是文件中各个部分的功能详细说明： 
#### 1. 导入库 
```python 
from typing import List 
from pydantic_sqlalchemy import sqlalchemy_to_pydantic 
from sqlalchemy import Column, ForeignKey, Integer, String, create_engine 
from sqlalchemy.ext.declarative import declarative_base 
from sqlalchemy.orm import Session, relationship, sessionmaker 
``` 
- **导入必要的库**: 
- `typing.List`: 用于类型注解。 
- `pydantic_sqlalchemy.sqlalchemy_to_pydantic`: 用于将 SQLAlchemy 模型转换为 Pydantic 模型。 
- `sqlalchemy` 相关模块: 用于定义数据库模型和会话管理。 
#### 2. 数据库连接配置
```python 
Base = declarative_base() 
engine = create_engine("sqlite:///test.db?check_same_thread=False", echo=True) 
``` 
- **Base**: 使用 `declarative_base` 创建一个基类，所有数据模型都继承自这个基类。 - **engine**: 使用 `create_engine` 创建一个 SQLite 数据库引擎，配置为 `test.db`，并设置 `check_same_thread=False` 以允许多线程访问。 
#### 3. 数据模型定义 
```python 
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    name = Column(String)
    fullname = Column(String)
    nickname = Column(String)
    addresses = relationship(
        "Address", back_populates="user", cascade="all, delete, delete-orphan"
    )
class Address(Base):
    __tablename__ = "addresses"
    id = Column(Integer, primary_key=True)
    email_address = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"))
    user = relationship("User", back_populates="addresses")
``` 
- **User**: 定义了 `users` 表的结构，包括字段 `id`、`name`、`fullname`、`nickname`，以及与 `Address` 表的一对多关系。 
- **Address**: 定义了 `addresses` 表的结构，包括字段 `id`、`email_address`、`user_id`，以及与 `User` 表的多对一关系。 
#### 4. Pydantic 模型定义 
```python 
PydanticUser = sqlalchemy_to_pydantic(User)
PydanticAddress = sqlalchemy_to_pydantic(Address)
class PydanticUserWithAddresses(PydanticUser):
    addresses: List[PydanticAddress] = []
``` 
- **PydanticUser**: 使用 `sqlalchemy_to_pydantic` 将 `User` 模型转换为 Pydantic 模型，用于数据验证和序列化。
- **PydanticAddress**: 使用 `sqlalchemy_to_pydantic` 将 `Address` 模型转换为 Pydantic 模型，用于数据验证和序列化。 
- **PydanticUserWithAddresses**: 继承自 `PydanticUser`，并添加了一个 `addresses` 字段，用于包含用户的地址列表。 
#### 5. 数据库表创建 
```python 
Base.metadata.create_all(engine) 
``` 
- **创建所有定义的数据表结构**。 
#### 6. 会话管理 
```python 
LocalSession = sessionmaker(bind=engine) 
db: Session = LocalSession() 
``` 
- **LocalSession**: 使用 `sessionmaker` 创建一个会话工厂。 
- **db**: 创建一个全局数据库会话实例。 
#### 7. 数据插入 
```python 
ed_user = User(name="ed", fullname="Ed Jones", nickname="edsnickname")
address = Address(email_address="ed@example.com")
address2 = Address(email_address="eddy@example.com")
ed_user.addresses = [address, address2]
db.add(ed_user)
db.commit()
``` 
- **创建一个 `User` 实例 `ed_user`，并添加两个 `Address` 实例**。 
- **将 `User` 实例添加到数据库会话中，并提交会话以保存数据**。 
#### 8. 测试函数 
```python 
def test_pydantic_sqlalchemy():
    user = db.query(User).first()
    pydantic_user = PydanticUser.from_orm(user)
    data = pydantic_user.dict()
    assert data == {
        "fullname": "Ed Jones",
        "id": 1,
        "name": "ed",
        "nickname": "edsnickname",
    }
    pydantic_user_with_addresses = PydanticUserWithAddresses.from_orm(user)
    data = pydantic_user_with_addresses.dict()
    assert data == {
        "fullname": "Ed Jones",
        "id": 1,
        "name": "ed",
        "nickname": "edsnickname",
        "addresses": [
            {"email_address": "ed@example.com", "id": 1, "user_id": 1},
            {"email_address": "eddy@example.com", "id": 2, "user_id": 1},
        ],
    }
``` 
- **测试 Pydantic 模型是否能正确地从 SQLAlchemy 模型转换为字典，并验证数据的正确性**。 
- **使用 `assert` 语句验证转换后的数据是否符合预期**。 
#### 9. 主程序 
```python 
if __name__ == "__main__": 
	test_pydantic_sqlalchemy() 
	print("ok") 
``` 
- **在脚本直接运行时，执行 `test_pydantic_sqlalchemy` 函数并打印“ok”**。 
## components
`components` 目录在项目里通常用于存放可复用的组件代码，这些组件能够在项目的不同页面或者模块中使用，有助于提高代码的复用性和可维护性。在当前的项目中，`components` 目录下仅存在一个文件 `data_table.py`，下面来详细分析其作用。
### 1. `data_table.py` 文件的作用
`data_table.py` 文件定义了一个名为 `render_data_table` 的函数，该函数的主要功能是使用 Streamlit 渲染数据表格，并且支持动态列。以下是该函数的详细分析：
#### 功能概述
- **渲染表头**：依据表格配置字典 `table_config` 中的列宽和子列信息，对表头进行渲染。支持普通列标题和包含子标题的列，子标题可以是 Markdown 格式或者按钮。
- **渲染数据行**：遍历当前页的数据列表 `data_page`，根据表格配置字典渲染每一行的数据。支持普通数据列和包含子内容或操作列的情况，操作列可以包含按钮，并且支持动态生成按钮参数。
- **样式处理**：在第一列添加左边框，并且在表头和数据行之间、数据行之间添加分隔线。
