CREATE TABLE pedido (
	id integer NOT NULL,
	data_movimento timestamp,
	id_cliente integer NOT NULL,
	id_funcionario integer NOT NULL,
	documento varchar(50) NOT NULL,
	valor_total numeric(15,2) DEFAULT 0,
	CONSTRAINT pk_pedido PRIMARY KEY (id),
	CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id),
	CONSTRAINT fk_pedido_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario (id)
);

CREATE SEQUENCE gen_pedido_id START WITH 0 INCREMENT BY 1;

CREATE TRIGGER pedido_bi FOR pedido
active BEFORE INSERT POSITION 0
AS
BEGIN
	IF (NEW.id IS null OR NEW.id <= 0) THEN
		NEW.id = gen_id(gen_pedido_id, 1);
END;

CREATE PROCEDURE sp_gen_pedido_id
RETURNS (id integer)
AS
BEGIN
	id = gen_id(gen_pedido_id, 1);
END;