CREATE TABLE fornecedor (
	id integer NOT NULL,
	telefone varchar(25),
	email varchar(100),
	website varchar(100),
	ativo SMALLINT DEFAULT 1,
	obs blob sub_type 1 segment SIZE 8192,
	CONSTRAINT pk_fornecedor PRIMARY KEY (id),
	CONSTRAINT fk_fornecedor_pessoa FOREIGN KEY (id) REFERENCES pessoa (id) ON DELETE CASCADE
);