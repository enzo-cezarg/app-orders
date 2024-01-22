CREATE TABLE funcionario (
	id integer NOT NULL,
	comissao numeric(15,2) DEFAULT 0,
	email varchar(100),
	login varchar(35),
	senha varchar(35),
	master SMALLINT DEFAULT 0,
	ativo SMALLINT DEFAULT 1,
	CONSTRAINT pk_funcionario PRIMARY KEY (id),
	CONSTRAINT fk_funcionario_pessoa FOREIGN KEY (id) REFERENCES pessoa (id) ON DELETE CASCADE
);