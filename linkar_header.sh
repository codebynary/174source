#!/bin/bash

# Diretório base para os links simbólicos
DEST_DIR="/root/header"

# Lista de arquivos com seus caminhos absolutos ou relativos
declare -a files=(
  "/root/cgame/gs/filter.h"
  "/root/cgame/libcm/hashtab.h"
  "../share/io/luabase.h"
  "/root/cgame/gs/obj_interface.h"
  "/root/cgame/gs/property.h"
  "/root/cgame/gs/substance.h"
  "/root/cgame/gs/attack.h"
  "/root/cgame/gs/config.h"
  "/root/cgame/gs/dbgprt.h"
)

# Criar o diretório de destino, se não existir
mkdir -p "$DEST_DIR"

# Criar links simbólicos
for file in "${files[@]}"; do
  # Caminho absoluto do arquivo de origem
  src=$(readlink -f "$file")

  # Nome do arquivo sem o caminho
  filename=$(basename "$file")

  # Criar link simbólico no diretório de destino
  ln -sf "$src" "$DEST_DIR/$filename"

  echo "Link criado: $DEST_DIR/$filename -> $src"
done

echo "Todos os links simbólicos foram criados."
