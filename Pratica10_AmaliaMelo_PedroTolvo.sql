--Amália Vitória de Melo NUSP:13692417
--Pedro Guilherme Tolvo NUSP:10492012

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
