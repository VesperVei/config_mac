# Chenhun's Dotfiles (macOS)

这是我的 macOS 配置仓库，使用 **软链接** 管理 `~/.config` 下的各类配置。

---

## 📦 使用方式

### 1. 克隆仓库（固定位置）

```bash
git clone https://github.com/VesperVei/config_mac.git ~/.myutils/dotfiles
```

建议使用该路径，后续命令都以这个目录为例。

---

### 2. 进入仓库并确认配置

```bash
cd ~/.myutils/dotfiles
chmod +x setup.sh
```

执行安装前，建议先检查并按需修改仓库内的配置文件，避免直接覆盖到自己的 `~/.config` 使用习惯。

确认后再运行：

```bash
./setup.sh
```

该脚本会为以下配置创建软链接：

- nvim
- aerospace
- sketchybar
- kitty
- tmux
- yazi

运行脚本后，界面顶部会显示“本次配置清单”，仓库中不存在的配置目录会自动跳过。

---

## 🔄 更新配置

当仓库有更新时：

```bash
cd ~/.myutils/dotfiles
git pull
./setup.sh
```

> 重复执行是安全的。

---

## 📂 目录结构

```text
dotfiles/
├── setup.sh
├── nvim/
├── aerospace/
├── sketchybar/
├── kitty/
├── tmux/
├── yazi/
└── extras/
```

---

## ⚠️ 注意事项

- `setup.sh` 会在发现真实目录时先备份再创建软链接
- `setup.sh` 会自动创建 `~/.config`，避免首次安装时报目录不存在
- 仓库中不存在的配置目录会自动跳过
- 敏感信息已通过 `.gitignore` 排除
