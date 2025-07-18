--Atividade 4 - Samila Garrido


-- instalar a extensão PostGIS (necessário para o tipo GEOMETRY)
CREATE EXTENSION IF NOT EXISTS postgis;


CREATE TABLE aluno (
    matricula SERIAL PRIMARY KEY,
    curso VARCHAR(100) NOT NULL,
    idade INT NOT NULL,
    cre NUMERIC(4,2),
    disciplinas JSONB,
    data_ingresso TIMESTAMP NOT NULL DEFAULT now(),
    localizacao GEOMETRY(Point, 4326)
);

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- a) SELECT * FROM aluno WHERE cre = 5.0
-- tipo de Índice: B-Tree Index
-- consulta de igualdade exata - B-Tree é ideal para comparações de igualdade e range 
-- CRE é um valor numérico com boa distribuição

CREATE INDEX idx_aluno_cre ON aluno (cre);

-----------------------------------------------------------------------------------------------------------------------------------------------------------------


--b) SELECT * FROM aluno WHERE idade < 70

--B-Tree Index

CREATE INDEX idx_aluno_idade ON aluno (idade);

-- consulta de range (menor que)
-- B-Tree suporta eficientemente operadores <, <=, >, >=
-- permite varredura ordenada dos valores

-----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- c) SELECT * FROM aluno WHERE idade > 27 AND cre < 3.0

-- Índice Composto B-Tree
CREATE INDEX idx_aluno_idade_cre ON aluno (idade, cre);

-- Consulta com múltiplas condições AND usando condições de range
-- Índice composto permite filtrar eficientemente por ambas as colunas
-- Ordem otimizada: IDADE primeiro por ter maior seletividade esperada
-- idade > 27 provavelmente filtra menos registros que cre < 3.0
-- Permite ao PostgreSQL usar o índice de forma mais eficiente

--porém ao analisar os dados poderia ser também:

--CREATE INDEX idx_aluno_cre_idade ON aluno (cre, idade);

-- Ordem: CRE primeiro assumindo que cre < 3.0 é mais seletivo
-- (válido se a maioria dos alunos tiver CRE >= 3.0)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------


--d) SELECT AVG(idade) FROM aluno

--B-Tree Index

-- Função agregada sobre toda a tabela sem WHERE clause
-- PostgreSQL precisa ler todos os valores de idade de qualquer forma
-- Índice em idade pode oferecer benefício marginal para ordenação interna
-- Mas geralmente não é necessário para agregações simples

--mas se for preciso criar o índice, ficaria assim:
--alterei o nome do índice para evitar duplicidade com a index da letra b)

CREATE INDEX idx_aluno_idade_avg ON aluno (idade);

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

--e) SELECT idade, count(*) FROM aluno WHERE curso = "Computação" GROUP BY idade

--Índice Composto B-Tree

CREATE INDEX idx_aluno_curso_idade ON aluno (curso, idade);

-- filtragem por curso + agrupamento por idade
-- índice composto otimiza tanto o WHERE quanto o GROUP BY
-- evita ordenação adicional para o agrupamento
-- curso como primeira coluna por ser usado no WHERE (mais seletivo)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------


--f) SELECT * FROM aluno WHERE disciplinas @> '[{"nome": "Cálculo I"}]'

-- GIN Index

CREATE INDEX idx_aluno_disciplinas_gin ON aluno USING GIN (disciplinas);

-- operador @> (contém) em dados JSONB
-- GIN (Generalized Inverted Index) é otimizado para tipos de dados complexos
-- suporta eficientemente operadores JSONB como @>, ?, ?&, ?|

-----------------------------------------------------------------------------------------------------------------------------------------------------------------


--g) SELECT * FROM aluno WHERE data_ingresso BETWEEN '2024-01-01' AND '2024-12-31'

--B-Tree Index

CREATE INDEX idx_aluno_data_ingresso ON aluno (data_ingresso);

-- consulta de range em dados temporais
-- B-Tree é ideal para operações BETWEEN
-- TIMESTAMP tem boa ordenação natural

-----------------------------------------------------------------------------------------------------------------------------------------------------------------


--h) SELECT * FROM aluno WHERE ST_DWithin(localizacao, ST_MakePoint(-34.88, -7.12)::GEOMETRY, 1000)

--GIST Index

CREATE INDEX idx_aluno_localizacao_gist ON aluno USING GIST (localizacao);

-- consulta espacial com função ST_DWithin
-- GIST (Generalized Search Tree) é otimizado para dados geométricos
-- suporta eficientemente operadores espaciais do PostGIS
