-- Pratica 8
-- Amalia Melo - 13692417
-- Pedro Tolvo - 10492012

--1)
-- inserindo alguns dados para o desenvolvimento do exercício
insert into comunidade (especie, nome, qtd_habitantes)
    values ('ESPECIE1', 'teste0', 2);
insert into comunidade (especie, nome, qtd_habitantes)
    values ('ESPECIE1', 'teste1', 2);


insert into habitacao (planeta, especie, comunidade, data_ini)
    values ('PLANETA1','ESPECIE1','teste0',to_date('05/05/2005', 'dd/mm/yyyy'))

insert into habitacao (planeta, especie, comunidade, data_ini)
    values ('PLANETA1','ESPECIE1','teste1',to_date('05/05/2005', 'dd/mm/yyyy'))

-- criando o programa

declare
    -- simular entrada do usuario
    v_faccao varchar2(15) := 'FACCAO2'; -- alterar conforme necessário
    -- variáveis para armazenar os dados da consulta
    v_nome_comunidade comunidade.nome%type;
    v_planeta habitacao.planeta%type;
    v_nacao dominancia.nacao%type;
    v_faccao_nf nacao_faccao.faccao%type;
    -- cursor para percorrer as comunidades
    cursor c_comunidades is
        select c.nome, h.planeta, d.nacao, nf.faccao from comunidade c
        join habitacao h on c.nome = h.comunidade
        join planeta p on h.planeta = p.id_astro
        join dominancia d on p.id_astro = d.planeta
        join nacao_faccao nf on d.nacao = nf.nacao
        where nf.faccao != v_faccao;
begin
    -- abrindo o cursor
    open c_comunidades;
    -- percorrendo o cursor
    loop
        fetch c_comunidades into v_nome_comunidade, v_planeta, v_nacao, v_faccao_nf;
        -- imprimir encontrados
        dbms_output.put_line('Comunidade ' || v_nome_comunidade || ' encontrada no planeta ' || v_planeta || ' dominado pela nação ' || v_nacao);
        -- saindo do loop quando não houver mais registros
        exit when c_comunidades%notfound;
        -- inserindo a comunidade na facção com verificacao de erro e imprimindo o que foi feito
        begin
            dbms_output.put_line('Tentando inserir comunidade ' || v_nome_comunidade || ' na facção ' || v_faccao);
            insert into participa (faccao, especie, comunidade)
                values (v_faccao, 'ESPECIE1', v_nome_comunidade);
            dbms_output.put_line('Comunidade ' || v_nome_comunidade || ' inserida na facção ' || v_faccao);
        exception
            when dup_val_on_index then
                dbms_output.put_line('Comunidade ' || v_nome_comunidade || ' já está na facção ' || v_faccao);
            when others then
                dbms_output.put_line('Erro ao inserir comunidade ' || v_nome_comunidade || ' na facção ' || v_faccao);
        end;
    end loop;
    -- fechando o cursor
    close c_comunidades;
end;

/* Resultado esperado:
Comunidade COMUNIDADE1 encontrada no planeta PLANETA1 dominado pela nação NACAO1
Tentando inserir comunidade COMUNIDADE1 na facção FACCAO2
Comunidade COMUNIDADE1 já está na facção FACCAO2
Comunidade COMUNIDADE1 encontrada no planeta PLANETA1 dominado pela nação NACAO1
*/

--2)
insert into dominancia (nacao, planeta, data_ini, data_fim)
values ('Deserunt vero.', 'Laborum nihil.', to_date('02/02/2002','dd/mm/yyyy'), null);

insert into dominancia (nacao, planeta, data_ini, data_fim)
values ('Deserunt vero.', 'Et iure earum.', to_date('04/05/1025','dd/mm/yyyy'), null);

insert into dominancia (nacao, planeta, data_ini, data_fim)
values ('Nam ut a.', 'Ut quisquam.', to_date('04/05/1025','dd/mm/yyyy'), to_date('16/05/2005','dd/mm/yyyy'));

insert into habitacao (planeta,especie,comunidade,data_ini, data_fim)
values ('Et iure earum.', 'Id sed', 'Teste3', to_date('12/12/2001', 'dd/mm/yyyy'), to_date('10/10/2010', 'dd/mm/yyyy'));

insert into habitacao (planeta,especie,comunidade,data_ini, data_fim)
values ('Et iure earum.', 'Ea qui modi', 'Teste0', to_date('12/12/2001', 'dd/mm/yyyy'), to_date('10/10/2010', 'dd/mm/yyyy'));
         

DECLARE
    TYPE planeta_info_type IS RECORD (
        id_astro PLANETA.ID_ASTRO%TYPE,
        nacao_atual DOMINANCIA.NACAO%TYPE,
        data_ini DOMINANCIA.DATA_INI%TYPE,
        data_fim DOMINANCIA.DATA_FIM%TYPE,
        qtd_comunidades NUMBER,
        qtd_especies NUMBER,
        qtd_habitantes NUMBER,
        qtd_faccoes NUMBER,
        faccao_majoritaria VARCHAR2(100),
        qtd_especies_origem NUMBER
    );
    
    TYPE planeta_info_table IS TABLE OF planeta_info_type INDEX BY PLS_INTEGER;
    
    v_planeta_info planeta_info_table;
    v_nacao_atual DOMINANCIA.NACAO%TYPE;
    v_data_ini DOMINANCIA.DATA_INI%TYPE;
    v_data_fim DOMINANCIA.DATA_FIM%TYPE;
    v_qtd_comunidades NUMBER;
    v_qtd_especies NUMBER;
    v_qtd_habitantes NUMBER;
    v_qtd_faccoes NUMBER;
    v_faccao_majoritaria VARCHAR2(100);
    v_qtd_especies_origem NUMBER;
BEGIN
    FOR r_planeta IN (SELECT DISTINCT p.id_astro
                      FROM planeta p
                      JOIN dominancia dom ON dom.planeta = p.id_astro
                      ORDER BY p.id_astro) LOOP
        BEGIN
             SELECT d.nacao, d.data_ini, d.data_fim
            INTO v_nacao_atual, v_data_ini, v_data_fim
            FROM (
                SELECT nacao, data_ini, data_fim
                FROM dominancia
                WHERE planeta = r_planeta.id_astro
                ORDER BY data_ini DESC
            ) d
            WHERE ROWNUM = 1;

            SELECT COUNT(DISTINCT c.nome)
            INTO v_qtd_comunidades
            FROM comunidade c
            JOIN habitacao h ON h.comunidade = c.nome
            WHERE h.planeta = r_planeta.id_astro;

            SELECT COUNT(DISTINCT e.nome)
            INTO v_qtd_especies
            FROM especie e
            WHERE e.planeta_or = r_planeta.id_astro;

            SELECT COUNT(*)
            INTO v_qtd_habitantes
            FROM habitacao
            WHERE planeta = r_planeta.id_astro;

            -- Adicione consultas adicionais para calcular a quantidade de facções e a facção majoritária

            SELECT COUNT(DISTINCT e.nome)
            INTO v_qtd_especies_origem
            FROM especie e
            WHERE e.planeta_or = r_planeta.id_astro;

            v_planeta_info(r_planeta.id_astro).id_astro := r_planeta.id_astro;
            v_planeta_info(r_planeta.id_astro).nacao_atual := v_nacao_atual;
            v_planeta_info(r_planeta.id_astro).data_ini := v_data_ini;
            v_planeta_info(r_planeta.id_astro).data_fim := v_data_fim;
            v_planeta_info(r_planeta.id_astro).qtd_comunidades := v_qtd_comunidades;
            v_planeta_info(r_planeta.id_astro).qtd_especies := v_qtd_especies;
            v_planeta_info(r_planeta.id_astro).qtd_habitantes := v_qtd_habitantes;
            v_planeta_info(r_planeta.id_astro).qtd_faccoes := v_qtd_faccoes;
            v_planeta_info(r_planeta.id_astro).faccao_majoritaria := v_faccao_majoritaria;
            v_planeta_info(r_planeta.id_astro).qtd_especies_origem := v_qtd_especies_origem;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Tratamento de exceção para quando não há dados para uma determinada consulta
                NULL;
        END;
    END LOOP;

    -- Loop para imprimir os resultados
    FOR i IN 1..v_planeta_info.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Planeta: ' || v_planeta_info(i).id_astro);
        DBMS_OUTPUT.PUT_LINE('Nação Atual: ' || v_planeta_info(i).nacao_atual);
        DBMS_OUTPUT.PUT_LINE('Data de Início da Última Dominação: ' || TO_CHAR(v_planeta_info(i).data_ini, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('Data de Fim da Última Dominação: ' || TO_CHAR(v_planeta_info(i).data_fim, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('Quantidade de Comunidades: ' || v_planeta_info(i).qtd_comunidades);
        DBMS_OUTPUT.PUT_LINE('Quantidade de Espécies: ' || v_planeta_info(i).qtd_especies);
        DBMS_OUTPUT.PUT_LINE('Quantidade de Habitantes: ' || v_planeta_info(i).qtd_habitantes);
        DBMS_OUTPUT.PUT_LINE('Quantidade de Facções: ' || v_planeta_info(i).qtd_faccoes);
        DBMS_OUTPUT.PUT_LINE('Facção Majoritária: ' || v_planeta_info(i).faccao_majoritaria);
        DBMS_OUTPUT.PUT_LINE('Quantidade de Espécies de Origem: ' || v_planeta_info(i).qtd_especies_origem);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
