
SET search_path TO nonrelational_examples, public;

-- ========================================
-- 1. ARRAYS - Demonstração de arrays em PostgreSQL
-- ========================================

CREATE TABLE employee 
(name TEXT PRIMARY KEY, certifications TEXT[]);

INSERT INTO employee
VALUES ('Bill', '{"CCNA", "ACSP", "CISSP"}');

SELECT * FROM employee;

-- Buscar por elementos específicos no array
SELECT name
FROM employee
WHERE certifications @> '{ACSP}';

-- Acessar elemento específico do array
SELECT certifications[1]
FROM employee;

-- Expandir array em linhas
SELECT unnest(certifications)
FROM employee;

-- Expandir array mantendo relação com o nome
SELECT name, unnest(certifications)
FROM employee;

-- Exemplos de agregação com arrays
SELECT DISTINCT relkind
FROM pg_class
ORDER BY 1;

SELECT array_agg(DISTINCT relkind)
FROM pg_class;

-- ========================================
-- 2. RANGES - Trabalho com intervalos de tempo
-- ========================================

CREATE TABLE car_rental 
(id SERIAL PRIMARY KEY, time_span TSTZRANGE);

INSERT INTO car_rental
VALUES (DEFAULT, '[2016-05-03 09:00:00, 2016-05-11 12:00:00)');

-- Verificar se um momento específico está no intervalo
SELECT *
FROM car_rental
WHERE time_span @> '2016-05-09 00:00:00'::timestamptz;

-- Teste com data fora do intervalo
SELECT *
FROM car_rental
WHERE time_span @> '2018-06-09 00:00:00'::timestamptz;

-- Inserir múltiplos intervalos usando generate_series
INSERT INTO car_rental (time_span)
SELECT tstzrange(y, y + '1 day')
FROM generate_series('2001-09-01 00:00:00'::timestamptz,
                     '2010-09-01 00:00:00'::timestamptz, '1 day') AS x(y);

-- Buscar rentals que incluem uma data específica
SELECT *
FROM car_rental
WHERE time_span @> '2007-08-01 00:00:00'::timestamptz;

-- Criar índice para melhor performance
CREATE INDEX car_rental_idx ON car_rental
USING GIST (time_span);

-- Adicionar constraint para evitar overlaps
ALTER TABLE car_rental ADD EXCLUDE USING GIST (time_span WITH &&);

-- Tentar inserir um overlap (deve falhar)
-- INSERT INTO car_rental
-- VALUES (DEFAULT, '[2003-04-01 00:00:00, 2003-04-01 00:00:01)');

-- ========================================
-- 3. GEOMETRIC DATA - Tipos geométricos
-- ========================================

CREATE TABLE dart (dartno SERIAL, location POINT);

-- Inserir pontos aleatórios
INSERT INTO dart (location)
SELECT CAST('(' || random() * 100 || ',' ||
            random() * 100 || ')' AS point)
FROM generate_series(1, 1000);

SELECT *
FROM dart
LIMIT 5;

-- Encontrar dardos dentro de um círculo
SELECT *
FROM dart
WHERE location <@ '<(50, 50), 4>'::circle;

-- Criar índice para consultas geométricas
CREATE INDEX dart_idx ON dart
USING GIST (location);

-- Encontrar os 2 dardos mais próximos de um ponto
SELECT *
FROM dart
ORDER BY location <-> '(50, 50)'::point
LIMIT 2;

-- ========================================
-- 4. XML DATA - Processamento de XML
-- ========================================

CREATE TABLE printer (doc XML);

-- precisa de um arquivo XML
-- ex de como criar um arquivo XML simples (powershwll):
/*
-- 
@"
<?xml version="1.0"?>
<options>
  <option>
    <arg_shortname><en>duplex</en></arg_shortname>
    <driver>hp1020</driver>
  </option>
  <option>
    <arg_shortname><en>quality</en></arg_shortname>
    <driver>hp1020</driver>
  </option>
</options>
"@ | Out-File -FilePath "C:\temp\foomatic.xml" -Encoding UTF8
*/

-- COPY printer from 'C:\temp\foomatic.xml'; -- Descomente se tiver o arquivo

-- Exemplos de consultas XPath (funcionarão quando tiver dados)
-- SELECT (xpath('/option/arg_shortname/en', doc))
-- FROM printer
-- LIMIT 5;

-- SELECT (xpath('/option/arg_shortname/en', doc))[1]
-- FROM printer
-- LIMIT 5;

-- ========================================
-- 5. JSON/JSONB DATA - Dados semi-estruturados
-- ========================================

-- Primeiro com JSON
CREATE TABLE friend (id SERIAL, data JSON);

-- Inserir dados JSON de exemplo
INSERT INTO friend (data) VALUES 
('{"first_name": "João", "last_name": "Silva", "email": "joao@email.com", "gender": "Male", "ip_address": "192.168.1.1"}'),
('{"first_name": "Maria", "last_name": "Santos", "email": "maria@email.com", "gender": "Female", "ip_address": "172.16.0.1"}'),
('{"first_name": "Pedro", "last_name": "Banks", "email": "pedro@email.com", "gender": "Male", "ip_address": "10.0.0.1"}'),
('{"first_name": "Ana", "last_name": "Costa", "email": "ana@email.com", "gender": "Female", "ip_address": "172.17.0.1"}'),
('{"first_name": "Carlos", "last_name": "Banks", "email": "carlos@email.com", "gender": "Male", "ip_address": "62.212.235.80"}');

-- Visualizar dados
SELECT *
FROM friend
ORDER BY 1
LIMIT 2;

-- Formatação bonita do JSON
SELECT id, jsonb_pretty(data::jsonb)
FROM friend
ORDER BY 1
LIMIT 1;

-- Extrair campos específicos
SELECT data->>'email'
FROM friend
ORDER BY 1
LIMIT 5;

-- Concatenar campos JSON
SELECT data->>'first_name' || ' ' || (data->>'last_name')
FROM friend
ORDER BY 1
LIMIT 5;

-- Buscar por campo específico
SELECT data->>'first_name'
FROM friend
WHERE data->>'last_name' = 'Banks'
ORDER BY 1;

-- Usar operador de contenção JSON
SELECT data->>'first_name'
FROM friend
WHERE data::jsonb @> '{"last_name" : "Banks"}'
ORDER BY 1;

-- Criar índice para campo específico
CREATE INDEX friend_idx ON friend ((data->>'last_name'));

-- Consultas com IP addresses
SELECT data->>'first_name' || ' ' || (data->>'last_name'),
       data->>'ip_address'
FROM friend
WHERE (data->>'ip_address')::inet <<= '172.0.0.0/8'::cidr
ORDER BY 1;

-- Agrupamento por gênero
SELECT data->>'gender', COUNT(data->>'gender')
FROM friend
GROUP BY 1
ORDER BY 2 DESC;

-- Diferença entre JSON e JSONB
SELECT '{"name" : "Jim", "name" : "Andy", "age" : 12}'::json;
SELECT '{"name" : "Jim", "name" : "Andy", "age" : 12}'::jsonb;

-- Tabela com JSONB para melhor performance
CREATE TABLE friend2 (id SERIAL, data JSONB);

INSERT INTO friend2
SELECT * FROM friend;

-- Índice GIN para JSONB
CREATE INDEX friend2_idx ON friend2
USING GIN (data);

-- Consultas otimizadas com JSONB
SELECT data->>'first_name'
FROM friend2
WHERE data @> '{"last_name" : "Banks"}'
ORDER BY 1;

-- ========================================
-- 6. COMPOSITE TYPES - Tipos compostos
-- ========================================

CREATE TYPE drivers_license AS 
(state CHAR(2), id INTEGER, valid_until DATE);

CREATE TABLE truck_driver 
(id SERIAL, name TEXT, license DRIVERS_LICENSE);

INSERT INTO truck_driver
VALUES (DEFAULT, 'Jimbo Biggins', ('PA', 175319, '2017-03-12'));

SELECT *
FROM truck_driver;

-- Acessar campos do tipo composto
SELECT (license).state
FROM truck_driver;

-- ========================================
-- 7. FULL-TEXT SEARCH - Busca textual
-- ========================================

CREATE TABLE fortune (line TEXT);

-- Inserir algumas frases de exemplo
INSERT INTO fortune VALUES 
('A bird in the hand is worth two in the bush'),
('The early bird catches the worm'),
('Don''t count your chickens before they hatch'),
('Actions speak louder than words'),
('Better late than never'),
('The cat is out of the bag'),
('Curiosity killed the cat'),
('Every cloud has a silver lining'),
('Rome wasn''t built in a day'),
('When in Rome, do as the Romans do'),
('Mop the floor carefully'),
('Mop up the mess quickly'),
('underdog'),
('Underdog saves the day'),
('So much for the plan we had');

-- Demonstrar busca básica
SELECT * FROM fortune WHERE line = 'underdog';
SELECT * FROM fortune WHERE line = 'Underdog';
SELECT * FROM fortune WHERE lower(line) = 'underdog';

-- Índices para texto
CREATE INDEX fortune_idx_text ON fortune (line);
CREATE INDEX fortune_idx_lower ON fortune (lower(line));

-- Busca com LIKE
SELECT line
FROM fortune
WHERE line LIKE 'Mop%'
ORDER BY 1;

-- Índice para pattern matching
CREATE INDEX fortune_idx_ops ON fortune (line text_pattern_ops);
CREATE INDEX fortune_idx_ops_lower ON fortune (lower(line) text_pattern_ops);

-- Full-text search
SHOW default_text_search_config;

SELECT to_tsvector('I can hardly wait.');
SELECT to_tsquery('hardly & wait');

SELECT to_tsvector('I can hardly wait.') @@
       to_tsquery('hardly & wait');

-- Índice para full-text search
CREATE INDEX fortune_idx_ts ON fortune
USING GIN (to_tsvector('english', line));

-- Busca com operadores textuais
SELECT line
FROM fortune
WHERE line ILIKE '%verit%'
ORDER BY 1;

-- ========================================
-- 8. TRIGRAM SEARCH - Busca por similaridade
-- ========================================

-- Extensão já foi criada no setup
CREATE INDEX fortune_idx_trgm ON fortune
USING GIN (line gin_trgm_ops);

-- Busca por similaridade
SELECT show_limit();

SELECT line, similarity(line, 'So much for the plan')
FROM fortune
WHERE line % 'So much for the plan'
ORDER BY 2 DESC;

-- Busca com regex case-insensitive
SELECT line
FROM fortune
WHERE line ~* '(^|[^a-z])cat'
ORDER BY 1;

-- ========================================
-- COMANDOS DE ANÁLISE E INFORMAÇÕES
-- ========================================

-- Informações sobre tabelas
-- \dt+ fortune
-- \d fortune
-- \di+
-- \do @>

SELECT 'Demonstração de recursos não-relacionais do PostgreSQL concluída!' as status;
SELECT 'Todas as tabelas foram criadas no schema: nonrelational_examples' as info;
