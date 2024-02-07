#!/bin/bash

CURRENT_DATE=$(date "+%B %Y")
SED_COMMAND="s/Acesso em: \w+ \d{4}/Acesso em: ${CURRENT_DATE}/g"

sed -i -E "${SED_COMMAND}" README.md

git config --global user.email rcflorestal@yahoo.com.br
git config --global user.name rcDeveloping

git add README.md
git commit -m "Atualizar data no README"
git push
