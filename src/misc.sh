#!/usr/bin/env bash

url_encode() {
  echo $1 | 
    sed 's/\ /+/g' | 
    sed 's/:/%3A/g'
}

get_random_user_agent() {
  echo $(shuf -n 1 "$USER_AGENTS_FILE")
}

write_to_tmp() {
  tmp_file_path="$(project_path)/tmp/$2.txt"
  echo "$1" > "$tmp_file_path"
  echo "$tmp_file_path"
}

sleep_for_random_time() {
  sec_to_sleep=$(shuf -i 5-7 -n 1)
  echo_stderr " ${blue}Scrapping page:${n} $1/5 ${orange}(sleep $sec_to_sleep)${n}"
  sleep $sec_to_sleep
}

check_google_ban() {
  cat "$1" | grep -io "https://www.google.com/sorry/index"
}

# *.google.com -> google\.com
regex_encode_domain() {
  local domain=$1
  if [[ '*' == ${domain::1} ]]; then
    domain=${domain:1}
  fi
  if [[ '.' == ${domain::1} ]]; then
    domain=${domain:1}
  fi
  echo "$domain" | sed 's/\./\\./g'
}

get_proxy() {
  echo $(shuf -n 1 "$proxy_file")
}
