default:
  just --list

check-deps:
  #!/bin/bash
  dependencies=(zsh stow git tree fzf)
  missing_dependencies=($(for dep in "${dependencies[@]}"; do command -v "$dep" &> /dev/null || echo "$dep"; done))

  if [ ${#missing_dependencies[@]} -gt 0 ]; then
    echo "Dependencies not found: ${missing_dependencies[*]}"
    echo "Please install them with the appropriate package manager"
    exit 1
  fi

  [ ! $SHELL = "/usr/bin/zsh" ] && chsh -s $(which zsh)

load-time:
  #!/bin/bash
  time zsh -i -c exit

reinstall-plugins:
  rm -rf "$HOME/.local/share/zinit/plugins"
  exec zsh

lint:
  shfmt -ln zsh -d -i 2 .z*

check:
  find . -type f \( -name "*.zsh" -o -name ".zshrc" -o -name "_*" \) -exec zsh -n {} +

install: check-deps config

config:
  stow -t "{{home_dir()}}" .

unset-config:
  stow -D -t "{{home_dir()}}" .
