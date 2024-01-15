#!/bin/bash

FOLDER="src"
SITEMAP="src/sitemap.txt"
URL="https://www.davlgd.fr"

echo ${URL} > ${SITEMAP}
find ${FOLDER} -type f -name "*.html" | sed "s|${FOLDER}|${URL}|" | sed 's|/|/|g' >> "${SITEMAP}"