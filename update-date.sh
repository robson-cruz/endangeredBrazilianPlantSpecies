#!/bin/bash

CURRENT_DATE=$(date "+%B %Y")
SED_COMMAND="s/Acesso em: \w+ \d{4}/Acesso em: ${CURRENT_DATE}/g"

sed -i -E "${SED_COMMAND}" README.md
git add README.md
git commit -m "Atualizar data no README"
git push
