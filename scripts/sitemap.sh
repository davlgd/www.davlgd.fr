#!/bin/bash

FOLDER="src"
SITEMAP="src/sitemap.txt"
URL="https://www.davlgd.fr"

echo ${URL} > ${SITEMAP}
find ${FOLDER} -type f -name "*.html" ! -name "index.template.html" | sed "s|${FOLDER}|${URL}|" >> "${SITEMAP}"