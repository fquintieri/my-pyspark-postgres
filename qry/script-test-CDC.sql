--
-- SCRIPT DE TESTE INTERATIVO DO CDC (Change Data Capture)
--
-- ATENÇÃO:
-- Este script NÃO deve ser executado de uma só vez (Run All / F5).
-- Você deve executar cada "PASSO" separadamente, em um cliente SQL,
-- seguindo as instruções nos comentários.
--

-- -----------------------------------------------------------------
-- PASSO 1: CRIAR O "REPLICATION SLOT"
--
--
-- Um "slot" é um canal de streaming. O banco manterá todas as mudanças
-- registradas no WAL até que este slot as consuma.
-- 'pgoutput' é o plugin de saída padrão.

SELECT pg_create_logical_replication_slot('db_loja_slot_teste', 'pgoutput');

-- -----------------------------------------------------------------
-- !! PARE AQUI !!
--
-- PASSO 2: FAZER UMA ALTERAÇÃO NO BANCO
--
--
-- Simular uma alteração real na aplicação.

UPDATE db_loja.produto
SET preco = 2999.99, estoque = 49
WHERE id = 1;

-- -----------------------------------------------------------------
--
-- PASSO 3: CONSUMIR AS MUDANÇAS DO SLOT
--
-- Ler o que foi capturado pelo slot.
-- Você deve ver um resultado (em formato de texto ou binário)
-- representando a transação de UPDATE que você fez no Passo 2.

SELECT * FROM pg_logical_slot_get_changes(
    'db_loja_slot_teste',       -- Nome do slot que criamos
    NULL,                       -- Posição do log (LSN), NULL para ler o próximo
    NULL,                       -- Limite de mudanças, NULL para ler todas pendentes
    'publication_names',        -- Opção para filtrar por publicação
    'db_loja_cdc_publication'   -- O nome da nossa publicação
);

-- -----------------------------------------------------------------
-- PASSO 4: FAZER OUTRA MUDANÇA
--

DELETE FROM db_loja.produto WHERE id = 20;

-- -----------------------------------------------------------------
-- PASSO 5: (OPCIONAL) LER NOVAMENTE
-- Exibirá apenas a nova transação (DELETE).

SELECT * FROM pg_logical_slot_get_changes(
    'db_loja_slot_teste',
    NULL,
    NULL,
    'publication_names',
    'db_loja_cdc_publication'
);

-- -----------------------------------------------------------------
-- PASSO 6: (OBRIGATÓRIO) LIMPAR O SLOT DE TESTE
--
-- IMPORTANTE: Slots de replicação impedem o PostgreSQL de limpar
-- os arquivos de WAL antigos. Se você não deletar o slot, seu
-- disco encherá rapidamente.

SELECT pg_drop_replication_slot('db_loja_slot_teste');

-- -----------------------------------------------------------------