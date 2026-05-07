#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS=("nvim" "aerospace" "sketchybar" "kitty" "tmux" "yazi")
SELECTED=()
CURRENT_INDEX=0
MESSAGE=""

init_selected_configs() {
  SELECTED=()
  for config in "${CONFIGS[@]}"; do
    if [ -e "$DOTFILES_DIR/$config" ]; then
      SELECTED+=(1)
    else
      SELECTED+=(0)
    fi
  done
}

clear_screen() {
  if ! command -v tput >/dev/null 2>&1 || ! tput clear 2>/dev/null; then
    printf '\033c'
  fi
}

print_config_list() {
  echo "本次配置清单："
  echo "使用 ↑/↓ 或 j/k 移动，按空格选中/取消。"
  echo

  for i in "${!CONFIGS[@]}"; do
    config="${CONFIGS[$i]}"
    source="$DOTFILES_DIR/$config"
    cursor=" "
    marker=" "
    suffix=""

    if [ "$i" -eq "$CURRENT_INDEX" ]; then
      cursor=">"
    fi

    if [ ! -e "$source" ]; then
      marker="-"
      suffix="（仓库中不存在，无法选择）"
    elif [ "${SELECTED[$i]}" -eq 1 ]; then
      marker="x"
    fi

    printf "%s [%s] %s%s\n" "$cursor" "$marker" "$config" "$suffix"
  done
  echo
}

print_menu() {
  clear_screen
  echo "=============================="
  echo " Dotfiles Setup"
  echo "=============================="
  print_config_list
  echo "1) Install / Deploy selected (创建选中项软链接)"
  echo "2) Uninstall selected (移除选中项软链接)"
  echo "q) Quit"
  echo "=============================="

  if [ -n "$MESSAGE" ]; then
    echo "$MESSAGE"
    echo
  fi
}

move_cursor_up() {
  if [ "$CURRENT_INDEX" -le 0 ]; then
    CURRENT_INDEX=$((${#CONFIGS[@]} - 1))
  else
    CURRENT_INDEX=$((CURRENT_INDEX - 1))
  fi
}

move_cursor_down() {
  if [ "$CURRENT_INDEX" -ge $((${#CONFIGS[@]} - 1)) ]; then
    CURRENT_INDEX=0
  else
    CURRENT_INDEX=$((CURRENT_INDEX + 1))
  fi
}

toggle_current_config() {
  config="${CONFIGS[$CURRENT_INDEX]}"
  source="$DOTFILES_DIR/$config"

  if [ ! -e "$source" ]; then
    MESSAGE="⚠️ $config 在仓库中不存在，无法选择"
    return
  fi

  if [ "${SELECTED[$CURRENT_INDEX]}" -eq 1 ]; then
    SELECTED[$CURRENT_INDEX]=0
    MESSAGE="已取消选择 $config"
  else
    SELECTED[$CURRENT_INDEX]=1
    MESSAGE="已选择 $config"
  fi
}

has_selected_configs() {
  for selected in "${SELECTED[@]}"; do
    if [ "$selected" -eq 1 ]; then
      return 0
    fi
  done
  return 1
}

run_for_selected_configs() {
  action="$1"

  if ! has_selected_configs; then
    MESSAGE="⚠️ 未选择任何配置项"
    return 1
  fi

  for i in "${!CONFIGS[@]}"; do
    if [ "${SELECTED[$i]}" -eq 1 ]; then
      "$action" "${CONFIGS[$i]}"
    fi
  done
}

install_one_config() {
  config="$1"
  target="$HOME/.config/$config"
  source="$DOTFILES_DIR/$config"

  if [ ! -e "$source" ]; then
    echo "⚠️ 跳过 $config（仓库中不存在）"
    return
  fi

  if [ -L "$target" ]; then
    link_target="$(readlink "$target")"
    if [ "$link_target" = "$source" ]; then
      echo "✅ $config 已正确链接，跳过"
      return
    fi

    echo "⚠️ $config 是其他软链接，重新指向 dotfiles"
    rm "$target"
  elif [ -e "$target" ]; then
    backup_dir="$HOME/.config/config_backup_$(date +%Y%m%d_%H%M%S)"
    echo "⚠️ 发现本地配置 $config，已备份"
    mkdir -p "$backup_dir"
    mv "$target" "$backup_dir/"
  fi

  ln -s "$source" "$target"
  echo "🔗 已链接 $config -> $target"
}

install_configs() {
  clear_screen
  echo "🚀 开始部署选中的 dotfiles..."
  mkdir -p "$HOME/.config"

  if run_for_selected_configs install_one_config; then
    echo "✨ 安装完成"
  else
    echo "$MESSAGE"
  fi

  echo
  IFS= read -rsn1 -p "按任意键返回菜单..." _
  MESSAGE=""
}

uninstall_one_config() {
  config="$1"
  target="$HOME/.config/$config"

  if [ -L "$target" ]; then
    link_target="$(readlink "$target")"
    if [[ "$link_target" == "$DOTFILES_DIR"* ]]; then
      rm "$target"
      echo "❌ 已移除 $config 软链接"
    else
      echo "⚠️ 跳过 $config（非本 dotfiles 链接）"
    fi
  else
    echo "ℹ️ $config 未安装或不是软链接"
  fi
}

uninstall_configs() {
  clear_screen
  echo "🧹 开始卸载选中的 dotfiles 软链接..."

  if run_for_selected_configs uninstall_one_config; then
    echo "✨ 卸载完成（dotfiles 本体未删除）"
  else
    echo "$MESSAGE"
  fi

  echo
  IFS= read -rsn1 -p "按任意键返回菜单..." _
  MESSAGE=""
}

handle_key() {
  key="$1"

  case "$key" in
    "")
      ;;
    " ")
      toggle_current_config
      ;;
    j|J)
      move_cursor_down
      MESSAGE=""
      ;;
    k|K)
      move_cursor_up
      MESSAGE=""
      ;;
    1)
      install_configs
      ;;
    2)
      uninstall_configs
      ;;
    q|Q)
      clear_screen
      echo "👋 Bye"
      exit 0
      ;;
    $'\e')
      IFS= read -rsn2 -t 0.1 rest || true
      case "$rest" in
        "[A")
          move_cursor_up
          MESSAGE=""
          ;;
        "[B")
          move_cursor_down
          MESSAGE=""
          ;;
      esac
      ;;
    *)
      MESSAGE="❌ 无效按键：$key"
      ;;
  esac
}

init_selected_configs

while true; do
  print_menu
  IFS= read -rsn1 key
  handle_key "$key"
done
