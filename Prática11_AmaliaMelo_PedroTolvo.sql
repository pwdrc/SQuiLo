--Amália Vitória de Melo NUSP:13692417
--Pedro Guilherme Tolvo NUSP:10492012


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

-- b) Os triggers são executados dentro da mesma transação em que é executada a operação
-- instrução de disparo e, portanto, as operações dentro do trigger são efetivadas (commit) ou
-- desfeitas (rollback) junto com as operações da transação em que está a instrução.
-- Implemente e teste esse cenário (i.e. teste commit e rollback da transação em que está
-- a instrução que dispara o trigger e explique o que acontece no log).

-- Transação comitada
set transaction isolation level read committed
name 'transacao_teste_1';
begin
    insert into planeta values ('teste_trigger', 100, 50, 'maneiro');
    commit;
end;
-- Saída
-- A10492012	insert	22/05/24
-- Explicacao: A transação foi comitada, logo o log foi registrado

-- Saída
-- c) Considere agora um cenário em que é interessante manter o log das informações de todas as
-- tentativas de execução de operações DML, mesmo que a operação em si não tenha sido
-- efetivada. Implemente e teste esse cenário (i.e. teste commit e rollback da transação
-- em que está a instrução que dispara o trigger e explique o que acontece no log).