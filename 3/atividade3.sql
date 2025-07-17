--Tarefa 3 - Samila Garrido

--Atividade 1

--criei as tabelas e inseri os dados conforme o pdf de instruções

CREATE TABLE TABELA_A (
    CODIGO INT PRIMARY KEY,
    NOME VARCHAR(50)
);

CREATE TABLE TABELA_B (
    ID INT PRIMARY KEY,
    CODIGO INT,
    VALOR DECIMAL(10,3)
);


INSERT INTO TABELA_A (CODIGO, NOME) VALUES
(1, 'UM'),
(2, 'DOIS'),
(3, 'TRES'),
(4, 'QUATRO'),
(5, 'CINCO');

INSERT INTO TABELA_B (ID, CODIGO, VALOR) VALUES
(1, 1, 1.000),
(2, 1, 2.000),
(3, 1, 5.000),
(4, 2, 4.000),
(5, 2, 9.000),
(6, 3, 7.000),
(7, 5, 4.000),
(8, 8, 7.000);

-- Atividade 1) 

-- 1. INNER JOIN (retorna apenas os registros que têm correspondência em ambas as tabelas)

SELECT A.CODIGO, A.NOME, B.ID, B.VALOR
FROM TABELA_A A
INNER JOIN TABELA_B B ON A.CODIGO = B.CODIGO;

-- QUATRO (código 4) não aparece porque não tem registros na TABELA_B
-- Registro com código 8 da TABELA_B não aparece porque não existe na TABELA_A


-- 2. LEFT OUTER JOIN (LEFT JOIN)( retorna todos os registros da tabela à esquerda (TABELA_A) e os registros correspondentes da tabela à direita (TABELA_B))

SELECT A.CODIGO, A.NOME, B.ID, B.VALOR
FROM TABELA_A A
LEFT OUTER JOIN TABELA_B B ON A.CODIGO = B.CODIGO;


-- QUATRO (código 4) aparece com valores NULL porque não tem registros na TABELA_B
--  Registro com código 8 da TABELA_B não aparece porque não existe na TABELA_A


-- 3. RIGHT OUTER JOIN (RIGHT JOIN) (retorna todos os registros da tabela à direita (TABELA_B) e os registros correspondentes da tabela à esquerda (TABELA_A))

SELECT A.CODIGO, A.NOME, B.ID, B.VALOR
FROM TABELA_A A
RIGHT OUTER JOIN TABELA_B B ON A.CODIGO = B.CODIGO;

-- QUATRO (código 4) não aparece porque não há JOIN com TABELA_B
-- Registro com código 8 da TABELA_B aparece com valores NULL para TABELA_A


-- 4. FULL OUTER JOIN (FULL JOIN) (retorna todos os registros de ambas as tabelas, com NULL onde não há correspondência)

SELECT A.CODIGO, A.NOME, B.ID, B.VALOR
FROM TABELA_A A
FULL OUTER JOIN TABELA_B B ON A.CODIGO = B.CODIGO;


-- Todos os registros de ambas as tabelas aparecem
-- QUATRO (código 4) aparece com NULL na TABELA_B
-- Código 8 da TABELA_B aparece com NULL na TABELA_A

-- análise

-- INNER JOIN:     7 registros (apenas com correspondência em ambas)
-- LEFT JOIN:      8 registros (todos da TABELA_A + correspondências)
-- RIGHT JOIN:     8 registros (todos da TABELA_B + correspondências)
-- FULL OUTER:     9 registros (todos de ambas as tabelas)





---- Atividade 2) Funções agregadas e nativas



-- a) Recupere a média salarial de todos os empregados do sexo feminino.

select avg(e.salario)
from empregado as e 
where e.sexo = 'F';


-- b) Mostre o número de empregados por supervisor

select e.superssn, count(e.ssn)
from empregado as e 
group by e.superssn
having e.superssn notnull;


-- c) Mostre o maior número de horas envolvido em projetos

select max(t.horas)
from trabalha as t;


-- d) Para cada projeto, liste o nome do projeto e o total de horas por semana (de todos os empregados) gastas no projeto.

select 
    p.pjnome,
    sum(t.horas) as Total_Horas
from 
    projeto p
join 
    trabalha t on p.pnumero = t.pno
group by 
    p.pjnome;

-- e) Para cada departamento, recupere o nome do departamento e a média salarial de todos os empregados que trabalham nesse departamento.
   
select 
    d.dnome as nome_departamento,
    avg(e.salario) as media_salarial
from 
    departamento d
join 
    empregado e on d.dnumero = e.dno
group by 
    d.dnome;

   
-- f) Liste os nomes de todos os empregados com dois ou mais dependentes
  
select 
    e.pnome as primeiro_nome,
    e.unome as ultimo_nome
from 
    empregado e
join 
    dependente d on e.ssn = d.essn
group by 
    e.pnome, e.unome
having 
    count(d.nomedep) >= 2;


-- g) Nome do departamento com o menor número de projetos associados
   
select 
    d.dnome as nome_departamento
from 
    departamento d
join 
    projeto p on d.dnumero = p.dnum
group by 
    d.dnome
order by 
    count(p.pnumero) asc
limit 1;


-- h) Consulta que retorne do 10º ao 22º caractere do endereço do empregado

select 
    substring(endereco from 10 for 13) as endereco_parcial
from 
    empregado;

   
-- i) Consulta que retorne apenas o mês de nascimento de cada funcionário
   
select 
    extract(month from datanasc) as mes_nascimento
from 
    empregado;


-- j) Idade do empregado quando o dependente de parentesco filho ou filha nasceu

 select 
    e.pnome as primeiro_nome,
    e.unome as ultimo_nome,
    extract(year from (d.datanascdep - e.datanasc)) as idade_quando_filho_nasceu
from 
    empregado e
join 
    dependente d on e.ssn = d.essn
where 
    d.parentesco in ('FILHO', 'FILHA');


-- k) Consulta que conte o número de dependentes por ano de nascimento

select 
    extract(year from datanascdep) as ano_nascimento,
    count(*) as numero_dependentes
from 
    dependente
group by 
    extract(year from datanascdep)
order by 
    ano_nascimento;


-- l) Nome de supervisores que tenham 2 ou mais supervisionados	

select 
    e.pnome as primeiro_nome,
    e.unome as ultimo_nome
from 
    empregado e
join 
    empregado sup on e.ssn = sup.superssn
group by 
    e.pnome, e.unome
having 
    count(sup.ssn) >= 2;


-- m) Escreva uma consulta que mostre o valor mensal a ser pago por projeto (considere que a coluna ‘salário’ de empregado é mensal).

select 
    p.pjnome as nome_projeto,
    sum(e.salario * t.horas / 160) as valor_mensal_pago
from 
    projeto p
join 
    trabalha t on p.pnumero = t.pno
join 
    empregado e on t.essn = e.ssn
group by 
    p.pjnome;





--- Atividade 3) – Subconsultas

-- a) Recupere nome (pnome e unome) de cada um dos empregados que tenham um dependente cujo primeiro nome e sexo sejam o mesmo do empregado em questão.

select 
    e.pnome, e.unome
from 
    empregado e
where 
    exists (
        select 
            1
        from 
            dependente d
        where 
            d.essn = e.ssn
            and d.nomedep = e.pnome
            and d.sexodep = e.sexo
    );


-- b) Recupere os nomes dos empregados (pnome e unome) cujos salários são maiores que a média dos salários dos empregados do departamento 5.

select 
    e.pnome, e.unome
from 
    empregado e
where 
    e.salario > (
        select 
            avg(e2.salario)
        from 
            empregado e2
        where 
            e2.dno = '5'
    );
   
   

-- c) Retorne o número do seguro social (SSN) de todos os empregados que trabalham com a mesma combinação (projeto, horas) em algum dos projetos em que o empregado ‘Fabio Will’ (SSN= 333445555) trabalhe.
   
select 
    t2.essn
from 
    trabalha t2
where 
    exists (
        select 
            1
        from 
            trabalha t1
        where 
            t1.essn = '333445555'
            and t1.pno = t2.pno
            and t1.horas = t2.horas
            and t2.essn <> '333445555'
    );
   


-- d) Recupere os nomes de todos os empregados que não trabalham em nenhum projeto.
   
select 
    e.pnome, e.unome
from 
    empregado e
where 
    not exists (
        select 
            1
        from 
            trabalha t
        where 
            t.essn = e.ssn
    );
   


-- e) Recupere o nome de empregados que não tenham dependentes.
   
select 
    e.pnome, e.unome
from 
    empregado e
where 
    not exists (
        select 
            1
        from 
            dependente d
        where 
            d.essn = e.ssn
    );
   


-- f) Liste o último nome de todos os gerentes de departamento que não tenham dependentes.
   
select 
    e.unome
from 
    empregado e
where 
    exists (
        select 
            1
        from 
            departamento d
        where 
            d.gerssn = e.ssn
    )
    and not exists (
        select 
            1
        from 
            dependente dep
        where 
            dep.essn = e.ssn
    );
   


-- g) Liste os nomes dos gerentes que tenham, pelo menos, um dependente.
   
select 
    e.pnome, e.unome
from 
    empregado e
where 
    exists (
        select 
            1
        from 
            departamento d
        where 
            d.gerssn = e.ssn
    )
    and exists (
        select 
            1
        from 
            dependente dep
        where 
            dep.essn = e.ssn
    );


-- Atividade 4) Visões


-- a) Crie a visão chamada TRABALHA_EM que deverá conter os campos pnome e unome da tabela empregado, o campo pjnome da tabela projeto e o campo horas da tabela trabalha.

create view trabalha_em as
select 
    e.pnome, e.unome, p.pjnome, t.horas
from 
    empregado e
join 
    trabalha t on e.ssn = t.essn
join 
    projeto p on t.pno = p.pnumero;


-- b) Crie uma consulta SQL na visão implementada no item a que retorne o último e o primeiro nome de todos os empregados que trabalham no ‘ProdutoX’.

select 
    unome, pnome
from 
    trabalha_em
where 
    pjnome = 'ProdutoX';


-- c) Exclua a visão criada no item a.

drop view if exists trabalha_em;


-- d) Crie uma visão chamada DEPTO_INFO que deverá conter os campos dnome da tabela departamento, e o total de empregados e somatório dos salários dos empregados da tabela empregado por departamento.

create view depto_info as
select 
    d.dnome,
    count(e.ssn) as total_empregados,
    sum(e.salario) as soma_salarios
from 
    departamento d
join 
    empregado e on d.dnumero = e.dno
group by 
    d.dnome;


-- e) Crie uma consulta SQL na visão implementada no item d que retorne a lista de informações por departamentos ordenados pelo somatório dos salários.

select 
    dnome, total_empregados, soma_salarios
from 
    depto_info
order by 
    soma_salarios desc;


-- f) Exclua as visões criadas nos itens a.

drop view if exists depto_info;