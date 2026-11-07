#!/bin/bash
# Publishes the DrawPulse privacy and support pages to GitHub Pages.
set -e
export PATH="$HOME/.local/bin:$PATH"
cd "$(dirname "$0")"
echo "Privacy policy and support pages for the DrawPulse iPhone app." > README.md
[ -d .git ] || git init -q -b main
git add -A
git -c user.name="Joseph Huntley" -c user.email=joseph.huntley@gmail.com commit -q -m "DrawPulse privacy and support pages"
gh repo create jhunt2323/drawpulse-info --public --description "Privacy policy and support pages for the DrawPulse iPhone app" --source . --push
gh api -X POST repos/jhunt2323/drawpulse-info/pages -f 'source[branch]=main' -f 'source[path]=/' > /dev/null
echo "Waiting for the pages to go live..."
for i in $(seq 1 30); do
  if [ "$(curl -s -o /dev/null -w '%{http_code}' https://jhunt2323.github.io/drawpulse-info/privacy.html)" = 200 ]; then
    echo "DONE: https://jhunt2323.github.io/drawpulse-info/privacy.html"; exit 0
  fi
  sleep 10
done
echo "Published, but the page isn't showing yet. Give it a few minutes."
