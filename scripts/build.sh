#!/usr/bin/env bash
# Generate src/index.html from src/index.template.html with the date-sorted post list.
set -euo pipefail

cd "$(dirname "$0")/.."
TEMPLATE=src/index.template.html
OUT=src/index.html

mois=("" janvier février mars avril mai juin juillet août septembre octobre novembre décembre)

format_date() {
    IFS=- read -r y m d <<<"$1"
    echo "$((10#$d)) ${mois[10#$m]} $y"
}

posts=""
while IFS=$'\t' read -r date file title; do
    formatted=$(format_date "$date")
    posts+="                    <li class=\"post-item\">
                        <a href=\"$file\" class=\"post-link\">
                            <span class=\"post-title\">$title</span>
                            <span class=\"post-date\">$formatted</span>
                        </a>
                    </li>
"
done < <(
    for f in src/*.html; do
        name=${f##*/}
        [[ "$name" == index*.html ]] && continue
        title=$(sed -n 's|.*<title>\([^<]*\)</title>.*|\1|p' "$f" | head -1 |
            sed "s/&#39;/'/g; s/&#x27;/'/g; s/&quot;/\"/g; s/&amp;/\&/g")
        date=$(sed -n 's|.*"datePublished":[^"]*"\([^T"]*\).*|\1|p' "$f" | head -1)
        [[ -n "$title" && -n "$date" ]] && printf '%s\t%s\t%s\n' "$date" "$name" "$title"
    done | sort -r
)

tmp=$(mktemp)
printf '%s' "$posts" >"$tmp"
awk -v f="$tmp" '
    /<!-- POSTS_PLACEHOLDER -->/ { while ((getline l < f) > 0) print l; next }
    { print }
' "$TEMPLATE" >"$OUT"
rm -f "$tmp"
echo "Generated $OUT"
