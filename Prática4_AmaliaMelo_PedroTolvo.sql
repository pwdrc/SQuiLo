-- 2
-- a)
delete from plan_table; 

 explain plan for 
 select * from planeta where classificacao = 'Dolores autem maxime fuga.'; 

SELECT plan_table_output 
 FROM TABLE(dbms_xplan.display());

/* Plan hash value: 2930980072

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     1 |    59 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |     1 |    59 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("CLASSIFICACAO"='Dolores autem maxime fuga.')*/

explain plan for 
 select * from planeta where classificacao = 'Confirmed';

SELECT plan_table_output 
 FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 2930980072

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     1 |    59 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |     1 |    59 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("CLASSIFICACAO"='Confirmed')
*/

-- b)
create index idx_classificacao on planeta(classificacao);

-- A utilização do tipo de indice B-tree permite uma busca rápida de dados, de uso geral e, portanto, é uma boa opção para o caso de consulta de dados simples, como a busca de um planeta por classificação

-- c)
/*
CONSULTA 1 : select * from planeta where classificacao = 'Dolores autem maxime fuga.'; 
Plan hash value: 1267387943

-------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                   |     1 |    59 |     3   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| PLANETA           |     1 |    59 |     3   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_CLASSIFICACAO |     1 |       |     1   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------------

CONSULTA 2 : select * from planeta where classificacao = 'Confirmed';
Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("CLASSIFICACAO"='Confirmed')

Plan hash value: 1267387943

---------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                   |     1 |    59 |     3   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| PLANETA           |     1 |    59 |     3   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_CLASSIFICACAO |     1 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("CLASSIFICACAO"='Dolores autem maxime fuga.')*/

-- Ocorreu uma diferença entres os planos antes e depois da utilização do índice. Anteriormente o custo de processamento era de 137% agora o custo é de 3%. Além disso a lógica de busca foi alterada, pois, agora, o índice é utilizado para buscar o registro, diminuindo o tempo de execução da tarefa.

-- 3.a)
explain plan for
select * from nacao where nome = 'Minus magni.';
SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*
----------------------------------------------------------------------------------------
| Id  | Operation                   | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |          |     1 |    30 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| NACAO    |     1 |    30 |     2   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_NACAO |     1 |       |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------
*/                                                                                   

explain plan for
select * from nacao where upper(nome) = 'MINUS MAGNI.';
SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*
---------------------------------------------------------------------------
| Id  | Operation         | Name  | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |       |   498 | 14940 |    69   (2)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| NACAO |   498 | 14940 |    69   (2)| 00:00:01 |
---------------------------------------------------------------------------
*/

/* 
A primeira busca utiliza a chave, consumindo menos recurso do banco de dados, pois não precisa fazer a busca de todos os registros, apenas aqueles que possuem o nome 'Minus magni'.
A segunda busca utiliza a função upper() para converter o nome para letras maiúsculas, o que pode levar a uma busca mais lenta, pois precisa percorrer todos os registros para encontrar seu objeto.
*/

-- 3.b) 
create index idx_nome on nacao (upper(nome));
/*
------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |          |   498 | 14940 |    67   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| NACAO    |   498 | 14940 |    67   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_NOME |   199 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access(UPPER("NOME")='MINUS MAGNI.')
*/
-- 3.c)
/*
A utlização do índice foi bem mais rápida, pois não precisou percorrer toda a tabela para encontrar o objeto procurado. Com o índice associado à função upper(), o custo de processamento diminuiu, assim como o número de linhas percorridas.
*/

--4
--a)
explain plan for 
select * from planeta where massa between 0.1 and 10;

SELECT plan_table_output 
 FROM TABLE(dbms_xplan.display());

/*Plan hash value: 2930980072

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     6 |   354 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |     6 |   354 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("MASSA"<=10 AND "MASSA">=0.1)*/
explain plan for 
select * from planeta where massa between 0.1 and 3000; 

SELECT plan_table_output 
 FROM TABLE(dbms_xplan.display());
/*
Plan hash value: 2930980072

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |  1580 | 93220 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |  1580 | 93220 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("MASSA"<=3000 AND "MASSA">=0.1)*/

--b) 

create index idx_massa on planeta(massa);

-- A escolha do índice foi feita de acordo com o tipo de dado a ser pesquisado. Tendo em vista que a busca leva em consideração um valor de massa entre 0.1 e 3000, faz sentido indexar o valor da massa de planeta.

--c)

explain plan for 
select * from planeta where massa between 0.1 and 10;

SELECT plan_table_output 
 FROM TABLE(dbms_xplan.display());

/*Plan hash value: 1147402337

-------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |           |     6 |   354 |     9   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| PLANETA   |     6 |   354 |     9   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_MASSA |     6 |       |     2   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("MASSA">=0.1 AND "MASSA"<=10)*/


explain plan for 
select * from planeta where massa between 0.1 and 3000; 

SELECT plan_table_output 
 FROM TABLE(dbms_xplan.display());
/*Plan hash value: 2930980072

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |  1580 | 93220 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |  1580 | 93220 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("MASSA"<=3000 AND "MASSA">=0.1)*/

select count(id_astro) from planeta where massa between 0.1 and 10;

explain plan for
select count(id_astro) from planeta where massa between 0.1 and 3000; 
SELECT plan_table_output 
 FROM TABLE(dbms_xplan.display());

-- Na segunda consulta, o indice de massa não é utilizado, pois como o intervalo é muito grande, é menos custoso pesquisar direto pelo arquivo de dados, que acaba sendo a opção escolhida pelo otimizador de consultas do SGBD. Caso a opção fosse de retornar a quantidade (com count), a opção pelo índice poderia voltar a ser interessante, dada a natureza do tipo do dado.

-- 5.a)
explain plan for
select * from especie where inteligente = 'V';
SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*
Plan hash value: 139595281

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24997 |   707K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24997 |   707K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("INTELIGENTE"='V')
*/

explain plan for
select * from especie where inteligente = 'F';
SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 139595281

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24997 |   707K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24997 |   707K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("INTELIGENTE"='F')

Como é possível observar, ambas as consultas exigem quantidades identicas de recursos, o que pode ser observado na tabela de planos. 
*/

-- 5.b)
create bitmap index idx_inteligente on especie(inteligente);

/*
Planos gerados:

Plan hash value: 139595281

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24997 |   707K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24997 |   707K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("INTELIGENTE"='V')

Plan hash value: 139595281

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24997 |   707K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24997 |   707K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("INTELIGENTE"='F')
*/

/*
De acordo com os planos acima, a implementação do índice bitmap não é necessariamente melhor nem pior, pois retorna o meso plano de consulta. Isso significa que o banco de dados não chega a utilizar o índice. O algoritmo de otimização identifica que não é mais vantajoso o uso do índice. Isso pode ter relação com a natureza e o tipo dos dados.
*/

-- 6
-- a)
explain plan for
select * from estrela where classificacao = 'M3' and massa < 1;

SELECT plan_table_output 
 FROM TABLE(dbms_xplan.display());
/*
Plan hash value: 1653849300

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     1 |    46 |    15   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESTRELA |     1 |    46 |    15   (0)| 00:00:01 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("MASSA"<1 AND "CLASSIFICACAO"='M3')
*/

select count(id_estrela) from estrela where classificacao = 'M3' and massa < 1;

select count(id_estrela) from estrela where classificacao = 'M3';

select count(id_estrela) from estrela where massa < 1;

create index idx_clasificacao_massa on estrela(classificacao,massa)

-- O índice composto idx_clasificacao_massa é eficaz para as consultas que filtram ambas colunas
-- Nesse sentido, para buscas com ambas as colunas, o índice composto é mais vantajogos do que índices separados, pois o SGBD pode aproveitar a ordenação no índice para acessar dados de forma mais eficiente.
    
-- b)

  explain plan for
  select * from estrela where classificacao = 'M3' and massa < 1;

  SELECT plan_table_output 
   FROM TABLE(dbms_xplan.display());

/*
  Plan hash value: 1949203251

------------------------------------------------------------------------------------------
  | Id  | Operation                           | Name                   | Rows  | Bytes | Cost (%CPU)| Time     |
  ------------------------------------------------------------------------------------------
  |   0 | SELECT STATEMENT                    |                        |     1 |    46 |     3   (0)| 00:00:01 |
  |   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| ESTRELA                |     1 |    46 |     3   (0)| 00:00:01 |
  |*  2 |   INDEX RANGE SCAN                  | IDX_CLASIFICACAO_MASSA |     1 |       |     2   (0)| 00:00:01 |
  ------------------------------------------------------------------------------------------

  Predicate Information (identified by operation id):
  ---------------------------------------------------

     2 - access("CLASSIFICACAO"='M3' AND "MASSA"<1)
*/

explain plan for
select count(id_estrela) from estrela where classificacao = 'M3';

SELECT plan_table_output 
 FROM TABLE(dbms_xplan.display());

/*Plan hash value: 2119345005

--------------------------------------------------------------------------------------------
| Id  | Operation         | Name                   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |                        |     1 |     5 |     2   (0)| 00:00:01 |
|   1 |  SORT AGGREGATE   |                        |     1 |     5 |            |          |
|*  2 |   INDEX RANGE SCAN| IDX_CLASIFICACAO_MASSA |     5 |    25 |     2   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("CLASSIFICACAO"='M3')*/

explain plan for
select * from estrela where massa < 1;

SELECT plan_table_output 
 FROM TABLE(dbms_xplan.display());

/*Plan hash value: 1653849300

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     1 |    46 |    15   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESTRELA |     1 |    46 |    15   (0)| 00:00:01 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("MASSA"<1)*/

-- 7
explain plan for
select classificacao, count(*) from estrela
group by classificacao;
SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*
Plan hash value: 2618708603

------------------------------------------------------------------------------
| Id  | Operation          | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |         |  1235 |  6175 |    16   (7)| 00:00:01 |
|   1 |  HASH GROUP BY     |         |  1235 |  6175 |    16   (7)| 00:00:01 |
|   2 |   TABLE ACCESS FULL| ESTRELA |  6586 | 32930 |    15   (0)| 00:00:01 |
------------------------------------------------------------------------------
*/
create bitmap index idx_classificacao on estrela(classificacao);
/*
Plan hash value: 3865298374

---------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                   |  1235 |  6175 |     8  (25)| 00:00:01 |
|   1 |  HASH GROUP BY                |                   |  1235 |  6175 |     8  (25)| 00:00:01 |
|   2 |   BITMAP CONVERSION COUNT     |                   |  6586 | 32930 |     6   (0)| 00:00:01 |
|   3 |    BITMAP INDEX FAST FULL SCAN| IDX_CLASSIFICACAO |       |       |            |          |
---------------------------------------------------------------------------------------------------
*/
/*
A criação de um índice bitmap é mais eficiente, pois tem um custo de praticaente metade.
*/

-- 8

insert into lider (CPI, nome, cargo, nacao, especie) 
values('999.999.999-99', 'Denzel', 'COMANDANTE', 'Commodi illum.', 'Non eos qui');

insert into lider (CPI, nome, cargo, nacao, especie) 
values ('111.111.111-11', 'Mickey', 'CIENTISTA', 'Deserunt vero.', 'Et sunt rerum');

insert into faccao (nome, lider, ideologia, qtd_nacoes)
values('Comando red', '999.999.999-99', 'PROGRESSITA', 2);

insert into faccao (nome, lider, ideologia, qtd_nacoes)
values ('Carinhosa', '111.111.111-11', 'TRADICIONALISTA', 5);

explain plan for
select faccao.nome, faccao.ideologia, lider.nome, lider.especie, lider.nacao from faccao
join lider on faccao.lider = lider.CPI;
SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/* Plan hash value: 3318351671

------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name            | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                 |     1 |    77 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |                 |     1 |    77 |     2   (0)| 00:00:01 |
|   2 |   NESTED LOOPS               |                 |     1 |    77 |     2   (0)| 00:00:01 |
|   3 |    TABLE ACCESS FULL         | LIDER           |     1 |    43 |     2   (0)| 00:00:01 |
|*  4 |    INDEX UNIQUE SCAN         | UN_FACCAO_LIDER |     1 |       |     0   (0)| 00:00:01 |
|   5 |   TABLE ACCESS BY INDEX ROWID| FACCAO          |     1 |    34 |     0   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("FACCAO"."LIDER"="LIDER"."CPI")*/

CREATE BITMAP INDEX faccao_lider_idx_3
ON     faccao(lider)
FROM   faccao, lider
WHERE  faccao.lider = lider.CPI;


explain plan for
select faccao.nome, faccao.ideologia, lider.nome, lider.especie, lider.nacao from faccao,lider
where faccao.lider = lider.CPI;
SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*Plan hash value: 3318351671

------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name            | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                 |     1 |    77 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |                 |     1 |    77 |     2   (0)| 00:00:01 |
|   2 |   NESTED LOOPS               |                 |     1 |    77 |     2   (0)| 00:00:01 |
|   3 |    TABLE ACCESS FULL         | LIDER           |     1 |    43 |     2   (0)| 00:00:01 |
|*  4 |    INDEX UNIQUE SCAN         | UN_FACCAO_LIDER |     1 |       |     0   (0)| 00:00:01 |
|   5 |   TABLE ACCESS BY INDEX ROWID| FACCAO          |     1 |    34 |     0   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("FACCAO"."LIDER"="LIDER"."CPI")*/

-- Um índice bitmap apresenta bom desempenho em cenários com baixa cardinalidade, ou seja, com um número de valores distintos pequeno em comparação com o número de linhas; ou, ainda, em cenários com pouca ou nenhuma ocorrência de alterações.

-- No caso do bitmap join index, de forma semelhante, produz um índice bitmap a partir de duas outras tabelas.

-- No entanto, no caso acima, mesmo com criação, o SGBD não consegue aproveitar o índice, pois ele acaba utilizando o índice da chave primária. Isso pode indicar que o cálculo do SGB indica que o uso do índice bitmap terá um resultado inferior ao do índice da chave primária.

-- Referência: ORACLE. Indexes and Index Organized Table. Disponível em: <https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/indexes-and-index-organized-tables.html#GUID-3286EBA4-0D5B-423D-815B-997A3E4B4B6C:~:text=vezes%20drasticamente.%20WHERE-,%C3%8Dndices%20de%20jun%C3%A7%C3%A3o%20de%20bitmap,-Um%20%C3%ADndice%20de>. Acesso em: 1º de abril de 2024.
