#!/bin/bash

TOOL="fswatch"
INSTALL_COMMAND="brew install ${TOOL}"
FOLDER="md/"
SCRIPT="scripts/toHTML.sh"

function watch() {
  while true; do
    fswatch -1 --event=Updated ${FOLDER} | while read file; do
    extension="${file##*.}"
    if [ "${extension}" = "md" ]; then
      echo 
      echo "File changed: ${file}"
      ./${SCRIPT} "$file" > /dev/null && printf "%s \e[32m✓\e[0m" "File conversion executed"
      echo
    fi
  done
done
}

if command -v ${TOOL} > /dev/null 2>&1; then
    echo "Watching for changes in '${FOLDER}' folder..."
    echo " - Press Ctrl+Z or CTRL+C to stop"
    watch
else
    printf "\e[31m✗\e[0m '${TOOL}' command not found. Install it with '${INSTALL_COMMAND}'"
fi