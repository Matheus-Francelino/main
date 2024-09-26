-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## **Tabela Silver**

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS tb_silver_breweries (
  id STRING                   comment 'registro',                             
  address_1 STRING            comment 'endereço 1',           
  address_2 STRING            comment 'endereço 2',           
  address_3 STRING            comment 'endereço 3',           
  brewery_type STRING         comment 'tipo de cervejaria',            
  city STRING                 comment 'cidade',            
  country STRING              comment 'país',           
  latitude STRING             comment 'coordenadas latitude',            
  longitude STRING            comment 'coordenadas longitude',           
  name STRING                 comment 'nome da cervejaria',            
  phone STRING                comment 'telefone da cervejaria',           
  postal_code STRING          comment 'código postal da cervejaria',           
  state STRING                comment 'estado',           
  state_province STRING       comment 'estado província',            
  street STRING               comment 'rua',            
  website_url STRING          comment 'site da cervejaria',           
  tmstp_ingestion TIMESTAMP   comment 'timestamp da última carga'
            )
USING Delta
PARTITIONED BY (country)
LOCATION '/silver_path/tb_silver_breweries/'
COMMENT 'Transform the data to a columnar storage format such as parquet or delta, and partition it by brewery location'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Escolha de Partição:
-- MAGIC
-- MAGIC country: Particionar por país pode ser vantajoso, pois temos um número limitado de países, resultando em menos partições, o que pode facilitar o gerenciamento e potencialmente melhorar o desempenho das consultas, pois menos partições precisam ser lidas durante as operações.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## **Tabela Gold**

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS tb_gold_breweries (    
  country STRING              comment 'país',           
  brewery_type STRING         comment 'tipo de cervejaria',            
  breweries_quantity INTEGER  comment 'quantidade de cervejarias'         
            )
USING Delta
LOCATION '/silver_path/tb_gold_breweries/'
COMMENT 'Create an aggregated view with the quantity of breweries per type and location'
