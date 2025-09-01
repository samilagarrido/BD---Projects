USE default_keyspace;

-- Tabela 1: Pessoa
CREATE TABLE IF NOT EXISTS pessoa (
    id UUID PRIMARY KEY,
    nome TEXT,
    idade INT,
    contatos TUPLE<TEXT, TEXT>, -- tupla: (email, telefone)
    hobbies LIST<TEXT>,         -- lista de hobbies
    idiomas SET<TEXT>,          -- conjunto de idiomas
    documentos MAP<TEXT, TEXT>  -- mapa: tipo -> número
);

-- Tabela 2: Produto
CREATE TABLE IF NOT EXISTS produto (
    codigo TEXT PRIMARY KEY,
    nome TEXT,
    preco DECIMAL,
    caracteristicas TUPLE<TEXT, INT>, -- tupla: (cor, peso)
    tags LIST<TEXT>,                 -- lista de tags
    categorias SET<TEXT>,            -- conjunto de categorias
    fornecedores MAP<TEXT, TEXT>     -- mapa: fornecedor -> contato
);

-- Inserindo 5 pessoas
INSERT INTO pessoa (id, nome, idade, contatos, hobbies, idiomas, documentos) VALUES (uuid(), 'Ana', 25, ('ana@email.com', '11999999999'), ['leitura', 'natação'], {'português', 'inglês'}, {'RG':'123456', 'CPF':'11122233344'});
INSERT INTO pessoa (id, nome, idade, contatos, hobbies, idiomas, documentos) VALUES (uuid(), 'Bruno', 30, ('bruno@email.com', '21988888888'), ['futebol', 'cinema'], {'português', 'espanhol'}, {'RG':'654321', 'CPF':'55566677788'});
INSERT INTO pessoa (id, nome, idade, contatos, hobbies, idiomas, documentos) VALUES (uuid(), 'Carla', 28, ('carla@email.com', '31977777777'), ['dança', 'música'], {'português', 'francês'}, {'RG':'789123', 'CPF':'99988877766'});
INSERT INTO pessoa (id, nome, idade, contatos, hobbies, idiomas, documentos) VALUES (uuid(), 'Diego', 35, ('diego@email.com', '41966666666'), ['corrida', 'xadrez'], {'português', 'alemão'}, {'RG':'321987', 'CPF':'44433322211'});
INSERT INTO pessoa (id, nome, idade, contatos, hobbies, idiomas, documentos) VALUES (uuid(), 'Eva', 22, ('eva@email.com', '51955555555'), ['pintura', 'yoga'], {'português', 'italiano'}, {'RG':'456789', 'CPF':'22233344455'});

-- Inserindo 5 produtos
INSERT INTO produto (codigo, nome, preco, caracteristicas, tags, categorias, fornecedores) VALUES ('P001', 'Notebook', 3500.00, ('preto', 2000), ['eletrônico', 'portátil'], {'informática', 'tecnologia'}, {'Dell':'dell@email.com', 'HP':'hp@email.com'});
INSERT INTO produto (codigo, nome, preco, caracteristicas, tags, categorias, fornecedores) VALUES ('P002', 'Cadeira', 450.00, ('azul', 7000), ['móvel', 'escritório'], {'móveis', 'conforto'}, {'TokStok':'contato@tokstok.com', 'Etna':'contato@etna.com'});
INSERT INTO produto (codigo, nome, preco, caracteristicas, tags, categorias, fornecedores) VALUES ('P003', 'Caneta', 5.50, ('vermelha', 10), ['papelaria', 'escolar'], {'escritório', 'material'}, {'Bic':'bic@email.com'});
INSERT INTO produto (codigo, nome, preco, caracteristicas, tags, categorias, fornecedores) VALUES ('P004', 'Celular', 2500.00, ('prata', 180), ['eletrônico', 'comunicação'], {'tecnologia', 'mobile'}, {'Samsung':'samsung@email.com', 'Apple':'apple@email.com'});
INSERT INTO produto (codigo, nome, preco, caracteristicas, tags, categorias, fornecedores) VALUES ('P005', 'Mesa', 800.00, ('branca', 15000), ['móvel', 'sala'], {'móveis', 'decoração'}, {'TokStok':'contato@tokstok.com'});

-- Atualizações (exemplo, lembre-se de usar o id real)
-- UPDATE pessoa SET idade = 26 WHERE id = <id_da_pessoa>;
-- UPDATE pessoa SET hobbies = hobbies + ['viajar'] WHERE id = <id_da_pessoa>;
-- UPDATE produto SET preco = 3600.00 WHERE codigo = 'P001';

-- Operações primitivas em colunas de coleção (exemplo, lembre-se de usar o id real)
-- UPDATE pessoa SET contatos = ('novo@email.com', '11911112222') WHERE id = <id_da_pessoa>;
-- UPDATE pessoa SET hobbies = hobbies + ['fotografia'] WHERE id = <id_da_pessoa>;
-- UPDATE pessoa SET hobbies = hobbies - ['dança'] WHERE id = <id_da_pessoa>;
-- UPDATE pessoa SET idiomas = idiomas + {'japonês'} WHERE id = <id_da_pessoa>;
-- UPDATE pessoa SET idiomas = idiomas - {'alemão'} WHERE id = <id_da_pessoa>;
-- UPDATE pessoa SET documentos = {'RG':'000000', 'CPF':'99999999999'} WHERE id = <id_da_pessoa>;
-- UPDATE pessoa SET documentos = documentos + {'CNH':'12312312300'} WHERE id = <id_da_pessoa>;
-- UPDATE pessoa SET documentos = documentos - {'RG'} WHERE id = <id_da_pessoa>;
-- UPDATE produto SET caracteristicas = ('azul', 2100) WHERE codigo = 'P001';

-- Consultas SELECT
SELECT * FROM pessoa WHERE idade > 25 ALLOW FILTERING;
SELECT * FROM produto WHERE categorias CONTAINS 'tecnologia' ALLOW FILTERING;
SELECT * FROM pessoa WHERE idiomas CONTAINS 'inglês' ALLOW FILTERING;

-- Índice secundário
CREATE INDEX IF NOT EXISTS idx_pessoa_idade ON pessoa (idade);
