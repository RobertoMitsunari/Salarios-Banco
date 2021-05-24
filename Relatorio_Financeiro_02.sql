CREATE DATABASE relatorio_financeiro
GO
USE relatorio_financeiro

CREATE TABLE Natureza_Rendimentos (
id INT,
natureza VARCHAR(15),
PRIMARY KEY (id)
)

CREATE TABLE Funcionario (
cpf CHAR(11),
nome VARCHAR(100),
natureza_redimentosid INT
PRIMARY KEY (cpf)
FOREIGN KEY (natureza_redimentosid) REFERENCES Natureza_Rendimentos (id)
)

CREATE TABLE Tipo_Rendimento (
id INT,
Tipo VARCHAR(30)
PRIMARY KEY (id)
)

CREATE TABLE Rendimentos (
funcionarioCPF CHAR(11),
data DATE,
valor DECIMAL(7,2),
tipo_rendimentoID INT
PRIMARY KEY (funcionarioCPF, data, tipo_rendimentoID)
FOREIGN KEY (funcionarioCPF)  REFERENCES Funcionario (cpf),
FOREIGN KEY (tipo_rendimentoID) REFERENCES Tipo_Rendimento (id)
)

INSERT INTO Natureza_Rendimentos VALUES
(1, 'salário')

INSERT INTO Funcionario VALUES
(11111111111, 'Fulano', 1),
(22222222222, 'Ciclano', 1),
(33333333333, 'Beltrano', 1),
(44444444444, 'Arnaldo', 1)

INSERT INTO Tipo_Rendimento VALUES
(101, 'Tributáveis'),
(102, 'Isentos e não tributáveis'),
(103, 'Tributação exclusiva')

INSERT INTO Rendimentos VALUES
(11111111111, GETDATE(), 4000.00, 101),
(22222222222, GETDATE(), 5500.00, 103),
(33333333333, GETDATE(), 6000.00, 102),
(44444444444, GETDATE(), 7500.00, 103)

CREATE FUNCTION fn_relatorio (@cpf CHAR(11)) 
RETURNS @table TABLE (
cpf CHAR(11),
nome VARCHAR(100),
natureza_rendimento VARCHAR(15),
salario_bruto DECIMAL(7,2),
contribuicao DECIMAL(7,2),
imposto DECIMAL(7,2),
salario13 DECIMAL(7,2),
imposto13 DECIMAL(7,2)
)
AS 
BEGIN

	INSERT INTO @table (cpf, nome, natureza_rendimento, salario_bruto, contribuicao, imposto, salario13, imposto13)
		SELECT f.cpf, f.nome, n.natureza, (r.valor * 12), (r.valor * 12 * 0.90), (r.valor * 12 * 0.85), r.valor, (r.valor * 0.90)
		FROM Funcionario f, Natureza_Rendimentos n, Rendimentos r
		WHERE f.natureza_redimentosid = n.id AND f.cpf = @cpf AND r.funcionarioCPF = f.cpf

	RETURN

END

SELECT * FROM fn_relatorio(11111111111)
SELECT * FROM fn_relatorio(22222222222)
SELECT * FROM fn_relatorio(33333333333)
SELECT * FROM fn_relatorio(44444444444)