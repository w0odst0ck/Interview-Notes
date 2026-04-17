
我按**你日常开发最常用的组合**整理好了：

MySQL + Kafka + Zookeeper + Redis + MinIO + Airflow + Superset

全部带**数据持久化、权限、端口、常用配置**，复制就能跑。

---

## 1. 先统一规范（必看）

- 所有数据存在 `./docker-data/` 下，重启不丢
- 统一网络：`data-net`
- 时区统一 `Asia/Shanghai`
- 账号密码统一简单好记（生产自行修改）

---

## 2. docker-compose.yml（完整版）

yaml

```
version: '3.8'

networks:
  data-net:
    driver: bridge

volumes:
  mysql-data:
  kafka-data:
  zk-data:
  redis-data:
  minio-data:
  airflow-data:
  superset-data:

services:
  # MySQL 数仓/业务库
  mysql:
    image: mysql:8.0
    container_name: mysql
    restart: always
    networks: [data-net]
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: data_center
      TZ: Asia/Shanghai
    command: --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4

  # Zookeeper (Kafka依赖)
  zookeeper:
    image: confluentinc/cp-zookeeper:7.4.0
    container_name: zookeeper
    restart: always
    networks: [data-net]
    ports:
      - "2181:2181"
    volumes:
      - zk-data:/var/lib/zookeeper/data
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
      TZ: Asia/Shanghai

  # Kafka 实时数据总线
  kafka:
    image: confluentinc/cp-kafka:7.4.0
    container_name: kafka
    restart: always
    networks: [data-net]
    ports:
      - "9092:9092"
    volumes:
      - kafka-data:/var/lib/kafka/data
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:29092,PLAINTEXT_HOST://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      TZ: Asia/Shanghai
    depends_on: [zookeeper]

  # Redis 缓存/维表/分布式锁
  redis:
    image: redis:7-alpine
    container_name: redis
    restart: always
    networks: [data-net]
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    command: redis-server --appendonly yes
    environment:
      TZ: Asia/Shanghai

  # MinIO 对象存储（替代HDFS/OSS做数据湖）
  minio:
    image: minio/minio
    container_name: minio
    restart: always
    networks: [data-net]
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio-data:/data
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
      TZ: Asia/Shanghai
    command: server /data --console-address ":9001"

  # Airflow 调度系统（ETL任务编排核心）
  airflow-webserver:
    image: apache/airflow:2.7.3
    container_name: airflow-web
    restart: always
    networks: [data-net]
    ports:
      - "8080:8080"
    volumes:
      - ./airflow/dags:/opt/airflow/dags
      - ./airflow/logs:/opt/airflow/logs
    environment:
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: mysql+mysqldb://root:root123@mysql:3306/airflow
      AIRFLOW__CORE__LOAD_EXAMPLES: 'false'
      AIRFLOW__WEBSERVER__EXPOSE_CONFIG: 'true'
      TZ: Asia/Shanghai
    depends_on: [mysql, airflow-init]

  airflow-scheduler:
    image: apache/airflow:2.7.3
    container_name: airflow-scheduler
    restart: always
    networks: [data-net]
    volumes:
      - ./airflow/dags:/opt/airflow/dags
      - ./airflow/logs:/opt/airflow/logs
    environment:
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: mysql+mysqldb://root:root123@mysql:3306/airflow
      TZ: Asia/Shanghai
    depends_on: [airflow-init]

  airflow-init:
    image: apache/airflow:2.7.3
    container_name: airflow-init
    networks: [data-net]
    entrypoint: /bin/bash
    command:
      - -c
      - |
        airflow db upgrade &&
        airflow users create --username admin --password admin123 --firstname Admin --lastname Admin --role Admin --email admin@example.com
    environment:
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: mysql+mysqldb://root:root123@mysql:3306/airflow
      TZ: Asia/Shanghai
    depends_on: [mysql]

  # Superset 数据可视化/BI
  superset:
    image: apache/superset
    container_name: superset
    restart: always
    networks: [data-net]
    ports:
      - "8088:8088"
    volumes:
      - superset-data:/app/superset_home
    environment:
      SUPERSET_SECRET_KEY: admin123
      TZ: Asia/Shanghai
```

---

## 3. 快速启动命令

bash

运行

```
# 启动所有服务（后台运行）
docker-compose up -d

# 查看运行状态
docker-compose ps

# 查看日志（比如看kafka）
docker-compose logs -f kafka

# 停止
docker-compose down

# 停止并删除数据（谨慎！）
docker-compose down -v
```

---

## 4. 访问入口

- MySQL：[localhost:3306](https://localhost:3306) / root:root123
- Kafka：[localhost:9092](https://localhost:9092)
- MinIO：[http://localhost:9001](http://localhost:9001) / minioadmin:minioadmin
- Airflow：[http://localhost:8080](http://localhost:8080) / admin:admin123
- Superset：[http://localhost:8088](http://localhost:8088)
- Redis：[localhost:6379](https://localhost:6379)

---

## 5. 数据中台 Docker 能力达标自测（你照着练就行）

1. 能一键拉起整套环境，无报错
2. 知道每个组件挂载了什么卷
3. 能在 Airflow 里写 Python ETL 脚本并跑通
4. 能把自己写的 Spark/Flink 任务打成镜像
5. 能排查：端口冲突、权限、时区、连接失败
6. 能看懂并修改 docker-compose 配置

达到这 6 条，**数据中台岗位 Docker 直接算精通**。

需要我再补：

- Spark / Flink / Hive 的镜像模板？
- 或者一个**ETL 任务 Dockerfile 示例**？