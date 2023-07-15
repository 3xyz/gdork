#!/usr/bin/env bash

dorks_domains_from_file() { 
  domains_count=$(wc -l "$1")
  processed=0
  while read line; do 
    progress_bar $processed $domains_count
    if is_alive "$line"; then
      progress_print "$line"
    fi
    let processed++
  done < "$1"
}

url_encode() {
  echo $1 | 
    sed 's/\ /+/g' | 
    sed 's/:/%3A/g'
}

dork_domain() {
  while read line; do 
    if [[ $line =~ ^#\ .+ ]]; then
      echo_stderr " ${bold}${blue}Dork theme:$n ${line:2}"
      continue
    elif [[ $line =~ ^(\ |$)+$ ]]; then
      continue
    elif [[ $line =~ ^.*site.*$ ]]; then
      google_result=$(run_google_dorks "$line" "$1")
      if [ "$?" -eq '1' ]; then
       exit 0
      fi
      if ! [[ -z $google_result ]]; then 
        echo_stderr "{bold}{green} Result:{n}"
        for url in $google_result; do 
          echo $url
        done
        echo_stderr ""
      fi
      continue
    fi
  done < "$google_dorks_file"
}

get_random_user_agent() {
  echo $(shuf -n 1 "$user_agents_file")
}

write_to_tmp() {
  tmp_file_path="$(project_path)/tmp/$2.txt"
  echo "$1" > "$tmp_file_path"
  echo "$tmp_file_path"
}

sleep_for_random_time() {
  sec_to_sleep=$(shuf -i 8-12 -n 1)
  info 'sleeping' $sec_to_sleep
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

get_http_proxy() {
  echo $(shuf -n 1 "$http_proxy")
}

get_https_proxy() {
  echo $(shuf -n 1 "$https_proxy")
}

get_socks4_proxy() {
  echo $(shuf -n 1 "$socks4_proxy")
}

run_google_dorks() {
  dork_query="$1"
  domain="$2"
  dork_query=$(echo "$dork_query" | sed "s/\[TARGET\]/\"$domain\"/")
  echo_stderr " ${blue}Running query:${n}\n$dork_query"
  dork_query=$(url_encode "$dork_query")
	result=""
  for start in $(seq 0 10 40); do # Listing pages 1-5 pages
    if (( $start != 0 )); then
      sleep_for_random_time
    fi
    url="https://www.google.com/search?q=${dork_query}&start=${start}"
    resp_file=$(request_google "$url")
    if [[ $? == 1 ]]; then 
      exit 1
    fi
    # echo_stderr $url
    regex_domain=$(regex_encode_domain "$domain")
    extract_regex="(http|https)://[a-zA-Z\.]*${regex_domain}/[a-zA-Z0-9\(\)./?=_~-]*"
    # echo_stderr "$extract_regex"
    extracted_urls=$(cat "$resp_file" | grep -o -E $extract_regex)
    if ! [ -z "$extracted_urls" ]; then
      result+="$extracted_urls"
    else
      break
    fi
	done
  echo "$result" | sort -u
}

request_google() {
  local resp_file=''
  local url=$1
  local user_agent=$(get_random_user_agent)
  if [[ $proxy_on == 1 ]]; then
    resp=$(curl -sS -A "$user_agent" "$url" -m 6 -k --proxytunnel -proxy-insecure --proxy "$(./get_proxy.py)")
    if [[ -z $resp ]]; then
      echo_stderr 'Not valid proxy, looking for another'
      request_google $url
    else
      resp_file=$(write_to_tmp "$resp" "google_resp")
      if ! [ -z "$(check_google_ban "$resp_file")" ]; then 
        echo_stderr "It is banned proxy, looking for another"
        request_google $url
      fi
    fi
  else
    resp=$(curl -sS -A "$user_agent" "$url" -m 6)
    resp_file=$(write_to_tmp "$resp" "google_resp")
    if ! [ -z "$(check_google_ban "$resp_file")" ]; then 
      error "Google banned your dirty ass. Use proxy!"; exit 1
    fi
  fi
  echo "$resp_file"
}
