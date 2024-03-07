--Amália Vitória de Melo NUSP:13692417
--Pedro Guilherme Tolvo NUSP:10492012

-- INSERT INTO table_name (column1, column2, column3, ...)
-- VALUES (value1, value2, value3, ...);

insert into federacao (nome_fd, data_fundacao)
values ("FIFA", to_date('10/05/1996', 'dd/mm/yyyy'), default);
insert into federacao (nome_fd, data_fundacao)
values ("Betelgeuse", to_date('10/01/1000', 'dd/mm/yyyy'), default);

insert into estrela (id_catalogo, nome, classificao_estrela, massa, coord_x, coord_y, coord_z)
values ("BABY0001", "Babylon By Gus", "Praticamente inofensiva", 500, 70000, 4, -45);
insert into estrela (id_catalogo, nome, classificao_estrela, massa, coord_x, coord_y, coord_z)
values ("NEYM1010", "Menino Ney", "Eterna Promessa?", 100, 02, 55, 0);
insert into estrela (id_catalogo, nome, classificacao_estrela, massa, coord_x, coord_y, coord_z)
values ("SKOL0420", "Skol", "Gigante Amarela", 2500, 25, 132154.55, 1, 2);

insert into planeta (designacao_astronomica, massa, raio, composicao, classificao_planeta)
values ("Terra", 0.56, 33, "terra+agua", "delicinha");
insert into planeta (designacao_astronomica, massa, raio, composicao, classificao_planeta)
values ("Plutao", 0.05, 8, "poeira espacial", "anao");


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






















