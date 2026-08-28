#!/bin/bash

SCRIPT=init.sh

IGNORE_VARS=(
    PWD OLDPWD SHLVL _ PS1 PS2 PS4
    BASH BASH_VERSION BASH_ARGV BASH_ARGV0 BASH_SOURCE BASH_LINENO
    BASH_SUBSHELL BASH_EXECUTION_STRING BASHOPTS BASHPID SHELLOPTS
    FUNCNAME PIPESTATUS COMP_WORDBREAKS RANDOM SECONDS LINENO
    EPOCHREALTIME EPOCHSECONDS
)
declare -A IGNORE=()
for v in "${IGNORE_VARS[@]}"; do IGNORE[$v]=1; done

# --- environment snapshotting -----------------------------------------
# NUL-delimited (`env -0`), not newline-delimited `printenv`/`env`, so a
# value that happens to contain a literal newline doesn't get split into
# a bogus extra "variable".
capture_env() {
	local -n _out="$1"
	_out=()
	local entry
	while IFS= read -r -d '' entry; do
		_out["${entry%%=*}"]="${entry#*=}"
	done < <(env -0)
}

declare -A BEFORE=() AFTER=()
capture_env BEFORE

# Redirect SCRIPT's own stdout to stderr: it may print banners/diagnostics
# (cmsenv does) which must NOT land in our stdout, since our stdout is
# meant to be `eval`d or `source`d verbatim by the caller.
source "$SCRIPT" "$@" 1>&2

capture_env AFTER

declare -A ALL_KEYS=()
for k in "${!BEFORE[@]}"; do ALL_KEYS[$k]=1; done
for k in "${!AFTER[@]}"; do ALL_KEYS[$k]=1; done

n_set=0
n_unset=0
while IFS= read -r name; do
	[ -n "${IGNORE[$name]:-}" ] && continue
	[[ "$name" == BASH_FUNC_*'%%' ]] && continue

	old_is_set=0; [ "${BEFORE[$name]+x}" ] && old_is_set=1
	new_is_set=0; [ "${AFTER[$name]+x}" ]  && new_is_set=1

	if [ "$old_is_set" -eq 1 ] && [ "$new_is_set" -eq 1 ] \
		&& [ "${BEFORE[$name]}" == "${AFTER[$name]}" ]; then
		continue
	fi

	if [ "$new_is_set" -eq 0 ]; then
		echo "unsetenv $name"
		n_unset=$((n_unset + 1))
	else
		printf "setenv %s '%s';\n" "$name" "${AFTER[$name]}"
		n_set=$((n_set + 1))
	fi
done < <(printf '%s\n' "${!ALL_KEYS[@]}" | sort)
