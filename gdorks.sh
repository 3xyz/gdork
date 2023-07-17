#!/usr/bin/env bash

# Twitter: @71nk3r
# Github: https://github.com/3xyz

# Color tags
gray='\033[1;30m'
IRed='\033[0;91m'         
blue='\033[34m'
cyan='\033[0;36m'
orange='\e[00;33m'
red='\033[31m'
green='\033[0;32m'
bold='\033[1m'
n='\033[0m'

init() {
  trap terminate INT   # Handle Ctrl-C
  trap terminate QUIT  # Handle Ctrl-\\
  trap terminate TSTP  # Handle Ctrl-Z
  # trap terminate EXIT # Handle any exit
  # Import files
  source "$(project_path)/src/dorking.sh"
  source "$(project_path)/src/error.sh"
  source "$(project_path)/src/misc.sh"
  source "$(project_path)/config.txt"
  # Required files
  USER_AGENTS_FILE="$(project_path)/user-agents.txt"
  GOOGLE_DORKING_FILE="$(project_path)/$google_dorks_file"
  # https://github.com/prxchk/proxy-list/blob/main/all.txt
  PROXY_FILE="$(project_path)/proxy.txt"
  # Print header
  header
}

main() {
  # Parsing options
  parse_args "$@"
}

parse_args() {
  proxy_on=0
  DOMAIN=''
  DOMAINS_FILE=''
  PROXY_FILE=''
  for i in $(seq 1 $#); do
    case ${@:$i:1} in
      -d|--domain)
        DOMAIN="${@:$i+1:1}"
        shift
        ;;
      -f|--file)
        DOMAINS_FILE="${@:$i+1:1}"
        check_file "$DOMAINS_FILE"
        dorks_domains_from_file "$DOMAINS_FILE"
        shift
        ;;
      -p|--proxy)
        PROXY_FILE="${@:$i+1:1}"
        let proxy_on=1
        shift
        ;;
      -g|--google-dorks-file)
        GOOGLE_DORKING_FILE="${@:$i+1:1}"
        shift
        ;;
      -h|--help)
        help_message
        ;;
      -*|--*)
        error "unknown option ${bold}${@:$i:1}"
        ;;
      *)
        ;;
    esac
  done
  if ! [[ -z $DOMAIN ]]; then 
    dork_domain "$DOMAIN"
  fi
  if ! [[ -z $DOMAINS_FILE ]]; then 
    check_file "$DOMAINS_FILE"
    dorks_domains_from_file "$DOMAINS_FILE"
  fi
}

# Check for file exists (just example)
check_file() {
  if ! [[ -f $1 ]]; then
    error "no such file ($1)"
  fi
}

# We can handle terminating for remove temp files for example
terminate() {
  printf "\n ${bold}${red}Terminated\n"
  exit 1
}

header() {
  echo_stderr ' [38;5;214m [38;5;214m [38;5;214m_[38;5;214m_[38;5;214m [38;5;214m [38;5;214m [38;5;214m_[38;5;208m_[38;5;208m [38;5;208m [38;5;208m [38;5;208m_[38;5;208m_[38;5;208m [38;5;208m [38;5;208m [38;5;209m_[38;5;203m_[38;5;203m [38;5;203m [38;5;203m [38;5;203m [38;5;203m [38;5;203m [38;5;203m [38;5;203m [38;5;203m_[38;5;203m_'
  echo_stderr ' [38;5;214m [38;5;214m/[38;5;214m [38;5;214m_[38;5;214m`[38;5;208m [38;5;208m|[38;5;208m [38;5;208m [38;5;208m\[38;5;208m [38;5;208m/[38;5;208m [38;5;208m [38;5;209m\[38;5;203m [38;5;203m|[38;5;203m_[38;5;203m_[38;5;203m)[38;5;203m [38;5;203m|[38;5;203m_[38;5;203m_[38;5;203m/[38;5;203m [38;5;204m/[38;5;198m_[38;5;198m_[38;5;198m`'
  echo_stderr ' [38;5;214m [38;5;214m\[38;5;208m_[38;5;208m_[38;5;208m>[38;5;208m [38;5;208m|[38;5;208m_[38;5;208m_[38;5;208m/[38;5;208m [38;5;209m\[38;5;203m_[38;5;203m_[38;5;203m/[38;5;203m [38;5;203m|[38;5;203m [38;5;203m [38;5;203m\[38;5;203m [38;5;203m|[38;5;203m [38;5;204m [38;5;198m\[38;5;198m [38;5;198m.[38;5;198m_[38;5;198m_[38;5;198m/[0m'
  echo_stderr
}

# Relative path to project
project_path() {
  SOURCE=${BASH_SOURCE[0]}
  while [ -L "$SOURCE" ]; do
    DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
  done
  DIR=$( cd -P "$( dirname "$SOURCE" )" > /dev/null 2>&1 && pwd )
  echo $DIR
}

# Start 
init
main "$@"
