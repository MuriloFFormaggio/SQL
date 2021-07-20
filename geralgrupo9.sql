--Nome: Murilo Formaggio Feliciano PC3006875


--Tabelas pessoa,pessoa_fisica, morador,telefone, habitacao,tipomoradia e funcionario foram criadas por outros grupos


CREATE TABLE pessoa ( 

	pessoa_id SERIAL NOT NULL,
	nome VARCHAR(255) NOT NULL,
	nome_social VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL 

);

CREATE TABLE pessoa_fisica ( 

	p_fisica_id SERIAL NOT NULL,
	pessoa_id INTEGER NOT NULL,
	cpf VARCHAR(20) NOT NULL,
	rg VARCHAR(20) NOT NULL, 
	sexo varchar(1)	not null check(sexo = 'F' OR sexo = 'f' OR sexo = 'M' OR sexo = 'm')
);

create table morador
(
  	morador_id int not null,
	habitacao_id int not null,
	telefone_id int UNIQUE not null
);

create table telefone (

	telefone_id SERIAL not null,
	ramal varchar (10) not null,
	fixo varchar (15),
	celular varchar	(15) not null,
	whatsapp boolean not null
);

create table habitacao(
	
	habitacao_id SERIAL not null,
	tipomoradia_id int not null,
	rua varchar(10) not null,
	bloco varchar(1) not null,
	numero varchar(4) not null
);

create table tipomoradia(

	tipomoradia_id SERIAL not null,
	tipo varchar (20)
);
ALTER TABLE tipomoradia ADD CONSTRAINT pk_tipomoradia_id PRIMARY KEY(tipomoradia_id);
ALTER TABLE habitacao ADD CONSTRAINT pk_habitacao_id PRIMARY KEY(habitacao_id); 
ALTER TABLE habitacao add constraint fk_habitacao_tipomoradia foreign key (tipomoradia_id) references tipomoradia(tipomoradia_id) on delete cascade;
ALTER TABLE pessoa ADD CONSTRAINT pk_pessoa_id PRIMARY KEY(pessoa_id); 
ALTER TABLE pessoa_fisica ADD CONSTRAINT pk_p_fisica_id PRIMARY KEY(p_fisica_id); 
ALTER TABLE pessoa_fisica ADD CONSTRAINT fk_pessoa_pessoafisica FOREIGN KEY(pessoa_id) REFERENCES pessoa(pessoa_id);
ALTER TABLE morador ADD CONSTRAINT pk_morador_id PRIMARY KEY(morador_id); 
ALTER TABLE morador add constraint fk_morador_habitacao foreign key (habitacao_id) references habitacao(habitacao_id) on delete cascade;
ALTER TABLE morador ADD CONSTRAINT fk_morador_pessoafisica FOREIGN KEY(morador_id) REFERENCES pessoa_fisica(p_fisica_id);
ALTER TABLE telefone ADD CONSTRAINT pk_telefone_id PRIMARY KEY(telefone_id); 
ALTER TABLE telefone add constraint fk_morador_telefone foreign key (telefone_id) references telefone(telefone_id) on delete set default on update cascade;

CREATE TABLE funcionario( 
	cpf VARCHAR (14) not NULL UNIQUE, 
  	nome VARCHAR (60) not NULL, 
  	telefone VARCHAR (15) not NULL, 
  	datanasc DATE not NULL, 
  	dataadm DATE not NULL, 
  	sexo CHAR not NULL, 
  	endereco VARCHAR (100) not NULL, 
  	estadocivil VARCHAR (10) not NULL, 
  	trabalha_em VARCHAR (50) DEFAULT 'Sem empresa') 
	WITH (OIDS = FALSE); 
ALTER TABLE funcionario ADD CONSTRAINT funcionario_pk PRIMARY KEY (cpf); 

CREATE TABLE infracoes(
	cpf_funcionario CHAR(14) NOT NULL,
	id_morador int NOT NULL,
	descricao VARCHAR(80),
	multa NUMERIC(10,2) NOT NULL,
	data DATE NOT NULL);

ALTER TABLE infracoes ADD CONSTRAINT cpf_func_fk FOREIGN KEY(cpf_funcionario) REFERENCES funcionario(cpf);
ALTER TABLE infracoes ADD CONSTRAINT id_morad_fk FOREIGN KEY(id_morador) REFERENCES pessoa(pessoa_id);


--CARGA DE DADOS

INSERT INTO pessoa(nome, nome_social, data_nascimento) VALUES 
('Jose Campos','José','1982-04-03'),
('Alice Martins','Alice','1990-06-01'),
('Alberto Neto','Beto','1978-03-02'),
('Bruna Alencar','Bruna','1993-08-12'),
('José Dias','Zé','1969-06-21');

INSERT INTO pessoa_fisica(pessoa_id, rg,cpf, sexo) VALUES 
(1, '30.954.445-2','458.776.882-12','M'),
(2,'42.928.400-6','498.771.854-9','F'),
(3,'28.902.445-4','401.702.800-1','M'),
(4,'47.968.4524-1','499.767.850-8','F'),
(5,'30.528.419-7','400.001.850-8','M');

INSERT INTO telefone(ramal, fixo, celular, whatsapp)VALUES 
('H10', '19 33426572', '19 934657649', true),
('H11', '19 36486671', '19 935688040', true),
('H12', '19 35446342', '19 937453042', true),
('H13', '19 36676272', '19 934600010', true),
('H14', '19 36776571', '19 990674228', true);

INSERT INTO tipomoradia(tipo) VALUES 
('Casa'),
('Apartamento');

INSERT INTO habitacao(tipomoradia_id, rua, bloco, numero)VALUES 
(1, '1', 'D', '1020'),
(2, '1', 'D', '144'),
(2, '2', 'A', '1040'),
(1, '1', 'D', '1050'),
(1, '1', 'D', '1066');


INSERT INTO morador(morador_id, habitacao_id, telefone_id) VALUES 
(1,1,1),
(2,2,2),
(3,3,3),
(4,4,4),
(5,5,5);

INSERT INTO funcionario(cpf,nome,telefone,datanasc,dataadm,sexo,endereco,estadocivil,trabalha_em) VALUES ('345.876.223-14','José Guilherme','1124067877','1985-06-21','2005-03-24','M','Rua Albert Martins/SP,520','Casado','Portaria');
INSERT INTO funcionario(cpf,nome,telefone,datanasc,dataadm,sexo,endereco,estadocivil,trabalha_em) VALUES ('303.845.221-10','Andréa Gimenes','1120337805','1978-02-22','2007-02-22','F','Rua Albert Einstein/SP,520','Casado','Portaria');
INSERT INTO funcionario(cpf,nome,telefone,datanasc,dataadm,sexo,endereco,estadocivil,trabalha_em) VALUES ('341.832.200-12','Paulo Goulart','1120032791','1989-01-10','2009-02-20','F','Rua Augusto Silva/SP,520','Solteiro','Segurança');

INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('345.876.223-14',1,'Som alto',192.50,'2010-02-15');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('303.845.221-10',2,'Mudança após 18h',302.70,'2011-08-21');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('341.832.200-12',1,'Óbras aos finais de semana',549.80,'2011-02-15');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('303.845.221-10',1,'Mudança após 18h',302.70,'2011-08-21');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('303.845.221-10',5,'Mudança após 18h',302.70,'2013-05-18');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('345.876.223-14',4,'Som alto',192.50,'2015-06-18');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('345.876.223-14',2,'Som alto',192.50,'2016-01-01');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('303.845.221-10',2,'Entulho na calçada',572.50,'2016-04-02');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('341.832.200-12',3,'Som alto',192.50,'2018-01-01');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('341.832.200-12',3,'Som alto',192.50,'2019-03-12');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('303.845.221-10',3,'Entulho na calçada',572.50,'2016-12-07');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('341.832.200-12',1,'Som alto',192.50,'2020-01-08');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('345.876.223-14',2,'Objeto em local irregular',350.50,'2021-01-14');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('303.845.221-10',5,'Entulho na calçada',572.50,'2019-11-08');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('341.832.200-12',1,'Som alto',192.50,'2020-05-08');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('303.845.221-10',5,'Objeto em local irregular',350.50,'2020-08-08');
INSERT INTO infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('341.832.200-12',1,'Som alto',192.50,'2021-01-01');

-- CONSULTAS
-- com ou sem ORDER BY e HAVING


-- SELECT com junção (join) e cláusula WHERE (filtro)
-- Murilo Formaggio Feliciano 
-- Enunciado: Consulta do nome do aplicador de multa, nome do infrator, multa,descrição e data

--select f.nome as "Aplicador de multa", p.nome as "Morador", inf.multa, inf.descricao, inf.data
--from infracoes as inf
--INNER JOIN funcionario f on f.cpf=inf.cpf_funcionario
--inner join pessoa p on p.pessoa_id=inf.id_morador
--where multa>200;


--select p.nome as "Morador",sum(multa)
--from infracoes as inf
--inner join pessoa p on p.pessoa_id=inf.id_morador
--group by p.nome
--having sum(multa) > 500;

-- VISOES
-- materializadas ou nao
-- Se a visao for materializada: 
--    -> adicionar o REFRESH correspondente
--    -> escrever comentario com a frequencia que o REFRESH e' necessario (por exemplo: diario, semanal etc)
-- Redigir tambem uma consulta sobre a visao (SELECT)

-- VISAO 1
-- Murilo Formaggio Feliciano
-- Enunciado: Consulta do nome do morador e o total pago em multas pelo mesmo
-- Utilidade/importancia da visao: A visão ajuda o morador saber quanto foi gasto em multas com o objetivo se conscientizar o morador

CREATE VIEW valor_totalpago_multas as (
select p.nome as "Morador",sum(multa) as "Total pago"
from infracoes as inf
inner join pessoa p on p.pessoa_id=inf.id_morador
group by p.nome);

-- DESEMPENHO
-- Primeiro analise o desempenho das suas consultas (e consultas sobre visoes).
-- Depois, decida pela criacao ou nao de um indice, e justifique.

--Murilo Formaggio Feliciano
--EXPLAIN
--select p.nome as "Morador",sum(multa)
--from infracoes as inf
--inner join pessoa p on p.pessoa_id=inf.id_morador
--group by p.nome
--having sum(multa) > 500;

--(4 operação) HashAggregate  (cost=27.47..28.45 rows=23 width=548)
   --Group Key: p.nome
   --Filter: (sum(inf.multa) > '500'::numeric)
   --->  (3 operação) Hash Join  (cost=11.57..25.12 rows=280 width=532)
         --Hash Cond: (inf.id_morador = p.pessoa_id)
         --->  (2 operação) Seq Scan on infracoes inf  (cost=0.00..12.80 rows=280 width=20)
         --->  (2 operação) Hash  (cost=10.70..10.70 rows=70 width=520)
               ---> (1 operação) Seq Scan on pessoa p  (cost=0.00..10.70 rows=70 width=520)


-- Murilo Formaggio Feliciano
--EXPLAIN ANALYZE 
--select p.nome as "Morador",sum(multa)
--from infracoes as inf
--inner join pessoa p on p.pessoa_id=inf.id_morador
--group by p.nome
--having sum(multa) > 500;

-- (4 operação) HashAggregate  (cost=27.22..28.45 rows=23 width=548) (actual time=0.160..0.172 rows=4 loops=1)
   --Group Key: p.nome
   --Filter: (sum(inf.multa) > '500'::numeric)
   --Batches: 1  Memory Usage: 24kB
   --Rows Removed by Filter: 1
   ---> (3 operação) Hash Join  (cost=11.57..25.12 rows=280 width=532) (actual time=0.072..0.104 rows=17 loops=1)
         --Hash Cond: (inf.id_morador = p.pessoa_id)
         ---> (2 operação) Seq Scan on infracoes inf  (cost=0.00..12.80 rows=280 width=20) (actual time=0.022..0.029 rows=17 loops=1)
         ---> (2 operação) Hash  (cost=10.70..10.70 rows=70 width=520) (actual time=0.029..0.031 rows=5 loops=1)
               --Buckets: 1024  Batches: 1  Memory Usage: 9kB
               ---> (1 operação) Seq Scan on pessoa p  (cost=0.00..10.70 rows=70 width=520) (actual time=0.013..0.018 rows=5 loops=1)
 --Planning Time: 1.259 ms
 --Execution Time: 0.302 ms
--(13 rows)



--Observando o explain analyze é possivel concluir que as operações mais custosas são seq scan on pessoa (cost=0.00..10.70) e seq scan on infracoes (cost=0.00..12.80). Com isso é possivel realizar a crianção de index btree na tabela pessoa e também na tabela infracoes para diminuir esse custo.
CREATE INDEX idx_infracoes on infracoes using btree (id_morador);
CREATE INDEX idx_pessoa on pessoa using btree (pessoa_id);

--Após a criação do index é possivel realizar a consulta novamente verifica-se uma redução expressiva no custo scan on pessoa (cost=0.00..1.05) e seq scan on infracoes (cost=0.00..1.17).

-- (4 operação) HashAggregate  (cost=2.47..2.55 rows=2 width=548) (actual time=0.160..0.172 rows=4 loops=1)
   --Group Key: p.nome
   --Filter: (sum(inf.multa) > '500'::numeric)
   --Batches: 1  Memory Usage: 24kB
   --Rows Removed by Filter: 1
   ---> (3 operação) Hash Join  (cost=1.11..2.34 rows=17 width=532) (actual time=0.072..0.104 rows=17 loops=1)
         --Hash Cond: (inf.id_morador = p.pessoa_id)
         ---> (2 operação) Seq Scan on infracoes inf  (cost=0.00..1.17 rows=17 width=20) (actual time=0.022..0.029 rows=17 loops=1)
         ---> (2 operação) Hash  (cost=1.05..1.05 rows=5 width=520) (actual time=0.029..0.031 rows=5 loops=1)
               --Buckets: 1024  Batches: 1  Memory Usage: 9kB
               ---> (1 operação) Seq Scan on pessoa p  (cost=0.00..1.05 rows=5 width=520) (actual time=0.013..0.018 rows=5 loops=1)
 --Planning Time: 1.259 ms
 --Execution Time: 0.302 ms
--(13 rows)




--7 Funções internas 

--Murilo Formaggio Feliciano
--O select apresenta o ID do morador com a soma das multas obtidas por ele, a função interna ROUND aproxima o resultado da soma para o proximo numero inteiro.

--select id_morador,ROUND(sum(multa)) as "Total a ser pago"
--from infracoes
--group by id_morador
--order by sum(multa) desc;

--8 USER-DEFINED FUNCTION (UDF)
--A função abaixo apresenta um reajuste no valor das multas. O percentual pode ser escolhido pelo administrador do banco.

CREATE OR REPLACE FUNCTION reajuste_percentual(percentual numeric(5,2),valor numeric(5,2))
RETURNS numeric(10,2) as $$
BEGIN
return round(valor*((percentual/100)+1),2);
END;
$$ LANGUAGE 'plpgsql';

--UPDATE infracoes SET multa=reajuste_percentual(10,multa)


--9 STORED PROCEDURE
--Murilo Formaggio Feliciano
--Enunciado: Atualização do valor das multas de acordo com a descrição e data de inicio de alteração.
--Utilidade: Permite que o administrador realize reajustes nos valores inseridos pelos funcionarios, com isso é possivel realizar a alteração de varias tuplas com uma simples chamada no procedimento.

CREATE OR REPLACE PROCEDURE reajuste (tipo varchar,valor numeric(10,2),datainic date)
as $$
BEGIN
    UPDATE infracoes set multa=valor 
    WHERE descricao=tipo and datainic<= infracoes.data;
    return;
end;
$$ LANGUAGE 'plpgsql';

--CALL reajuste('Som alto',230.20,'2018-01-01')


--10 TRIGGER
--Primeiramente deve ser criado uma visão materializada para somar as multas de cada morador, apresentando assim o valor total gasto em multas. Após
--isso será criado um gatilho com refresh, para que toda vez que uma multa for inserida o gatilho seja acionado e com isso a visão materializada possa --ser atualizada.

create MATERIALIZED VIEW total as (
  	select id_morador,sum(multa) as "Total a ser pago"
	from infracoes
	group by id_morador
	order by sum(multa) desc);

create function total_pago()
returns TRIGGER as $$
BEGIN
    refresh materialized view total;
    return new;
end;
$$ LANGUAGE 'plpgsql';
create TRIGGER novo_calculo after insert on infracoes
for each row execute function total_pago();

--insert into infracoes(cpf_funcionario,id_morador,descricao,multa,data) VALUES ('345.876.223-14',1,'Som alto',192.50,'2019-03-15');












