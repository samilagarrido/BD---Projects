-- ----------------------------
-- Table structure for EMPREGADO
-- ----------------------------
CREATE TABLE EMPREGADO (
  ssn char(9) NOT NULL,
  pnome varchar(30) NOT NULL,
  inicialm char(1) default NULL,
  unome varchar(30) NOT NULL,
  sexo char(1) NOT NULL,
  endereco varchar(50) default NULL,
  datanasc date default NULL,
  superssn char(9) default NULL,
  dno char(1) NOT NULL,
  salario float default NULL,
  PRIMARY KEY  (ssn)
) ;

-- ----------------------------
-- Records of EMPREGADO
-- ----------------------------
INSERT INTO EMPREGADO VALUES ('123456789', 'Joao', 'B', 'Souza', 'M', 'R. 24 de maio, 1500 - Curitiba - PR', '1965-01-09', '333445555', '5', '30000.00');
INSERT INTO EMPREGADO VALUES ('333445555', 'Fabio', 'T', 'Will', 'M', 'R. Alagoas, 325 - Curitiba - PR', '1955-12-08', '888665555', '5', '40000.00');
INSERT INTO EMPREGADO VALUES ('999887777', 'Alice', 'J', 'Zebra', 'F', 'R. Ribeira, 98 - Pinhais - PR', '1968-01-19', '987654321', '4', '25000.00');
INSERT INTO EMPREGADO VALUES ('987654321', 'Jennifer', 'S', 'Wallace', 'F', 'R. Berry, 291 - Colombo - PR', '1941-06-20', '888665555', '4', '43000.00');
INSERT INTO EMPREGADO VALUES ('666884444', 'Ricardo', 'K', 'Nantes', 'M', 'Av. Figueira, 55 - Almirante Tamandare - PR', '1962-09-15', '333445555', '5', '38000.00');
INSERT INTO EMPREGADO VALUES ('453453453', 'Jussara', 'A', 'Pereira', 'F', 'Trav. da Lapa, 23 - Curitiba - PR', '1972-07-31', '333445555', '5', '25000.00');
INSERT INTO EMPREGADO VALUES ('987987987', 'Alberto', 'V', 'Medeiros', 'M', 'R. Ceará, 1245 - Curitiba - PR', '1969-03-29', '987654321', '4', '25000.00');
INSERT INTO EMPREGADO VALUES ('888665555', 'Joaquim', 'E', 'Brito', 'M', 'R. Stone, 450 - Curitiba - PR', '1937-11-10', null, '1', '55000.00');

-- ----------------------------
-- Table structure for DEPARTAMENTO
-- ----------------------------

CREATE TABLE DEPARTAMENTO (
  dnumero char(1) NOT NULL,
  dnome varchar(30) NOT NULL,
  gerssn char(9) NOT NULL,
  gerdatainicio date NOT NULL,
  PRIMARY KEY  (dnumero)
) ;

-- ----------------------------
-- Records of DEPARTAMENTO
-- ----------------------------
INSERT INTO DEPARTAMENTO VALUES ('5', 'Pesquisa', '333445555', '1988-05-22');
INSERT INTO DEPARTAMENTO VALUES ('4', 'Administracao', '987654321', '1995-01-01');
INSERT INTO DEPARTAMENTO VALUES ('1', 'Sede Administrativa', '888665555', '1981-06-19');

-- ----------------------------
-- Table structure for DEPENDENTE
-- ----------------------------

CREATE TABLE DEPENDENTE (
  essn char(9) NOT NULL,
  nomedep varchar(30) NOT NULL default '',
  sexodep char(1) NOT NULL,
  datanascdep date NOT NULL,
  parentesco varchar(30) NOT NULL,
  PRIMARY KEY  (essn,nomedep)
) ;

-- ----------------------------
-- Records of DEPENDENTE
-- ----------------------------
INSERT INTO DEPENDENTE VALUES ('333445555', 'Alice', 'F', '1986-04-05', 'FILHA');
INSERT INTO DEPENDENTE VALUES ('333445555', 'Teodoro', 'M', '1983-10-25', 'FILHO');
INSERT INTO DEPENDENTE VALUES ('333445555', 'Joana', 'F', '1958-05-03', 'CONJUGE');
INSERT INTO DEPENDENTE VALUES ('987654321', 'Abdala', 'M', '1942-02-28', 'CONJUGE');
INSERT INTO DEPENDENTE VALUES ('123456789', 'Michel', 'M', '1988-01-04', 'FILHO');
INSERT INTO DEPENDENTE VALUES ('123456789', 'Alice', 'F', '1988-12-30', 'FILHA');
INSERT INTO DEPENDENTE VALUES ('123456789', 'Elizabete', 'F', '1967-05-05', 'CONJUGE');

-- ----------------------------
-- Table structure for LOCALIZACAO
-- ----------------------------

CREATE TABLE LOCALIZACAO (
  dnum char(1) NOT NULL,
  dlocalizacao varchar(30) NOT NULL,
  PRIMARY KEY  (dnum,dlocalizacao)
) ;

-- ----------------------------
-- Records of LOCALIZACAO
-- ----------------------------
INSERT INTO LOCALIZACAO VALUES ('1', 'Curitiba');
INSERT INTO LOCALIZACAO VALUES ('4', 'Colombo');
INSERT INTO LOCALIZACAO VALUES ('5', 'Araucaria');
INSERT INTO LOCALIZACAO VALUES ('5', 'Curitiba');
INSERT INTO LOCALIZACAO VALUES ('5', 'Pinhais');

-- ----------------------------
-- Table structure for PROJETO
-- ----------------------------
CREATE TABLE PROJETO (
  pnumero char(2) NOT NULL,
  pjnome varchar(30) NOT NULL,
  plocal varchar(30) NOT NULL,
  dnum char(1) NOT NULL,
  PRIMARY KEY  (pnumero)
) ;

-- ----------------------------
-- Records of PROJETO
-- ----------------------------
INSERT INTO PROJETO VALUES ('1', 'ProdutoX', 'Pinhais', '5');
INSERT INTO PROJETO VALUES ('2', 'ProdutoY', 'Araucaria', '5');
INSERT INTO PROJETO VALUES ('3', 'ProdutoZ', 'Curitiba', '5');
INSERT INTO PROJETO VALUES ('10', 'Automatizacao', 'Pinhais', '4');
INSERT INTO PROJETO VALUES ('20', 'Reorganizacao', 'Curitiba', '1');
INSERT INTO PROJETO VALUES ('30', 'Novos Beneficios', 'Pinhais', '4');

-- ----------------------------
-- Table structure for TRABALHA
-- ----------------------------
CREATE TABLE TRABALHA (
  essn char(9) NOT NULL,
  pno char(2) NOT NULL,
  horas float default NULL,
  PRIMARY KEY  (essn,pno)
) ;

-- ----------------------------
-- Records of TRABALHA
-- ----------------------------
INSERT INTO TRABALHA VALUES ('123456789', '1', '32.5');
INSERT INTO TRABALHA VALUES ('123456789', '2', '7.5');
INSERT INTO TRABALHA VALUES ('666884444', '3', '40');
INSERT INTO TRABALHA VALUES ('453453453', '1', '20');
INSERT INTO TRABALHA VALUES ('453453453', '2', '20');
INSERT INTO TRABALHA VALUES ('333445555', '2', '10');
INSERT INTO TRABALHA VALUES ('333445555', '3', '10');
INSERT INTO TRABALHA VALUES ('333445555', '10', '10');
INSERT INTO TRABALHA VALUES ('333445555', '20', '10');
INSERT INTO TRABALHA VALUES ('999887777', '30', '30');
INSERT INTO TRABALHA VALUES ('999887777', '10', '10');
INSERT INTO TRABALHA VALUES ('987987987', '10', '35');
INSERT INTO TRABALHA VALUES ('987987987', '30', '5');
INSERT INTO TRABALHA VALUES ('987654321', '30', '20');
INSERT INTO TRABALHA VALUES ('987654321', '20', '15');
INSERT INTO TRABALHA VALUES ('888665555', '20', null);

-- ------------------------------
-- Restrições - CONSTRAINTS
-- ------------------------------
ALTER TABLE EMPREGADO ADD CONSTRAINT fk_empregado_empregado  FOREIGN KEY (superssn) REFERENCES  EMPREGADO (ssn);
ALTER TABLE EMPREGADO ADD CONSTRAINT fk_empregado_departamento FOREIGN KEY  (dno) REFERENCES  DEPARTAMENTO (dnumero) ;

ALTER TABLE DEPARTAMENTO ADD CONSTRAINT fk_departamento_empregado FOREIGN KEY (gerssn) REFERENCES  EMPREGADO (ssn) ;

ALTER TABLE DEPENDENTE ADD CONSTRAINT fk_dependente_empregado FOREIGN KEY (essn) REFERENCES EMPREGADO (ssn) ;

ALTER TABLE LOCALIZACAO ADD CONSTRAINT fk_localizacao_departamento FOREIGN KEY (dnum) REFERENCES  DEPARTAMENTO (dnumero) ;

ALTER TABLE PROJETO ADD CONSTRAINT fk_projeto_departamento FOREIGN KEY (dnum) REFERENCES  DEPARTAMENTO (dnumero) ;

ALTER TABLE TRABALHA ADD CONSTRAINT fk_trabalha_empregado FOREIGN KEY (essn) REFERENCES  EMPREGADO (ssn) ;
ALTER TABLE TRABALHA ADD CONSTRAINT fk_trabalha_projeto FOREIGN KEY (pno) REFERENCES  PROJETO (pnumero) ;
