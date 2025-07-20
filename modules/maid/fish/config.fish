set -Ux COLORTERM truecolor
set -U fish_greeting
set -Ux EDITOR nvim

set -Ux XDG_DATA_HOME $HOME/.local/share
set -Ux XDG_STATE_HOME $HOME/.local/state
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux XDG_CACHE_HOME $HOME/.cache

# TokyoNight Color Palette
set -l foreground c0caf5
set -l selection 283457
set -l comment 565f89
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple 9d7cd8
set -l cyan 7dcfff
set -l pink bb9af7
# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_option $pink
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment
# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection

if status is-interactive
    # Setup other programs I use
    starship init fish | source

    # Setup fish shell aliases
    alias ls (command -v eza)
    alias cat (command -v bat)
    alias gri 'git rebase --interactive'
    alias gcr 'git clone --recursive'
    alias gcs 'git clone --depth=1'
    alias gpa 'git push --atomic'
    alias gco 'git commit'
    alias grt 'git remote'
    alias grb 'git rebase'
    alias grs 'git reset'
    alias gcl 'git clone'
    alias gst 'git stash'
    alias gpu 'git push'
    alias gpl 'git pull'
    alias gad 'git add'
    alias gtg 'git tag'
end

if command -q nix-your-shell
  nix-your-shell fish | source
end