#!/bin/bash

# Define a data atual
CURRENT_DATE=$(date "+%B %Y" --quiet)

if [[ $? -ne 0 ]]; then
  echo "Erro ao obter a data atual!" >&2
  echo "Verifique se o comando 'date' está funcionando corretamente."
  exit 1
fi

# Define o comando sed para substituir a data no README.md
SED_COMMAND="s/Acesso em: [A-Za-z]* [0-9]\{4\}/Acesso em: ${CURRENT_DATE}/g"

# Executa o comando sed para substituir a data no README.md
sed -i -E "${SED_COMMAND}" README.md

if [[ $? -ne 0 ]]; then
  echo "Erro ao atualizar a data no README.md!" >&2
  echo "Verifique se o comando 'sed' está instalado e se o arquivo README.md existe."
  exit 1
fi

echo "Data atualizada no README.md com sucesso!"

# Autenticação no Repositório
#git remote set-url origin https://github.com/rcDeveloping/endangeredBrazilianPlantSpecies.git

# Configura o nome e o email do usuário do Git
#git config --global user.email rcflorestal@yahoo.com.br
#git config --global user.name rcDeveloping

# Atualiza o repositório local com as alterações remotas
#git pull https://github.com/rcDeveloping/endangeredBrazilianPlantSpecies.git main

# Adiciona as alterações ao commit
git add README.md

# Realiza o commit das alterações com uma mensagem descritiva
git commit -m "Atualizar data no README"

# Faz o push das alterações para o repositório remoto
#git push https://github.com/rcDeveloping/endangeredBrazilianPlantSpecies.git main

