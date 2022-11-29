#!/bin/bash

function urlChecker() {
	if [[ ! "${1//:*}" =~ ^(http|https)$ ]]; then
		echo "\e[31m[*] Invalid URL: ${1}\e[0m"

		return 0
	fi
	return 1
}

printf "\e[32m[*] Enter URL: \e[0m"
read -r url
if [[ -z ${url} ]]; then
	echo -e "\e[31m[*] URL cannot be empty!\e[0m"
	exit 1
fi
printf "Checking URL: ${url}..."
if ! urlChecker "${url}"; then
	echo -e "\e[32m[OK]\e[0m"
else
	echo -e "\e[31m[FAIL]\e[0m"
	exit 1
fi
printf "Let's get some keywords ex: (Free-money, Game-Cheat, etc): "
read -r keywords
if [[ -z ${keywords} ]]; then
	echo -e "\e[31m[*] Keywords cannot be empty!\e[0m"
	exit 1
fi
printf "Checking Keywords: ${keywords}..."
if [[ ${keywords} =~ [[:space:]] ]]; then
	echo -e "\e[31m[FAIL]\e[0m"
	echo -e "\e[31m[*] Keywords cannot contain spaces!\e[0m"
	exit 1
else
	echo -e "\e[32m[OK]\e[0m"
fi
# Generate a short url with the given url and keywords
shortUrl=$(curl -s "https://is.gd/create.php?format=simple&url=${url}&shorturl=${keywords}")
if [[ -z ${shortUrl} ]]; then
	echo -e "\e[31m[*] Failed to generate short URL!\e[0m"
	exit 1
fi
echo -e "\e[32m[*] Short URL: ${shortUrl}\e[0m"
