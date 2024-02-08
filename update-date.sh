#!/bin/bash

# Defina a variável de ambiente LC_TIME para pt_BR.UTF-8
export LC_TIME=pt_BR.UTF-8

# Obtenha a data atual no formato desejado
CURRENT_DATE=$(date "+%b %Y" | sed "s/\b\w/\u&/")

if [[ $? -ne 0 ]]; then
  echo "Erro ao obter a data atual!" >&2
  echo "Verifique se o comando 'date' está funcionando corretamente."
  exit 1
fi

# Atualiza o repositório local com as alterações remotas
git pull https://github.com/rcDeveloping/endangeredBrazilianPlantSpecies.git main

# Define o comando sed para substituir a data no README.md
SED_COMMAND=$(sed "s/Acesso em: [A-Za-z]* [0-9]\{4\}\./Acesso em: $CURRENT_DATE./g" README.md)

# Executa o comando sed para substituir a data no README.md
echo "$SED_COMMAND" > README.md

if [[ $? -ne 0 ]]; then
  echo "Erro ao atualizar a data no README.md!" >&2
  echo "Verifique se o comando 'sed' está instalado e se o arquivo README.md existe."
  exit 1
fi

echo "Data atualizada no README.md com sucesso!"

# Adiciona as alterações ao commit
git add README.md

# Realiza o commit das alterações com uma mensagem descritiva
git commit -m "Atualizar data no README"

# Faz o push das alterações para o repositório remoto
git push https://github.com/rcDeveloping/endangeredBrazilianPlantSpecies.git main

