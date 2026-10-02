## PATH (fish_add_path skips directories that don't exist)
fish_add_path --append ~/.local/share/mise/shims ~/.local/bin # Omarchy defaults
fish_add_path ~/.local/bin          # General
fish_add_path ~/.pulumi/bin         # Pulumi
fish_add_path /usr/local/go/bin     # Go
fish_add_path ~/.config/venv/bin    # Python

# golang
set -gx GOPATH "$HOME/.go"
fish_add_path $GOPATH/bin

# bun
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

# Volta (Node.js Tool Manager)
set -gx VOLTA_HOME "$HOME/.volta"
fish_add_path $VOLTA_HOME/bin

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path $PNPM_HOME

# maestro (Android Testing)
fish_add_path ~/.maestro/bin
set -gx ANDROID_HOME "$HOME/Android/Sdk/"

# kubernetes
fish_add_path --append ~/.krew/bin # plugin manager

# Rust
test -f ~/.cargo/env.fish; and source ~/.cargo/env.fish

# Google Cloud SDK
test -f ~/google-cloud-sdk/path.fish.inc; and source ~/google-cloud-sdk/path.fish.inc

# Use vim as editor (falls back to nvim, Omarchy's default).
if command -q vim
    set -gx VISUAL vim
else
    set -gx VISUAL nvim
end
set -gx EDITOR "$VISUAL"

set -gx NODE_OPTIONS "--max_old_space_size=4096"
set -gx DOCKER_BUILDKIT 1
# AWS (default profile is a personal test account).
set -gx AWS_PROFILE default

# Tokens and credentials
test -f ~/.config/fish/secrets.fish; and source ~/.config/fish/secrets.fish

if status is-interactive
    set -g fish_greeting

    command -q mise; and mise activate fish | source
    command -q starship; and starship init fish | source
    command -q zoxide; and zoxide init fish --cmd j | source # j = jump (autojump habit), ji = interactive

    # python3 venv
    test -f ~/.config/venv/bin/activate.fish; and source ~/.config/venv/bin/activate.fish

    # File watchers limit so webpack doesn't freeze your machine.
    ulimit -n 10240

    # eza (ported from Omarchy's bash aliases)
    if command -q eza
        alias ls="eza -lh --group-directories-first --icons=auto"
        alias lsa="ls -a"
        alias lt="eza --tree --level=2 --long --icons --git"
        alias lta="lt -a"
    end

    # Arch's zed package installs the CLI as zeditor
    if command -q zeditor
        alias zed="zeditor"
    end

    ## git functions
    alias git-cleanup="git branch --merged | egrep -v '(^\*|master|dev)' | xargs git branch -d"
    alias gpo="git push origin HEAD"
    alias gp="git pull origin HEAD"
    alias gac="git add . && git commit -m"

    # Reef development
    alias reef ~/Desktop/work/chatpt-refactor/src/index.ts
end

# Get list of files changed, without their file extension (useful for passing to test runners as a list of files).
function git-changed-files-without-extension
    set branch_name $argv[1]
    if test -z "$branch_name"
        set branch_name "master"
    end
    git diff --name-only $branch_name...HEAD | string replace -r '\.[^.]*$' ''
end
