#  Breweries Case

O projeto consiste no consumo da API <api.openbrewerydb.org/breweries> e no tratamento dos dados, através do Databricks com orquestração via pipeline do Azure Data Factory.

As tabelas “Delta” (silver e gold) são criadas no notebook “setup”, para a tabela silver utiliza-se o particionamento pela coluna “country”, pois temos um número limitado de países, resultando em menos partições, o que pode facilitar o gerenciamento e potencialmente melhorar o desempenho das consultas, dado que menos partições precisam ser lidas durante as operações.

O notebook “functions” oferece funções que validam a unicidade dos dados (key_validation) e também que criam chave única com base nas colunas fornecidas (unique_key_gen).

O consumo acontece no notebook ”bronze”, utiliza-se um loop para interagir na URL da API e garantir  o consumo completo dos  dados. Cria-se um Dataframe a patir desses dados, o qual é salvo no formato de tabela “Delta”, na camada Bronze do Data Lake. Armazenar dados no formato Delta na camada Bronze proporciona transações ACID, garantindo integridade e consistência. Oferece versionamento (Time Travel), facilitando auditoria e controle de alterações, além de suportar esquemas evolutivos para adaptações a mudanças na API.

No notebook silver, realiza-se um tratamento de dados duplicados na coluna “country”, verifica-se se existem dados duplicado e por fim realize-se um “Merge” dos dados  na tabela Silver (delta).

Por fim  o notebook gold, realiza agregação final, além de também garantir a unicidade dos dados antes de se realizar o “Merge” na tabela gold.

Todo processo de Orquestração de Notebooks é feito via Pipeline no Azure Data Factory:

![image](https://github.com/user-attachments/assets/a747a86c-2798-40c0-afbd-f185336c6494)



O pipeline foi desenvolvido para orquestrar três etapas de processamento de dados utilizando notebooks do Databricks, correspondendo às camadas Bronze, Silver e Gold, com monitoramento e notificação de falhas automatizados. Cada atividade do pipeline está configurada da seguinte forma:

1. Atividade Databricks para Bronze, Silver e Gold
•	Configuração de Linked Service:
o	Cada atividade do Databricks no pipeline é configurada para se conectar a um Linked Service previamente criado. Esse Linked Service define a conexão com o workspace do Databricks, incluindo:
	URL do Databricks Workspace: Fornece o ponto de conexão.
	Token de Autenticação: Utilizado para autorização segura de acesso ao Databricks.
	Cluster: Especifica o cluster onde o notebook será executado, garantindo os recursos necessários para cada etapa.
•	Configuração de Cada Atividade:
o	Notebook Path: Caminho completo do notebook no Databricks que será executado. Cada notebook é responsável por uma camada do pipeline:
	Bronze: Ingestão de dados brutos.
	Silver: Limpeza e transformação intermediária.
	Gold: Agregações final.

3. Atividade Web (email falha) para Envio de E-mail via Logic App
•	Configuração da Atividade Web:
o	Cada atividade do Databricks está conectada a uma atividade Web que é acionada em caso de falha. Essa atividade Web está configurada para fazer uma chamada HTTP POST para a URL do Logic App.
o	A URL do endpoint do Logic App, será chamado em caso de falha. Este endpoint aciona o fluxo de envio de e-mail, enviando informações personalizadas sobre a falha, como o nome da atividade, mensagem de erro, e detalhes adicionais para serem usados na notificação por e-mail.



