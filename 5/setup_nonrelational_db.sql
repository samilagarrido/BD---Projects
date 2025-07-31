-- Script para criar database/schema para consultas não-relacionais PostgreSQL
-- Baseado no arquivo non-relational.sql

-- Criação do database (executar como superusuário)
-- Se você quiser criar um novo database:
-- CREATE DATABASE nonrelational_examples
--     WITH 
--     OWNER = postgres
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'Portuguese_Brazil.1252'
--     LC_CTYPE = 'Portuguese_Brazil.1252'
--     TABLESPACE = pg_default
--     CONNECTION LIMIT = -1;

-- Alternativamente, criar apenas um schema no database atual
CREATE SCHEMA IF NOT EXISTS nonrelational_examples;

-- Definir o schema como padrão para esta sessão
SET search_path TO nonrelational_examples, public;

-- Comentário explicativo
COMMENT ON SCHEMA nonrelational_examples IS 'Schema para demonstração de recursos não-relacionais do PostgreSQL: Arrays, Ranges, Geometria, XML, JSON/JSONB, Tipos Compostos, Full-Text Search e Trigramas';

-- Habilitar extensões necessárias
-- Nota: algumas extensões podem precisar de privilégios de superusuário
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Criar diretórios temporários se necessário (no sistema de arquivos)
-- Estes comandos devem ser executados no sistema operacional:
-- mkdir -p /tmp
-- 
-- Arquivos de exemplo que podem ser necessários:
-- 1. /tmp/foomatic.xml - arquivo XML de exemplo
-- 2. /tmp/MOCK_DATA.json - dados JSON de exemplo do mockaroo.com
-- 3. /tmp/fortunes - arquivo de texto com frases/citações

-- Mensagem de setup concluído
SELECT 'Setup do schema nonrelational_examples concluído!' as status;
SELECT 'Para usar este schema, execute: SET search_path TO nonrelational_examples, public;' as instrucao;
