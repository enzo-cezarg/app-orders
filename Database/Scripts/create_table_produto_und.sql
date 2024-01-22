CREATE TABLE produto_und (
	id integer NOT NULL,
	und varchar(3) NOT NULL,
	descricao varchar(35) NOT NULL,
	CONSTRAINT pk_produto_und PRIMARY KEY (id)
);

CREATE SEQUENCE gen_produto_und_id START WITH 0 INCREMENT BY 1;

CREATE TRIGGER produto_und_bi FOR produto_und
active BEFORE INSERT POSITION 0
AS
BEGIN
	IF (NEW.id IS null OR NEW.id <= 0) THEN
		NEW.id = gen_id(gen_produto_und_id, 1);
END;

CREATE PROCEDURE sp_gen_produto_und_id
RETURNS (id integer)
AS
BEGIN
	id = gen_id(gen_produto_und_id, 1);
END;