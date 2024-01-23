CREATE TABLE produto (
	id integer NOT NULL,
	codigo_barra varchar(13) NOT NULL,
	descricao varchar(25) NOT NULL,
	id_grupo integer NOT NULL,
	id_und integer NOT NULL,
	qtd_minima numeric(15,3) DEFAULT 0,
	qtd_maxima numeric(15,3) DEFAULT 0,
	em_estoque numeric(15,3) DEFAULT 0,
	preco_custo numeric(15,3) DEFAULT 0,
	preco_venda numeric(15,3) DEFAULT 0,
	foto blob sub_type 0 segment SIZE 80,
	ativo SMALLINT,
	CONSTRAINT pk_produto PRIMARY KEY (id),
	CONSTRAINT fk_produto_grupo FOREIGN KEY (id_grupo) REFERENCES produto_grupo (id),
	CONSTRAINT fk_produto_und FOREIGN KEY (id_und) REFERENCES produto_und (id)
);

CREATE SEQUENCE gen_produto_id START WITH 0 INCREMENT BY 1;

CREATE TRIGGER produto_bi FOR produto
active BEFORE INSERT POSITION 0
AS
BEGIN
	IF (NEW.id IS null OR NEW.id <= 0) THEN
		NEW.id = gen_id(gen_produto_id, 1);
END;

CREATE PROCEDURE sp_gen_produto_id
RETURNS (id integer)
AS
BEGIN
	id = gen_id(gen_produto_id, 1);
END;