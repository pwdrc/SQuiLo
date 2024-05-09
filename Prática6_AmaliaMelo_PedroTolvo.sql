-- Entrega 6
--Amalia Vitoria de Melo NUSP:13692417
--Pedro Guilherme Tolvo NUSP:10492012


-- 1
-- a)
grant select on Comunidade to a10492012;

--i. 
  select * from a13692417.Comunidade;
  -- Sucesso
--ii.
  insert into a13692417.Comunidade values ('Non eos qui','Teste_user2',199);
  -- Erro. Falta privilégios para o user 2 executrar a ação
--iii.
  select nome from a13692417.Comunidade;
  -- Erro. A view não existe para o user 3
--iv.
  Revoke select on Comunidade from a10492012;
  --Sucesso
--v.
  select especie from a13692417.Comunidade;
  -- Erro. A view não existe mais para o user 2

--b)
grant select on Comunidade to a10492012 with grant option;

--i.
  select * from a13692417.Comunidade;
  -- Sucesso.
--ii.
  grant select on a13692417.Comunidade to a13692272;
  --Sucesso
--iii.
  select nome from a13692417.Comunidade;
  --Sucesso
--iv.
  Revoke select on Comunidade from a10492012;
  --Sucesso
--v.
  select * from a13692417.Comunidade;
  select * from a13692417.Comunidade;
  -- Apresentaram erro, indicando q a tabela não existia, logo, a revogação funcionou



-- 2
-- a
-- user1:
grant select a13692272.planeta to a10492012;
create view v as select id_astro, massa from a13692272.planeta;
grant insert on v planeta to a10492012 with grant option;
-- sucesso
-- user 2:
insert into a13692272.v values('Ra Tim Bum', 8000);
commit;
-- sucesso

-- b
-- antes do commit (AC)
-- user1:
select * from planeta where id_astro='Ra Tim Bum'
-- linha vazia
-- user2:
select * from a13692272.planeta where id_astro='Ra Tim Bum'
-- sucesso

-- depois do commit (DC)
-- user1:
select * from planeta where id_astro='Ra Tim Bum'
-- sucesso
-- user2:
select * from a13692272.planeta where id_astro='Ra Tim Bum'
-- sucesso

-- as tuplas para as quais não foram concedidas as devidas permissões
-- recebem o valor null

-- c
grant insert on a13692272.v to a13692417;

-- user 3:
insert into a13692272.v (id_astro, massa) values ('Pega pega', 0.4);

-- d
-- da mesma forma que no exercício anterior:
-- só é possível consultar após o commit

-- e
revoke insert on v from a10492012;



--3
-- a)
  grant select on Comunidade to a10492012 with grant option;
  grant insert on Comunidade to a10492012 with grant option;
  grant update on Comunidade to a10492012 with grant option;
  grant delete on Comunidade to a10492012 with grant option;
  grant references on Comunidade to a10492012 with grant option;

-- b)

create table curiosidade_comunidade(
    Especie varchar(15),
    Nome_comunidade varchar(15),
    Descricao_curiosidade varchar(118) not null,
    constraint pk_curiosidade_comunidade primary key (Especie, Nome_comunidade),
    constraint fk_nome_comunidade foreign key (Especie, Nome_comunidade) references a13692417.Comunidade(Especie,Nome)
)
--c)
  --no user1:
  insert into comunidade values ('Id sed','Teste3', '9');
  --no user2:
insert into curiosidade_comunidade values ('Non eos qui','Teste', 'blblablablabla');

insert into curiosidade_comunidade values ('Ea qui modi','Teste0', 'blblablablabla3');

-- funciona

insert into curiosidade_comunidade values ('Nisi id eum','Teste2', 'blblablablabla2');
-- não funciona, pois ocorre um erro de retrição de integrade, relacionado a referencia 

--visualizando...
select * from  a13692417.comunidade;
select * from  curiosidade_comunidade;

--d)

--no user1:
delete from comunidade where nome='Teste';
commit;

--linha exluida

--no user2:
select * from  curiosidade_comunidade;
/* A tupla que continha a comunidade com o nome 'Teste' foi excluida, visto que, após a exclusão da comunidade na tabela do user1, a tupla 
não obedecia mais a restrição de integridade em que só poderia haver comunidades que também existissem na tabela do user1*/

-- 4
-- a
grant select on estrela to a10492012;
-- sucesso

-- b
create index idx on estrela(nome);
-- sucesso

-- c
explain plan for 
select * from a13692272.estrela;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

/*
Plan hash value: 1653849300

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |  6586 |   295K|    15   (0)| 00:00:01 |
|   1 |  TABLE ACCESS FULL| ESTRELA |  6586 |   295K|    15   (0)| 00:00:01 |
-----------------------------------------------------------------------------
*/

-- d
/*
Plan hash value: 1653849300

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |  6586 |   295K|    15   (0)| 00:00:01 |
|   1 |  TABLE ACCESS FULL| ESTRELA |  6586 |   295K|    15   (0)| 00:00:01 |
-----------------------------------------------------------------------------
*/

-- e
ALTER SESSION SET OPTIMIZER_MODE = FIRST_ROWS;

-- f
/*

Especificamente no cenário testado, não houve mudança, conforme indicado abaixo.

Plan hash value: 1653849300

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |  6586 |   295K|    15   (0)| 00:00:01 |
|   1 |  TABLE ACCESS FULL| ESTRELA |  6586 |   295K|    15   (0)| 00:00:01 |
-----------------------------------------------------------------------------

No entanto, é relevante observar que o plano de execução foi executado e terá efeitos sobre o banco de dados em relação ao usuário 1.
Em outros contextos, nos quais o SGBD calcule ser mais vantajoso o uso da otimização, a depender da quantidade e tipo de dados, o novo índice será utilizado.

*/

-- g
/*
As mudanças de otimização em relação ao índice aplicadas pelo (e para) o usuário 1, via de regra, não afetarão o usuário 2. 
*/


--05)
-- a)

grant select on faccao to a10492012 with grant option;
grant insert on faccao to a10492012 with grant option;
grant update on faccao to a10492012 with grant option;
grant delete on faccao to a10492012 with grant option;

grant select on lider to a10492012 with grant option;

commit;

create or replace view view_faccao_lider as
Select f.nome, f.lider, f.ideologia from a13692417.faccao f join a13692417.lider l
on f.lider=l.CPI;

grant select on view_faccao_lider to a13692272 with grant option;

--b)
select * from a10492012.view_faccao_lider;
--User3 conseguiu visualizar a view;

select * from view_faccao_lider;
--User2 conseguiu visualizar a view

--no user1, rodar:
insert into lider values ('888.888.888-99', 'Teste0','CIENTISTA', 'Deserunt vero.', 'Non eos qui');

--no user2, tentar:
Insert into view_faccao_lider values ('carinhosa', '888.888.888-99', 'TOTALITARIA');
--User2 conseguiu inserir a tupla

Update view_faccao_lider set ideologia = 'TOTALITARIA' where nome_lider = 'Denzel';
--User2 consegue

Insert into a10492012.view_faccao_lider values ('Comando red', '999.999.999-99', 'Denzel', 'Cientifica');
--User3 não consegue

Update a10492012.view_faccao_lider set ideologia = 'TOTALITARIA' where nome_lider = 'Denzel';
--User3 não consegue

--no user2:
delete from view_faccao_lider where nome = 'carinhosa'; 
select * from a13692417.faccao;
--funciona

--no user3
 select * from a13692417.faccao;
--User3 não tem aceeso

--c)
--no user1:
revoke select,insert,update,delete on faccao from a10492012;

--no user2 e user3:
select * from  a10492012.view_faccao_lider;
-- Erro. Por conta da revogação de permissão, os dados da view ficam inacessiveis para os demais usuários;

