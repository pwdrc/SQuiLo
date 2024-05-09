--1)
/*
Implemente uma função que calcule a distância entre duas estrelas (pode ser distância
Euclididana)
*/
/*
cria (ou substitui) a função armazenada para o cálculo da distância
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

/*
Implemente as seguines funcionalidades relacionadas ao 
usuário Cientista do Sistema Sociedade
Galática (ver descrição do projeto final):
a. Gerenciamento: item 4.a (CRUD de estrelas)
b. Relatórios: item 4.a (Informações de Estrelas, Planetas e Sistemas)
*/

/*
Considerando que:
- a função/cargo de cada usuário será tratado em aplicação
- haverá 4 telas, uma para cada usuário
- cada tela só permitirá que as funções desse usuário sejam executadas
Logo, não é necessário se precoupar, diretamente, com o cargo do usuário no banco de dados
*/
-- a. Gerenciamento: item 4.a (CRUD de estrelas)
-- create
-- read
-- update
-- delete

-- b. Relatórios: item 4.a 
-- (Informações de Estrelas, Planetas e Sistemas)
/*
Informações de Estrelas, Planetas e 
Sistemas: o cientista está interessado
principalmente em catalogar corpos 
celestes. Assim, ele deve ter acesso 
a relatórios de estrelas, planetas e 
sistemas, que sirvam de apoio a 
atividades como possível
ampliação do catálogo existente e
preenchimento de valores faltantes no 
sistema.

b. Bônus (1.5): É também de interesse 
para o cientista a capacidade de analisar
grupos de sistemas próximos e/ou 
densamente compactados, assim como
informações como a prevalência ou 
correlação de características 
específicas de estrelas/planetas em 
regiões particulares da galáxia. 
Em outras palavras, quando um cientista
seleciona um sistema/estrela e um
intervalo de distâncias, o relatório
deve fornecer métricas relevantes para 
todos os corpos celestes nesse intervalo,
tomando como referência o sistema/estrela
selecionado. Por exemplo: "Desejo obter
informações sobre todos os corpos 
celestes situados a uma distância 
superior a 100 anos-luz e inferior a 200 
anos-luz do Sistema Solar".

c. Bônus (1.0): Implemente uma solução 
que otimize o cálculo de distâncias 
entre estrelas.
*/

create or 
--2)
/*Considerando que:
- a função/cargo de cada usuário será tratado em aplicação
- haverá 4 telas, uma para cada usuário
- cada tela só permitirá que as funções desse usuário sejam executadas
Logo, não é necessário se precoupar, diretamente, com o cargo do usuário no banco de dados*/
CREATE OR REPLACE PROCEDURE remover_faccao_nacao ( 
    p_lider IN OUT Faccao.lider%TYPE, 
    p_faccao IN OUT Faccao.nome%TYPE, 
    p_nacao OUT Nacao_faccao.nacao%TYPE ) AS 
    v_lider Faccao.lider%TYPE;
    v_faccao Faccao.nome%TYPE; 
    v_nacao  Nacao_faccao.nacao%TYPE;
    e_naoexiste EXCEPTION; 
    e_naopode EXCEPTION;
    e_naolider EXCEPTION;
   
     BEGIN 
     select lider into v_lider from Faccao where faccao.nome = p.faccao; 
     if v_lider = p_lider
        then
            select faccao into v_faccao from Nacao_faccao where faccao.lider = v_lider;
            then
        else
     EXCEPTION 
     WHEN NO_DATA_FOUND THEN RAISE e_naoexiste; 
 END remover_faccao_nacao; 
