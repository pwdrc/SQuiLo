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

-- chamar o meu package com o nome da procedure em um bloco PL/SQL
-- verificar se a nação não está sendo usada em outra ligação, com planeta, ou participa
-- verificação semantica da restrição

--3)
Create or replace package Comandante as

    e_naoEncontrado Exception;
    e_federacao_existe Exception;
    
    Procedure Criar_nova_federacao(
        p_nacao Nacao.Nome%type
     );
    
    procedure verificar_federacao_existe(
        p_nacao Nacao.nome%type);
    
    
end Comandante;

/

Create or replace package body Comandante as 
    
    Procedure Criar_nova_federacao(p_nacao in Nacao.nome%type)
    as 
     v_nome_federacao federacao.nome%TYPE;
    begin 
        v_nome_federacao := 'TESTE2024';
        insert into federacao values (v_nome_federacao, (SYSDATE));
        update Nacao set federacao = v_nome_federacao where nome = p_nacao;
    end Criar_nova_federacao;

    Procedure verificar_federacao_existe(p_nacao Nacao.nome%type)
    as
      var_federacao Nacao.Federacao%type;
    begin
        select federacao into var_federacao from Nacao
            where nome = p_nacao;
        if(var_federacao is null) then
            Criar_nova_federacao(p_nacao);
            else raise e_federacao_existe;
        end if;
    end verificar_federacao_existe;   
    
end Comandante;

-- chamar o package em um bloco PL/SQL separado

-- 4)
/*
Considerando que:
- a função/cargo de cada usuário será tratado em aplicação
- haverá 4 telas, uma para cada usuário
- cada tela só permitirá que as funções desse usuário sejam executadas
Logo, não é necessário se precoupar, diretamente, com o cargo do usuário no banco de dados
*/

create or replace package CIENTISTA as
    -- CRUD estrela
    Procedure inserir_estrela(
        p_id_estrela estrela.id_estrela%type,
        p_nome estrela.nome%type,
        p_classificacao estrela.classificacao%type,
        p_massa estrela.massa%type,
        p_x estrela.x%type,
        p_y estrela.y%type,
        p_z estrela.z%type
    );

    Procedure atualizar_estrela(
        p_id_estrela estrela.id_estrela%type,
        p_nome estrela.nome%type,
        p_classificacao estrela.classificacao%type,
        p_massa estrela.massa%type,
        p_x estrela.x%type,
        p_y estrela.y%type,
        p_z estrela.z%type
    );

    Procedure remover_estrela(
        p_id_estrela estrela.id_estrela%type
    );

    -- Informações de Estrelas, Planetas e Sistemas
    Function listar_estrelas return sys_refcursor;
    Function listar_planetas return sys_refcursor;
    Function listar_sistemas return sys_refcursor;
end CIENTISTA;
/
-- body
create or replace package body CIENTISTA as
    Procedure inserir_estrela(
        p_id_estrela estrela.id_estrela%type,
        p_nome estrela.nome%type,
        p_classificacao estrela.classificacao%type,
        p_massa estrela.massa%type,
        p_x estrela.x%type,
        p_y estrela.y%type,
        p_z estrela.z%type
    ) as
    begin
        insert into estrela values (p_id_estrela, p_nome, p_classificacao, p_massa, p_x, p_y, p_z);
        EXCEPTION
            when DUP_VAL_ON_INDEX then
                dbms_output.put_line('Estrela já existe');
            when NO_DATA_FOUND then
                dbms_output.put_line('Estrela não encontrada');
            when OTHERS then
                dbms_output.put_line('Erro ao inserir estrela');
    end inserir_estrela;

    Procedure atualizar_estrela(
        p_id_estrela estrela.id_estrela%type,
        p_nome estrela.nome%type,
        p_classificacao estrela.classificacao%type,
        p_massa estrela.massa%type,
        p_x estrela.x%type,
        p_y estrela.y%type,
        p_z estrela.z%type
    ) as
    begin
        update estrela set
            nome = p_nome,
            classificacao = p_classificacao,
            massa = p_massa,
            x = p_x,
            y = p_y,
            z = p_z
        where id_estrela = p_id_estrela;
        EXCEPTION
            when NO_DATA_FOUND then
                dbms_output.put_line('Estrela não encontrada');
            when OTHERS then
                dbms_output.put_line('Erro ao atualizar estrela');
    end atualizar_estrela;

    Procedure remover_estrela(
        p_id_estrela estrela.id_estrela%type
    ) as
    begin
        delete from estrela where id_estrela = p_id_estrela;
        EXCEPTION
            when NO_DATA_FOUND then
                dbms_output.put_line('Estrela não encontrada');
            when OTHERS then
                dbms_output.put_line('Erro ao remover estrela');
    end remover_estrela;

    Function listar_estrelas return sys_refcursor as
        v_cursor sys_refcursor;
    begin
        open v_cursor for
            select * from estrela;
        return v_cursor;
    end listar_estrelas;

    Function listar_planetas return sys_refcursor as
        v_cursor sys_refcursor;
    begin
        open v_cursor for
            select * from planeta;
        return v_cursor;
    end listar_planetas;

    Function listar_sistemas return sys_refcursor as
        v_cursor sys_refcursor;
    begin
        open v_cursor for
            select * from sistema;
        return v_cursor;
    end listar_sistemas;
end CIENTISTA;

-- testes
declare
    v_cursor sys_refcursor;
    v_id_estrela estrela.id_estrela%type;
    v_nome estrela.nome%type;
    v_classificacao estrela.classificacao%type;
    v_massa estrela.massa%type;
    v_x estrela.x%type;
    v_y estrela.y%type;
    v_z estrela.z%type;
begin
    CIENTISTA.inserir_estrela('Zet2Mus', 'Zeta 2 Muscae', 'G2V', 1.1, 1, 2, 3);
    CIENTISTA.inserir_estrela('Citadelle', 'Citadelle', 'K0V', 0.8, 4, 5, 6);
    CIENTISTA.inserir_estrela('Zet2Mus', 'Zeta 2 Muscae', 'G2V', 1.1, 1, 2, 3);
    CIENTISTA.inserir_estrela('Citadelle', 'Citadelle', 'K0V', 0.8, 4, 5, 6);

    v_cursor := CIENTISTA.listar_estrelas;
    loop
        fetch v_cursor into v_id_estrela, v_nome, v_classificacao, v_massa, v_x, v_y, v_z;
        exit when v_cursor%notfound;
        dbms_output.put_line(v_id_estrela || ' ' || v_nome || ' ' || v_classificacao || ' ' || v_massa || ' ' || v_x || ' ' || v_y || ' ' || v_z);
    end loop;
    close v_cursor;
end;


/* saída (parcial)
strela já existe
Estrela já existe
Estrela já existe
Estrela já existe
Gl 539 Menkent K0IIIb 42.46195639463128 -12.358808 -7.624204 -10.694288
Zet2Mus  Am 77.55324957585901 -38.477906 -3.725728 -93.430273
21    Mon  F2V 44.136714346343965 -26.721561 82.987009 -.459427
GJ 3579  m .0009120108393559 -12.511333 7.23996 15.612279
Del Cae  B2IV-V 380.8903764981352 57.976821 141.4236 -152.599589
Gl 84  M3 .0061094202490557 7.447634 4.522928 -2.766518
Nu  Hor  A2V 17.603539536161644 17.06589 15.504933 -44.877574
GJ 1079  K2/K3V .2288758657062362 2.19941 14.825278 -9.549867
GJ 3200  G3V 1.3514500541175594 20.511102 21.863046 -7.342177
23    Lyn  K5III 146.28506869998537 -49.557608 105.284831 179.755262
Gl 654.1  F9V 1.4804713248976245 -4.886918 -20.077518 .253391
GJ 3298  K4V .1706082389003123 7.325216 18.397104 -14.892531
50    LMi  K0 15.332041990349136 -68.150834 19.357413 33.792481
GJ 3724  m .0001336595516546 -23.394295 -2.564435 10.177992
46    Cnc  G5III 101.85913880541167 -102.89117 116.956839 92.483481
(...)
*/
