# -*- coding: utf-8 -*-
"""
Script de teste "Olá, Mundo!" para PySpark.

Este script inicializa uma sessão Spark, cria um DataFrame a partir de
dados em memória, exibe o conteúdo do DataFrame e encerra a sessão.
Serve para validar a instalação e configuração do PySpark no ambiente.
"""

# 1. Importações Necessárias
# Importamos a classe SparkSession do módulo sql, que é o ponto de entrada
# para programar com Spark e a API de DataFrame.
from pyspark.sql import SparkSession

def main():
    """Função principal que executa o teste do Spark."""

    # 2. Inicialização da SparkSession
    # A SparkSession é o ponto de entrada para qualquer funcionalidade do Spark.
    # Usamos o padrão de construção (builder pattern) para configurá-la.
    #
    # .appName("OlaMundoSpark"): Define um nome para a nossa aplicação.
    #   Isso é útil para identificar a aplicação em interfaces de monitoramento do Spark.
    # .getOrCreate(): Tenta obter uma SparkSession existente ou, se não houver,
    #   cria uma nova com as configurações definidas.
    print("Iniciando a sessão Spark...")
    spark = SparkSession.builder.appName("OlaMundoSpark").getOrCreate()
    print("Sessão Spark iniciada com sucesso!")

    try:
        # 3. Criação de Dados de Exemplo
        # Criamos uma pequena lista de tuplas para servir como nossos dados.
        # Estes dados existem apenas na memória do driver Python por enquanto.
        dados = [("Alice", 34),
                 ("Bruno", 45),
                 ("Carla", 29)]

        # Definimos os nomes das colunas para o nosso DataFrame.
        colunas = ["Nome", "Idade"]

        # 4. Criação do DataFrame
        # Usamos spark.createDataFrame() para transformar nossa lista de dados locais
        # em um DataFrame do Spark. Um DataFrame é uma coleção de dados distribuída
        # e organizada em colunas nomeadas, similar a uma tabela de banco de dados.
        print("\nCriando DataFrame a partir de dados locais...")
        df = spark.createDataFrame(dados, colunas)

        # 5. Execução de Ações
        # Ações são operações que fazem o Spark executar os cálculos e retornar um resultado.
        
        # .printSchema(): Exibe a estrutura (schema) do DataFrame, mostrando
        # os nomes das colunas e seus tipos de dados inferidos.
        print("\nSchema do DataFrame:")
        df.printSchema()

        # .show(): Exibe as primeiras 20 linhas do DataFrame em um formato de tabela.
        # Esta é uma das ações mais comuns para inspecionar os dados.
        print("\nConteúdo do DataFrame:")
        df.show()

        # Exemplo de uma transformação simples: filtrar dados
        print("\nFiltrando pessoas com mais de 30 anos:")
        df_filtrado = df.filter(df.Idade > 30)
        df_filtrado.show()

        print("\nTeste do Spark concluído com sucesso!")

    finally:
        # 6. Encerramento da Sessão
        # É uma boa prática encerrar a sessão Spark ao final do script.
        # Isso libera todos os recursos (memória, processadores) alocados pelo Spark.
        print("\nEncerrando a sessão Spark.")
        spark.stop()

if __name__ == '__main__':
    main()
