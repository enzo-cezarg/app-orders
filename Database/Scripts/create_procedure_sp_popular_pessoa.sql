CREATE PROCEDURE sp_popular_pessoa(pQTD integer)
AS
DECLARE VARIABLE i integer;
BEGIN
	i = 0;
	WHILE (i <= pQTD) do
	BEGIN
		INSERT INTO pessoa
			(nome_razao,
			 apelido_fantasia,
			 cpf_cnpj,
			 logradouro,
			 numero,
			 bairro,
			 cep,
			 municipio,
			 uf)
		VALUES
			('Nome ou Razão Social',
			 'Apelido ou Nome Fantasia',
			 '00000',
			 'Av. Assis Brasil',
			 '0000',
			 'Bairro Centro',
			 '00000000',
			 'Tapes',
			 'RS'
			);
		i = i + 1;
	END
END
