# 🛠️ Chenhun's Dotfiles (macOS)

这是我的 macOS 配置仓库，使用 **软链接** 管理 `~/.config` 下的各类配置。

---

## 📦 使用方式

### 1️⃣ 克隆仓库（固定位置）

```bash
git clone <repo_url> ~/.myutils/dotfiles
```

> 建议使用该路径，脚本默认按此路径工作。

---

### 2️⃣ 一键部署配置

```bash
cd ~/.myutils/dotfiles
chmod +x setup.sh
./setup.sh
```

该脚本会为以下配置创建软链接：

- nvim
- aerospace
- sketchybar
- kitty
- …

---

## 🔄 更新配置

当仓库有更新时：

```bash
cd ~/.myutils/dotfiles
git pull
./setup.sh
```

ps:或者可以使用我setup.sh脚本的2选项。

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
└── ...
```

---

## ⚠️ 注意事项

- `setup.sh` 会在发现真实目录时先备份再创建软链接
- 敏感信息已通过 `.gitignore` 排除
