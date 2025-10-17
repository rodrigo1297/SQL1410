-- 07_delete_com_cascade.sql

CREATE DATABASE db1410_fallscompany;
GO

USE db1410_fallscompany;
GO

-- Indepot�ncia: permite  realizar o comando mais de uma vez, pois exclui antes de ser criado novamente
DROP TABLE IF EXISTS clientes
CREATE TABLE clientes (
-- IDENTITY(1,1) � o comando que cria de forma autom�tica o ID, a partir do 1 e de 1 em 1
-- PRIMARY KEY declara que esse ID ser� utilizado como chave prim�ria para o relacionamento com outras querys
	cliente_id INT PRIMARY KEY IDENTITY(1,1),
	nome_cliente VARCHAR(100),
	EMAIL_cliente VARCHAR(100)
);  

DROP TABLE IF EXISTS pedidos
CREATE TABLE pedidos (
	pedido_id INT PRIMARY KEY IDENTITY(1,1),
	cliente_id INT,
	data_pedido DATETIME,
	valor_total DECIMAL (10,2),
	/*
	Primeiro ele diz que o campo estar� na tabela, ap�s isso ele diz que o campo � uma 
	FOREIGN KEY da tabela cliente
	*/
	FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id) ON DELETE CASCADE
);

INSERT INTO pedidos(
	cliente_id, 
	data_pedido, 
	valor_total)
VALUES
	(1, GETDATE(),50),
	(2, GETDATE(),150),
	(3, GETDATE(),250),
	(4, GETDATE(),350);

INSERT INTO clientes(
	nome_cliente, 
	EMAIL_cliente)
VALUES
	('Rodrigo', 'rodrigo_mauri'),
	('Caio', 'caio__'),
	('Rafael', 'rafael__'),
	('Julio', 'julio__');

SELECT * FROM pedidos
SELECT * FROM clientes

BEGIN TRY
	BEGIN TRANSACTION
		DELETE FROM clientes WHERE cliente_id = 7;
	COMMIT TRANSACTION;
	PRINT 'Cliente e seus respectivos pedidos foram excluidos com sucesso!'
END TRY
BEGIN CATCH
	IF @@TRANCOUNT>0
	BEGIN
		ROLLBACK TRANSACTION;
	END
	PRINT 'Erro durante a exclus�o: ' + ERROR_MESSAGE();
END CATCH

/*no delete cascate eu consigo excluir de todas as bases que tem ocorr�ncia do id que  estou excluindo,
dessa forma, al�m de excluir todos de uma vez, ainda mitigo o erro do SQL que nao permite exclus�o
de informa��es em tabelas que est�o atrelados a outras consultas*/