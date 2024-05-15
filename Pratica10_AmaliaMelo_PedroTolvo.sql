/*
Usando view e trigger instead-of implemente a funcionalidade (de Gerenciamento) 
a.iii do Líder de Facção: 
Credenciar comunidades novas (Participa), 
que habitem planetas dominados por nações onde a facção está presente/credenciada. 
Devem ser atendidos os seguintes requisitos:
• o líder deve visualizar: as nações em que sua facção está presente, os planetas
dominados (dominação atual) por cada uma dessas nações, as comunidades que habitam
cada um desses planetas, e a indicação se cada uma dessas comunidades está ou não
credenciada à facção da qual é lider;
• deve ser criada somente 1 view, e tanto a visualização de informações do item anterior
quanto o credenciamento de uma comunidade (em Participa) devem ser feitos
exclusivamente por meio da view.
*/

-- considerando que o privilégio de execução de cada operação
-- será tratado em nível da aplicação (e não no banco de dados),
-- para os fins deste exercício, o foco será somente na implementação
-- da solução de gerenciamento.

-- variável para simular o nome da faccao
-- substituir 'FACCAO1' pelo nome da facção desejada


-- para utilizar trigger instead of é necessário a criação de uma view
create or replace view credenciar_comunidades as
select participa.nacao, dominancia.planeta, participa.comunidade, credenciada
from participa, dominancia
where participa.facção = variavel_faccao
