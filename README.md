#  Breweries Case

O projeto consiste no consumo da API <api.openbrewerydb.org/breweries> e no tratamento dos dados, através do Databricks com orquestração via pipeline do Azure Data Factory.

As tabelas “Delta” (silver e gold) são criadas no notebook “setup”, para a tabela silver utiliza-se o particionamento pela coluna “country”, pois temos um número limitado de países, resultando em menos partições, o que pode facilitar o gerenciamento e potencialmente melhorar o desempenho das consultas, dado que menos partições precisam ser lidas durante as operações.

O notebook “functions” oferece funções que validam a unicidade dos dados (key_validation) e também que criam chave única com base nas colunas fornecidas (unique_key_gen).

O consumo acontece no notebook ”bronze”, utiliza-se um loop para interagir na URL da API e garantir  o consumo completo dos  dados. Cria-se um Dataframe a patir desses dados, o qual é salvo no formato de tabela “Delta”, na camada Bronze do Data Lake. Armazenar dados no formato Delta na camada Bronze proporciona transações ACID, garantindo integridade e consistência. Oferece versionamento (Time Travel), facilitando auditoria e controle de alterações, além de suportar esquemas evolutivos para adaptações a mudanças na API.

No notebook silver, realiza-se um tratamento de dados duplicados na coluna “country”, verifica-se se existem dados duplicado e por fim realize-se um “Merge” dos dados  na tabela Silver (delta).

Por fim  o notebook gold, realiza agregação final, além de também garantir a unicidade dos dados antes de se realizar o “Merge” na tabela gold.

Todo processo de Orquestração de Notebooks é feito via Pipeline no Azure Data Factory:

![image](https://github.com/user-attachments/assets/a747a86c-2798-40c0-afbd-f185336c6494)


