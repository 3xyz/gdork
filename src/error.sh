#!/usr/bin/env bash

random_emoji() {
  emoji=(👿 👺 😫 😅 🤌)
  echo ${emoji[$RANDOM % ${#emoji[@]}]}
}

echo_stderr() {
  echo -e "$@" >&2
}

info() {
  echo -e " ${bold}${blue}Info:${n} $@" >&2
}

warning() {
  echo -e " ${bold}${orange}Warning:${n} $@" >&2
}

error() {
  echo -e " $(random_emoji) ${red}${bold}Error:${n} $@" >&2
  exit 1
}

help_message() {
  echo -e "${bold}Description:${n}"
  echo "  Thist tool automate research with google dorks."
  echo
  echo -e "${bold}Flags:${n}"
  echo "  -d, --domain    domain"
  echo "  -f, --file      file"
  echo "  -h, --help      Show this help"
}
