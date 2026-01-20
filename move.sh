#!/bin/bash

# 1. 定义路径
SOURCE_DIR="$HOME/.config"
DEST_DIR="$HOME/.myutils/dotfiles"

# 2. 确保目标仓库文件夹存在
mkdir -p "$DEST_DIR"

# 3. 你想迁移的项目
configs=("nvim" "aerospace" "sketchybar" "kitty")
echo "📦 开始执行配置搬家..."
for config in "${configs[@]}"; do
    # 定义完整路径
    REAL_PATH="$SOURCE_DIR/$config"
    REPO_PATH="$DEST_DIR/$config"

    # --- 关键逻辑开始 ---

    # 检查 .config 里是不是真的有这个文件夹
    if [ -d "$REAL_PATH" ] && [ ! -L "$REAL_PATH" ]; then
        echo "📦 正在迁移 $config 到仓库..."
        
        # 第一步：把真实的文件夹移动到仓库
        mv "$REAL_PATH" "$DEST_DIR/"
        
        # 第二步：建立软链接，把位置还给系统
        ln -s "$REPO_PATH" "$REAL_PATH"
        
        echo "✅ $config 迁移完成并已建立链接"
    else
        echo "⏭️ $config 不存在或已经是链接，跳过"
    fi
done
