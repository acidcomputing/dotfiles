#!/usr/bin/env bash
# acidcomputing/dotfiles/install.sh
# :: a c i d c o m p u t i n g ::

set -euo pipefail

# --- colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- state ---
MINIMAL=false
DRY_RUN=false
INTERACTIVE=false

INSTALLED=()
SKIPPED=()
FAILED=()
BACKED_UP=()

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- banner ---
banner() 
{
  echo ""
  echo " ╔════════════════════════════════════════════════╗"
  echo " ║            a c i d c o m p u t i n g           ║"
  echo " ╚════════════════════════════════════════════════╝"
  echo " "
}

welcome() 
{
  echo "  W E L C O M E !"
  echo ""
  echo "  Welcome to acidcomputing's dotfiles installer."
  echo "  This script offers no warranties! Existing configs are backed up to .ORIG if found."
  echo "  NOTE: pacman config and motd require sudo."
  echo ""
}

# --- usage ---
usage() 
{
  echo "usage: ./install.sh [options]"
  echo ""
  echo "  --minimal        zsh only"
  echo "  --dry-run        show what would happen, commit nothing"
  echo "  --help, -h       print this menu and exit"
  echo ""
  echo "  no flags = interactive wizard"
  echo ""
}

# --- helpers ---
ask() 
{
  local prompt="$1"
  local reply
  printf "  %s [Y/n] " "$prompt"
  read -r reply
  case "$reply" in
  y | Y | yes | YES | "") return 0 ;;
  *) return 1 ;;
  esac
}

backup_if_exists() 
{
  local target="$1"

  if [[ -e "$target" ]]; then
    if [[ -e "${target}.ORIG" ]]; then
      echo -e "  ${YELLOW}warn${NC}  .ORIG already exists for $target, skipping backup..."
    else
      if [[ "$DRY_RUN" == true ]]; then
        echo -e "  ${YELLOW}dry${NC}   would backup $target → ${target}.ORIG"
      else
        mv "$target" "${target}.ORIG"
        BACKED_UP+=("${target}.ORIG")
        echo -e "  ${YELLOW}backup${NC} $target → ${target}.ORIG"
      fi
    fi
  fi
}

do_copy() 
{
  local src="$1"
  local dst="$2"
  local name="$3"

  if [[ "$DRY_RUN" == true ]]; then
    echo -e "  ${GREEN}dry${NC}   would copy $src → $dst"
    return
  fi

  mkdir -p "$(dirname "$dst")"
  backup_if_exists "$dst"
  cp "$src" "$dst"
  echo -e "  ${GREEN}copy${NC}  $src → $dst"
  INSTALLED+=("$name")
}

do_sudo_copy() 
{
  local src="$1"
  local dst="$2"
  local name="$3"

  if [[ "$DRY_RUN" == true ]]; then
    echo -e "  ${GREEN}dry${NC}   would sudo copy $src → $dst"
    return
  fi

  if ! sudo -n true 2>/dev/null && ! sudo -v 2>/dev/null; then
    echo -e "  ${RED}fail${NC}  sudo unavailable, skipping... $name"
    FAILED+=("$name (sudo unavailable)")
    return
  fi

  if sudo test -e "$dst" && ! sudo test -e "${dst}.ORIG"; then
    sudo mv "$dst" "${dst}.ORIG"
    BACKED_UP+=("${dst}.ORIG")
    echo -e "  ${YELLOW}backup${NC} $dst → ${dst}.ORIG"
  elif sudo test -e "${dst}.ORIG"; then
    echo -e "  ${YELLOW}warn${NC}  .ORIG already exists for $dst, skipping backup"
  fi

  sudo cp "$src" "$dst"
  echo -e "  ${GREEN}copy${NC}  $src → $dst (sudo)"
  INSTALLED+=("$name")
}

# --- install functions ---
install_zsh() {
  echo "  → zsh"
  do_copy "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc" "zshrc"
  do_copy "$DOTFILES_DIR/.aliases.zsh" "$HOME/.aliases.zsh" "aliases.zsh"
}

install_fastfetch() 
{
  echo "  → fastfetch"
  do_copy "$DOTFILES_DIR/.config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc" "fastfetch/config.jsonc"
  do_copy "$DOTFILES_DIR/.config/fastfetch/logo.txt" "$HOME/.config/fastfetch/logo.txt" "fastfetch/logo.txt"
}

install_kitty() 
{
  echo "  → kitty"
  do_copy "$DOTFILES_DIR/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf" "kitty/kitty.conf"
  do_copy "$DOTFILES_DIR/.config/kitty/current-theme.conf" "$HOME/.config/kitty/current-theme.conf" "kitty/current-theme.conf"
}

install_htop() 
{
  echo "  → htop"
  do_copy "$DOTFILES_DIR/.config/htop/htoprc" "$HOME/.config/htop/htoprc" "htop/htoprc"
}

install_pacman() 
{
  echo "  → pacman (sudo)"
  do_sudo_copy "$DOTFILES_DIR/etc/pacman.conf" "/etc/pacman.conf" "pacman.conf"
}

install_motd() 
{
  echo "  → motd (sudo)"
  do_sudo_copy "$DOTFILES_DIR/etc/motd" "/etc/motd" "motd"
}

# --- summary ---
summary() 
{
  echo ""
  echo " ╔═════════════════════════════════╗"
  echo " ║             summary             ║"
  echo " ╚═════════════════════════════════╝"
  echo " "
  echo "  method: copy"
  [[ "$DRY_RUN" == true ]] && echo "  mode:   dry run: nothing written"
  echo ""

  if [[ ${#INSTALLED[@]} -gt 0 ]]; then
    echo -e "  ${GREEN}installed:${NC}"
    for item in "${INSTALLED[@]}"; do
      echo "    • $item"
    done
  fi

  if [[ ${#BACKED_UP[@]} -gt 0 ]]; then
    echo -e "  ${YELLOW}backed up:${NC}"
    for item in "${BACKED_UP[@]}"; do
      echo "    • $item"
    done
  fi

  if [[ ${#SKIPPED[@]} -gt 0 ]]; then
    echo -e "  ${YELLOW}skipped:${NC}"
    for item in "${SKIPPED[@]}"; do
      echo "    • $item"
    done
  fi

  if [[ ${#FAILED[@]} -gt 0 ]]; then
    echo -e "  ${RED}failed:${NC}"
    for item in "${FAILED[@]}"; do
      echo "    • $item"
    done
  fi

  echo ""
  echo "  make computing fun again!"
  echo ""
}

# --- wizard ---
wizard() 
{
  banner
  welcome

  ask "install zsh configs?" && install_zsh
  ask "install fastfetch configs?" && install_fastfetch
  ask "install kitty configs?" && install_kitty
  ask "install htop config?" && install_htop
  ask "install pacman.conf? (sudo required)" && install_pacman
  ask "install motd? (sudo required)" && install_motd

  summary
}

# --- parse args ---
if [[ $# -eq 0 ]]; then
  INTERACTIVE=true
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
  --minimal) MINIMAL=true ;;
  --dry-run) DRY_RUN=true ;;
  --help | -h)
    usage
    exit 0
    ;;
  *)
    echo "unknown flag: $1"
    usage
    exit 1
    ;;
  esac
  shift
done

# --- non-interactive ---
if [[ "$INTERACTIVE" == false ]]; then
  if [[ "$MINIMAL" == true ]]; then
    install_zsh
  else
    install_zsh
    install_fastfetch
    install_kitty
    install_htop
    install_pacman
    install_motd
  fi

  summary
  exit 0
fi

# --- interactive ---
wizard

