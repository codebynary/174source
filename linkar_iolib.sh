#!/bin/bash

# Diretório base onde os arquivos estão localizados
BASE_DIR="/root"

# Lista de arquivos com seus caminhos relativos
declare -a files=(
  "../../cnet/gamed/factionlib.h"
  "../../cnet/common/glog.h"
  "../../cnet/gamed/gsp_if.h"
  "../../cnet/gamed/kingelectionsyslib.h"
  "../../share/io/luabase.h"
  "../../cnet/gamed/mailsyslib.h"
  "../../cnet/gamed/privilege.hxx"
  "../../cnet/gamed/pshopsyslib.h"
  "../../cnet/gamed/sellpointlib.h"
  "../../cnet/gamed/stocklib.h"
  "../../cnet/gamed/sysauctionlib.h"
  "../../cnet/gamed/webtradesyslib.h"
)

# Diretório de destino para os links simbólicos
DEST_DIR="/root/iolib/inc"

# Criar o diretório de destino, se não existir
mkdir -p "$DEST_DIR"

# Criar links simbólicos
for file in "${files[@]}"; do
  # Caminho absoluto do arquivo de origem
  src="${BASE_DIR}/${file#../../}"

  # Nome do arquivo sem caminho
  filename=$(basename "$file")

  # Criar link simbólico no diretório de destino
  ln -sf "$src" "$DEST_DIR/$filename"

  echo "Link criado: $DEST_DIR/$filename -> $src"
done

echo "Todos os links simbólicos foram criados."
