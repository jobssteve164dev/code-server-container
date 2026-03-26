# code-server 无损更新指南 (Lossless Update Guide)

为了确保你在更新 `code-server` 镜像时不会丢失已安装的工具（如 Gemini CLI）或配置信息，请遵循以下步骤。

## 1. 核心机制
- **环境持久化 (Dockerfile)**: `Dockerfile` 负责安装 Python、Node.js 和 Gemini CLI。每次更新时通过 `build` 操作重新生成这些环境。
- **数据持久化 (Volumes)**: `docker-compose.yml` 中的 `volumes` 确保了你的代码、配置（config.yaml）、扩展和 Codex Token 存储在宿主机上，不会随容器重置而丢失。

## 2. 更新步骤

当你想要升级 `code-server` 版本时，请在 `/home/ubuntu/ai_test/code-server-container/` 目录下执行：

```bash
# 1. 拉取最新的基础镜像
sudo docker compose pull

# 2. 重新构建自定义镜像 (这会根据 Dockerfile 重新安装 Gemini CLI 等工具)
sudo docker compose build

# 3. 重新启动容器
sudo docker compose up -d
```

## 3. 常见问题 (FAQ)

### 如何修改登录密码？
由于我们删除了 `docker-compose.yml` 中的密码环境变量，系统会自动读取：
`/home/ubuntu/.config/code-server/config.yaml`
直接修改该文件中的 `password` 字段并重启容器即可。

### 如何添加新工具？
如果你想在容器中永久添加新软件（例如 `golang`）：
1. 修改目录下的 `Dockerfile`，在 `apt-get install` 列表里添加 `golang`。
2. 执行 `sudo docker compose up -d --build` 即可生效。

### 为什么提示 "gemini: command not found"？
如果你刚完成更新并打开了终端，请运行 `hash -r` 刷新路径缓存，或者新开一个终端窗口。

---
**提示**：建议将此目录提交到 Git 进行版本管理，以便随时找回你的自定义环境配置。
