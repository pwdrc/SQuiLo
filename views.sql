/* 1)*/

Create view view_faccao_progressista as select nome, lider from faccao where ideologia = 'PROGRESSITA' with read only;

/*a)*/
Select count(*) as Numero_faccoes_progressistas from view_faccao_progressista;

/*b)*/
Insert into view_faccao_progressista values('teste','444.444.444-44');

/*Resultado: 
Erro a partir da linha : 9 no comando -
Insert into view_faccao_progressista values('teste','444.444.444-44')
Erro na Linha de Comandos : 9 Coluna : 1
Relatório de erros -
Erro de SQL: ORA-42399: não é possível efetuar uma operação de DML em uma view somente para leitura
42399.0000 - "cannot perform a DML operation on a read-only view"
*/

/* Como a view foi definida como somente leitura (with read only), essa operação de inserção é proibida e resulta no erro.
O erro indica explicitamente que uma operação de DML (como inserção, atualização ou exclusão) está sendo tentada em uma view que foi definida como somente leitura, o que não é permitido. */

-- 2) 
-- a
create or replace view view_faccao_tradicionalista_insert_on
  as select nome, lider, ideologia from faccao
  where ideologia = 'TRADICIONALISTA';
commit;

insert into lider
values('000.000.000-01','baco_blues','OFICIAL','Nemo atque.','Beatae itaque');
insert into view_faccao_tradicionalista_insert_on
values('faccaocarinhosa','000.000.000-01', 'PROGRESSITA');

insert into lider
values('000.000.000-02','serj_tankian','OFICIAL','Nemo atque.','Beatae itaque');
insert into view_faccao_tradicionalista_insert_on
values('SOAD','000.000.000-02', 'TRADICIONALISTA');

select * from view_faccao_tradicionalista_insert_on;
select * from faccao;

-- b
create or replace view view_faccao_tradicionalista_insert_off
  as select nome, lider, ideologia from faccao
  where ideologia = 'TRADICIONALISTA'
  with check option;
commit;

insert into lider
values('000.000.000-03','djonga','OFICIAL','Nemo atque.','Beatae itaque');
insert into view_faccao_tradicionalista_insert_on
values('DVTRIBO','000.000.000-03', 'TRADICIONALISTA');

insert into lider
values('000.000.000-04','bob_marley','OFICIAL','Nemo atque.','Beatae itaque');
insert into view_faccao_tradicionalista_insert_off
values('weeds','000.000.000-04', 'PROGRESSITA');

select * from view_faccao_tradicionalista_insert_off;
select * from faccao;

/* nesse caso, a segunda inserção resultará em erro, pois viola a clausula
where ideologia = TRADICIONALISTA utilizada na criação da view.
*/

/*3)*/
/*a)*/

insert into orbita_planeta values('Laborum nihil.', '34Gam Eri', 1,2,3);
insert into orbita_planeta values('Ut quisquam.', '10    Tri', 1,2,3);
insert into orbita_planeta values('Reiciendis ex.', 'Gl 414A', 1,2,3);
insert into orbita_planeta values('Laborum nihil.', 'GJ 2121', 1,2,3);
insert into orbita_planeta values('Laborum nihil.', 'Gl 480', 1,2,3);


create or replace view view_estrela_orbitada_por_planeta as select es.nome, es.x, es.y, es.z, op.planeta,
p.classificacao from orbita_planeta op 
join estrela es on op.estrela = es.id_estrela join planeta p on op.planeta = p.id_astro;

Insert into view_estrela_orbitada_por_planeta 
values('Inquill',1,2,3,'Reiciendis ex.','Quos commodi ipsa dignissimos.');
/*não é possível modificar uma coluna que mapeie uma tabela não preservada pela chave*/

Update view_estrela_orbitada_por_planeta set classificacao = 'teste'
where planeta = 'Reiciendis ex.';
/*não é possível modificar uma coluna que mapeie uma tabela não preservada pela chave*/

Update view_estrela_orbitada_por_planeta set planeta = 'teste'
where planeta = 'Reiciendis ex.';
/*Não é possivel pois não existe o planeta teste na tabela base planeta, assim sendo, a atualização é barrada
na tabela base de orbita, pois o comando não obedece a restrição de integridade da chave estrangeira da tabela*/

Update view_estrela_orbitada_por_planeta set planeta = 'K2-247 c'
where planeta = 'Reiciendis ex.';
Update view_estrela_orbitada_por_planeta set planeta = 'K2-247 c'
where nome = 'Zaurak';
/*A atualização é permitida! Apenas atualizações para a coluna planeta da view podem ser realizadas*/

delete from view_estrela_orbitada_por_planeta where nome = 'Zaurak'; 
/*a operação de deleção é sempre permitida, visto que a primeira tabela logo após a clausula 'from' é a tabela
orbita planeta, que contem preservação de chaves*/


/* A view criada contem preservação de chaves da tabela orbita, portanto é possivel fazer operações DML com
os dados advindos dessa tabela, obedencendo as restrições da mesma. Entretanto, como a view só possui um item
advindo da tabela orbita, o id_planeta, não é possivel fazer nenhuma inserção que obedeça a restrição de
inteegridade de chave primaria da tabela orbita, logo, nenhuma inserção na view poderá ser feita. Entretanto, 
deleções e alterações feitas a partir do atributo planeta(o.plantea), advindo da tabela orbita_plantea,
poderão ser executadas, já que este atributo faz parte da tabela com preservação de chave*/

/*b)*/


insert into orbita_planeta values('Laborum nihil.', 'GJ 2121', 1,2,3);
insert into orbita_planeta values('Dolor ea.', 'GJ 2121', 1,2,3);

select count(planeta) from view_estrela_orbitada_por_planeta group by nome;

/*Nesta consultado, o resultado é inconclusivo, já que todas tuplas 'nome' são nulas*/

insert into estrela values (111,'teste1','B6III', 408.5071251, 213.92, -35.768, 134.13);
insert into orbita_planeta values('Laborum nihil.', '111', 1,2,3);
insert into estrela values ('234','teste2','BrIII', 48.5071251, 13.92, -35.68, 34.13);
insert into orbita_planeta values('Laborum nihil.', '234', 1,2,3);
insert into orbita_planeta values('Dolor ea.', '234', 1,2,3);

select count(planeta) from view_estrela_orbitada_por_planeta group by nome;

/*
4) Crie uma view que armazene, para cada lider: CPI, nome, cargo, sua nação e respectiva federação,
sua espécie e respectivo planeta de origem.

b) Faça operações de inserção, atualização e remoção na view. Explique o efeito de cada
operação nas tabelas base.
*/
-- 4
-- a
create view view_lider_1 as
select l.CPI, l.nome, l.cargo, l.nacao, n.federacao, l.especie, e.planeta_or
from lider l
  join nacao n on l.nacao = n.nome
  join federacao f on n.federacao = f.nome
  join especie e on l.especie = e.nome;
/*a view é, por definição, atualizável, pois há a manutenção (preservação)
de chave da tabela líder*/

-- b
-- inserção:
insert into view_lider_1 values('000.000.000-01','baco_blues','OFICIAL','Ducimus odio.')
-- não é possível, pois acusa não existir valores suficientes

-- atualização:
update view_lider_1 set nome = 'baco_blues_2' where nome = 'baco_blues';
-- atualiza a tabela base

-- remoção:
delete from view_lider_1 where nome = 'baco_blues_2';
-- acusa erro de violação de integridade; no caso, a chave estrangeira de faccao_lider.

-- 6
/*
6.1
Abaixo, é possível observar a criação de uma visão materializada com junção.
Quanto aos parâmetros, temos:
  a) build immediate: garante que a visão seja criada e populada com dados no momento em que é chamada (no momento da criação)
  b) refresh complete: o refresh ocorre automaticamente quando qualquer das tabelas originais é atualizada; 
o complete, por sua vez, garante que a view seja COMPLETAMENTE atualizada com os dados mais recentes.
*/
create materialized view mv_join1
build immediate
refresh complete
as 
select habitacao.especie, lider.nome from habitacao join lider
on habitacao.especie = lider.especie;

select * from mv_join1;

/*
6.2
Abaixo, é possível observar a criação de uma visão materializada com agregação.
Quanto aos parâmetros, temos:
  a) build deferred: a visão não é populada no momento da criação, mas de forma deferida.
  b) refresh on commit: o refresh ocorre após cada commit.
*/
create materialized view mv_count
build deferred
refresh on commit
as
select count(*) as gigante from estrela where massa > 100000000

select * from mv_count
/*
6.3
Abaixo, é possível observar a criação de uma visão materializada com aninhada.
Quanto aos parâmetros, temos:
  a) build immediate: garante que a visão seja criada e populada com dados no momento em que é chamada (no momento da criação)
  b) refresh complete: o refresh ocorre automaticamente quando qualquer das tabelas originais é atualizada;
*/
create materialized view mv_lider
build immediate
refresh complete
as
select nome from (
select lider.nome from lider
join nacao
on lider.nacao = nacao.nome
where nacao.qtd_planetas > 4);

select * from mv_lider;