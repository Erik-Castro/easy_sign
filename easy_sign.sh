#!/usr/bin/env bash
#
# Nome do Script: easy_sign.sh
# Autor: Erik Castro
# Data de Criação: 23 de Outubro de 2024
# Versão: 0.0.1-alpha
# Descrição: Ferramenta simples para assinatura e verificação de arquivos utilizando OpenSSL.
# Dependências:
# --------------
# - OpenSSL 3.3.2
# =================================================
# AVISO LEGAL:
# ------------
# Ao utilizar este software, o usuário concorda que o autor não se responsabiliza por quaisquer danos resultantes do uso. A responsabilidade total pelo uso do software é do usuário.

# Verifica se as dependências estão instaladas
if ! command -v openssl &>/dev/null; then
    echo "[ERRO]: OpenSSL não está instalado. Instale o OpenSSL e tente novamente."
    exit 1
fi

# Variáveis de configuração
SAIDA_SIG=""   # Nome do arquivo de assinatura
PRIV_KEY=""    # Chave privada para assinatura
PUB_KEY=""     # Chave pública para verificação
OP_MODE="sign" # Modo padrão: assinar
FILE=""        # Arquivo de entrada para assinatura ou verificação

# Função de ajuda
mostrar_ajuda() {
    echo "Uso: $(basename $0) [-o assinatura_saida] [-k chave_privada] [-v chave_publica] [arquivo]"
    echo
    echo "Opções:"
    echo "  -o   Define o nome do arquivo de saída para a assinatura"
    echo "  -k   Fornece o caminho para a chave privada (somente para assinatura)"
    echo "  -v   Fornece o caminho para a chave pública (somente para verificação)"
    echo "  -c   Verifica a assinatura ao invés de assinar"
    echo "  -h   Exibe esta mensagem de ajuda"
    echo
    echo "Exemplos:"
    echo "  Assinar: $(basename $0) -o assinatura.sig -k minha_chave_priv.pem arquivo.txt"
    echo "  Verificar: $(basename $0) -v minha_chave_pub.pem -c assinatura.sig arquivo.txt"
    exit 0
}

# Processamento de argumentos
while [[ "$#" -gt 0 ]]; do
    case "$1" in
    -h)
        mostrar_ajuda
        ;;
    -o)
        SAIDA_SIG="$2"
        shift
        ;;
    -k)
        PRIV_KEY="$2"
        shift
        ;;
    -v)
        PUB_KEY="$2"
        shift
        ;;
    -c)
        OP_MODE="verify"
        ;;
    *)
        FILE="$1"
        ;;
    esac
    shift
done

# Função para assinar um arquivo
assinar() {
    local arquivo="$1"
    local chave_priv="$2"
    local saida_sig="$3"

    if [[ -z "$chave_priv" ]]; then
        echo "[ERRO]: Chave privada não fornecida."
        exit 1
    fi

    if [[ ! -f "$chave_priv" ]]; then
        echo "[ERRO]: A chave privada $chave_priv não existe."
        exit 1
    fi

    if [[ -n "$arquivo" ]]; then
        if [[ -n "$saida_sig" ]]; then
            if openssl dgst -sha256 -sign "$chave_priv" -out "$saida_sig" "$arquivo"; then
                echo "Arquivo '${arquivo}' assinado com sucesso. Assinatura salva em '${saida_sig}'"
            else
                echo "[ERRO]: Falha ao assinar o arquivo '${arquivo}'."
                exit 1
            fi
        else
            if openssl dgst -sha256 -sign "$chave_priv" "$arquivo"; then
                echo "Arquivo '${arquivo}' assinado com sucesso. Assinatura impressa na saída padrão."
            else
                echo "[ERRO]: Falha ao assinar o arquivo '${arquivo}'."
                exit 1
            fi
        fi
    else
        # Assinar dados da entrada padrão
        if [[ -n "$saida_sig" ]]; then
            if openssl dgst -sha256 -sign "$chave_priv" -out "$saida_sig"; then
                echo "Dados assinados com sucesso. Assinatura salva em '${saida_sig}'"
            else
                echo "[ERRO]: Falha ao assinar os dados da entrada padrão."
                exit 1
            fi
        else
            if openssl dgst -sha256 -sign "$chave_priv"; then
                echo "Dados assinados com sucesso. Assinatura impressa na saída padrão."
            else
                echo "[ERRO]: Falha ao assinar os dados da entrada padrão."
                exit 1
            fi
        fi
    fi
}

# Função para verificar uma assinatura
verificar() {
    local arquivo="$1"
    local chave_pub="$2"
    local assinatura="$3"

    if [[ -z "$chave_pub" ]]; then
        echo "[ERRO]: Chave pública não fornecida."
        exit 1
    fi

    if [[ ! -f "$chave_pub" ]]; then
        echo "[ERRO]: A chave pública $chave_pub não existe."
        exit 1
    fi

    if [[ -z "$assinatura" ]]; then
        echo "[ERRO]: Arquivo de assinatura não fornecido."
        exit 1
    fi

    if [[ ! -f "$assinatura" ]]; then
        echo "[ERRO]: O arquivo de assinatura $assinatura não existe."
        exit 1
    fi

    if [[ -n "$arquivo" ]]; then
        if openssl dgst -sha256 -verify "$chave_pub" -signature "$assinatura" "$arquivo"; then
            echo "A assinatura do arquivo '${arquivo}' é válida."
        else
            echo "[ERRO]: A assinatura do arquivo '${arquivo}' é inválida."
            exit 1
        fi
    else
        if openssl dgst -sha256 -verify "$chave_pub" -signature "$assinatura"; then
            echo "A assinatura dos dados da entrada padrão é válida."
        else
            echo "[ERRO]: A assinatura dos dados da entrada padrão é inválida."
            exit 1
        fi
    fi
}

# Modo de operação
if [[ "$OP_MODE" == "sign" ]]; then
    [[ -z "$PRIV_KEY" ]] && { echo "[ERRO]: Chave privada necessária para assinatura."; exit 1; }
    if [[ -n "$FILE" && -f "$FILE" ]]; then
        assinar "$FILE" "$PRIV_KEY" "$SAIDA_SIG"
    elif [[ -z "$FILE" ]]; then
        assinar "" "$PRIV_KEY" "$SAIDA_SIG"
    else
        echo "[ERRO]: O arquivo ${FILE} não existe!"
        exit 1
    fi
elif [[ "$OP_MODE" == "verify" ]]; then
    [[ -z "$PUB_KEY" ]] && { echo "[ERRO]: Chave pública necessária para verificação."; exit 1; }
    if [[ -n "$FILE" && -f "$FILE" ]]; then
        verificar "$FILE" "$PUB_KEY" "$SAIDA_SIG"
    elif [[ -z "$FILE" ]]; then
        verificar "" "$PUB_KEY" "$SAIDA_SIG"
    else
        echo "[ERRO]: O arquivo ${FILE} não existe!"
        exit 1
    fi
fi
