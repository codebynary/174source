#!/bin/bash

# PW Server v174 - Script de Limpeza
# Este script remove arquivos desnecessários que podem ser reconstruídos
# Execute com cuidado!

echo "=========================================="
echo "  PW Server v174 - Cleanup Script"
echo "=========================================="
echo ""

# Função para perguntar confirmação
confirm() {
    read -p "$1 (s/N): " response
    case "$response" in
        [sS][iI][mM]|[sS]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Contador de espaço liberado
space_freed=0

# 1. Remover arquivos .bak (backups)
echo "[1/7] Procurando arquivos .bak..."
bak_files=$(find . -name "*.bak" -type f 2>/dev/null)
if [ ! -z "$bak_files" ]; then
    echo "Arquivos .bak encontrados:"
    echo "$bak_files"
    if confirm "Remover arquivos .bak?"; then
        find . -name "*.bak" -type f -delete
        echo "✓ Arquivos .bak removidos"
    fi
else
    echo "Nenhum arquivo .bak encontrado"
fi
echo ""

# 2. Remover arquivos .log
echo "[2/7] Procurando arquivos .log..."
log_files=$(find . -name "*.log" -type f 2>/dev/null)
if [ ! -z "$log_files" ]; then
    echo "Arquivos .log encontrados:"
    echo "$log_files"
    if confirm "Remover arquivos .log?"; then
        find . -name "*.log" -type f -delete
        echo "✓ Arquivos .log removidos"
    fi
else
    echo "Nenhum arquivo .log encontrado"
fi
echo ""

# 3. Remover arquivos .o (object files)
echo "[3/7] Procurando arquivos .o..."
o_count=$(find . -name "*.o" -type f 2>/dev/null | wc -l)
if [ $o_count -gt 0 ]; then
    echo "Encontrados $o_count arquivos .o"
    o_size=$(find . -name "*.o" -type f -exec du -ch {} + 2>/dev/null | grep total | cut -f1)
    echo "Espaço total: $o_size"
    if confirm "Remover TODOS os arquivos .o?"; then
        find . -name "*.o" -type f -delete
        echo "✓ Arquivos .o removidos"
    fi
else
    echo "Nenhum arquivo .o encontrado"
fi
echo ""

# 4. Remover libskill.so (166 MB - pode ser reconstruído)
echo "[4/7] Verificando libskill.so..."
if [ -f "cskill/libskill.so" ]; then
    size=$(du -h cskill/libskill.so | cut -f1)
    echo "Encontrado: cskill/libskill.so ($size)"
    echo "AVISO: Este arquivo é grande mas pode ser reconstruído com ./build.sh"
    if confirm "Remover cskill/libskill.so?"; then
        rm -f cskill/libskill.so
        echo "✓ libskill.so removido"
    fi
else
    echo "libskill.so não encontrado ou já removido"
fi
echo ""

# 5. Remover bibliotecas estáticas compiladas (.a)
echo "[5/7] Procurando bibliotecas .a compiladas..."
echo "AVISO: Isso NÃO removerá .a de dependências externas"
a_files_to_remove=""

# Verificar arquivos .a específicos que são compilados localmente
if [ -f "cgame/libcm.a" ]; then
    a_files_to_remove="$a_files_to_remove cgame/libcm.a"
fi
if [ -f "cgame/collision/libTrace.a" ]; then
    a_files_to_remove="$a_files_to_remove cgame/collision/libTrace.a"
fi
if [ -f "cgame/liblua.a" ]; then
    a_files_to_remove="$a_files_to_remove cgame/liblua.a"
fi

if [ ! -z "$a_files_to_remove" ]; then
    echo "Arquivos .a identificados para remoção:"
    for file in $a_files_to_remove; do
        if [ -f "$file" ]; then
            size=$(du -h "$file" | cut -f1)
            echo "  - $file ($size)"
        fi
    done
    if confirm "Remover estes arquivos .a?"; then
        for file in $a_files_to_remove; do
            rm -f "$file"
        done
        echo "✓ Arquivos .a removidos"
    fi
else
    echo "Nenhum arquivo .a compilado localmente encontrado"
fi
echo ""

# 6. Remover links simbólicos (serão recriados pelo build.sh)
echo "[6/7] Links simbólicos..."
echo "NOTA: Links simbólicos serão recriados automaticamente pelo build.sh"
echo "Esta operação é opcional e pode ser ignorada"
if confirm "Remover links simbólicos?"; then
    # Remover links em cnet
    cd cnet 2>/dev/null
    rm -f common io mk storage rpc lua rpcgen 2>/dev/null
    cd ..
    
    # Remover links em cgame/gs
    cd cgame/gs 2>/dev/null
    rm -f libskill.so 2>/dev/null
    cd ../..
    
    echo "✓ Links simbólicos principais removidos"
else
    echo "Links simbólicos mantidos"
fi
echo ""

# 7. Verificar 174compiler.tar.gz
echo "[7/7] Verificando 174compiler.tar.gz..."
if [ -f "174compiler.tar.gz" ]; then
    size=$(du -h 174compiler.tar.gz | cut -f1)
    echo "Encontrado: 174compiler.tar.gz ($size)"
    echo "ATENÇÃO: Este pode ser um backup importante do toolchain de compilação!"
    echo "Só remova se tiver certeza de que não é necessário"
    if confirm "Remover 174compiler.tar.gz? (NÃO recomendado sem verificar)"; then
        rm -f 174compiler.tar.gz
        echo "✓ 174compiler.tar.gz removido"
    else
        echo "174compiler.tar.gz mantido (recomendado)"
    fi
else
    echo "174compiler.tar.gz não encontrado"
fi
echo ""

echo "=========================================="
echo "  Limpeza Concluída!"
echo "=========================================="
echo ""
echo "Para reconstruir o projeto após a limpeza:"
echo "  ./build.sh all"
echo ""
echo "Para instalar após compilação:"
echo "  ./build.sh install"
echo ""
