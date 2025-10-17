-- 08_delete_eficiente.sql

CREATE DATABASE db1410_eficiente_enterprise
GO

USE db1410_eficiente_enterprise;
GO

DROP TABLE IF EXISTS clientes
CREATE TABLE clientes (
-- IDENTITY(1,1) é o comando que cria de forma automática o ID, a partir do 1 e de 1 em 1
-- PRIMARY KEY declara que esse ID será utilizado como chave primária para o relacionamento com outras querys
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100),
	data_cadastro DATETIME
);  

DROP TABLE IF EXISTS pedidos
CREATE TABLE pedidos (
	pedido_id INT PRIMARY KEY,
	cliente_id INT,
	data_pedido DATETIME,
	valor_total DECIMAL (10,2)
);

INSERT INTO clientes (
	cliente_id,
	nome_cliente,
	data_cadastro
	)
SELECT TOP 100000
/*
gerar o valor sequencial de 1 até o infinito por cada linha
o over exige ordenar, isso é um truque do instrutor
para dizer que nao quero em ordem pre-definida
*/
-- Gerar o cliente_id
ROW_NUMBER() OVER( ORDER BY (SELECT NULL)),
-- Gerar o nome_cliente
'Cliente: ' + CAST(ROW_NUMBER() OVER( ORDER BY (SELECT NULL)) AS VARCHAR(10)),
-- Gerar a data_cadastro da data de hoje subtraindo do dia o numero da linha
DATEADD(
	DAY,-
	(ROW_NUMBER() OVER( ORDER BY (SELECT NULL))%3650),
	GETDATE()
	)
FROM master.dbo.spt_values a, master.dbo.spt_values b;
-- Truncate é mais  eficiente pois não registra a remoção, ao contrário do delete.
TRUNCATE TABLE clientes;
