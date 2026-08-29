add_to_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$PATH:$1"
  fi
}

add_to_lua_path() {
  if [[ ";$LUA_PATH;" != *";$1;"* ]]; then
    LUA_PATH="$LUA_PATH;$1"
  fi
}

add_to_path "$HOME/.local/bin"
add_to_path "$HOME/google-cloud-sdk/bin"
add_to_path "$HOME/.config/composer/vendor/bin"        # Makes composer/PHP installed plugins available
add_to_path "$HOME/.local/share/nvim/mason/bin"        # Makes mason installed plugins available
add_to_path "$HOME/.cargo/bin"                         # Makes cargo installed packages available
add_to_path "$HOME/.luarocks/bin"                      # Makes lua installed packages available
add_to_path "/usr/local/texlive/2025/bin/x86_64-linux" # TeX Live
add_to_path "/opt/openresty/bin"
command -v go >/dev/null && add_to_path "$(go env GOPATH)/bin"

add_to_lua_path "$HOME/lua/?.lua"
add_to_lua_path "$HOME/httpreqs/?.lua"

# Environment variables
export EDITOR='nvim'
export LANG=en_US.UTF-8
export NVM_DIR="$HOME/.nvm"
export UTILS_CUSTOM_DOCS_DIR="$HOME/Documents $HOME/issues $HOME/misc"
export UTILS_PROJECTS_DIR="$HOME/workspace $HOME/projects $HOME/dotfiles $HOME/misc"
