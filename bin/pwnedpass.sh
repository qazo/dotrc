#!/bin/bash

api_url="https://api.pwnedpasswords.com/range"

read -p "Password: " passwd

pass_hash=$(echo -n ${passwd} | sha1sum | awk '{print toupper($1)}')
pass_prefix="${pass_hash:0:5}"
printf "%8s: %40s\n" "Hash" "${pass_hash}"

curl_result=$(curl --silent "${api_url}/${pass_prefix}" | rg -i "${pass_hash:5}")
if [ -z "${curl_result}" ]; then
	echo "password hash not found."
else
	echo -ne "\e[31m"
	printf "%8s: %40s\n" "Result" "${curl_result%:*}"
	printf "%8s: %41s\n" "Count" "${curl_result#*:}"
	echo -ne "\e[0m"
fi

