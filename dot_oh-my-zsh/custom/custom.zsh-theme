setopt PROMPT_SUBST

# Colors
ERROR_COLOR="$FG[196]%B"
OK_COLOR="$FG[122]%B"
CWD_COLOR="$FG[033]%B"
TIME_COLOR="$FG[069]" # Nice
GIT_MAIN_COLOR="$FG[202]%B"
GIT_BRANCH_COLOR="$FG[097]%B"
GIT_DIRTY_COLOR="$FG[088]"
GIT_CLEAN_COLOR="$FG[031]"

# Git
ZSH_THEME_GIT_PROMPT_PREFIX="%{${GIT_MAIN_COLOR}%}%1{󰊢%} <%{${GIT_BRANCH_COLOR}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" %f"

function calculate_time() {
    local time=$1
    local seconds=$(( time % 60 ))
    local minutes=$(( (time / 60) % 60 ))
    local hours=$(( (time / (60*60)) % 24 ))
    local days=$(( time / (60*60*24) ))

    local display=()
    (( days    > 0 )) && display+=("${days}d")
    (( hours   > 0 )) && display+=("${(l:2::0:)hours}h")
    (( minutes > 0 )) && display+=("${(l:2::0:)minutes}m")
    (( seconds > 0 )) && display+=("${(l:2::0:)seconds}s")

    display_time="${(j: :)display}"
}

function preexec() {
    display_time=""
    _t_start=${EPOCHREALTIME}
    _start_sec=${_t_start%.*}
}

function precmd() {
    # We need it here so the SHA string is refreshed before each prompt
    ZSH_THEME_GIT_PROMPT_DIRTY="@$(git_prompt_short_sha)%{${GIT_MAIN_COLOR}%}>%b %{${GIT_DIRTY_COLOR}%}%1{✗%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="@$(git_prompt_short_sha)%{${GIT_MAIN_COLOR}%}>%b %{${GIT_CLEAN_COLOR}%}%1{%}"

    if [[ -n $_start_sec ]]; then
        _t_end=$EPOCHREALTIME
        _end_sec=${_t_end%.*}

        # Calculate how much time has passed (seconds first)
        local time_elapsed=$(( _end_sec - _start_sec ))
        if (( time_elapsed >= 60 )); then # if >= 60 secs, ms are not important
            calculate_time $time_elapsed
        else 
            time_elapsed=$(( (_t_end - _t_start) * 1000 ))
            if (( time_elapsed < 1 )); then
                display_time="<1ms"
            else
                display_time="${time_elapsed%.*}ms"
            fi
        fi
        unset _end_sec _start_sec _t_start _t_end time_elapsed
    else # fallback
        unset _end_sec _start_sec _t_start _t_end time_elapsed
        display_time=""
    fi
}

# Main Prompt
local prefix='%(?:%{${OK_COLOR}%}:%{${ERROR_COLOR}%})%1{%(!.#.)%}%{$reset_color%}'
local cwd='%{${CWD_COLOR}%}%c%{$reset_color%}'
# local git_info='$(git_prompt_info)'

# Right Prompt
local error_code='%(?..%{${ERROR_COLOR}%}[%?]%{$reset_color%})'
local elapsed_time='%{${TIME_COLOR}%}\
${display_time}\
%{$reset_color%}'

PROMPT="${prefix}  ${cwd} \$(git_prompt_info)"
RPS1="${error_code} ${elapsed_time}"
