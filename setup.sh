#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS=("nvim" "aerospace" "sketchybar" "kitty" "tmux" "yazi")
BACKUP_DIR="$HOME/.config/config_backup_$(date +%Y%m%d_%H%M%S)"

print_config_list() {
  echo "本次配置清单："
  for config in "${CONFIGS[@]}"; do
    SOURCE="$DOTFILES_DIR/$config"
    if [ -e "$SOURCE" ]; then
      echo "  - $config"
    else
      echo "  - $config（仓库中不存在，将跳过）"
    fi
  done
  echo
}

print_menu() {
  print_config_list
  echo "=============================="
  echo " Dotfiles Setup"
  echo "=============================="
  echo "1) Install / Deploy (创建软链接)"
  echo "2) Uninstall (移除软链接)"
  echo "q) Quit"
  echo "=============================="
}

install_configs() {
  echo "🚀 开始部署 dotfiles..."
  mkdir -p "$HOME/.config"

  for config in "${CONFIGS[@]}"; do
    TARGET="$HOME/.config/$config"
    SOURCE="$DOTFILES_DIR/$config"

    if [ ! -e "$SOURCE" ]; then
      echo "⚠️ 跳过 $config（仓库中不存在）"
      continue
    fi

    # 已存在且是软链接
    if [ -L "$TARGET" ]; then
      LINK_TARGET="$(readlink "$TARGET")"
      if [ "$LINK_TARGET" = "$SOURCE" ]; then
        echo "✅ $config 已正确链接，跳过"
        continue
      else
        echo "⚠️ $config 是其他软链接，重新指向 dotfiles"
        rm "$TARGET"
      fi
    # 已存在但不是软链接
    elif [ -e "$TARGET" ]; then
      echo "⚠️ 发现本地配置 $config，已备份"
      mkdir -p "$BACKUP_DIR"
      mv "$TARGET" "$BACKUP_DIR/"
    fi

    ln -s "$SOURCE" "$TARGET"
    echo "🔗 已链接 $config -> $TARGET"
  done

  echo "✨ 安装完成"
}

uninstall_configs() {
  echo "🧹 开始卸载 dotfiles 软链接..."

  for config in "${CONFIGS[@]}"; do
    TARGET="$HOME/.config/$config"

    if [ -L "$TARGET" ]; then
      LINK_TARGET="$(readlink "$TARGET")"
      if [[ "$LINK_TARGET" == "$DOTFILES_DIR"* ]]; then
        rm "$TARGET"
        echo "❌ 已移除 $config 软链接"
      else
        echo "⚠️ 跳过 $config（非本 dotfiles 链接）"
      fi
    else
      echo "ℹ️ $config 未安装或不是软链接"
    fi
  done

  echo "✨ 卸载完成（dotfiles 本体未删除）"
}

while true; do
  print_menu
  read -rp "请选择操作 [1/2/q]: " choice

  case "$choice" in
    1)
      install_configs
      ;;
    2)
      uninstall_configs
      ;;
    q|Q)
      echo "👋 Bye"
      exit 0
      ;;
    *)
      echo "❌ 无效选项"
      ;;
  esac

  echo
done
