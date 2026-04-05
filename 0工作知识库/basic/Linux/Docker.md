以下是常用的Docker命令：

1. 基本操作命令：
```bash
# 查看所有容器（包括未运行的）
docker ps -a

# 查看正在运行的容器
docker ps

# 查看所有镜像
docker images

# 启动容器
docker start 容器ID或名称

# 停止容器
docker stop 容器ID或名称

# 重启容器
docker restart 容器ID或名称
```

2. 容器管理命令：
```bash
# 进入容器终端
docker exec -it 容器ID或名称 bash

# 查看容器日志
docker logs 容器ID或名称

# 实时查看日志
docker logs -f 容器ID或名称

# 删除容器（需要先停止）
docker rm 容器ID或名称

# 强制删除容器（即使在运行）
docker rm -f 容器ID或名称
```

3. 镜像管理命令：
```bash
# 拉取镜像
docker pull 镜像名称:标签

# 删除镜像
docker rmi 镜像ID或名称

# 构建镜像
docker build -t 镜像名称:标签 .
```

4. Docker Compose命令：
```bash
# 启动所有服务
docker-compose up

# 后台启动所有服务
docker-compose up -d

# 停止所有服务
docker-compose down

# 查看服务状态
docker-compose ps

# 查看服务日志
docker-compose logs
```

5. 系统信息命令：
```bash
# 查看Docker系统信息
docker info

# 查看Docker版本
docker version

# 查看容器资源使用情况
docker stats
```

6. 网络和数据卷命令：
```bash
# 查看网络列表
docker network ls

# 查看数据卷列表
docker volume ls

# 创建网络
docker network create 网络名称

# 创建数据卷
docker volume create 数据卷名称
```

注意事项：
1. 使用容器ID时，可以只使用前几位，只要能唯一标识即可
2. 建议给容器指定名称，方便管理
3. 使用`-d`参数可以让容器在后台运行
4. 使用`--rm`参数可以在容器停止后自动删除

---
## 在Docker容器中访问MySQL数据库
要在Docker容器中访问MySQL数据库，您可以使用以下方法：

1. 进入MySQL容器：
```bash
docker exec -it mysql容器ID bash
```

2. 然后在容器内连接MySQL：
```bash
mysql -u root -p
```

3. 或者直接一步到位：
```bash
docker exec -it mysql容器ID mysql -u root -p
```

要查看MySQL容器ID，可以使用：
```bash
docker ps
```

常用的MySQL命令：
```sql
-- 查看所有数据库
SHOW DATABASES;

-- 使用特定数据库
USE 数据库名;

-- 查看所有表
SHOW TABLES;

-- 查看表结构
DESC qj_schools;

-- 查询数据
SELECT * FROM qj_schools LIMIT 5;

-- 按省份分组统计
SELECT province, COUNT(*) as count FROM qj_schools GROUP BY province;
```

注意：
1. 需要确保Docker服务正在运行
2. 需要有适当的数据库访问权限
3. 如果遇到中文显示问题，可以在进入MySQL后执行：
```sql
SET NAMES utf8mb4;
```
        