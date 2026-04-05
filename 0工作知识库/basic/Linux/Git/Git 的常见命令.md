以下是 Git 的常见命令分类汇总，以及对应的常见报错和解决方案：

### **一、基础操作命令**

#### **仓库操作**

|命令|作用|示例|
|---|---|---|
|`git init`|初始化本地仓库|`git init myproject`|
|`git clone <url>`|克隆远程仓库|`git clone https://github.com/xxx.git`|
|`git remote -v`|查看远程仓库信息||
|`git remote add <name> <url>`|添加远程仓库|`git remote add origin https://...`|

#### **提交操作**

|命令|作用|示例|
|---|---|---|
|`git status`|查看工作区状态||
|`git add <file>`|将文件添加到暂存区|`git add README.md` 或 `git add .`|
|`git commit -m "msg"`|提交暂存区到本地仓库|`git commit -m "fix bug"`|
|`git diff`|查看工作区与暂存区差异||
|`git diff --staged`|查看暂存区与本地仓库差异||

#### **分支操作**

|命令|作用|示例|
|---|---|---|
|`git branch`|查看本地分支||
|`git branch <name>`|创建新分支|`git branch feature`|
|`git checkout <name>`|切换分支|`git checkout feature`|
|`git checkout -b <name>`|创建并切换分支|`git checkout -b feature`|
|`git merge <name>`|合并指定分支到当前分支|`git merge feature`|
|`git branch -d <name>`|删除分支|`git branch -d feature`|

#### **远程同步**

|命令|作用|示例|
|---|---|---|
|`git pull <remote> <branch>`|拉取远程分支并合并|`git pull origin main`|
|`git push <remote> <branch>`|推送本地分支到远程|`git push origin main`|
|`git fetch <remote>`|仅获取远程分支更新|`git fetch origin`|

### **二、常见报错及解决方案**

#### **1. 认证失败（HTTPS）**

- **错误信息**：  
    `remote: Invalid username or password.`  
    `fatal: Authentication failed for 'https://github.com/...'`
- **原因**：GitHub 密码错误或未配置凭据助手
- **解决方案**：
    
    ```bash
    # 配置Git保存密码（避免每次输入）
    git config --global credential.helper store
    
    # 若已配置SSH密钥，切换为SSH协议
    git remote set-url origin git@github.com:user/repo.git
    ```
    
      
    

#### **2. 权限不足（SSH）**

- **错误信息**：  
    `Permission denied (publickey).`  
    `fatal: Could not read from remote repository.`
- **原因**：SSH 密钥未添加到 GitHub 账户或权限错误
- **解决方案**：
    
    
    ```bash
    # 检查SSH密钥配置
    ssh -T git@github.com
    
    # 重新生成并添加SSH密钥
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```
    
      
    

#### **3. 连接被拒绝（SSH）**

- **错误信息**：  
    `kex_exchange_identification: Connection closed by remote host`  
    `Connection closed by 20.205.243.166 port 22`
- **原因**：防火墙阻止、网络代理或 GitHub 服务问题
- **解决方案**：
    
    bash
    
    ```bash
    # 测试网络连通性
    ping github.com
    nc -zv github.com 22
    
    # 使用备用SSH端口443
    git config --global sshProxy "ssh -p 443"
    ```
    
      
    

#### **4. 冲突合并（Merge Conflict）**

- **错误信息**：  
    `CONFLICT (content): Merge conflict in file.txt`  
    `Automatic merge failed; fix conflicts and then commit the result.`
- **原因**：多人修改同一文件导致冲突
- **解决方案**：
    1. 手动编辑冲突文件，删除冲突标记（`<<<<<<<`、`=======`、`>>>>>>>`）
    2. 标记冲突已解决：
        
        bash
        
        ```bash
        git add <conflicted-file>
        git commit -m "resolve merge conflict"
        ```
        
          
        

#### **5. 推送被拒绝（非快进更新）**

- **错误信息**：  
    `To https://github.com/user/repo.git`  
    `! [rejected] main -> main (non-fast-forward)`  
    `error: failed to push some refs to 'https://github.com/user/repo.git'`
- **原因**：远程仓库有新提交，本地分支落后
- **解决方案**：
    
    bash
    
    ```bash
    # 先拉取远程更新并合并
    git pull --rebase origin main
    
    # 再推送本地分支
    git push origin main
    ```
    
      
    

#### **6. 证书验证失败（HTTPS）**

- **错误信息**：  
    `SSL certificate problem: unable to get local issuer certificate`  
    `fatal: unable to access 'https://github.com/...'`
- **原因**：Git 无法验证 HTTPS 证书
- **解决方案**：
    
    bash
    
    ```bash
    # 临时忽略证书验证（不推荐）
    git config --global http.sslVerify false
    
    # 正确配置证书路径
    git config --global http.sslCAInfo "/path/to/cacert.pem"
    ```
    
      
    

### **三、其他常用命令**

|命令|作用|
|---|---|
|`git log`|查看提交历史|
|`git reset <file>`|撤销暂存区的文件|
|`git revert <commit>`|撤销指定提交|
|`git stash`|暂存当前工作区修改|
|`git stash pop`|恢复暂存的修改|
|`git tag <name>`|创建标签（用于发布版本）|
|`git config --list`|查看 Git 配置|

### **四、Git 配置命令**

|命令|作用|
|---|---|
|`git config --global user.name "Your Name"`|设置用户名|
|`git config --global user.email "you@example.com"`|设置邮箱|
|`git config --global core.editor "code --wait"`|设置编辑器（VS Code）|
|`git config --global alias.st status`|设置命令别名|

### **五、学习资源推荐**

- 官方文档：[Git Documentation](https://git-scm.com/doc)
- 交互式教程：[Git Immersion](https://gitimmersion.com/)
- 可视化指南：[Git Visualizer](https://git-school.github.io/visualizing-git/)

  

掌握这些命令和错误处理方法，基本可以应对日常开发中的 Git 使用需求。遇到复杂场景时，建议查阅官方文档或社区教程获取更详细的解决方案。


## 使用 SSH 协议替代 HTTPS 访问 GitHub 仓库
使用 SSH 协议替代 HTTPS 访问 GitHub 仓库，可避免 SSL 证书验证问题，同时提升安全性和访问效率。以下是详细步骤：

### **一、生成 SSH 密钥对**

#### **步骤 1：检查是否已有 SSH 密钥**

打开终端（Windows 使用 Git Bash，macOS/Linux 使用默认终端），输入：

  

bash

```bash
ls -al ~/.ssh
# 查看是否存在 id_rsa.pub 或 id_ed25519.pub 文件（公钥）
```

  

- **若存在**：跳过生成步骤，直接进入 **步骤 2**。
- **若不存在**：继续生成新密钥。

#### **步骤 2：生成新的 SSH 密钥**

推荐使用 **ED25519 算法**（更安全、更快）：

  

bash

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

  

- 提示 “Enter file in which to save the key” 时，直接按回车（默认保存到 `~/.ssh/id_ed25519`）。
- 提示 “Enter passphrase” 时，可留空（无密码）或设置密码（推荐设置，提升安全性）。

### **二、添加公钥到 GitHub 账户**

#### **步骤 1：复制公钥内容**

bash

```bash
# Linux/macOS
cat ~/.ssh/id_ed25519.pub

# Windows（Git Bash）
clip < ~/.ssh/id_ed25519.pub  # 复制到剪贴板
```

  

手动复制终端输出的公钥字符串（以 `ssh-ed25519` 开头）。

#### **步骤 2：登录 GitHub 并添加公钥**

1. 访问 GitHub 官网，登录账户。
2. 点击右上角头像，选择 **Settings** → **SSH and GPG keys** → **New SSH key**。
3. 在 **Title** 中填写标识（如 “Work Laptop”），将复制的公钥粘贴到 **Key** 文本框，点击 **Add SSH key**。

### **三、切换仓库 URL 为 SSH 协议**

#### **步骤 1：查看当前远程仓库 URL**

bash

```bash
git remote -v
# 输出示例（HTTPS 协议）：
# origin  https://github.com/w0odst0ck/408Notes.git (fetch)
# origin  https://github.com/w0odst0ck/408Notes.git (push)
```

#### **步骤 2：修改为 SSH 协议**

bash

```bash
git remote set-url origin git@github.com:w0odst0ck/408Notes.git
```

  

- 验证修改：再次执行 `git remote -v`，确保 URL 以 `git@github.com:` 开头。

### **四、测试 SSH 连接**

bash

```bash
ssh -T git@github.com
# 输出示例：
# Hi w0odst0ck! You've successfully authenticated, but GitHub does not provide shell access.
```

  

- 若提示 “Are you sure you want to continue connecting?”，输入 `yes` 并回车（首次连接需确认）。
- 若返回上述信息，说明 SSH 连接成功。

### **五、常见问题处理**

#### **1. 权限问题（Permission denied）**

- **原因**：公钥未正确添加或权限设置错误。
- **解决方法**：
    - 重新检查 GitHub 账户中的公钥是否正确粘贴。
    - 确保私钥文件权限正确（Windows 需设置 `.ssh` 文件夹权限为仅限当前用户访问）。

#### **2. 多账户管理**

若需管理多个 GitHub 账户（如个人 / 工作账户），可通过以下方式配置：

  

1. 为不同账户生成独立的 SSH 密钥（如 `id_ed25519_work` 和 `id_ed25519_personal`）。
2. 在 `~/.ssh/config` 文件中添加配置（若文件不存在需新建）：
    
    bash
    
    ```bash
    # 账户 1（个人）
    Host github.com-personal
      HostName github.com
      User git
      IdentityFile ~/.ssh/id_ed25519_personal
      IdentitiesOnly yes
    
    # 账户 2（工作）
    Host github.com-work
      HostName github.com
      User git
      IdentityFile ~/.ssh/id_ed25519_work
      IdentitiesOnly yes
    ```
    
      
    
3. 修改远程仓库 URL 为对应 Host：
    
    bash
    
    ```bash
    git remote set-url origin git@github.com-personal:w0odst0ck/408Notes.git
    ```
    
      
    

#### **3. 忘记私钥密码**

若生成密钥时设置了密码，每次推送需输入密码。可通过以下方式简化：

  

bash

```bash
# 启动 SSH 代理并添加私钥（仅需执行一次）
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### **六、优势总结**

- **免证书验证**：无需处理 SSL 证书路径或验证错误。
- **更高安全性**：SSH 密钥对比 HTTPS 密码更难破解，且支持二次验证（2FA）。
- **便捷性**：一次配置后，推送 / 拉取无需重复输入密码（配合 SSH 代理）。

  

完成上述步骤后，即可通过 SSH 协议正常使用 `git push`/`git pull` 等命令。如需切换回 HTTPS，只需将远程 URL 改回原格式即可。以下是使用 SSH 替代 HTTPS 连接 GitHub 的完整指南，包含详细步骤和注意事项：

### **一、检查 SSH 密钥是否存在**

1. 打开终端（Windows 用户建议使用 Git Bash）
2. 执行以下命令查看是否已有 SSH 密钥：
    
    bash
    
    ```bash
    ls -al ~/.ssh
    # 检查是否存在 id_rsa.pub 或 id_ed25519.pub 文件
    ```
    
      
    - 若存在 `id_rsa.pub` 或 `id_ed25519.pub`，说明已有 SSH 密钥，可直接跳到**步骤三**。
    - 若不存在，继续生成新密钥。

### **二、生成新的 SSH 密钥**

1. 执行以下命令生成 ED25519 类型的 SSH 密钥（推荐）：
    
    bash
    
    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"
    # 替换为你的 GitHub 邮箱地址
    ```
    
      
    
2. 按提示连续回车，使用默认文件路径和空密码：
    
    plaintext
    
    ```plaintext
    Enter file in which to save the key (/Users/you/.ssh/id_ed25519): [回车]
    Enter passphrase (empty for no passphrase): [回车]
    Enter same passphrase again: [回车]
    ```
    
      
    
3. 生成成功后，执行以下命令启动 SSH 代理：
    
    bash
    
    ```bash
    # macOS/Linux
    eval "$(ssh-agent -s)"
    
    # Windows (Git Bash)
    eval $(ssh-agent -s)
    ```
    
      
    
4. 将新生成的密钥添加到代理：
    
    bash
    
    ```bash
    ssh-add ~/.ssh/id_ed25519
    ```
    
      
    

### **三、将 SSH 公钥添加到 GitHub**

1. 复制公钥内容到剪贴板：
    
    bash
    
    ```bash
    # macOS/Linux
    pbcopy < ~/.ssh/id_ed25519.pub
    
    # Windows (Git Bash)
    clip < ~/.ssh/id_ed25519.pub
    ```
    
      
    
2. 登录 GitHub，访问：[Settings → SSH and GPG keys](https://github.com/settings/keys)
3. 点击 **New SSH key**，填写标题（如 `My Laptop`），粘贴刚才复制的公钥内容。
4. 点击 **Add SSH key**，输入 GitHub 密码确认。

### **四、验证 SSH 连接**

执行以下命令测试连接：

  

bash

```bash
ssh -T git@github.com
```

  

- 首次连接会提示确认指纹，输入 `yes` 继续：
    
    plaintext
    
    ```plaintext
    The authenticity of host 'github.com (140.82.114.4)' can't be established.
    RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    ```
    
      
    
- 若看到以下信息，说明连接成功：
    
    plaintext
    
    ```plaintext
    Hi username! You've successfully authenticated, but GitHub does not provide shell access.
    ```
    
      
    

### **五、将现有仓库的远程 URL 从 HTTPS 切换到 SSH**

1. 查看当前远程 URL：
    
    bash
    
    ```bash
    git remote -v
    # 输出示例：
    # origin  https://github.com/w0odst0ck/408Notes.git (fetch)
    # origin  https://github.com/w0odst0ck/408Notes.git (push)
    ```
    
      
    
2. 修改远程 URL 为 SSH 格式：
    
    bash
    
    ```bash
    git remote set-url origin git@github.com:w0odst0ck/408Notes.git
    ```
    
      
    
3. 验证修改结果：
    
    bash
    
    ```bash
    git remote -v
    # 应显示：
    # origin  git@github.com:w0odst0ck/408Notes.git (fetch)
    # origin  git@github.com:w0odst0ck/408Notes.git (push)
    ```
    
      
    

### **六、使用 SSH 克隆新仓库**

直接使用 SSH 格式克隆仓库，避免后续切换：

  

bash

```bash
git clone git@github.com:w0odst0ck/408Notes.git
```

### **七、常见问题解决**

1. **连接被拒绝**：
    
    - 检查 GitHub 账户是否已正确添加 SSH 公钥。
    - 确认公钥和私钥匹配（`id_ed25519` 和 `id_ed25519.pub`）。
2. **权限问题**：
    
    bash
    
    ```bash
    chmod 600 ~/.ssh/id_ed25519
    chmod 644 ~/.ssh/id_ed25519.pub
    ```
    
      
    
3. **防火墙 / 代理问题**：
    
    - 确保 22 端口未被防火墙阻止：
        
        bash
        
        ```bash
        ssh -vT git@github.com  # 查看详细连接日志
        ```
        
          
        
          
        
    - 若通过代理，需配置 SSH 代理（示例）：
        
        bash
        
        ```bash
        # 编辑 ~/.ssh/config
        Host github.com
          HostName github.com
          User git
          ProxyCommand nc -X 5 -x proxy.example.com:1080 %h %p
        ```
        
          
        
          
        

  

切换到 SSH 后，`git push/pull` 操作将不再需要每次输入 GitHub 密码，且避免了 HTTPS 的证书验证问题。如果遇到其他问题，请提供具体错误信息以便进一步排查。