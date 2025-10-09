# A instrução 'FROM' é sempre a primeira linha de um Dockerfile.
# Ela define a imagem base sobre a qual construiremos a nossa. Em vez de começar
# de um sistema operacional limpo (como 'ubuntu:22.04'), estamos usando uma imagem
# pré-configurada da Microsoft para Dev Containers.
#
# Vantagens desta imagem:
# - Já vem com Python 3.11, Git, e muitas outras ferramentas de desenvolvimento.
# - Inclui um usuário não-root ('vscode') já configurado, o que é uma boa prática de segurança.
# - Economiza muito tempo de configuração manual.
FROM mcr.microsoft.com/devcontainers/python:3.11

# --- (Opcional, mas recomendado para PySpark) Instalação de dependências do sistema ---
# PySpark requer Java para ser executado. Usamos o gerenciador de pacotes 'apt-get'
# (padrão em sistemas baseados em Debian/Ubuntu) para instalar o Java Runtime Environment (JRE).
#
# 'apt-get update' atualiza a lista de pacotes disponíveis.
# 'apt-get install -y default-jre' instala o Java. O '-y' confirma a instalação automaticamente.
# Usar '&&' encadeia os comandos em uma única camada (layer) do Docker, o que é uma otimização.
RUN apt-get update && apt-get install -y default-jre

# --- Instalação das bibliotecas Python ---

# A instrução 'COPY' copia arquivos do seu computador (o "contexto de build") para dentro da imagem.
#
# 'COPY ../requirements.txt': Copia o arquivo 'requirements.txt' da raiz do projeto...
# '/tmp/pip-tmp/': ...para uma pasta temporária dentro da imagem.
#
# Por que copiar apenas este arquivo primeiro?
# O Docker constrói imagens em camadas e armazena o resultado de cada passo em cache.
# Ao copiar apenas o 'requirements.txt' e depois instalar as dependências, a demorada
# etapa de instalação só será executada novamente se o arquivo 'requirements.txt' mudar.
# Se copiássemos todo o código do projeto antes, a instalação rodaria toda vez que
# qualquer arquivo de código fosse alterado, tornando o build muito mais lento.
COPY ../requirements.txt /tmp/pip-tmp/

# A instrução 'RUN' executa um comando dentro da imagem durante o processo de build.
# Aqui, usamos o 'pip' para instalar todas as bibliotecas listadas no arquivo que acabamos de copiar.
#
# '--disable-pip-version-check': Um pequeno detalhe que impede o pip de verificar se há uma nova
#   versão de si mesmo, tornando o build um pouco mais rápido e limpo.
# '--no-cache-dir': Uma
