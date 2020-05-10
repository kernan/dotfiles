#!/usr/bin/env sh

set -e

readonly python3_ver="3.7.2"

stow() {
  command stow -t "$HOME" -v "$1"
}

version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

check_command() {
  local cmd="$1"
  local exec="$(which "$cmd" 2>/dev/null || true)"
  if [ -z "$exec" ]; then
    (>&2 echo -e "$cmd\t->")
    return 1
  else
    echo -e "$cmd\t-> $exec"
    return 0
  fi
}

guess_target() {
  if [ $(command -v pacman) ]; then
    # arch linux
    echo "cli gui"
  elif [ $(command -v yum) ]; then
    # centos/rhel/fedora - work
    echo "cli work"
  else
    # other
    echo "cli"
  fi
  # always check health
  echo "checkhealth"
}

install_brew() {
  if ! check_command brew >/dev/null 2>&1; then
    curl -sL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash -s
  else
    brew update
  fi
}

install_rustup() {
  if [ ! -e "${HOME}/.rustup" ] || [ ! -e "${HOME}/.cargo" ]; then
    curl -sL https://sh.rustup.rs | bash -s -- --no-modify-path -y
  else
    rustup update
  fi
}

setup_minpac() {
  # install minpac
  local minpac_dir="${HOME}/.config/nvim/pack/minpac/opt/minpac"
  if [ ! -e "$minpac_dir" ]; then
    mkdir -p "$minpac_dir"
    git clone "https://github.com/k-takata/minpac.git" "$minpac_dir"
  fi
}

setup_gpg_agent() {
  mkdir -p "${HOME}/.config/systemd/user"
  pushd "${HOME}/.config/systemd/user" >/dev/null
  cp -f /usr/share/doc/gnupg/examples/systemd-user/* .
  systemctl --user daemon-reload
  systemctl --user enable *.socket
  popd >/dev/null
}

readonly targets=${*:-$(guess_target)}

# don't clobber these directories
mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/.config"

for target in $targets; do
  case $target in
    checkhealth)
      # commands
      check_command brew   || true
      check_command cargo  || true
      check_command clangd || true # coc-clangd
      check_command ctags  || true # coc-fzf (uses for outline)
      check_command go     || true
      check_command gopls  || true # coc-go
      check_command fzf    || true
      check_command npm    || true
      check_command nvim   || true
      check_command pylint || true # coc-python (linter, uses mpls as server)
      check_command rg     || true
      check_command rls    || true # coc-rls
      check_command rustup || true
      check_command texlab || true # coc-texlab
      check_command tmux   || true
      ;;
    cli)
      stow cli
      setup_minpac
      ;;
    gui)
      stow gui
      setup_gpg_agent
      ;;
    install_brew)
      install_brew
      ;;
    install_rustup)
      install_rustup
      ;;
    work)
      stow work
      ;;
    *)
      (>&2 echo "Unknown target $target")
      exit 1
      ;;
  esac
done
