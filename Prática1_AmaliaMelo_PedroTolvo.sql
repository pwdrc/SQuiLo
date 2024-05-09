--Amália Vitória de Melo NUSP:13692417
--Pedro Guilherme Tolvo NUSP:10492012

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
    dta_fim date not null,
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


































































