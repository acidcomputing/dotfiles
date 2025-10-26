## A c i d  C o m p u t i n g ##########
# ~/.zshrc file for zsh interactive shells
# see /usr/share/doc/zsh/examples/zshrc for examples

# --- Shell Options ---
setopt autocd              # change directory just by typing its name
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form 'anything=expression'
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt extendedglob        # enable extended globbing 

# --- History ---
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_verify

# --- PATH ---
export PATH="$PATH:$HOME/.local/bin"
export PATH=$PATH:/usr/games

# --- Aliases ---
if [[ -f "$HOME/.aliases.zsh" ]]; then
  source "$HOME/.aliases.zsh"
fi

# --- LS Colors ---
alias ls='ls --color=auto'
eval "$(dircolors -b)"

# --- Zsh Tab Completion ---
autoload -Uz compinit
compinit

# Menu selection & colored completions
zstyle ':completion:*' rehash true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=1
zstyle ':completion:*:descriptions' format '%B%d%b'

# --- Key Bindings ---
# Word navigation
bindkey "^[[1;3D" backward-word   # Alt + <--
bindkey "^[[1;3C" forward-word    # Alt + -->
bindkey "^[[1;5D" backward-word   # Ctrl + <--
bindkey "^[[1;5C" forward-word    # Ctrl + -->

# --- Prompt Style ---
PROMPT='%F{cyan}┌[%B%F{white}%n%b%f%F{cyan} ◆ %B%F{white}%M%b%f%F{cyan}]%F{white}-%F{cyan}(%B%F{white}%~%b%f%F{cyan})$(git_prompt_info)
└> % %f'

# --- Git Prompt ---
ZSH_THEME_GIT_PROMPT_PREFIX="-%F{white}git://%B%F{white}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%f%F{cyan}-"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}✗%f"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{green}✔%f"

git_prompt_info() {
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local branch dirty
  branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null \
           || git describe --tags --exact-match 2>/dev/null \
           || git rev-parse --short HEAD 2>/dev/null)

  if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
    dirty="$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    dirty="$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}${dirty}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# --- Syntax Highlighting Styles ---
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main brackets pattern cursor root)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[alias]=fg=51
ZSH_HIGHLIGHT_STYLES[precommand]=fg=123,underline
ZSH_HIGHLIGHT_STYLES[function]=fg=45,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=141,bold
ZSH_HIGHLIGHT_STYLES[default]=fg=123
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=196,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=105,bold
ZSH_HIGHLIGHT_STYLES[argument]=fg=51
ZSH_HIGHLIGHT_STYLES[comment]=fg=82,bg=235
ZSH_HIGHLIGHT_STYLES[redirection]=fg=201,underline
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=198,bold
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=93
ZSH_HIGHLIGHT_STYLES[pattern:^-[-a-zA-Z0-9]+]=fg=208,bold
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=99
ZSH_HIGHLIGHT_STYLES[path]=fg=207,bold,underline
ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=15,bold
ZSH_HIGHLIGHT_STYLES[path_approx]=fg=201,underline,bg=236
ZSH_HIGHLIGHT_STYLES[globbing]=fg=201,bold
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=123,underline
ZSH_HIGHLIGHT_STYLES[command-substitution]=fg=87
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=93,bold
ZSH_HIGHLIGHT_STYLES[process-substitution]=fg=141
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=fg=207
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=93,underline
ZSH_HIGHLIGHT_STYLES[named-fd]=fg=99,bold

# --- Plugins ---
# Detect plugin directories
if [[ -d /usr/share/zsh/plugins ]]; then
  ZSH_PLUGIN_DIR=/usr/share/zsh/plugins
else
  ZSH_PLUGIN_DIR=/usr/share
fi

# Autosuggestions
if [[ -f $ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source $ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Syntax Highlighting (keep last or won't work)
if [[ -f $ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
