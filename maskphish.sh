#!/bin/bash

# Function to validate URL format
url_checker() {
    if [[ ! $1 =~ ^https?:// ]]; then
        echo -e "\e[31m[!] Invalid URL. Please use http or https.\e[0m"
        exit 1
    fi
}

# Decorative Output and Information Display
echo -e "\n\e[1;31;42m######┌──────────────────────────┐##### \e[0m"
echo -e "\e[1;31;42m######│▙▗▌      ▌  ▛▀▖▌  ▗    ▌  │##### \e[0m"
echo -e "\e[1;31;42m######│▌▘▌▝▀▖▞▀▘▌▗▘▙▄▘▛▀▖▄ ▞▀▘▛▀▖│##### \e[0m"
echo -e "\e[1;31;42m######│▌ ▌▞▀▌▝▀▖▛▚ ▌  ▌ ▌▐ ▝▀▖▌ ▌│##### \e[0m"
echo -e "\e[1;31;42m######│▘ ▘▝▀▘▀▀ ▘ ▘▘  ▘ ▘▀▘▀▀ ▘ ▘│##### \e[0m"
echo -e "\e[1;31;42m######└──────────────────────────┘##### \e[0m \n"
echo -e "\e[40;38;5;82m Please Visit \e[30;48;5;82m https://www.kalilinux.in \e[0m"
echo -e "\e[30;48;5;82m    Copyright \e[40;38;5;82m   JayKali \e[0m \n\n"

# Prompt user for phishing URL
echo -e "\e[1;31;42m ### Phishing URL ###\e[0m \n"
read -p "Paste Phishing URL here (with http or https): " phish

# Validate phishing URL
url_checker "$phish"

# Processing Phishing URL
echo "Processing and Modifying Phishing URL..."
short=$(curl -s "https://is.gd/create.php?format=simple&url=${phish}")
shorter=${short#https://}

# Prompt user for masking domain
echo -e "\n\e[1;31;42m ### Masking Domain ###\e[0m"
read -p "Enter domain to mask the Phishing URL (with http or https): " mask

# Validate masking domain
url_checker "$mask"

# Prompt user for social engineering words
echo -e "\nType social engineering words (like free-money, best-pubg-tricks)"
echo -e "\e[31mDon't use spaces, just use '-' between social engineering words\e[0m"
read -p "=> " words

# Generate MaskPhish URL
if [[ -z "$words" ]]; then
    final="$mask@$shorter"
else
    if [[ "$words" =~ " " ]]; then
        echo -e "\e[31m[!] Invalid words. Please avoid spaces.\e[0m"
        exit 1
    fi
    final="$mask-$words@$shorter"
fi

# Display the generated MaskPhish URL
echo -e "\nGenerating MaskPhish Link...\n"
echo -e "Here is the MaskPhish URL:\e[32m ${final} \e[0m\n"
