#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No file name provided"
    echo
    echo "Usage:"
    echo "  $0 path_to/file_to_convert.md"
    exit 1
fi

if command -v generate-md > /dev/null 2>&1; then
    generate-md --layout jasonm23-markdown --input "$1" --output src/
else
    printf "\e[31m✗\e[0m 'generate-md' command not found. Install it with 'npm i -g markdown-styles'"
fi