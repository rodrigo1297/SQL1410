-- 01_insert_select_complexo

CREATE DATABASE db1410_vendas;
GO

USE db1410_vendas;
GO

-- idempotencia (não quebra o código (crashar) caso eu execute mais de uma vez
DROP TABLE IF EXISTS clientes
CREATE TABLE clientes(
	cliente_id INT PRIMARY KEY IDENTITY(1,1),
	nome_cliente VARCHAR(100),
	email_cliente VARCHAR(100)
	);

DROP TABLE IF EXISTS produtos;
CREATE TABLE produtos (
	produto_id INT PRIMARY KEY IDENTITY(1,1),
	nome_produto VARCHAR(100),
	preco DECIMAL (10,2)
	);

DROP TABLE IF EXISTS vendas;
CREATE TABLE vendas(
	venda_id INT PRIMARY KEY IDENTITY (1,1),
	cliente_id INT, 
	produto_id INT, 
	quantidade INT, 
	data_venda DATE,

	FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
	FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
	);

INSERT INTO clientes (nome_cliente, email_cliente) VALUES
('Caio','caio@gmail.com'),
('Gustavo','gustavo@gmail.com'),
('Juliana','juliana@gmail.com'),
('Rafael','rafael@gmail.com'),
('Rodrigo','rodrigo@gmail.com');

INSERT INTO produtos(nome_produto,preco) VALUES
('Laptop',3600.70),
('Notebook',2400.40),
('Smartphone',900.90),
('Cadeira Gamer',1400.30);

INSERT INTO vendas (cliente_id, produto_id, quantidade, data_venda)
VALUES
(1,1,2,'2025-03-01'),
(2,2,2,'2025-03-11'),
(3,3,2,'2025-03-21'),
(4,4,2,'2025-03-31'),
(5,3,2,'2025-03-12');

DROP TABLE IF EXISTS relatorio_vendas_clientes;
CREATE TABLE relatorio_vendas_clientes(
	cliente_id INT,
	nome_cliente VARCHAR (100),
	produto_id INT,
	nome_produto VARCHAR(100),
	total_gasto DECIMAL(10,2)
	);
	-- SELECT * FROM produtos
	-- Visualiza a tabela desejada

INSERT INTO  relatorio_vendas_clientes
(cliente_id, nome_cliente, produto_id, nome_produto, total_gasto)
SELECT 
	c.cliente_id,
	c.nome_cliente,
	p.produto_id,
	p.nome_produto,
	SUM(v.quantidade * p.preco) AS total_gasto
FROM vendas v
JOIN clientes c ON v.cliente_id = c.cliente_id
JOIN produtos p ON v.produto_id = p.produto_id
GROUP BY 
c.cliente_id, c.nome_cliente, p.produto_id, p.nome_produto
HAVING SUM(v.quantidade * p.preco) > 3000;
-- HAVING corta os resultados 

SELECT * FROM relatorio_vendas_clientes