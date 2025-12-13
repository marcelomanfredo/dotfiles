setopt PROMPT_SUBST

# Git
local get_sha="$(git_prompt_short_sha)"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[208]%B%}%1{󰊢%} <%{$FG[147]%B%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" %f"
ZSH_THEME_GIT_PROMPT_DIRTY="@${get_sha}%{$FG[208]%B%}>%b %{$FG[088]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="@${get_sha}%{$FG[208]%B%}>%b %{$FG[031]%}%1{%}"
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[208]%B%}>%b %{$FG[088]%}%1{✗%}"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[208]%B%}>%b %{$FG[031]%}%1{%}"

function preexec() {
    printf -v _start '%.0f' "$(echo "EPOCHREALTIME * 1000")"
}

function precmd() {
    if [[ -n $_start ]]; then
        printf -v _end '%.0f' "$(echo "EPOCHREALTIME * 1000")"
        _cmd_elapsed_ms=$(( _end - _start ))
        (( _cmd_elapsed_ms < 1 )) && _cmd_elapsed_ms=1
        unset _start
    else # fallback
        _cmd_elapsed_ms=1
    fi
}

function display_time() {
    if (( _cmd_elapsed_ms == 1 )); then
        echo -n "<1"
    else
        echo -n "$_cmd_elapsed_ms"
    fi
}

# Main Prompt
local prefix='%(?:%{$FG[122]%B%}:%{$FG[196]%B%})%1{%(!.#.)%}%{$reset_color%}'
local cwd='%{$FG[033]%B%}%c%{$reset_color%}'
local git_info='$(git_prompt_info)'

# Right Prompt
local error_code='%(?..%{$FG[196]%B%}[%?]%{$reset_color%})'
local elapsed_time='%{$FG[104]%}\
$(display_time)\
ms%{$reset_color%}'


PROMPT="${prefix}  ${cwd} ${git_info}"
RPS1="${error_code} ${elapsed_time}"
