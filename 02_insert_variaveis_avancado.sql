-- 02_insert_variaveis_avancado.sql

USE db1410_vendas;
GO

-- insere a coluna de valor total que falta na tabela de vendas
ALTER TABLE vendas
ADD valor_total DECIMAL(10,2);

/*
	a logica é realizar multiplas insersões 
	de forma controlada, usando variaveis 
	para armazenas os dados
*/

-- iniciar a transação
-- SEMPRE que terminar uma instrução iremos finalizar com ponto e virgula;

BEGIN TRANSACTION;
-- função de isolar um comando

DECLARE @cliente_id INT = 1; -- Cliente para o pedido (Caio)
DECLARE @produto_id INT = 2; -- Produto Comprado (Notebook)
DECLARE @quantidade INT = 3; -- Quantidade comprada (3 unidades) 
DECLARE @valor_total DECIMAL (10,2); -- Valor total do pedido
DECLARE @data_venda DATETIME = GETDATE(); -- Data atual da venda
DECLARE @status_transacao VARCHAR (50);

-- calcular o valor total da venda
SELECT @valor_total = p.preco * @quantidade
FROM produtos p
WHERE p.produto_id = @produto_id

-- validacao para garantir que a quantidade seja valida
IF @quantidade <=0
	BEGIN
		SET @status_transacao = 'Falha: Quantidade invalida!';
		ROLLBACK TRANSACTION; -- Reverte a transação caso a quantidade seja invalida
		PRINT @status_transacao;
		RETURN;
	END

-- Inserindo outro venda usando nosso novo 'metodo'
INSERT INTO 
	vendas 
		(cliente_id, produto_id, quantidade, valor_total, data_venda)
	VALUES 
		(@cliente_id, @produto_id, @quantidade, @valor_total, @data_venda)

IF @@ERROR <> 0 
BEGIN
	SET @status_transacao = 'Falha: Erro na inserção da venda';
	ROLLBACK TRANSACTION;
	PRINT @status_transacao;
	RETURN;
END

-- se todas as inserções forem OK, confirmar a transacao
SET @status_transacao = 'Sucesso: Vendas inseridas com sucesso!'

COMMIT TRANSACTION;

SELECT * FROM vendas;


------------ CASO DE FALHA -------------------

BEGIN TRANSACTION;
-- função de isolar um comando

DECLARE @cliente_id INT = 1; -- Cliente para o pedido (Caio)
DECLARE @produto_id INT = 2; -- Produto Comprado (Notebook)
DECLARE @quantidade INT = 3; -- Quantidade comprada (3 unidades) 
DECLARE @valor_total DECIMAL (10,2); -- Valor total do pedido
DECLARE @data_venda DATETIME = GETDATE(); -- Data atual da venda
DECLARE @status_transacao VARCHAR (50);

SET @quantidade = -1
SET @cliente_id = 1
SET @produto_id = 1
SET @data_venda = GETDATE();

SELECT @valor_total = p.preco * @quantidade
FROM produtos p
WHERE p.produto_id = @produto_id

-- validacao para garantir que a quantidade seja valida
IF @quantidade <=0
	BEGIN
		SET @status_transacao = 'Falha: Quantidade invalida!';
		ROLLBACK TRANSACTION; -- Reverte a transação caso a quantidade seja invalida
		PRINT @status_transacao;
		RETURN;
	END

-- Inserindo outro venda usando nosso novo 'metodo'
INSERT INTO 
	vendas 
		(cliente_id, produto_id, quantidade, valor_total, data_venda)
	VALUES 
		(@cliente_id, @produto_id, @quantidade, @valor_total, @data_venda)

COMMIT TRANSACTION;