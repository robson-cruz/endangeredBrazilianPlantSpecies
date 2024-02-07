#!/bin/bash

# Define a data atual
CURRENT_DATE=$(date "+%B %Y")

# Define o comando sed para substituir a data no README.md
SED_COMMAND="s/Acesso em: [A-Za-z]* [0-9]\{4\}/Acesso em: ${CURRENT_DATE}/g"

# Executa o comando sed para substituir a data no README.md
sed -i -E "${SED_COMMAND}" README.md

# Configura o nome e o email do usuário do Git
git config user.email "rcflorestal@yahoo.com.br"
git config user.name "rcDeveloping"

# Atualiza o repositório local com as alterações remotas
git pull origin main

# Adiciona as alterações ao commit
git add README.md

# Realiza o commit das alterações com uma mensagem descritiva
git commit -m "Atualizar data no README"

# Faz o push das alterações para o repositório remoto
git push origin main

