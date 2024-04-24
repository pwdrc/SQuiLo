# SQuiLo 
## Laboratório de Base de Dados - a.k.a SQL, a.k.a SQuiLo
Este repositório contém uma coleção de exercícios relacionados à disciplina de Laboratório de Base de Dados.

_______________________________________________________________________________________________________________

# Anotações

## Coleções
### Index-by tables
- semelhante a tabelas com duas colunas: chave, valor
- não podem ser armazenadas no banco
- "tipo um hash"

```sql
-- declaração
type nome is table of tabela index by pls_integer;
-- coleção vazia
v_colecao nome;
```

### Nested table
- semelhantes a arrays unidimensionais, mas com algumas diferenças (valores não contiguos em memória, ...)
- chaves devem ser sequenciais (não podem ser negativas e numero de chaves 2GB)
- **precisam ser inicializadas**
- podem ser armazenadas no banco (create type): como tabelas de duas colunas: chave,valor
- ao tentar atribuir numa posição não alocado -> *gera-se uma exceção de elemento não existente*
- ao tentar uma acesso qualquer numa coleção numa -> *gera-se uma exceção de colection is null*

```sql
type t_numeros is table of number;
```
### varray
- contíguo em memória
- variabilidade de tamanho até um máximo predefinido
- tamanho do vetor = nro de elementos aramzenados
- não pode ser esparso -> elementos removidos somente no **final da array**
- precisar ser inicializados
- podem ser armazenados no banco (create type)

```sql
-- declaração
type tipo_array is varray (tamanho maximo) of tipo

type t_alunos is varray(3) of varchar2(30);

-- inicialização 
v_alunos t_alunos := t_alunos('usp', 'unesp');

begin

v_alunos.extend; -- cria posicao de índice 3
v_alunos(3) := 'ufscar';
```

### Métodos
- exists(i)
- count
- limit
- first -- da o primeiro indice
- last -- da o ultimo elemento
- next(i) -- proxima posicao
- prior(i) -- anterior posicao
- extend
- extend(n)
- extend(n,i)
- trim -- remocao no final da colecao
- trim(n) -- remocao das n ultimas posicoes
- delete -- remove do fim
- delete(i) -- remove a posicao i
- delete(i,j) -- remove do i até o j; i <= j

### Utilidade
- pegar o resultado de uma consulta, jogar para dentro de uma coleção 
- e nessa coleção, fazer operações e percorrer os índices 
- sem a necessidade de refazer a consulta
- (manipula uma variável de memório ao invés de um cursor)

## Tipos armazenados
- **object type**
- para registros
- para objetos (recurso objeto-relacional)

- **collection type**
- nested table
- varray
