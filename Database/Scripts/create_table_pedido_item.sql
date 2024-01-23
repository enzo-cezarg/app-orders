CREATE TABLE pedido_item (
	id integer NOT NULL,
	id_pedido integer NOT NULL,
	id_produto integer NOT NULL,
	qtd numeric(15,3) DEFAULT 0,
	preco_venda numeric(15,2) DEFAULT 0,
	valor_total numeric(15,2) DEFAULT 0,
	CONSTRAINT pk_pedido_item PRIMARY KEY (id, id_pedido),
	CONSTRAINT fk_produto_pedido FOREIGN KEY (id_produto) REFERENCES produto (id) ON DELETE CASCADE
);