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

/*
constraints da tabela estrela
CK_ESTRELA_MASSA	Check	MASSA > 0
PK_ESTRELA	Primary_Key	
SYS_C00230128	Check	"X" IS NOT NULL
SYS_C00230129	Check	"Y" IS NOT NULL
SYS_C00230130	Check	"Z" IS NOT NULL
UN_ESTRELA_COORDS	Unique	
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
