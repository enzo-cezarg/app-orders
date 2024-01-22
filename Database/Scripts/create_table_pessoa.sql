CREATE TABLE pessoa (
	id integer NOT NULL,
	nome_razao varchar(50) NOT NULL,
	apelido_fantasia varchar(50),
	cpf_cnpj varchar(14),
	logradouro varchar(50),
	numero varchar(9),
	bairro varchar(35),
	cep char(8),
	municipio varchar(35),
	uf char(2),
	CONSTRAINT pk_pessoa PRIMARY KEY (id)
);

CREATE SEQUENCE gen_pessoa_id START WITH 0 INCREMENT BY 1;

CREATE TRIGGER pessoa_bi FOR pessoa
active BEFORE INSERT POSITION 0
AS
BEGIN
	IF (NEW.id IS null OR NEW.id <= 0) THEN
		NEW.id = gen_id(gen_pessoa_id, 1);
END;

CREATE PROCEDURE sp_gen_pessoa_id
RETURNS (id integer)
AS
BEGIN
	id = gen_id(gen_pessoa_id, 1);
END;