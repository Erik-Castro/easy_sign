# Documentação da Ferramenta: easy_sign.sh

## Visão Geral

easy_sign.sh é uma ferramenta de linha de comando desenvolvida para assinar e verificar arquivos utilizando o OpenSSL. Ela oferece uma interface simples para o uso de algoritmos de assinatura digital baseados em SHA-256 e chaves assimétricas (privada e pública). A ferramenta suporta dois modos de operação: assinatura e verificação, e pode processar tanto arquivos quanto dados da entrada padrão.

### Autor
- Nome: Erik Castro
- Versão: 0.0.1-alpha
- Data de Criação: 23 de Outubro de 2024

### Dependências
- OpenSSL versão 3.3.2 ou superior

### Aviso Legal
Este software é fornecido "como está", sem garantias ou condições de qualquer tipo. O autor não se responsabiliza por quaisquer danos resultantes do uso indevido ou inadequado desta ferramenta. A responsabilidade total pelo uso é do usuário.

## Funcionalidades

### Assinatura de Arquivos
Permite assinar arquivos usando uma chave privada. A assinatura gerada pode ser armazenada em um arquivo especificado ou impressa na saída padrão.

### Verificação de Assinatura
Valida a assinatura de um arquivo ou de dados fornecidos por meio da entrada padrão utilizando uma chave pública.

## Sintaxe

./easy_sign.sh [-o assinatura_saida] [-k chave_privada] [-v chave_publica] [-c assinatura] [arquivo]
### Opções

| Opção        | Descrição                                                                 |
|--------------|---------------------------------------------------------------------------|
| -o         | Define o nome do arquivo de saída para a assinatura (modo de assinatura). |
| -k         | Caminho para a chave privada usada para assinar arquivos.                 |
| -v         | Caminho para a chave pública usada para verificar a assinatura.           |
| -c         | Verifica a assinatura do arquivo ao invés de assinar.                     |
| -h         | Exibe a mensagem de ajuda com as opções e exemplos de uso.                |

## Exemplos de Uso

### Assinatura de Arquivo
Para assinar um arquivo de texto (documento.txt) utilizando a chave privada minha_chave_priv.pem e salvar a assinatura no arquivo documento.sig:

./easy_sign.sh -o documento.sig -k minha_chave_priv.pem documento.txt
### Verificação de Assinatura
Para verificar se o arquivo documento.txt possui uma assinatura válida, utilizando a chave pública minha_chave_pub.pem e a assinatura armazenada em documento.sig:

./easy_sign.sh -v minha_chave_pub.pem -c documento.sig documento.txt
## Fluxo de Funcionamento

1. Verificação de Dependências: O script verifica se o openssl está instalado no sistema. Caso contrário, exibe uma mensagem de erro e encerra a execução.
   
2. Processamento de Argumentos: O script utiliza parâmetros da linha de comando para definir o modo de operação (assinatura ou verificação) e os arquivos necessários (chaves, arquivo a ser assinado/verificado, assinatura de saída, etc.).

3. Assinatura de Arquivos ou Dados:
    - Se o arquivo de entrada é fornecido, ele será assinado usando a chave privada.
    - Caso contrário, os dados da entrada padrão são utilizados.
    - A assinatura é gerada com o algoritmo SHA-256.

4. Verificação de Assinatura:
    - O script verifica se a assinatura corresponde ao conteúdo do arquivo fornecido ou dos dados da entrada padrão, utilizando a chave pública fornecida.

## Requisitos

- openssl versão 3.3.2 ou superior
- Acesso a uma chave privada para assinatura de arquivos e a chave pública correspondente para verificação.

## Tratamento de Erros

- O script implementa validações rigorosas para garantir que todos os arquivos e chaves fornecidos existam e sejam acessíveis antes de tentar processá-los.
- Em caso de erro, mensagens detalhadas são fornecidas para guiar o usuário no diagnóstico e solução de problemas.

## Melhorias Futuras

- Suporte a outros algoritmos de hash além de SHA-256.
- Opção para definir o algoritmo de assinatura.
- Melhor integração com entradas e saídas criptografadas.

## Conclusão

easy_sign.sh é uma ferramenta útil para desenvolvedores e administradores que precisam garantir a integridade e autenticidade de arquivos. A simplicidade de uso e as funcionalidades de verificação tornam essa ferramenta flexível para diferentes cenários de assinatura digital.
