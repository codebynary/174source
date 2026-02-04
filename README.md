# PW Server v174 - Source Code

> **Versão**: 1.6.2 (v174)  
> **Compatibilidade**: Client 1.6.2+  
> **Status**: Cleaned & Optimized (Release Mode)

![Standard](https://img.shields.io/badge/standard-pending_compliance-yellow?style=for-the-badge)

> [!WARNING]
> **Aguardando Padronização Antigravity**: Este projeto deve ser migrado para arquitetura "Docker Dev / Native Prod".
> Consulte: `.agent/PROJECT_STATUS.md` e a tarefa associada.


Este repositório contém o código fonte completo do servidor Perfect World versão 174, otimizado e limpo para desenvolvimento e produção.

---

## 🚀 Quick Start (Linux)

Este projeto foi otimizado para compilação em **Ubuntu 22.04 LTS**.

### 1. Instalar Dependências

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar compiladores e ferramentas
sudo apt install -y build-essential gcc g++ make git

# Instalar bibliotecas requeridas
sudo apt install -y \
    libpcre3-dev \
    libssl-dev \
    libcrypto++-dev \
    libcurl4-openssl-dev \
    libjsoncpp-dev \
    ant \
    default-jdk
```

### 2. Configurar Build

O script `build.sh` configura automaticamente os paths necessários.

```bash
cd 174source
chmod +x *.sh
```

### 3. Compilar (Release Mode)

O projeto está configurado por padrão para **Release Mode** (`-O2`), proporcionando melhor performance e binários menores.

```bash
# Compilar todo o projeto (15-30 min)
./build.sh all
```

Outras opções de build:
```bash
./build.sh deliver    # Apenas servidores de rede (glinkd, gdeliveryd, etc)
./build.sh gs         # Apenas game server lib
./build.sh install    # Instalar binários compilados em /home/
```

---

## 🛠️ Manutenção e Limpeza

Scripts de limpeza foram incluídos para remover arquivos temporários e liberar espaço.

### No Linux

```bash
# Executar limpeza interativa
./cleanup.sh
```

### No Windows (PowerShell)

```powershell
# Executar limpeza automatizada
./cleanup.ps1
```

**Arquivos removidos:**
- Objetos compilados (`.o`, `.a`, `.so`)
- Logs de execução (`.log`)
- Backups de editores (`.bak`, `*~`)

---

## 📁 Estrutura do Projeto

### Diretórios Principais

| Diretório | Descrição |
|-----------|-----------|
| `cnet/` | **Network Servers**: gamed, gdeliveryd, gauthd, glinkd, etc. |
| `cgame/` | **Game Logic**: Lógica principal do jogo (gs), física, colisão. |
| `cskill/` | **Skill System**: Sistema de habilidades, gerado via Apache Ant. |
| `share/` | **Shared Libs**: Bibliotecas comuns, RPC framework, I/O. |
| `iolib/` | **I/O Library**: Gerado automaticamente (links simbólicos). |

### Binários Gerados

Após a instalação (`./build.sh install`), os binários são movidos para:

- `/home/gamed/` (Game Server)
- `/home/gdeliveryd/` (Delivery Server)
- `/home/gamedbd/` (Database Server)
- `/home/glinkd/` (Link Server)
- `/home/gauthd/` (Auth Server)
- `/home/gfactiond/` (Faction Server)
- `/home/uniquenamed/` (Unique Name Server)
- `/home/gacd/` (Anti-Cheat Server)

---

## ⚙️ Configurações Técnicas

### Otimizações Aplicadas
- **Compiler**: GCC/G++
- **Mode**: Release (`-O2`)
- **Flags**: `-mfpmath=387` (required for float consistency)
- **Feature**: Debug symbols removed (smaller binaries)

### Arquivos de Configuração
- `cgame/Rules.make`: Configurações globais de compilação (flags, includes).
- `*.conf`: Arquivos de configuração de cada servidor (ips, portas, limites).

---

## 📝 Notas de Desenvolvimento

### Git Ignore
O arquivo `.gitignore` está configurado para excluir:
- Binários compilados (`.o`, `.so`, `.a`)
- Logs e arquivos temporários
- Backups grandes (`174compiler.tar.gz`)
- Arquivos de IDE (`.vscode/`, `.vscode-server/`)

### Recomendações
- **Não commitar binários**: O repositório deve conter apenas código fonte.
- **Manter .conf fora do git**: Para produção, mantenha arquivos de configuração sensíveis (senhas DB) em um repositório privado ou gerencie separadamente.

---

> **Desenvolvido para**: PW Server 1.6.2 (174)
