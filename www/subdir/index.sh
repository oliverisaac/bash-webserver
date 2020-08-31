#!/usr/bin/env bash
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 ft=sh

set -e # Exit on any error. Use `COMMAND || true` to nullify
set -E # Functions inherit error trap
set -u # Error on unset variables. Use ${var:-alternate value} to bypass
set -f # Error on attempted file globs (e.g. *.txt )
set -o pipefail # Failed commands in pipes cause the whole pipe to fail

LOG_LEVEL=info
LOG_IN_COLOR=true
LOG_WITH_DATE=false

function main()
{
    info "hello world from subdir"
    echo "Hello from a shell script"
    return 0
}

export LOG_LEVEL_TRACE=90 LOG_LEVEL_DEBUG=70 LOG_LEVEL_INFO=50 LOG_LEVEL_WARN=30 LOG_LEVEL_ERROR=10 LOG_LEVEL_FATAL=0
# Colors used in log lines
export LOG_COLORS=( [$LOG_LEVEL_TRACE]=37 [$LOG_LEVEL_DEBUG]=36 [$LOG_LEVEL_INFO]=32 [$LOG_LEVEL_WARN]=33 [$LOG_LEVEL_ERROR]=31 [$LOG_LEVEL_FATAL]=41)
declare -A LOG_LEVEL_MAPPING
LOG_LEVEL_MAPPING=( 
    [trace]="$LOG_LEVEL_TRACE" [debug]="$LOG_LEVEL_DEBUG" [info]="$LOG_LEVEL_INFO" [warn]="$LOG_LEVEL_WARN" [error]="$LOG_LEVEL_ERROR" [fatal]="$LOG_LEVEL_FATAL"
    [$LOG_LEVEL_TRACE]="trace" [$LOG_LEVEL_DEBUG]="debug" [$LOG_LEVEL_INFO]="info" [$LOG_LEVEL_WARN]="warn" [$LOG_LEVEL_ERROR]="error" [$LOG_LEVEL_FATAL]="fatal" 
)

function log(){
    local level="$1";
    shift 1;

    local INT_LOG_LEVEL=${LOG_LEVEL_MAPPING[$LOG_LEVEL]}
    local LEVEL_WORD=${LOG_LEVEL_MAPPING[$level]}

    # Check if we should bail
    [[ $level -le ${INT_LOG_LEVEL} ]] || return 0

    # If we are using log colors, then set those here
    local color_pre="\\e[${LOG_COLORS[$level]}m";
    local color_post='\e[0m';
    local date=""; $LOG_WITH_DATE && date=" $( date +%H:%M:%S.%3N )" || true

    {
        ${LOG_IN_COLOR} && echo -en "\\002$color_pre\\003";
        echo -n "[${LEVEL_WORD: 0:4}$date]:"
        ${LOG_IN_COLOR} && echo -en "\\002$color_post\\003";
        echo " ${@}"
    } >&2
}

function trace(){ log $LOG_LEVEL_TRACE "${@}"; }
function debug(){ log $LOG_LEVEL_DEBUG "${@}"; }
function info(){ log $LOG_LEVEL_INFO "${@}"; }
function warn(){ log $LOG_LEVEL_WARN "${@}"; }
function error(){ log $LOG_LEVEL_ERROR "${@}"; }
function fatal(){ log $LOG_LEVEL_FATAL "${@}"; exit 1; return 1; }

main "${@}"

exit $?

