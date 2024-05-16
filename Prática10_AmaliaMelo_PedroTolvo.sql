--1)

--a)
Create or replace trigger federacao_nacao
before delete on Nacao
for each row
declare
    e_nao_pode exception;
    v_confere number;
Begin
    Select count(Federacao) into v_confere from Nacao;
    if(v_confere>2) then 
        Delete from nacao where federacao = :old.federacao;
    else raise e_nao_pode;
    end if;
exception
    when e_nao_pode
        then dbms_output.put_line('Não é possível executar a operacao');
    when others
        then  dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM );
end federacao_nacao;

Create or replace trigger federacao_nacao_update
after update on Nacao
for each row
declare
    v_confere number;
Begin
    Select count(Federacao) into v_confere from Nacao
        where federacao = :old.federacao;
    if(v_confere<1) then 
        Delete from Federacao where Nome = :old.federacao;
    end if;
exception
    when others
        then  dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM );
end federacao_nacao_update;

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


--2)
/*
Usando view e trigger instead-of implemente a funcionalidade (de Gerenciamento) 
a.iii do Líder de Facção: 
Credenciar comunidades novas (Participa), 
que habitem planetas dominados por nações onde a facção está presente/credenciada. 
Devem ser atendidos os seguintes requisitos:
• o líder deve visualizar: as nações em que sua facção está presente, os planetas
dominados (dominação atual) por cada uma dessas nações, as comunidades que habitam
cada um desses planetas, e a indicação se cada uma dessas comunidades está ou não
credenciada à facção da qual é lider;
• deve ser criada somente 1 view, e tanto a visualização de informações do item anterior
quanto o credenciamento de uma comunidade (em Participa) devem ser feitos
exclusivamente por meio da view.
*/

-- considerando que o privilégio de execução de cada operação
-- será tratado em nível da aplicação (e não no banco de dados),
-- para os fins deste exercício, o foco será somente na implementação
-- da solução de gerenciamento.

-- variável para simular o nome da faccao
-- substituir 'FACCAO1' pelo nome da facção desejada


-- para utilizar trigger instead of é necessário a criação de uma view
create or replace view credenciar_comunidades as
select participa.nacao, dominancia.planeta, participa.comunidade, credenciada
from participa, dominancia
where participa.facção = variavel_faccao
