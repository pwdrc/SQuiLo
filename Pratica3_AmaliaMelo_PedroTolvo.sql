-- Entrega 3
--Amalia Vitoria de Melo NUSP:13692417
--Pedro Guilherme Tolvo NUSP:10492012
-- Em relação aos casos de teste das consultas, faça primeiro a consulta, e após insira um a um cada caso para a verificação
drop table COMUNIDADE cascade constraints;
drop table DOMINANCIA cascade constraints;
drop table ESPECIE cascade constraints;
drop table ESTRELA cascade constraints;
drop table FACCAO cascade constraints;
drop table FEDERACAO cascade constraints;
drop table HABITACAO cascade constraints;
drop table LIDER cascade constraints;
drop table NACAO cascade constraints;
drop table NACAO_FACCAO cascade constraints;
drop table ORBITA_ESTRELA cascade constraints;
drop table ORBITA_PLANETA cascade constraints;
drop table PARTICIPA cascade constraints;
drop table SISTEMA cascade constraints;


create table federacao (
    nome_fd varchar2(128) not null,
    data_fundacao date, -- olhar --
    constraint pk_federacao primary key (nome_fd)
);

create table estrela (
    id_catalogo varchar2(8) not null,
    nome varchar2(128),
    classificacao_estrela varchar2(128),
    massa number,
    coord_x number not null,
    coord_y number not null,
    coord_z number not null,
    constraint pk_estrela primary key (id_catalogo),
    constraint sk_estrela unique (coord_x, coord_y, coord_z)
);

create table planeta (
    designacao_astronomica varchar2(128) not null,
    massa number,
    raio number,
    composicao varchar2(256),
    classificacao_planeta varchar2(128),
    constraint pk_planeta primary key (designacao_astronomica)
);

create table nacao (
    nome_nacao varchar2(128) not null,
    quantidade_planetas number DEFAULT 0,
    federacao varchar2(128),
    constraint pk_nacao primary key (nome_nacao),
    constraint fk_nacao foreign key (federacao) references federacao(nome_fd) on delete cascade 
);

create table dominancia (
    nacao varchar2(128) not null,
    planeta varchar2(128),
    data_inicio date,
    data_fim date,
    constraint pk_dominancia primary key (nacao,planeta,data_inicio),
    constraint fk_dominancia_nacao foreign key (nacao) references nacao(nome_nacao) on delete cascade,
    constraint fk_dominancia_planeta foreign key (planeta) references planeta(designacao_astronomica) on delete cascade
);

create table sistema (
    estrela varchar2(8) not null,
    nome varchar(128),
    constraint pk_sistema primary key (estrela),
    constraint fk_sistema_estrela foreign key (estrela) references estrela(id_catalogo) on delete cascade
);

create table orbita_estrela(
    orbitante varchar2(8) not null,
    orbitada varchar2(8) not null,
    distancia_min number DEFAULT 0,
    distancia_max number,
    periodo number DEFAULT 0,
    constraint pk_orbita_estrela primary key (orbitante,orbitada),
    constraint fk_obrbitante_estrela foreign key (orbitante) references estrela(id_catalogo) on delete cascade,
    constraint fk_orbitada_estrela foreign key (orbitada) references estrela(id_catalogo) on delete cascade
);

create table orbita_planeta(
    planeta varchar2(128) not null,
    estrela varchar2(8) not null,
    distancia_min number DEFAULT 0,
    distancia_max number,
    periodo number DEFAULT 0,
    constraint pk_orbita_planeta primary key (planeta,estrela),
    constraint fk_orbita_planeta foreign key (planeta) references planeta(designacao_astronomica) on delete cascade,
    constraint fk_orbita_estrela foreign key (estrela) references estrela(id_catalogo) on delete cascade
);

create table especie(
    nome_cientifico varchar2(128) not null,
    planeta_o varchar2(128) not null,
    eh_inteligente char(1) not null,
    constraint pk_especie primary key (nome_cientifico),
    constraint fk_especie foreign key (planeta_o) references planeta(designacao_astronomica) on delete cascade,
    constraint chek_eh_inteligente check (upper(eh_inteligente) in ('S', 'N'))
);


create table comunidade(
    especie varchar2(128) not null,
    nome varchar2(128) not null,
    qtd_habitantes number DEFAULT 0,
    constraint pk_comunidade primary key (especie,nome),
    constraint fk_comunidade foreign key (especie) references especie(nome_cientifico) on delete cascade
);

create table habitacao(
    planeta varchar2(128) not null,
    com_especie varchar2(128) not null,
    com_nome varchar2(128) not null,
    dta_inicio date not null,
    dta_fim date,
    constraint pk_habitacao primary key (planeta,com_especie,com_nome,dta_inicio),
    constraint fk_habitacao_planeta foreign key (planeta) references planeta(designacao_astronomica) on delete cascade,
    constraint fk_habitacao_comunidade foreign key (com_especie,com_nome) references comunidade(especie,nome) on delete cascade
);


create table lider (
    CPI varchar2(12) not null,
    nome varchar(32),
    cargo varchar2(10) not null, 
    nacao varchar(128) not null,
    especie varchar2(128) not null,
    constraint pk_lider primary key (CPI),
    constraint fk_lider_nacao foreign key (nacao) references nacao(nome_nacao) on delete cascade,
    constraint fk_lider_especie foreign key (especie) references especie(nome_cientifico) on delete cascade,
    constraint check_cargo check (upper(cargo) in ('COMANDANTE', 'OFICIAL', 'CIENTISTA'))
);

create table faccao (
    nome_faccao varchar2(128) not null,
    lider_faccao varchar2(12) not null,
    ideologia varchar2(128),
    qtd_nacoes number DEFAULT 0,
    constraint pk_faccao primary key (nome_faccao),
    constraint fk_lider_faccao foreign key (lider_faccao) references lider(CPI) on delete cascade,
    constraint sk_faccao unique (lider_faccao),
    constraint check_ideologia check (upper(ideologia) in ('PROGRESSISTA', 'TRADICIONALISTA','TOTALITARIA'))
);

create table nacao_faccao(
    nacao varchar2(128) not null,
    faccao varchar2(128) not null,
    constraint pk_nacao_faccao primary key (nacao,faccao),
    constraint fk_nacao_faccao foreign key (nacao) references nacao(nome_nacao) on delete cascade,
    constraint fk_faccao foreign key (faccao) references faccao(nome_faccao) on delete cascade
);

create table participa(
    faccao varchar2(128) not null,
    comunidade_especie varchar2(128) not null,
    comunidade_nome varchar2(128) not null,
    constraint pk_participa primary key (faccao,comunidade_especie,comunidade_nome),
    constraint fk_faccao_participa foreign key (faccao) references faccao(nome_faccao) on delete cascade,
    constraint fk_comunidade_participa foreign key (comunidade_especie,comunidade_nome) 
        references comunidade(especie,nome)on delete cascade
);


insert into federacao (nome_fd, data_fundacao)
values ('FIFA', to_date('10/05/1996', 'dd/mm/yyyy'));
insert into federacao (nome_fd, data_fundacao)
values ('Betelgeuse', to_date('10/01/1000', 'dd/mm/yyyy'));

insert into estrela (id_catalogo, nome, classificacao_estrela, massa, coord_x, coord_y, coord_z)
values ('BABY0001', 'Babylon By Gus', 'Praticamente inofensiva', 500, 70000, 4, -45);
insert into estrela (id_catalogo, nome, classificacao_estrela, massa, coord_x, coord_y, coord_z)
values ('NEYM1010', 'Menino Ney', 'Eterna Promessa?', 100, 02, 55, 0);
insert into estrela (id_catalogo, nome, classificacao_estrela, massa, coord_x, coord_y, coord_z)
values ('SKOL0420', 'Skol', 'Gigante Amarela', 2500, 25, 132154.55, 1); 

insert into planeta (designacao_astronomica, massa, raio, composicao, classificacao_planeta)
values ('Terra', 0.56, 33, 'terra+agua', 'delicinha');
insert into planeta (designacao_astronomica, massa, raio, composicao, classificacao_planeta)
values ('Plutao', 0.05, 8, 'poeira espacial', 'anao');


insert into nacao (nome_nacao, quantidade_planetas, federacao)
values ('Nacao Zumbi', 6, 'Betelgeuse');

insert into nacao (nome_nacao, quantidade_planetas, federacao)
values ('Nacao do Fogo', 1, 'Betelgeuse');

insert into dominancia (nacao, planeta, data_inicio, data_fim)
values ('Nacao Zumbi', 'Terra', to_date('02/02/2002','dd/mm/yyyy'), null);

insert into dominancia (nacao, planeta, data_inicio, data_fim)
values ('Nacao do Fogo', 'Plutao', to_date('04/05/1025','dd/mm/yyyy'), null);

insert into sistema (estrela, nome)
values ('BABY0001', 'Planet Hemp');

insert into sistema (estrela, nome)
values ('NEYM1010', 'Los Parsas');

insert into orbita_estrela (orbitante, orbitada, distancia_min, distancia_max, periodo)
values ('BABY0001', 'NEYM1010', 1, 100000, 56.458529);

insert into orbita_estrela (orbitante, orbitada, distancia_min, distancia_max, periodo)
values ('SKOL0420', 'BABY0001', 254, 698, 333.333);
insert into orbita_planeta (planeta, estrela, distancia_min, distancia_max)
values ('Terra', 'SKOL0420', 500, 501);

insert into orbita_planeta (planeta, estrela, distancia_min, distancia_max)
values('Terra', 'NEYM1010', 12, 136);

insert into especie (nome_cientifico, planeta_o, eh_inteligente) 
values ('sapiens', 'Terra', 's');

insert into especie (nome_cientifico, planeta_o, eh_inteligente) 
values ('texano', 'Plutao', 'n');

insert into comunidade (especie, nome, qtd_habitantes)
values ('sapiens', 'humanoides', 200);

insert into comunidade (especie, nome, qtd_habitantes)
values ('texano', 'texies', null);

insert into habitacao (planeta,com_especie,com_nome,dta_inicio, dta_fim)
values ('Terra', 'sapiens', 'humanoides', to_date('12/12/2012', 'dd/mm/yyyy'), to_date('10/10/2010', 'dd/mm/yyyy'));

insert into habitacao (planeta,com_especie,com_nome,dta_inicio, dta_fim)
values ('Plutao', 'texano', 'texies', to_date('02/02/2002', 'dd/mm/yyyy'), to_date('03/03/2003', 'dd/mm/yyyy'));

insert into lider (CPI, nome, cargo, nacao, especie) 
values('65287623', 'Denzel', 'Comandante', 'Nacao Zumbi', 'sapiens');

insert into lider (CPI, nome, cargo, nacao, especie) 
values ('90675418', 'Mickey', 'Cientista', 'Nacao do Fogo', 'texano');
insert into faccao (nome_faccao, lider_faccao, ideologia, qtd_nacoes)
values('Comando red', '90675418', 'progressista', 2);

insert into faccao (nome_faccao, lider_faccao, ideologia, qtd_nacoes)
values ('Faccao carinhosa', '65287623', 'tradicionalista', 5);

insert into nacao_faccao (nacao, faccao)
values ('Nacao do Fogo', 'Faccao carinhosa');

insert into nacao_faccao (nacao, faccao)
values ('Nacao Zumbi', 'Comando red');

insert into participa (faccao, comunidade_especie, comunidade_nome)
values ('Comando red', 'sapiens', 'humanoides');

insert into participa (faccao, comunidade_especie, comunidade_nome)
values ('Faccao carinhosa', 'texano', 'texies');
commit;

-------------------------------------------------------
--------letra A
select faccao.nome_faccao, faccao.ideologia, lider.nome, lider.especie, lider.nacao from faccao
join lider on faccao.lider_faccao = lider.CPI;
---------------
-------------- letra b
insert into lider(CPI, nome, cargo, nacao, especie)
    values ('121231131', 'TESTE', 'cientista', 'Nacao Zumbi', 'sapiens');

select lider.CPI, lider.nome, lider.nacao, lider.especie, especie.planeta_o, faccao.nome_faccao
from lider join especie on lider.especie = especie.nome_cientifico left join faccao on lider.CPI = faccao.lider_faccao;
-----------------
----------------- letra c
select estrela2.nome as orbitada, estrela2.classificacao_estrela as orbitada_classificao,
	estrela1.nome as orbitante, estrela1.classificacao_estrela as orbitante_classificacao 
	from orbita_estrela
	join estrela estrela1 on orbita_estrela.orbitante = estrela1.id_catalogo
	join estrela estrela2 on orbita_estrela.orbitada = estrela2.id_catalogo;
---------------------
  
---------------------------------------------------- letra D
	--------------------------testes da letra D
	insert into habitacao (planeta,com_especie,com_nome,dta_inicio, dta_fim)
	values ('Terra', 'texano', 'texies', to_date('12/12/2012', 'dd/mm/yyyy'), to_date('12/12/2025', 'dd/mm/yyyy'));
	insert into habitacao (planeta,com_especie,com_nome,dta_inicio, dta_fim)
	values ('Plutao', 'sapiens', 'humanoides', to_date('12/12/2012', 'dd/mm/yyyy'), to_date('12/12/2027', 'dd/mm/yyyy'));
	
	-- Planetas
	INSERT INTO PLANETA (DESIGNACAO_ASTRONOMICA, MASSA, RAIO, COMPOSICAO, CLASSIFICACAO_planeta) 
	    VALUES ('Terraço', 5.972 * POWER(10, 24), 6371, 'Nitrogenio e Oxigenio', 'Terrestre');
	INSERT INTO PLANETA (DESIGNACAO_ASTRONOMICA, MASSA, RAIO, COMPOSICAO, CLASSIFICACAO_planeta) 
	    VALUES ('Marte', 6.417 * POWER(10, 23), 3389.5, 'Dióxido de Carbono', 'Terrestre');
	
	-- Especies
	INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_O, EH_INTELIGENTE) 
	    VALUES ('Humanos', 'Terra', 'S');
	INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_o, EH_INTELIGENTE) 
	    VALUES ('FEDERUPAS', 'Terraço', 'N');
	INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_O, EH_INTELIGENTE) 
	    VALUES ('USPIANOS', 'Terraço', 'S');
	INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_O, EH_INTELIGENTE) 
	    VALUES ('Computeiros', 'Terra', 'S');
	INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_O, EH_INTELIGENTE) 
	    VALUES ('Marcianos', 'Marte', 'N');
	
	-- Comunidades
	INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) 
	    VALUES ('Humanos', 'Metropolis', 10000000);
	INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) 
	    VALUES ('FEDERUPAS', 'UFSCAR', 200);
	INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) 
	    VALUES ('USPIANOS', 'USP', 1500);
	INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) 
	    VALUES ('Computeiros', 'BSI', 1500);
	INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) 
	    VALUES ('Marcianos', 'Red Valley', 5000000);
	
	
	-- Habitacoes
	INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DTa_INICIO, DTa_FIM) 
	    VALUES ('Terra', 'Humanos', 'Metropolis', TO_DATE('2200-01-01', 'YYYY-MM-DD'), TO_DATE('2300-01-01', 'YYYY-MM-DD'));
	INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DTa_INICIO, DTa_FIM) 
	    VALUES ('Terra', 'FEDERUPAS', 'UFSCAR', TO_DATE('2200-01-01', 'YYYY-MM-DD'), TO_DATE('2300-01-01', 'YYYY-MM-DD'));
	INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DTa_INICIO, DTa_FIM) 
	    VALUES ('Terra', 'USPIANOS', 'USP', TO_DATE('2200-01-01', 'YYYY-MM-DD'), TO_DATE('2300-12-31', 'YYYY-MM-DD'));
	INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DTa_INICIO, DTa_FIM) 
	    VALUES ('Terra', 'Computeiros', 'BSI', TO_DATE('2200-01-01', 'YYYY-MM-DD'), TO_DATE('2300-01-01', 'YYYY-MM-DD'));
	INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DTa_INICIO, DTa_FIM) 
	    VALUES ('Marte', 'Marcianos', 'Red Valley', TO_DATE('2200-01-01', 'YYYY-MM-DD'), TO_DATE('2300-01-01', 'YYYY-MM-DD'));
     -------------------------------------fim testes da letra D
select p.planeta, count(c.especie) as quantidade_comunidades_inteligentes 
	from habitacao p left join especie e on p.com_especie = e.nome_cientifico 
    and p.dta_inicio <= CURRENT_TIMESTAMP and p.dta_fim > CURRENT_TIMESTAMP and e.eh_inteligente in ('s','S')
	left join comunidade c on c.especie = e.nome_cientifico
	group by p.planeta;

----------------------------------- letra E
select p.planeta, count(p.com_especie) as quantidade_comunidades_por_especie
	from habitacao p left join comunidade c on c.nome = p.com_nome and p.dta_fim > CURRENT_TIMESTAMP
    join especie e on c.especie = e.nome_cientifico 
	group by p.planeta;
------------------------------------ letra F
	----------------- casos de teste
		insert into orbita_planeta (planeta, estrela, distancia_min, distancia_max)
		values('Terraço', 'NEYM1010', 112, 1336);
		insert into orbita_planeta (planeta, estrela, distancia_min, distancia_max)
		values('Marte', 'NEYM1010', 1124, 36);
		insert into estrela (id_catalogo, nome, classificacao_estrela, massa, coord_x, coord_y, coord_z)
		values ('1', 'T1', 'teste 1', 2400, 15, 132124.55, 9); 
		insert into orbita_planeta (planeta, estrela, distancia_min, distancia_max)
		values('Terra', '1', 4, 6);
		insert into orbita_planeta (planeta, estrela, distancia_min, distancia_max)
		values('Terraço', 'SKOL0420', 1, 2);
         ---------------------------- fim casos de teste

select e.nome, e.classificacao_estrela from estrela e where not exists
	((select p.planeta from orbita_planeta p where p.estrela ='SKOL0420')
    minus
    (select p.planeta from orbita_planeta p where p.estrela = e.id_catalogo));







