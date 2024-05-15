--Amália Vitória de Melo NUSP:13692417
--Pedro Guilherme Tolvo NUSP:10492012
--1)
/*
Considerando que:
- a função/cargo de cada usuário será tratado em aplicação
- haverá 4 telas, uma para cada usuário
- cada tela só permitirá que as funções desse usuário sejam executadas
Logo, não é necessário se precoupar, diretamente, com o cargo do usuário no banco de dados
*/
create or replace function distancia (
    estrela_a estrela.id_estrela%type,
    estrela_b estrela.id_estrela%type
) return number as 
    v_distancia number;

begin
    select sqrt(
        power((select X from estrela where id_estrela = estrela_a) - (select x from estrela where id_estrela = estrela_b), 2) +
        power((select Y from estrela where id_estrela = estrela_a) - (select y from estrela where id_estrela = estrela_b), 2) +
        power((select Z from estrela where id_estrela = estrela_a) - (select z from estrela where id_estrela = estrela_b), 2)
    ) into v_distancia from dual;

    return round(v_distancia, 5);
end distancia;

/*
chama a funcao
*/
declare
    estrela_a estrela.id_estrela%type;
    estrela_b estrela.id_estrela%type;
    v_distancia number;
begin
    estrela_a := 'Zet2Mus';
    estrela_b := 'Citadelle';
    v_distancia := distancia(estrela_a, estrela_b);
    dbms_output.put_line('A distância entre ' || estrela_a || ' e ' || estrela_b || ' é ' || v_distancia);
end;
/*
Saída:
--------------
A distância entre Zet2Mus e Citadelle é 233,98187
--------------
*/

--2) 
/*No Projeto Final, usaremos packages para modularizar as 
funções de cada um dos nossos uusuários, sendo o lider facção um deles*/

Create or replace package Lider_Faccao as
    e_naoEncontrado Exception;
    
    Procedure remover_faccao_de_nacao(
    p_faccao Faccao.Nome%type);
end Lider_Faccao;

/

Create or replace package body Lider_Faccao as
    Procedure remover_faccao_de_nacao(p_faccao Faccao.Nome%type)
    as 
    begin
        Delete from nacao_faccao where faccao = p_faccao;
        IF SQL%NOTFOUND then raise e_naoEncontrado;
        end if;
    end remover_faccao_de_nacao;
end Lider_Faccao;

/*
Considerando que:
- a função/cargo de cada usuário será tratado em aplicação
- haverá 4 telas, uma para cada usuário
- cada tela só permitirá que as funções desse usuário sejam executadas
Logo, não é necessário se precoupar, diretamente, com o cargo do usuário no banco de dados
*/
--SAIDA
/*
Package LIDER_FACCAO compilado


Package Body LIDER_FACCAO compilado
*/

--3)
Create or replace package Comandante as

    e_naoEncontrado Exception;
    e_federacao_existe Exception;
    
    Procedure Criar_nova_federacao(
    p_nacao Nacao.Nome%type);
    
    var_federacao Nacao.Federacao%type;
    
    procedure verificar_federacao_existe(
    p_nacao Nacao.nome%type);
    
     
    
end Comandante;

Create or replace package body Comandante as 
    Procedure criar_nova_federacao(p_nacao Nacao.nome%type)
    as
    begin 
        
    end criar_nova_federacao;

    Procedure verificar_federacao_existe(p_nacao Nacao.nome%type)
    as
    begin
        select federacao into var_fedaracao from Nacao
            where nome = p_nacao;
        if(var_federacao == null)
            Criar_nova_federacao(p_nacao);
        else raise e_federacao_existe;
    end verificar_federacao_existe;   

-- 4)
/*
Considerando que:
- a função/cargo de cada usuário será tratado em aplicação
- haverá 4 telas, uma para cada usuário
- cada tela só permitirá que as funções desse usuário sejam executadas
Logo, não é necessário se precoupar, diretamente, com o cargo do usuário no banco de dados
*/

create or replace package CIENTISTA as
    -- CRUD de estrelas
    procedure create_estrela(
        id_estrela estrela.id_estrela%type,
        nome_estrela estrela.nome%type,
        classificacao_estrela estrela.classificacao%type,
        massa_estrela estrela.massa%type,
        x_estrela estrela.X%type,
        y_estrela estrela.Y%type,
        z_estrela estrela.Z%type
    );

    procedure read_estrela(
        id_estrela estrela.id_estrela%type
    );

    procedure update_estrela(
        id_estrela estrela.id_estrela%type,
        new_data_estrela estrela%rowtype
    );

    procedure delete_estrela(
        nome_estrela estrela.nome%type
    );

    -- Informações de Estrelas, Planetas e Sistemas
    procedure relatorio_estrela(
        nome_estrela estrela.nome%type
    );

    procedure relatorio_planeta(
        nome_planeta planeta.nome%type
    );

    procedure relatorio_sistema(
        nome_sistema sistema.nome%type
    );

    -- Bônus (1.5)
    procedure relatorio_corpos_celestes(
        nome_corpo_corpo_estrela estrela.nome%type,
        distancia_min number,
        distancia_max number
    );

    -- Bônus (1.0)
    function distancia_otimizada(
        estrela_a estrela.id_estrela%type,
        estrela_b estrela.id_estrela%type
    ) return number;
end CIENTISTA;
