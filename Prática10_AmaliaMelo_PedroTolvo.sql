--1)

--a)
CREATE OR REPLACE TRIGGER federacao_nacao
  FOR UPDATE OF federacao or DELETE ON Nacao
COMPOUND TRIGGER
   e_nao_pode exception;
  
  TYPE type_collection IS TABLE OF integer INDEX BY nacao.federacao%type;
  Collection_Nacao_Federacao type_collection;
  
  BEFORE STATEMENT IS
  BEGIN
    
    For contagem in 
    (SELECT       federacao, count(nome) as nacoes
      FROM               Nacao where federacao is not null
      GROUP BY          federacao)
    Loop  
        Collection_Nacao_Federacao(contagem.federacao) := contagem.nacoes;
    end loop;
    --dbms_output.put_line('oii3'); 

     
  END BEFORE STATEMENT;

  AFTER EACH ROW IS
  BEGIN
   
    IF UPDATING then
        if (:old.federacao != :new.federacao) and :old.federacao is not null then
            Collection_Nacao_Federacao(:old.federacao) := Collection_Nacao_Federacao(:old.federacao) - 1;
               dbms_output.put_line('velha:'|| :old.federacao || ' nova:' || :new.federacao);
            If (:new.federacao is not null) then
             Collection_Nacao_Federacao(:new.federacao) := Collection_Nacao_Federacao(:new.federacao) + 1;
                dbms_output.put_line('velha:'|| :old.federacao || ' nova:' || :new.federacao);
            end if;
        end if;
         if Collection_Nacao_Federacao(:old.federacao) < 1 then
             raise e_nao_pode;
        end if;
    
    end if;

    IF DELETING and :old.federacao is not null  then
        IF Collection_Nacao_Federacao(:old.federacao) <= 1   THEN
           raise e_nao_pode;
        end if;
    END IF;   
   
END AFTER EACH ROW;

END federacao_nacao;

select * from nacao where federacao ='Ea ex fuga.';
/*Non soluta sit.	0	Ea ex fuga.
Quam facere.	0	Ea ex fuga.
Odio unde a.	0	Ea ex fuga.*/

update nacao set federacao = 'Deserunt vero.' where nome = 'Quam facere.';
select * from nacao where federacao ='Ea ex fuga.';

update nacao set federacao = 'Deserunt vero.' where nome = 'Odio unde a.';

delete from nacao where nome ='Odio unde a.';

--1 linha atualizado.

rollback;

commit;


--b)
Create or replace trigger LiderFaccaoNacao
after insert or update on Nacao_Faccao
for each row
declare
  e_nao_pode exception;
  v_lider Faccao.lider%type;
  v_nacao Nacao_Faccao.nacao%type;
begin
    Select lider into v_lider from Faccao where nome = :new.faccao;
    Update lider set nacao = :new.nacao where cpi = v_lider;
exception
    when others
        then  dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM );
end LiderFaccaoNacao;
/*SAIDA
    Trigger LIDERFACCAONACAO compilado
*/


--c)
Create or replace trigger  qttFaccao_Nacao_remove
After delete on Nacao_Faccao for each row
Begin
    Update Faccao set qtd_nacoes = qtd_nacoes - 1
        where nome = :old.faccao;
exception
    when others
        then  dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM );
end qttFaccao_Nacao;

Create or replace trigger  qttFaccao_Nacao_soma
After insert on Nacao_Faccao for each row
Begin
    Update Faccao set qtd_nacoes = qtd_nacoes + 1
        where nome = :old.faccao;
exception
    when others
        then  dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM );
end qttFaccao_Nacao;
/*SAIDA
 Trigger QTTFACCAO_NACAO_REMOVE compilado
*/

--d
Create or replace trigger qtd_planeta_nacao
After insert or update on dominancia for each row
Begin
    if(:new.data_fim > SYSDATE) then
     Update nacao  set qtd_planetas = qtd_planetas + 1
        where nome = :new.nacao;
    end if;
exception
    when others
        then  dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM );
end qtd_planeta_nacao;
/*SAIDA
    Trigger QTD_PLANETA_NACAO compilado
*/

Create or replace trigger qtd_planeta_nacao_remove
After delete on dominancia for each row
Begin
     Update nacao  set qtd_planetas = qtd_planetas - 1
        where nome = :old.nacao;
exception
    when others
        then  dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM );
end qtd_planeta_nacao_remove;
/*SAIDA
    Trigger QTD_PLANETA_NACAO_REMOVE compilado
*/

--2)
-- considerando que o privilégio de execução de cada operação
-- será tratado em nível da aplicação (e não no banco de dados),
-- para os fins deste exercício, o foco será somente na implementação
-- da solução de gerenciamento.

-- para utilizar trigger instead of é necessário a criação de uma view
create or replace view op_credenciar_comunidades as 
select
    nacao_faccao.nacao,
    dominancia.planeta,
    comunidade.nome,
    case when habitacao.planeta is not null then 's' else 'n' end as credenciada
from dominancia
join nacao_faccao on dominancia.nacao = nacao_faccao.nacao
left join habitacao on dominancia.planeta = habitacao.planeta
left join comunidade on habitacao.especie = comunidade.especie and habitacao.comunidade = comunidade.nome
where nacao_faccao.faccao = 'FACCAO_A' -- alterar conforme necessário para simular a parâmetro da busca
and dominancia.data_fim is null;

-- dados gerados (chatGPT) para teste
-- Gerar dados para FEDERACAO
INSERT INTO FEDERACAO (NOME, DATA_FUND)
VALUES ('Federacao_A', TO_DATE('2020-01-01', 'YYYY-MM-DD'));

-- Gerar dados para NACAO
INSERT INTO NACAO (NOME, QTD_PLANETAS, FEDERACAO)
VALUES ('Nacao_A', 5, 'Federacao_A');

-- Gerar dados para PLANETA
INSERT INTO PLANETA (ID_ASTRO, MASSA, RAIO, CLASSIFICACAO)
VALUES ('Planeta_A1', 2000, 5000, 'Tipo1');
INSERT INTO PLANETA (ID_ASTRO, MASSA, RAIO, CLASSIFICACAO)
VALUES ('Planeta_A2', 3000, 6000, 'Tipo2');
INSERT INTO PLANETA (ID_ASTRO, MASSA, RAIO, CLASSIFICACAO)
VALUES ('Planeta_A3', 4000, 7000, 'Tipo3');
INSERT INTO PLANETA (ID_ASTRO, MASSA, RAIO, CLASSIFICACAO)
VALUES ('Planeta_A4', 5000, 8000, 'Tipo1');
INSERT INTO PLANETA (ID_ASTRO, MASSA, RAIO, CLASSIFICACAO)
VALUES ('Planeta_A5', 6000, 9000, 'Tipo2');

-- Gerar dados para ESPECIE
INSERT INTO ESPECIE (NOME, PLANETA_OR, INTELIGENTE)
VALUES ('Especie_A', 'Planeta_A1', 'V');
INSERT INTO ESPECIE (NOME, PLANETA_OR, INTELIGENTE)
VALUES ('Especie_B', 'Planeta_A2', 'F');
INSERT INTO ESPECIE (NOME, PLANETA_OR, INTELIGENTE)
VALUES ('Especie_C', 'Planeta_A3', 'V');

-- Gerar dados para COMUNIDADE
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES)
VALUES ('Especie_A', 'Comunidade_A1', 1000);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES)
VALUES ('Especie_B', 'Comunidade_B1', 2000);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES)
VALUES ('Especie_C', 'Comunidade_C1', 1500);

-- Gerar dados para HABITACAO
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI, DATA_FIM)
VALUES ('Planeta_A1', 'Especie_A', 'Comunidade_A1', TO_DATE('2023-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI, DATA_FIM)
VALUES ('Planeta_A2', 'Especie_B', 'Comunidade_B1', TO_DATE('2023-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI, DATA_FIM)
VALUES ('Planeta_A3', 'Especie_C', 'Comunidade_C1', TO_DATE('2023-01-01', 'YYYY-MM-DD'), NULL);

-- Gerar dados para LIDER
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE)
VALUES ('111.222.333-44', 'Lider_A', 'COMANDANTE', 'Nacao_A', 'Especie_A');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE)
VALUES ('222.333.444-55', 'Lider_B', 'OFICIAL', 'Nacao_A', 'Especie_B');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE)
VALUES ('333.444.555-66', 'Lider_C', 'CIENTISTA', 'Nacao_A', 'Especie_C');

-- Gerar dados para FACCAO
INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES)
VALUES ('FACCAO_A', '111.222.333-44', 'PROGRESSITA', 1);

-- Gerar dados para NACAO_FACCAO
INSERT INTO NACAO_FACCAO (NACAO, FACCAO)
VALUES ('Nacao_A', 'FACCAO_A');

-- Gerar dados para PARTICIPA
INSERT INTO PARTICIPA (FACCAO, ESPECIE, COMUNIDADE)
VALUES ('FACCAO_A', 'Especie_A', 'Comunidade_A1');
INSERT INTO PARTICIPA (FACCAO, ESPECIE, COMUNIDADE)
VALUES ('FACCAO_A', 'Especie_B', 'Comunidade_B1');
INSERT INTO PARTICIPA (FACCAO, ESPECIE, COMUNIDADE)
VALUES ('FACCAO_A', 'Especie_C', 'Comunidade_C1');

-- Gerar dados para DOMINANCIA
INSERT INTO DOMINANCIA (PLANETA, NACAO, DATA_INI, DATA_FIM)
VALUES ('Planeta_A1', 'Nacao_A', TO_DATE('2023-01-01', 'YYYY-MM-DD'), NULL);

-- teste da saída da view
select * from op_credenciar_comunidades;

-- saída:
-- NacaoTeste	Planeta1	    ComunidadeTeste	s
-- NacaoTeste	PlanetaTeste	ComunidadeTeste	s
-- Nacao_A	    Planeta_A1	    Comunidade_A1	s
-- NacaoTeste	Planeta3		-               n
-- NacaoTeste	Planeta2		-               n

-- trigger instead of para credenciar comunidades
-- OBSERVAÇÃO: trocar 'FACCAO_A' para o valor da FACCAO do líder/usuário
create or replace trigger credenciar_comunidades
instead of insert on op_credenciar_comunidades
for each row
begin
    if :new.credenciada = 's' then
        insert into participa (faccao, especie, comunidade)
        values ('FACCAO_A', (select especie from habitacao where planeta = :new.planeta and comunidade = :new.nome), :new.nome);
    else
        delete from participa where faccao = 'FACCAO_A' and especie = (select especie from habitacao where planeta = :new.planeta and comunidade = :new.nome) and comunidade = :new.nome;
    end if;
end;

-- teste do gatilho com 'credenciada' = 'n'
insert into op_credenciar_comunidades (nacao, planeta, nome, credenciada) values ('Nacao_A', 'Planeta_A1', 'Comunidade_A1', 'n');
select * from participa;
-- saída
-- FACCAO1	ESPECIE1	COMUNIDADE1
-- FACCAO2	ESPECIE2	COMUNIDADE2
-- FACCAO_A	Especie_B	Comunidade_B1
-- FACCAO_A	Especie_C	Comunidade_C1

-- teste do gatilho com 'credenciada' = 's'
insert into op_credenciar_comunidades (nacao, planeta, nome, credenciada) values ('Nacao_A', 'Planeta_A1', 'Comunidade_A1', 's');
select * from participa;
-- saída:
-- FACCAO1	ESPECIE1	COMUNIDADE1
-- FACCAO2	ESPECIE2	COMUNIDADE2
-- FACCAO_A	Especie_A	Comunidade_A1
-- FACCAO_A	Especie_B	Comunidade_B1
-- FACCAO_A	Especie_C	Comunidade_C1
