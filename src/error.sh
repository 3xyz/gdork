#!/usr/bin/env bash

random_emoji() {
  emoji=(👿 👺 😫 😅 🤌)
  echo ${emoji[$RANDOM % ${#emoji[@]}]}
}

echo_stderr() {
  echo -e "$@" >&2
}

info() {
  echo_stderr " ${bold}${blue}Info:${n} $@"
}

warning() {
  echo_stderr " ${bold}${orange}Warning:${n} $@"
}

error() {
  echo_stderr " $(random_emoji) ${red}${bold}Error:${n} $@"
  exit 1
}

help_message() {
  echo_stderr "${bold}Description:${n}"
  echo_stderr "  Tool which helps automate google dorking."
  echo_stderr
  echo_stderr "${bold}Flags:${n}"
  echo_stderr "  -d, --domain    domain (ex. *.hackerone.com)"
  echo_stderr "  -f, --file      domains file (recomended to use proxy)"
  echo_stderr "  -p, --proxy     file with proxy"
  echo_stderr "  -h, --help      Show this help"
}
