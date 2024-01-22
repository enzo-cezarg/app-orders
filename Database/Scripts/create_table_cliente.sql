CREATE TABLE cliente (
	id integer NOT NULL,
	limite_credito numeric(15,2) DEFAULT 0,
	telefone_fixo varchar(25),
	telefone_celular varchar(25),
	email varchar(100),
	ativo SMALLINT DEFAULT 1,
	obs blob sub_type 1 segment SIZE 8192,
	CONSTRAINT pk_cliente PRIMARY KEY (id),
	CONSTRAINT fk_cliente_pessoa FOREIGN KEY (id) REFERENCES pessoa (id) ON DELETE CASCADE
);