#!/usr/bin/env bash
# safe_link_preview.sh
# Purpose: Validate a URL, fetch its title + domain, and create a safe local landing page
# NOTE: This is explicitly NOT a tool to mask or hide destinations.
set -euo pipefail

# ---------- Helpers ----------
print_err() { printf '\e[31m[!] %s\e[0m\n' "$1" >&2; }
print_info() { printf '\e[32m%s\e[0m\n' "$1"; }
usage() {
  cat <<EOF
Usage: $0
Interactive script: you'll be asked to paste a URL.
Generates a local safe landing HTML file that shows the real destination and title.
EOF
}

# Validate URL (http or https)
validate_url() {
  local url="$1"
  # Basic regex: starts with http:// or https://
  if [[ ! "$url" =~ ^https?:// ]]; then
    return 1
  fi
  # Optional: further basic structure check
  if ! printf '%s' "$url" | grep -qE '^[a-z]+://[^/ ]+'; then
    return 1
  fi
  return 0
}

# Extract domain from URL
get_domain() {
  local url="$1"
  # strip protocol then take host (up to / or ?)
  printf '%s' "$url" | sed -E 's#^[a-z]+://##; s#/.*##; s/\:.*$//'
}

# Fetch title (if any) safely using curl -sL and a small sed
fetch_title() {
  local url="$1"
  local title
  title=$(curl -sL --max-time 8 --fail "$url" 2>/dev/null \
    | tr '\n' ' ' \
    | sed -E 's/.*<title[^>]*>([^<]+)<\/title>.*/\1/I' \
    || true)
  # Fallback if not found
  if [ -z "$title" ]; then
    title="(no title found)"
  fi
  # Trim leading/trailing whitespace
  printf '%s' "$title" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g'
}

# Generate safe landing HTML
generate_landing() {
  local url="$1"
  local title="$2"
  local domain="$3"
  local outdir="${4:-./safe_links}"
  mkdir -p "$outdir"
  # unique id
  local id; id=$(date +%s%3N)$RANDOM
  local filename="$outdir/landing_${id}.html"

  cat >"$filename" <<HTML
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>Safe Preview — $domain</title>
  <style>
    body{font-family:Inter,system-ui, sans-serif; max-width:720px;margin:3rem auto;padding:1rem;}
    .warn{background:#fff3cd;border:1px solid #ffeeba;padding:1rem;border-radius:8px;}
    .meta{margin:1rem 0;padding:1rem;border-radius:8px;background:#f7f7f7;}
    a.button{display:inline-block;padding:0.6rem 1rem;border-radius:6px;text-decoration:none;border:1px solid #2b6cb0;}
  </style>
</head>
<body>
  <h1>Safe Link Preview</h1>
  <div class="warn">
    <strong>Notice:</strong> This page shows the real destination and page metadata. Do not proceed if you do not trust the site.
  </div>

  <div class="meta">
    <p><strong>Destination:</strong> <a href="$url" target="_blank" rel="noopener noreferrer">$url</a></p>
    <p><strong>Domain:</strong> $domain</p>
    <p><strong>Page title:</strong> $title</p>
  </div>

  <p>If you trust the destination, you may open it in a new tab. Otherwise, do not continue.</p>
  <p><a class="button" href="$url" target="_blank" rel="noopener noreferrer">Open destination (new tab)</a></p>
  <hr/>
  <small>Generated: $(date -R)</small>
</body>
</html>
HTML

  # Append mapping for reference (CSV)
  printf '%s,%s,%s\n' "$id" "$filename" "$url" >> "$outdir/links.csv"
  printf '%s' "$filename"
}

# ---------- Main ----------
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

printf '\n%s\n' "=== Safe Link Preview Generator ==="
printf 'Paste the URL (with http:// or https://): '
read -r url_input

if ! validate_url "$url_input"; then
  print_err "Invalid URL. Make sure it begins with http:// or https://"
  exit 1
fi

print_info "Valid URL. Fetching metadata (this may take a few seconds)..."

domain=$(get_domain "$url_input")
title=$(fetch_title "$url_input")

print_info "Domain: $domain"
print_info "Title: $title"

# Ask user whether to create a landing file
printf 'Create safe preview landing page? [Y/n]: '
read -r create_choice
create_choice=${create_choice:-Y}
if [[ "$create_choice" =~ ^[Yy] ]]; then
  outfile=$(generate_landing "$url_input" "$title" "$domain" "./safe_links")
  print_info "Safe landing page created: $outfile"
  print_info "Open it in your browser to view the preview."
else
  print_info "No file created. You can still view the domain/title above."
fi

exit 0
