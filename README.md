# 🛠️ Chenhun's Dotfiles (macOS)

这是我的个人配置文件自动化管理库。基于 **“原子化存储，软链接映射”** 的逻辑构建，旨在实现配置的云端同步与多机秒级部署。

## 🌟 核心工具链

- **Window Manager:** AeroSpace (Tiling WM)
- **Status Bar:** Sketchybar (Shell Scripting)
- **Terminal:** Kitty & iTerm2
- **Code Editor:** Neovim (Optimized for Pwn & Python)
- **Misc:** Lazygit, 010 Editor, Clash

## 🚀 脚本说明

仓库内包含两个核心 Bash 脚本，用于处理配置的生命周期管理：

### 1. `move.sh` (首次迁移脚本)

**用途：** 将本地 `~/.config` 下的真实文件夹“搬家”到本仓库中，并在原位留下软链接。
**逻辑：** `Check Existing` -> `Move to Repo` -> `Create Symbol Link`。

```bash
chmod +x move.sh
./move.sh

```

### 2. `setup.sh` (环境部署脚本)

**用途：** 当你在新机器上 `git clone` 本库后，运行此脚本一键建立所有软链接。
**逻辑：** `Confirm Paths` -> `Force Symlink`。

```bash
chmod +x setup.sh
./setup.sh

```

## 📂 目录结构预览

```text
.
├── move.sh           # 初始化迁移工具
├── setup.sh          # 自动化部署工具
├── nvim/             # Neovim 模块化配置 (Lua)
├── aerospace/        # 窗口管理布局定义
├── sketchybar/       # 顶部状态栏动态脚本
└── ...

```

## ⚠️ 安全与隐私

- **敏感数据：** 代理订阅链接、API Key 等隐私信息已通过 `.gitignore` 过滤，严禁上传至公开仓库。
- **备份建议：** 脚本执行 `mv` 操作前请确保已对关键配置进行冷备份。
