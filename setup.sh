#!/bin/bash
# 1. 定义路径
DOTFILES_DIR="$HOME/.myutils/dotfiles"
configs=("nvim" "aerospace" "sketchybar" "kitty")

# 创建一个备份文件夹，以防万一
BACKUP_DIR="$HOME/.config/config_backup_$(date +%Y%m%d_%H%M%S)"
echo "🚀 开始自动化部署配置链接..."
for config in "${configs[@]}"; do
  TARGET="$HOME/.config/$config"

  # 1. 判断目标路径是否存在
  if [ -e "$TARGET" ]; then
    # 2. 如果存在，且它【不是】一个软链接（说明它是真实的本地文件夹）
    if [ ! -L "$TARGET" ]; then
      echo "⚠️ 发现已存在的本地配置: $config，正在备份到 $BACKUP_DIR"
      mkdir -p "$BACKUP_DIR"
      mv "$TARGET" "$BACKUP_DIR/"
    fi
  fi
  
  # 3. 创建软连接（强制覆盖！危险操作）
  ln -sf "$DOTFILES_DIR/$config" "$TARGET"
  echo "🔗 已链接 $config -> $HOME/.config/$config"
done
echo "✨ 部署完成！"
