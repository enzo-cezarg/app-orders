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