-- Pratica 8
-- Amalia Melo - 13692417
-- Pedro Tolvo - 10492012

-- CREATE TABLE FEDERACAO(
-- 	NOME VARCHAR2(15),
-- 	DATA_FUND DATE NOT NULL,
-- 	CONSTRAINT PK_FEDERACAO PRIMARY KEY (NOME)
-- );
-- CREATE TABLE NACAO(
-- 	NOME VARCHAR2(15),
-- 	QTD_PLANETAS NUMBER,
-- 	FEDERACAO VARCHAR2(15),
-- 	CONSTRAINT PK_NACAO PRIMARY KEY (NOME),
-- 	CONSTRAINT FK_NACAO_FEDERACAO FOREIGN KEY (FEDERACAO) REFERENCES FEDERACAO(NOME) ON DELETE SET NULL,
-- 		CONSTRAINT CK_NACAO_QTD_PLANETAS CHECK (QTD_PLANETAS >= 0) -- >= 0 para poder manter o histórico de nações extintas
-- );
-- CREATE TABLE PLANETA(
-- 	ID_ASTRO VARCHAR2(15),
-- 	MASSA NUMBER,
-- 	RAIO NUMBER,
-- 	CLASSIFICACAO VARCHAR2(63),
-- 	CONSTRAINT PK_PLANETA PRIMARY KEY (ID_ASTRO),
-- 	CONSTRAINT CK_PLANETA_MASSA CHECK (MASSA > 0),
-- 	CONSTRAINT CK_PLANETA_RAIO CHECK (RAIO > 0)
-- );
-- CREATE TABLE ESPECIE(
-- 	NOME VARCHAR2(15),
-- 	PLANETA_OR VARCHAR2(15),
-- 	INTELIGENTE CHAR(1),
-- 	CONSTRAINT PK_ESPECIE PRIMARY KEY (NOME),
-- 	CONSTRAINT FK_ESPECIE_PLANETA FOREIGN KEY (PLANETA_OR) REFERENCES PLANETA(ID_ASTRO) ON DELETE CASCADE,
-- 	CONSTRAINT CK_ESPECIE_INTELIGENTE CHECK (INTELIGENTE IN ('V', 'F'))
-- );
-- CREATE TABLE LIDER(
-- 	CPI CHAR(14),
-- 	NOME VARCHAR2(15),
-- 	CARGO CHAR(10) NOT NULL,
-- 	NACAO VARCHAR2(15) NOT NULL,
-- 	ESPECIE VARCHAR2(15) NOT NULL,
-- 	CONSTRAINT PK_LIDER PRIMARY KEY (CPI),
-- 	CONSTRAINT FK_LIDER_NACAO FOREIGN KEY (NACAO) REFERENCES NACAO(NOME) ON DELETE CASCADE,
-- 	CONSTRAINT FK_LIDER_ESPECIE FOREIGN KEY (ESPECIE) REFERENCES ESPECIE(NOME) ON DELETE CASCADE,
-- 	CONSTRAINT CK_LIDER_CPI CHECK (REGEXP_LIKE(CPI, '^\d{3}\.\d{3}\.\d{3}-\d{2}$')),
-- 	CONSTRAINT CK_LIDER_CARGO CHECK (CARGO IN ('COMANDANTE', 'OFICIAL', 'CIENTISTA')) -- Uppercase para padronização
-- );
-- CREATE TABLE FACCAO(
-- 	NOME VARCHAR2(15),
-- 	LIDER CHAR(14) NOT NULL,
-- 	IDEOLOGIA VARCHAR2(15),
-- 	QTD_NACOES NUMBER,
-- 	CONSTRAINT PK_FACCAO PRIMARY KEY (NOME),
-- 	CONSTRAINT FK_FACCAO_LIDER FOREIGN KEY (LIDER) REFERENCES LIDER(CPI),
-- 	CONSTRAINT CK_FACCAO_IDEOLOGIA CHECK (
-- 		IDEOLOGIA IN ('PROGRESSITA', 'TOTALITARIA', 'TRADICIONALISTA')
-- 	),
-- 	CONSTRAINT CK_FACCAO_QTD_NACOES CHECK (QTD_NACOES >= 0),
-- 	-- >= 0 para poder manter o histórico de facções extintas
-- 	CONSTRAINT UN_FACCAO_LIDER UNIQUE (LIDER)
-- );
-- CREATE TABLE NACAO_FACCAO(
-- 	NACAO VARCHAR2(15),
-- 	FACCAO VARCHAR2(15),
-- 	CONSTRAINT PK_NF PRIMARY KEY (NACAO, FACCAO),
-- 	CONSTRAINT FK_NF_NACAO FOREIGN KEY (NACAO) REFERENCES NACAO(NOME) ON DELETE CASCADE,
-- 	CONSTRAINT FK_NF_FACCAO FOREIGN KEY (FACCAO) REFERENCES FACCAO(NOME) ON DELETE CASCADE
-- );
-- CREATE TABLE ESTRELA(
-- 	ID_ESTRELA VARCHAR2(31),
-- 	NOME VARCHAR2(31),
-- 	CLASSIFICACAO VARCHAR2(31),
-- 	MASSA NUMBER,
-- 	X NUMBER NOT NULL,
-- 	Y NUMBER NOT NULL,
-- 	Z NUMBER NOT NULL,
-- 	CONSTRAINT PK_ESTRELA PRIMARY KEY (ID_ESTRELA),
-- 	CONSTRAINT CK_ESTRELA_MASSA CHECK (MASSA > 0),
-- 	CONSTRAINT UN_ESTRELA_COORDS UNIQUE (X, Y, Z)
-- );
-- CREATE TABLE COMUNIDADE(
-- 	ESPECIE VARCHAR2(15),
-- 	NOME VARCHAR2(15),
-- 	QTD_HABITANTES NUMBER NOT NULL,
-- 	CONSTRAINT PK_COMUNIDADE PRIMARY KEY (ESPECIE, NOME),
-- 	CONSTRAINT CK_COMUNIDADE_QTD_HABITANTES CHECK (QTD_HABITANTES >= 0),
-- 	-- >= 0 para poder manter o histórico de comunidades extintas
-- 	CONSTRAINT FK_COMUNIDADE_ESPECIE FOREIGN KEY (ESPECIE) REFERENCES ESPECIE(NOME) ON DELETE CASCADE
-- );
-- CREATE TABLE PARTICIPA(
-- 	FACCAO VARCHAR2(15),
-- 	ESPECIE VARCHAR2(15),
-- 	COMUNIDADE VARCHAR2(15),
-- 	CONSTRAINT PK_PARTICIPA PRIMARY KEY (FACCAO, ESPECIE, COMUNIDADE),
-- 	CONSTRAINT FK_PARTICIPA_FACCAO FOREIGN KEY (FACCAO) REFERENCES FACCAO(NOME) ON DELETE CASCADE,
-- 	CONSTRAINT FK_PARTICIPA_COMUNIDADE FOREIGN KEY (ESPECIE, COMUNIDADE) REFERENCES COMUNIDADE(ESPECIE, NOME) ON DELETE CASCADE
-- );
-- CREATE TABLE HABITACAO(
-- 	PLANETA VARCHAR2(15),
-- 	ESPECIE VARCHAR2(15),
-- 	COMUNIDADE VARCHAR2(15),
-- 	DATA_INI DATE,
-- 	DATA_FIM DATE,
-- 	CONSTRAINT PK_HABITACAO PRIMARY KEY (PLANETA, ESPECIE, COMUNIDADE, DATA_INI),
-- 	CONSTRAINT FK_HABITACAO_PLANETA FOREIGN KEY (PLANETA) REFERENCES PLANETA(ID_ASTRO),
-- 	CONSTRAINT FK_HABITACAO_COMUNIDADE FOREIGN KEY (ESPECIE, COMUNIDADE) REFERENCES COMUNIDADE(ESPECIE, NOME),
-- 	CONSTRAINT CK_HABITACAO_DATA CHECK (
-- 		DATA_FIM IS NULL
-- 		OR DATA_FIM > DATA_INI
-- 	)
-- );
-- CREATE TABLE DOMINANCIA(
-- 	PLANETA VARCHAR2(15),
-- 	NACAO VARCHAR2(15),
-- 	DATA_INI DATE,
-- 	DATA_FIM DATE,
-- 	CONSTRAINT PK_DOMINANCIA PRIMARY KEY (NACAO, PLANETA, DATA_INI),
-- 	CONSTRAINT FK_DOMINANCIA_NACAO FOREIGN KEY (NACAO) REFERENCES NACAO(NOME),
-- 	CONSTRAINT FK_DOMINANCIA_PLANETA FOREIGN KEY (PLANETA) REFERENCES PLANETA(ID_ASTRO),
-- 	CONSTRAINT CK_DOMINANCIA_DATA CHECK (
-- 		DATA_FIM IS NULL
-- 		OR DATA_FIM > DATA_INI
-- 	)
-- );
-- CREATE TABLE SISTEMA(
-- 	ESTRELA VARCHAR2(31),
-- 	NOME VARCHAR2(31),
-- 	CONSTRAINT PK_SISTEMA PRIMARY KEY (ESTRELA),
-- 	CONSTRAINT FK_SISTEMA_ESTRELA FOREIGN KEY (ESTRELA) REFERENCES ESTRELA(ID_ESTRELA) ON DELETE CASCADE
-- );
-- CREATE TABLE ORBITA_ESTRELA(
-- 	ORBITANTE VARCHAR2(31),
-- 	ORBITADA VARCHAR2(31),
-- 	DIST_MIN NUMBER,
-- 	DIST_MAX NUMBER,
-- 	PERIODO NUMBER,
-- 	CONSTRAINT PK_OE PRIMARY KEY (ORBITANTE, ORBITADA),
-- 	CONSTRAINT FK_OE_ORBITANTE FOREIGN KEY (ORBITANTE) REFERENCES ESTRELA(ID_ESTRELA) ON DELETE CASCADE,
-- 	CONSTRAINT FK_OE_ORBITADA FOREIGN KEY (ORBITADA) REFERENCES ESTRELA(ID_ESTRELA) ON DELETE CASCADE,
-- 	CONSTRAINT CK_OE_ORBITANTE_ORBITADA CHECK (ORBITANTE <> ORBITADA),
-- 	CONSTRAINT CK_OE_DIST CHECK (DIST_MAX >= DIST_MIN),
-- 	-- >= para permitir órbitas circulares
-- 	CONSTRAINT CK_OE_PERIODO CHECK (PERIODO > 0)
-- );
-- CREATE TABLE ORBITA_PLANETA(
-- 	PLANETA VARCHAR2(15),
-- 	ESTRELA VARCHAR2(31),
-- 	DIST_MIN NUMBER,
-- 	DIST_MAX NUMBER,
-- 	PERIODO NUMBER,
-- 	CONSTRAINT PK_ORBITA_PLANETA PRIMARY KEY (PLANETA, ESTRELA),
-- 	CONSTRAINT FK_OP_ESTRELA FOREIGN KEY (ESTRELA) REFERENCES ESTRELA(ID_ESTRELA) ON DELETE CASCADE,
-- 	CONSTRAINT FK_OP_PLANETA FOREIGN KEY (PLANETA) REFERENCES PLANETA(ID_ASTRO) ON DELETE CASCADE,
-- 	CONSTRAINT CK_OP_DIST CHECK (DIST_MAX >= DIST_MIN),
-- 	-- >= para permitir órbitas circulares
-- 	CONSTRAINT CK_OP_PERIODO CHECK (PERIODO > 0)
-- );

-- Aspectos que serão levados em consideração na correção:
-- • faça as inserções/atualizações necessárias para testar o código PL/SQL criado;
-- • use estruturas de controle variadas;
-- • faça tratamento de exceções; além de definir suas próprias exceções, use também exceções
-- PL/SQL pré-definidas; pesquise a lista de exceções no manual – cuidado para não criar uma
-- exceção de usuário para algo que já existe como erro ou exceção pré-definida!!!
-- • em cada exercício, inclua o resultado da execução do código PL/SQL no relatório;
-- • teste o código: casos de sucesso e casos de erro. Teste as exceções!!!
-- • projete bem os algoritmos, pois tanto a eficiência das consultas quanto dos algoritmos utilizados
-- serão analisados na correção;
-- • quando o código envolver dados que seriam "entrada de usuário", faça atribuição de valores a
-- variáveis e usa-as no código (ou seja, NÃO use esses valores de entrada diretamente na consulta
-- SQL e/ou código PL/SQL - use variáveis, como seria numa aplicação real).

-- Implemente um programa PL/SQL que, dada uma facção (entrada de usuário), selecione as
-- comunidades que habitam planetas dominados por nações onde a facção está presente
-- (NacaoFaccao), mas que ainda não participam da facção (Participa). Cadastre essas
-- comunidades como novas participantes da facção. Para este exercício:
-- a. pesquise CURSOR FOR LOOP (tipos: Explícito e SQL) e escolha um deles para usar. Use
-- coleção Nested Table. As tuplas resultantes da consulta por comunidades devem ser
-- atribuídas uma a uma à coleção, isto é, sem usar BULK COLLECT.
-- b. Pesquise FORALL e use para o cadastro das comunidades como novas participantes da
-- facção. Pesquise e explique se há diferença de performance entre usar FORALL com a
-- coleção ou percorrer a coleção com FOR LOOP para realizar as inserções.


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


DECLARE
  -- Definindo uma exceção de usuário
  ex_custom EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_custom, -20001);

  TYPE ComunidadesTab IS TABLE OF comunidade%ROWTYPE;
  comunidades ComunidadesTab;
  v_faccao VARCHAR2(15) := 'FACCAO2';
  v_nome_comunidade comunidade.nome%TYPE;
  v_planeta habitacao.planeta%TYPE;
  v_nacao dominancia.nacao%TYPE;
  v_faccao_nf nacao_faccao.faccao%TYPE;
  CURSOR c_comunidades IS 
    SELECT c.nome 
    FROM comunidade c 
    JOIN habitacao h ON h.comunidade = c.nome 
    JOIN dominancia d ON d.planeta = h.planeta 
    JOIN nacao_faccao nf ON nf.nacao = d.nacao 
    WHERE nf.faccao = v_faccao 
    AND NOT EXISTS (
      SELECT 1 
      FROM participa p 
      WHERE p.comunidade = c.nome 
      AND p.faccao = v_faccao
    );
BEGIN
  OPEN c_comunidades;
  LOOP
    FETCH c_comunidades INTO v_nome_comunidade;
    EXIT WHEN c_comunidades%NOTFOUND;
    comunidades.EXTEND;
    comunidades(comunidades.LAST) := v_nome_comunidade;
  END LOOP;
  CLOSE c_comunidades;

  FORALL i IN comunidades.FIRST..comunidades.LAST
    INSERT INTO faccao_comunidades VALUES (v_faccao, comunidades(i));
EXCEPTION
  WHEN ex_custom THEN
    DBMS_OUTPUT.PUT_LINE('Exceção de usuário levantada');
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nenhum dado encontrado');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLCODE || ', Mensagem: ' || SQLERRM);
END;
