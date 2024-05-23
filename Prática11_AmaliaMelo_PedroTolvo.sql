--Amália Vitória de Melo NUSP:13692417
--Pedro Guilherme Tolvo NUSP:10492012

--1)
--dando acesso de leitura ao usuário da sessão 2----------------------------------
select 'grant select on a13692417.'|| table_name || ' to a10492012;' from user_tables;

grant select on a13692417.FEDERACAO to a10492012;
grant select on a13692417.ESTRELA to a10492012;
grant select on a13692417.NACAO to a10492012;
grant select on a13692417.ESPECIE to a10492012;
grant select on a13692417.DOMINANCIA to a10492012;
grant select on a13692417.PLANETA to a10492012;
grant select on a13692417.NACAO_FACCAO to a10492012;
grant select on a13692417.LIDER to a10492012;
grant select on a13692417.FACCAO to a10492012;
grant select on a13692417.ORBITA_PLANETA to a10492012;
grant select on a13692417.COMUNIDADE to a10492012;
grant select on a13692417.HABITACAO to a10492012;
grant select on a13692417.PARTICIPA to a10492012;
grant select on a13692417.SISTEMA to a10492012;
grant select on a13692417.ORBITA_ESTRELA to a10492012;
---------------------------------------------------------------------------------------

-- EXECUTANDO COM READ COMMITED COMO NIVEL DE ISOLAMENTO--
--1.3) 
set transaction isolation level read committed;

--1.4)
select f.nome, f.ideologia, l.nome, l.especie, l.nacao from a13692417.faccao  f join a13692417.lider  l on f.lider = l.CPI;
/*
Comando red	TOTALITARIA	Denzel	Non eos qui	Nam ut a.
Carinhosa	TRADICIONALISTA	Mickey	Et sunt rerum	Fugit a omnis.
*/

--1.5)
--Na sessão 1
update faccao set ideologia = 'TOTALITARIA' where nome = 'Carinhosa';

select f.nome, f.ideologia, l.nome, l.especie, l.nacao from a13692417.faccao  f join a13692417.lider  l on f.lider = l.CPI;

/*
Comando red	TOTALITARIA	Denzel	Non eos qui	Nam ut a.
Carinhosa	TOTALITARIA	Mickey	Et sunt rerum	Fugit a omnis.
*/

-- A tabela alterou o atributo que foi atualizado anteriormente;
--1.6)
--Sessão 2
select f.nome, f.ideologia, l.nome, l.especie, l.nacao from a13692417.faccao  f join a13692417.lider  l on f.lider = l.CPI;

/*
Comando red	TOTALITARIA	Denzel	Non eos qui	Nam ut a.
Carinhosa	TRADICIONALISTA	Mickey	Et sunt rerum	Fugit a omnis.
*/

-- Não aconteceu a alteração na coluna q foi modificada pelo outro usuário dono da base, logo os dados lidos estão desatualizados.
--1.7 Sessão 1
commit;

--1.8) Sessão 2
select f.nome, f.ideologia, l.nome, l.especie, l.nacao from a13692417.faccao  f join a13692417.lider  l on f.lider = l.CPI;

/*
Comando red	TOTALITARIA	Denzel	Non eos qui	Nam ut a.
Carinhosa	TOTALITARIA	Mickey	Et sunt rerum	Fugit a omnis.
*/

-- Aconteceu a alteração na coluna que foi modificada pelo usuário dono da base, logo os dados lidos estão atualizados a partir de agora.

--1.9)  Sessão 2
commit;

--1.10  Sessão 2
select f.nome, f.ideologia, l.nome, l.especie, l.nacao from a13692417.faccao  f join a13692417.lider  l on f.lider = l.CPI;

/*
Comando red	TOTALITARIA	Denzel	Non eos qui	Nam ut a.
Carinhosa	TOTALITARIA	Mickey	Et sunt rerum	Fugit a omnis.
*/

-- Nada mudou, visto que os dados não pertencem a essa base, além de nada ter sido alterado nessa base também.

-- EXECUTANDO COM SERIALIZABLE COMO NIVEL DE ISOLAMENTO--

--1.4) Sessão 2
select f.nome, f.ideologia, l.nome, l.especie, l.nacao from a13692417.faccao  f join a13692417.lider  l on f.lider = l.CPI;
/*
Comando red	TOTALITARIA	Denzel	Non eos qui	Nam ut a.
Carinhosa	TOTALITARIA	Mickey	Et sunt rerum	Fugit a omnis.
*/

--1.5)  Sessão 1
update faccao set ideologia = 'PROGRESSITA' where nome = 'Carinhosa';

select f.nome, f.ideologia, l.nome, l.especie, l.nacao from a13692417.faccao  f join a13692417.lider  l on f.lider = l.CPI;

/*
Comando red	TOTALITARIA	Denzel	Non eos qui	Nam ut a.
Carinhosa	PROGRESSITA	Mickey	Et sunt rerum	Fugit a omnis.
*/

 -- A tabela alterou o atributo que foi atualizado anteriormente

--1.6) Sessão 2
select f.nome, f.ideologia, l.nome, l.especie, l.nacao from a13692417.faccao  f join a13692417.lider  l on f.lider = l.CPI;

/*
Comando red	TOTALITARIA	Denzel	Non eos qui	Nam ut a.
Carinhosa	TOTALITARIA	Mickey	Et sunt rerum	Fugit a omnis.
*/

-- Não aconteceu a alteração na coluna q foi modificada pelo outro usuário dono da base, logo os dados lidos estão desatualizados.

--1.7) Sessão 1
commit;

--1.8) Sessão 2
select f.nome, f.ideologia, l.nome, l.especie, l.nacao from a13692417.faccao  f join a13692417.lider  l on f.lider = l.CPI;

/*
Comando red	TOTALITARIA	Denzel	Non eos qui	Nam ut a.
Carinhosa	TOTALITARIA	Mickey	Et sunt rerum	Fugit a omnis.
*/

-- Não aconteceu a alteração na coluna q foi modificada pelo outro usuário dono da base, logo os dados lidos estão desatualizados.


--1.9) Sessão 2
commit;


--1.10) Sessão 2
select f.nome, f.ideologia, l.nome, l.especie, l.nacao from a13692417.faccao  f join a13692417.lider  l on f.lider = l.CPI;

/*
Comando red	TOTALITARIA	Denzel	Non eos qui	Nam ut a.
Carinhosa	PROGRESSITA	Mickey	Et sunt rerum	Fugit a omnis.
*/

-- Aconteceu a alteração na coluna que foi modificada pelo usuário dono da base, logo os dados lidos estão atualizados a partir de agora.



-- 2
-- a
-- Tabela para armazenar os logs
create table log_op_planeta(
    usuario varchar2(50),
    operacao varchar2(250),
    data_hora date,
    constraint pk_log_op_planeta primary key(usuario, operacao, data_hora)
);

-- Trigger
create or replace trigger log_op_planeta_insert
after insert on planeta
begin
    insert into log_op_planeta(usuario, operacao, data_hora)
    values(user, 'insert', sysdate);
end;
/
create or replace trigger log_op_planeta_update
after update on planeta
begin
    insert into log_op_planeta(usuario, operacao, data_hora)
    values(user, 'update', sysdate);
end;
/
create or replace trigger log_op_planeta_delete
after delete on planeta
begin
    insert into log_op_planeta(usuario, operacao, data_hora)
    values(user, 'delete', sysdate);
end;

-- Teste
insert into planeta values ('teste_trigger', 100, 50, 'maneiro')
-- Saída
-- A10492012 | insert | 22/05/24

-- Transação comitada
set transaction isolation level read committed
name 'transacao_teste_1';
begin
    insert into planeta values ('teste_trigger_3', 100, 50, 'maneiro');
    commit;
end;

-- Saída
-- A10492012	insert	22/05/24
-- Explicacao: A transação foi comitada, logo o log foi registrado

-- Transcao com rollback
set transaction isolation level read committed
name 'transacao_teste_2';
begin
    insert into planeta values ('teste_trigger_4', 100, 50, 'maneiro');
    rollback;
end;
-- O log não foi inserido, pois a transação foi desfeita

-- c) 
-- Trigger autônomo, que registra inclusive ações com rollback
-- Procedimento autônomo
CREATE OR REPLACE PROCEDURE log_op_aut(p_operacao VARCHAR2) AS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO log_op_planeta(usuario, operacao, data_hora)
  VALUES(USER, p_operacao, SYSDATE);
  COMMIT;
END;
/

-- Triggers que chamam o procedimento autônomo
CREATE OR REPLACE TRIGGER log_op_aut_insert
BEFORE INSERT ON planeta
FOR EACH ROW
BEGIN
  log_op_aut('INSERT');
END;
/

CREATE OR REPLACE TRIGGER log_op_aut_update
BEFORE UPDATE ON planeta
FOR EACH ROW
BEGIN
  log_op_aut('UPDATE');
END;
/

CREATE OR REPLACE TRIGGER log_op_aut_delete
BEFORE DELETE ON planeta
FOR EACH ROW
BEGIN
  log_op_aut('DELETE');
END;
/

-- Teste rollback
set transaction isolation level read committed
name 'transacao_teste_rollback';
begin
    insert into planeta values ('tem_que_gravar', 100, 50, 'maneiro');
    rollback;
end;
-- O log foi inserido, mesmo com o rollback, em função da adoção de um procedimento autônomo
