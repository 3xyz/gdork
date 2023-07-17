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
  echo "  Tool which helps automate google dorking."
  echo
  echo -e "${bold}Flags:${n}"
  echo "  -d, --domain    domain (ex. *.hackerone.com)"
  echo "  -f, --file      domains file (recomended to use proxy)"
  echo "  -p, --proxy     file with proxy"
  echo "  -h, --help      Show this help"
}
