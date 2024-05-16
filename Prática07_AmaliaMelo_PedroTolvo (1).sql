-- Amalia ...                   nUSP 13692417
-- Pedro Guilherme Tolvo        nUSP 10492012

-- 1
-- inserindo alguns dados iniciais para começarmos a brincadeira
INSERT INTO ESTRELA (ID_ESTRELA, NOME, CLASSIFICACAO, MASSA, X, Y, Z)
VALUES ('estrela1', 'Estrela Alpha', 'Tipo A', 5.2, 10, 20, 30);

INSERT INTO ESTRELA (ID_ESTRELA, NOME, CLASSIFICACAO, MASSA, X, Y, Z)
VALUES ('estrela2', 'Estrela Beta', 'Tipo B', 8.1, 15, 25, 35);

INSERT INTO ESTRELA (ID_ESTRELA, NOME, CLASSIFICACAO, MASSA, X, Y, Z)
VALUES ('estrela4', 'Estrela Gama', 'Tipo C', 10.5, 20, 30, 40);

INSERT INTO ESTRELA (ID_ESTRELA, NOME, CLASSIFICACAO, MASSA, X, Y, Z)
VALUES ('estrela5', 'Estrela D', 'Tipo A', 5.2, 6, 20, 30);

INSERT INTO ESTRELA (ID_ESTRELA, NOME, CLASSIFICACAO, MASSA, X, Y, Z)
VALUES ('estrela6', 'Estrela S', 'Tipo B', 8.1, 15, 6, 35);

INSERT INTO ESTRELA (ID_ESTRELA, NOME, CLASSIFICACAO, MASSA, X, Y, Z)
VALUES ('estrela7', 'Estrela X', 'Tipo C', 10.5, 20, 30, 6);

INSERT INTO ESTRELA (ID_ESTRELA, NOME, CLASSIFICACAO, MASSA, X, Y, Z)
VALUES ('estrela8', 'Estrela sD', 'Tipo A', 5.2, 6, 77, 30);

INSERT INTO ESTRELA (ID_ESTRELA, NOME, CLASSIFICACAO, MASSA, X, Y, Z)
VALUES ('estrela9', 'Estrela dS', 'Tipo B', 8.1, 77, 6, 35);

INSERT INTO ESTRELA (ID_ESTRELA, NOME, CLASSIFICACAO, MASSA, X, Y, Z)
VALUES ('estrela10', 'Estrela sX', 'Tipo C', 10.5, 20, 77, 6);

-- Inserts para a tabela ORBITA_ESTRELA
INSERT INTO ORBITA_ESTRELA (ORBITANTE, ORBITADA, DIST_MIN, DIST_MAX, PERIODO)
VALUES ('23    Lyn', 'estrela1', 50, 60, 200);

INSERT INTO ORBITA_ESTRELA (ORBITANTE, ORBITADA, DIST_MIN, DIST_MAX, PERIODO)
VALUES ('23    Lyn', 'estrela3', 70, 80, 250);

INSERT INTO ORBITA_ESTRELA (ORBITANTE, ORBITADA, DIST_MIN, DIST_MAX, PERIODO)
VALUES ('GJ 3579', 'estrela2', 40, 50, 180);

INSERT INTO ORBITA_ESTRELA (ORBITANTE, ORBITADA, DIST_MIN, DIST_MAX, PERIODO)
VALUES ('estrela5', 'estrela1', 50, 60, 200);

INSERT INTO ORBITA_ESTRELA (ORBITANTE, ORBITADA, DIST_MIN, DIST_MAX, PERIODO)
VALUES ('estrela5', 'estrela3', 70, 80, 250);

INSERT INTO ORBITA_ESTRELA (ORBITANTE, ORBITADA, DIST_MIN, DIST_MAX, PERIODO)
VALUES ('estrela5', 'estrela2', 40, 50, 180);

INSERT INTO ORBITA_ESTRELA (ORBITANTE, ORBITADA, DIST_MIN, DIST_MAX, PERIODO)
VALUES ('estrela9', 'estrela1', 50, 60, 200);

INSERT INTO ORBITA_ESTRELA (ORBITANTE, ORBITADA, DIST_MIN, DIST_MAX, PERIODO)
VALUES ('estrela8', 'estrela1', 70, 80, 250);

INSERT INTO ORBITA_ESTRELA (ORBITANTE, ORBITADA, DIST_MIN, DIST_MAX, PERIODO)
VALUES ('estrela7', 'estrela1', 40, 50, 180);

-- início do programa 'per se'
declare
   -- cursor explícito
    cursor c_estrela is
        select e.nome, e.id_estrela, count(*) as n_orbitantes 
        from estrela e
        join orbita_estrela o on e.id_estrela = o.orbitada
        group by e.nome, e.id_estrela
        order by n_orbitantes desc;

    v_estrela c_estrela%ROWTYPE;

begin
    open c_estrela;
        loop
            fetch c_estrela into v_estrela;
            exit when c_estrela%notfound;
            dbms_output.put_line('Nome: ' || v_estrela.nome || ' | ID: ' || v_estrela.id_estrela || ' | NRO: ' || v_estrela.n_orbitantes);

        end loop;
    close c_estrela;

    exception
        when 
end;

--2
begin
    delete from federacao where nome IN
        (select f.nome from federacao f 
        left join nacao n on f.nome=n.federacao
        where n.federacao is null);
      if sql%found   
          then dbms_output.put_line(sql%rowcount || ' fedaracoes excluida');
      else dbms_output.put_line('Nenhuma fedaracao excluida');
    end if;
    exception
        when others 
            then  dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM); 
commit;
end;

/*
Procedimento PL/SQL concluído com sucesso.
Saida: Nenhuma fedaracao excluida

*/
insert into federacao values('teste','25/03/200');   
insert into federacao values('teste1','25/03/200');        
insert into federacao values('teste2','05/05/2020');        
insert into federacao values('teste3','20/07/2040');        
insert into federacao values('teste4','25/03/2000');        
insert into federacao values('teste5','15/06/2030');   

/*
Rodar o comando de novo
Saida: 6 fedaracoes excluida
*/

-- 3 

declare
  v_planeta varchar2(15);
  v_comunidade varchar2(15);
  v_quantidade_habitantes number;
  v_data_inicio date;
  v_data_fim date;
begin
  -- Obter entradas do usuário
  DBMS_OUTPUT.PUT_LINE('Informe o nome do planeta: ');
  DBMS_INPUT.PUT_LINE('PLANETA', v_planeta, 15);

  DBMS_OUTPUT.PUT_LINE('Informe o nome da comunidade: ');
  DBMS_INPUT.PUT_LINE('COMUNIDADE', v_comunidade, 15);

-- verificando se a comunidade existe, tratamento de exceção
  select count(*) into v_quantidade
    from comunidade
    where nome = v_comunidade;

  if v_quantidade_habitantes = 0 then
    DBMS_OUTPUT.PUT_LINE('Comunidade não encontrada.');
    return;
  end if;

-- verificando se o planeta existe, tratamento de exceção
  select count(*) into v_quantidade
    from planeta 
    where id_astro = v_planeta;

  if v_quantidade = 0 then
    DBMS_OUTPUT.PUT_LINE('Planeta não encontrado.');

    return;

  end if;

  -- obter informacoes
  select qtd_habitantes into v_qtd_habitantes
    from comunidade
    where nome = v_comunidade;

  -- data final da habitacao
  if v_qtd_habitantes <= 1000 then
    v_data_fim := sysdate + 100;
  else
    v_data_fim := sysdate + 50;
  end if;

  -- inserindo registro
  insert into habitacao (planeta, especie, comunidade, data_inicio, data_fim)
    values (v_planeta, 
    (select especie from comunidade where nome = v_comunidade), v_comunidade, sysdate, v_data_fim);

-- informacoes da comunidade
select e.nome, p.nome, e.inteligente
  into v_nome_especie, v_nome_planeta, v_inteligente
  from especie e
  join planeta p on e.planeta_or = p.id_astro
  join comunidade c on e.nome = c.especie
  where c.nome = v_comunidade;

-- imprimindo tudo
DBMS_OUTPUT.PUT_LINE('--- Informações da Habitação ---');
  DBMS_OUTPUT.PUT_LINE('Espécie: ' || v_nome_especie);
  DBMS_OUTPUT.PUT_LINE('Planeta de origem: ' || v_planeta_origem);
  DBMS_OUTPUT.PUT_LINE('Inteligente: ' || (CASE WHEN v_inteligente = 'V' THEN 'Sim' ELSE 'Não' END));
  DBMS_OUTPUT.PUT_LINE('Data de início: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD'));
  DBMS_OUTPUT.PUT_LINE('Data final: ' || TO_CHAR(v_data_fim, 'YYYY-MM-DD'));
END;
  
--4

declare
    v_classificacao estrela.classificacao%type := 'M4';
    v_dist_min number := 2;
    cursor delete_planeta is
    select op.dist_min, es.classificacao, op.estrela from orbita_planeta op 
        join estrela es on op.estrela=es.id_estrela 
        where es.classificacao = v_classificacao ;

    v_resultado delete_planeta%rowtype;
    v_qtd_excluida number := 0;
begin
    open delete_planeta;

    loop
        fetch delete_planeta into v_resultado;
        exit when delete_planeta%notfound;

        if v_resultado.dist_min < v_dist_min then
            delete from orbita_planeta where dist_min= v_resultado.dist_min;
            v_qtd_excluida := v_qtd_excluida + sql%rowcount;
        end if;
    end loop;

    close delete_planeta;

    if v_qtd_excluida > 0 then
        dbms_output.put_line(v_qtd_excluida || ' planetas excluídos');
    else
        dbms_output.put_line('Nenhum planeta excluído');
    end if;
    exception
    when others 
        then  dbms_output.put_line('Erro nro: ' || SQLCODE || '. Mensagem: ' || SQLERRM); 
commit;
end;

insert into orbita_planeta values('Laborum nihil.','Gl 480', 1,9999,null);

insert into orbita_planeta values('Et iure earum.','Gl 480', 2,999,null);

insert into orbita_planeta values('Reiciendis ex.','Gl 480', 0,9899,null);

select  * from orbita_planeta;
