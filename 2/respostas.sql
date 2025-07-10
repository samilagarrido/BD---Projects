--A
INSERT INTO empregado 
VALUES ('943775543', 'Roberto', 'F', 'Silva', 'M', 'Rua X, 22 – Araucária – PR', '1952-06-21',
        '888665555', '1', 58000);

--Success

--B
INSERT INTO projeto
VALUES ('4', 'ProdutoA', 'Araucaria', '2');

--ERROR:  23503: insert or update on table "projeto" violates foreign key constraint "fk_projeto_departamento"
--DETAIL:  Key (dnum)=(2) is not present in table "departamento". 
--Ou seja, retornou o erro porque não existe dnumero = 2 em departamento

--C
INSERT INTO DEPARTAMENTO
VALUES ('4', 'Produção', '943775543', '1998-10-01');
--ERROR:  23505: duplicate key value violates unique constraint "departamento_pkey"
--DETAIL:  Key (dnumero)=(4) already exists. _crypto_aead_det_decrypt
--O departamento 4 já existe, então não é possível cadastrar um novo departamento com esse identificador.
--a PK d 4 já existe. Não podemos duplicar chaves primárias

--D
INSERT INTO trabalha
VALUES ('677678989', null, 40.0);

-- ERROR:  23502: null value in column "pno" of relation "trabalha" violates not-null constraint
--DETAIL:  Failing row contains (677678989, null, 40).

-- coluna pno não pode conter nulos

--E

INSERT INTO dependente
VALUES ('453453453', 'Joao', 'M', '1970-12-12', 'CONJUGE');
--Success

--F
DELETE FROM trabalha
WHERE essn = '333445555';

--Success

--G
DELETE FROM empregado
WHERE ssn = '987654321';
--ERROR:  23503: update or delete on table "empregado" violates foreign key constraint "fk_empregado_empregado" on table "empregado"
--DETAIL:  Key (ssn)=(987654321) is still referenced from table "empregado".

-- não eh possível excluir essa PK porque ela ainda é referenciada como chave estrangeira na tabela dependente

--H
DELETE FROM projeto
WHERE pjnome = 'ProdutoX';
--ERROR:  23503: update or delete on table "projeto" violates foreign key constraint "fk_trabalha_projeto" on table "trabalha"
--DETAIL:  Key (pnumero)=(1 ) is still referenced from table "trabalha".

-- não é possível remover esse projeto porque ele ainda está sendo referenciado por empregados na tabela trabalha(há uma chave estrangeira (FK) que impede a exclusão)

--I
UPDATE departamento
SET gerssn = '123456789', gerdatainicio= '1999-01-10'
WHERE dnumero = '5';

--Success

--J
UPDATE empregado
SET superssn = '943775543'
WHERE ssn = '999887777';

--Success

--L
UPDATE trabalha
SET horas = 5.0
WHERE essn = '999887777' AND pno = '10';

--Success




--2








-- a) Mostre o número de segurança social do empregado, o nome do dependente e o parentesco, ordenado por ssn ascendente e parentesco descendente.

select essn, nomedep,  parentesco
from dependente
order by essn asc, parentesco desc;


-- b)  Mostre o nome e endereço de todos os empregados que trabalham para o departamento Pesquisa.


select e.pnome, e.endereco
from empregado as e
inner join departamento as d on e.dno = d.dnumero 
where d.dnome = 'Pesquisa';


-- c) Para todo projeto localizado em Araucaria, liste o nome do projeto, o nome do departamento de controle e o último nome, endereço e data de nascimento do gerente do departamento.


select p.pjnome, d.dnome, e.unome, e.endereco, e.datanasc
from empregado as e
inner join departamento as d on e.ssn = d.gerssn 
inner join projeto as p on p.dnum = d.dnumero
where p.plocal = 'Araucaria';

-- d) Recupere os nomes de todos os empregados que trabalhem mais de 10 horas por semana no projeto Automatizacao.


select e.pnome
from empregado as e
inner join trabalha as t on e.ssn = t.essn
inner join projeto as p on t.pno = p.pnumero 
where t.horas > 10.0 and p.pjnome = 'Automatizacao';


-- e) Mostre o nome dos empregados que têm os três maiores salários.


select pnome
from empregado
order by salario desc 
limit 3;


-- f) Mostre o nome e o salário dos supervisores com aumento de 20%.

select distinct e2.pnome, (e2.salario * 1.2) as salario_com_aumento 
from empregado as e1
inner join empregado as e2 on e1.superssn = e2.ssn;


-- g) Mostre os departamentos e suas localidades.


select d.dnome, l.dlocalizacao 
from departamento as d
inner join localizacao as l on d.dnumero = l.dnum;


-- h) Mostre os departamentos e seus projetos.


select d.dnome, p.pjnome
from departamento as d
inner join projeto as p on d.dnumero = p.dnum;


-- i)  Mostre os empregados do sexo feminino e a data de nascimento cujo salário é maior que 30.000.


select pnome, sexo, datanasc 
from empregado
where sexo = 'F' and salario > 30000.0;



-- j) Mostre os projetos em que o empregado 'Fábio' trabalha.


select p.pjnome 
from empregado as e
left join trabalha as t on e.ssn = t.essn
left join projeto as p on t.pno = p.pnumero
where e.pnome = 'Fabio'; --Fábio deve ser sem acento






--3







--a) Encontre todos os empregados cujo supervisor esteja alocado em um departamento diferente. Mostre o número de segurança social e o nome completo do empregado.

SELECT 
    e.ssn AS ssn_empregado,
    CONCAT(e.pnome, ' ', COALESCE(e.inicialm, ''), ' ', e.unome) AS nome_completo
FROM EMPREGADO e
INNER JOIN EMPREGADO s ON e.superssn = s.ssn  -- JOIN com supervisor
WHERE e.dno != s.dno  -- Departamentos diferentes
ORDER BY e.ssn;

--b)
SELECT 
    d.essn AS ssn_empregado,
    d.nomedep AS nome_dependente,
    d.parentesco
FROM DEPENDENTE d
ORDER BY 
    d.essn ASC,           -- SSN ascendente
    d.parentesco DESC;    -- Parentesco descendente

--c)


SELECT 
    CONCAT(e.pnome, ' ', COALESCE(e.inicialm, ''), ' ', e.unome) AS nome_empregado_supervisionado
FROM EMPREGADO e
INNER JOIN EMPREGADO s ON e.superssn = s.ssn  -- JOIN com supervisor
WHERE CONCAT(s.pnome, ' ', COALESCE(s.inicialm, ''), ' ', s.unome) = 'Joaquim E Brito'
ORDER BY e.pnome, e.unome;

--d)
-- Cenário 1: Projetos onde empregados com último nome 'Will' trabalham diretamente
SELECT DISTINCT
    p.pnumero AS numero_projeto,
    p.pjnome AS nome_projeto
FROM PROJETO p
INNER JOIN TRABALHA t ON p.pnumero = t.pno
INNER JOIN EMPREGADO e ON t.essn = e.ssn
WHERE e.unome = 'Will'

UNION

-- Cenário 2: Projetos controlados por departamentos gerenciados por empregados 'Will'
SELECT DISTINCT
    p.pnumero AS numero_projeto,
    p.pjnome AS nome_projeto
FROM PROJETO p
INNER JOIN DEPARTAMENTO d ON p.dnum = d.dnumero
INNER JOIN EMPREGADO e ON d.gerssn = e.ssn
WHERE e.unome = 'Will'

ORDER BY numero_projeto;

--e)

SELECT DISTINCT
    CONCAT(e.pnome, ' ', COALESCE(e.inicialm, ''), ' ', e.unome) AS nome_empregado,
    e.pnome,
    e.unome
FROM EMPREGADO e
INNER JOIN TRABALHA t ON e.ssn = t.essn
INNER JOIN PROJETO p ON t.pno = p.pnumero
WHERE p.dnum = '5'  -- projetos controlados pelo departamento 5
ORDER BY e.pnome, e.unome;

--f)
SELECT DISTINCT
    CONCAT(e.pnome, ' ', COALESCE(e.inicialm, ''), ' ', e.unome) AS nome_empregado,
    e.endereco
FROM EMPREGADO e
INNER JOIN TRABALHA t ON e.ssn = t.essn
INNER JOIN PROJETO p ON t.pno = p.pnumero
WHERE p.plocal = 'Curitiba'        -- projeto em curitiba
  AND NOT EXISTS (                 -- departamento NÃO tem localização em Curitiba
    SELECT 1 
    FROM LOCALIZACAO l 
    WHERE l.dnum = e.dno 
    AND l.dlocalizacao = 'Curitiba'
  )
ORDER BY nome_empregado;



