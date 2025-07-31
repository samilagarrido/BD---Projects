# PostgreSQL Non-Relational Features Demo

Este projeto demonstra diversos recursos não-relacionais do PostgreSQL, incluindo arrays, ranges, tipos geométricos, XML, JSON/JSONB, tipos compostos, full-text search e busca por trigramas.

## Arquivos

1. **setup_nonrelational_db.sql** - Script de configuração inicial (execute PRIMEIRO)
2. **nonrelational_examples.sql** - Demonstrações dos recursos não-relacionais (execute SEGUNDO)
3. **non-relational.sql** - Script original (referência)
4. **non-relational.pdf** - Documentação de referência


### Método Usado: pgAdmin
1. **Execute primeiro** `setup_nonrelational_db.sql`
2. **Execute segundo** `nonrelational_examples.sql`


## Recursos Demonstrados

### 1. Arrays
- Criação de colunas array
- Busca por elementos específicos (`@>`)
- Acesso a elementos individuais
- Expansão de arrays com `unnest()`
- Agregação com `array_agg()`

### 2. Range Types
- Intervalos de tempo (`TSTZRANGE`)
- Verificação de containment (`@>`)
- Índices GIST para ranges
- Exclusion constraints para prevenir overlaps

### 3. Geometric Types
- Pontos (`POINT`)
- Círculos e consultas de proximidade
- Operadores de distância (`<->`)
- Índices GIST para dados geométricos

### 4. XML
- Armazenamento de dados XML
- Consultas XPath
- Extração de elementos e texto

### 5. JSON/JSONB
- Diferenças entre JSON e JSONB
- Operadores de extração (`->`, `->>`)
- Operadores de contenção (`@>`)
- Índices GIN para JSONB
- Consultas complexas em dados semi-estruturados

### 6. Composite Types
- Criação de tipos compostos customizados
- Uso em tabelas
- Acesso a campos específicos

### 7. Full-Text Search
- Vetores de texto (`tsvector`)
- Consultas de texto (`tsquery`)
- Operador de match (`@@`)
- Índices GIN para full-text search

### 8. Trigram Search
- Extensão `pg_trgm`
- Busca por similaridade
- Operador de similaridade (`%`)
- Índices para busca fuzzy

## Comandos Úteis

### Visualização de Estruturas
```sql
-- Listar tabelas no schema
\dt nonrelational_examples.*

-- Descrever uma tabela
\d nonrelational_examples.employee

-- Listar índices
\di nonrelational_examples.*

-- Ver operadores disponíveis
\do @>
```

### Análise de Performance
```sql
-- Ver plano de execução
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM friend2 WHERE data @> '{"last_name": "Banks"}';
```

## Dados de Exemplo

O script inclui dados de exemplo para todas as demonstrações. Para recursos que requerem arquivos externos (como XML), são fornecidas instruções para criar os arquivos necessários.

### Criando Arquivo XML de Exemplo (PowerShell)
```powershell
@"
<?xml version="1.0"?>
<options>
  <option>
    <arg_shortname><en>duplex</en></arg_shortname>
    <driver>hp1020</driver>
  </option>
  <option>
    <arg_shortname><en>quality</en></arg_shortname>
    <driver>hp1020</driver>
  </option>
</options>
"@ | Out-File -FilePath "C:\temp\foomatic.xml" -Encoding UTF8
```

## Extensões Necessárias

- `pg_trgm` - Para busca por trigramas (incluída no script de setup)

## Compatibilidade

- PostgreSQL 10+
- Testado com PostgreSQL 13+ 
- Funciona em Windows, Linux e macOS

## Troubleshooting

### Problemas Comuns

1. **Erro de permissão para criar extensões**
   - Execute como superusuário ou peça ao DBA para instalar as extensões

2. **Arquivo não encontrado para COPY**
   - Crie os arquivos de exemplo conforme instruções
   - Ou comente as linhas COPY no script

3. **Encoding de caracteres**
   - Verifique se o database foi criado com encoding UTF8

### Verificações Úteis
```sql
-- Verificar extensões instaladas
SELECT * FROM pg_extension WHERE extname = 'pg_trgm';

-- Verificar configuração de busca de texto
SHOW default_text_search_config;

-- Verificar schema atual
SELECT current_schema();
```

## Referências

- [PostgreSQL Documentation - Arrays](https://www.postgresql.org/docs/current/arrays.html)
- [PostgreSQL Documentation - Range Types](https://www.postgresql.org/docs/current/rangetypes.html)
- [PostgreSQL Documentation - JSON Types](https://www.postgresql.org/docs/current/datatype-json.html)
- [PostgreSQL Documentation - Full Text Search](https://www.postgresql.org/docs/current/textsearch.html)
