CREATE DATABASE EducaFuturo;

USE EducaFuturo;
SHOW TABLES;
DESCRIBE aluno;
SELECT * FROM uso_recurso;
SELECT * FROM vw_alunos_cursos;
SHOW TRIGGERS;
SHOW INDEX FROM aluno;
SELECT * FROM aluno;


CREATE TABLE aluno (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    sexo VARCHAR(15),
    endereco VARCHAR(150),
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    data_cadastro DATE NOT NULL,
    situacao_social VARCHAR(100)
);

CREATE TABLE professor (
    id_professor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    especialidade VARCHAR(100),
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    data_contratacao DATE
);

CREATE TABLE curso (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL,
    descricao TEXT,
    carga_horaria INT,
    nivel VARCHAR(50),
    data_inicio DATE,
    data_fim DATE,
    vagas INT,
    id_professor INT,

    FOREIGN KEY (id_professor)
    REFERENCES professor(id_professor)
);

CREATE TABLE matricula (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT,
    id_curso INT,
    data_matricula DATE,
    status VARCHAR(50),

    FOREIGN KEY (id_aluno)
    REFERENCES aluno(id_aluno),

    FOREIGN KEY (id_curso)
    REFERENCES curso(id_curso)
);

CREATE TABLE voluntario (
    id_voluntario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    area_atuacao VARCHAR(100),
    disponibilidade VARCHAR(100)
);

CREATE TABLE participacao_voluntario (
    id_participacao INT AUTO_INCREMENT PRIMARY KEY,
    id_voluntario INT,
    id_curso INT,
    funcao VARCHAR(100),
    carga_horaria INT,

    FOREIGN KEY (id_voluntario)
    REFERENCES voluntario(id_voluntario),

    FOREIGN KEY (id_curso)
    REFERENCES curso(id_curso)
);

CREATE TABLE doador (
    id_doador INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(18) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    tipo_doador VARCHAR(50)
);

CREATE TABLE doacao (
    id_doacao INT AUTO_INCREMENT PRIMARY KEY,
    valor DECIMAL(10,2) NOT NULL,
    data_doacao DATE,
    tipo_doacao VARCHAR(50),
    descricao TEXT,
    comprovante VARCHAR(255),
    id_doador INT,

    FOREIGN KEY (id_doador)
    REFERENCES doador(id_doador)
);

CREATE TABLE recurso_educacional (
    id_recurso INT AUTO_INCREMENT PRIMARY KEY,
    nome_recurso VARCHAR(100),
    tipo_recurso VARCHAR(50),
    quantidade INT,
    estado_conservacao VARCHAR(50)
);

CREATE TABLE uso_recurso (
    id_uso INT AUTO_INCREMENT PRIMARY KEY,
    id_recurso INT,
    id_curso INT,
    quantidade_utilizada INT,

    FOREIGN KEY (id_recurso)
    REFERENCES recurso_educacional(id_recurso),

    FOREIGN KEY (id_curso)
    REFERENCES curso(id_curso)
);

CREATE VIEW vw_alunos_cursos AS
SELECT
    aluno.nome AS aluno,
    curso.nome_curso AS curso
FROM matricula
JOIN aluno
    ON matricula.id_aluno = aluno.id_aluno
JOIN curso
    ON matricula.id_curso = curso.id_curso;
    
DELIMITER $$

CREATE TRIGGER trg_validar_doacao
BEFORE INSERT ON doacao
FOR EACH ROW
BEGIN
    IF NEW.valor <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'O valor da doação deve ser maior que zero';
    END IF;
END$$

DELIMITER ;

CREATE INDEX idx_cpf_aluno
ON aluno(cpf);

INSERT INTO professor
(nome, cpf, especialidade, telefone, email, data_contratacao)
VALUES
('João Silva','11111111111','Informática','81999990001','joao@educafuturo.com','2025-01-10'),
('Maria Santos','22222222222','Programação','81999990002','maria@educafuturo.com','2025-01-15'),
('Carlos Oliveira','33333333333','Robótica','81999990003','carlos@educafuturo.com','2025-02-01'),
('Ana Souza','44444444444','Inglês','81999990004','ana@educafuturo.com','2025-02-10'),
('Pedro Lima','55555555555','Empreendedorismo','81999990005','pedro@educafuturo.com','2025-02-20');

INSERT INTO aluno
(nome, cpf, data_nascimento, sexo, endereco,
telefone, email, data_cadastro, situacao_social)
VALUES
('Lucas Andrade','12345678901','2005-03-10','Masculino',
'Recife','81990000001','lucas@email.com',
'2026-01-01','Baixa renda');

INSERT INTO curso
(nome_curso, descricao, carga_horaria, nivel,
data_inicio, data_fim, vagas, id_professor)
VALUES
('Informática Básica',
'Curso introdutório de informática',
60,
'Básico',
'2026-03-01',
'2026-06-01',
30,
1);

INSERT INTO matricula
(id_aluno, id_curso, data_matricula, status)
VALUES
(1,1,'2026-02-15','Ativa');

INSERT INTO voluntario
(nome, cpf, telefone, email,
area_atuacao, disponibilidade)
VALUES
('Carlos Mendes',
'98765432101',
'81988880001',
'carlos@email.com',
'Tecnologia',
'Noite');

INSERT INTO participacao_voluntario
(id_voluntario, id_curso, funcao, carga_horaria)
VALUES
(1,1,'Monitor',20);

INSERT INTO doador
(nome, cpf_cnpj, telefone,
email, tipo_doador)
VALUES
('Empresa Alpha',
'12345678000199',
'8133334444',
'contato@alpha.com',
'Pessoa Jurídica');

INSERT INTO doacao
(valor, data_doacao, tipo_doacao,
descricao, comprovante, id_doador)
VALUES
(5000.00,
'2026-04-01',
'Financeira',
'Doação para compra de equipamentos',
'comp001.pdf',
1);

INSERT INTO recurso_educacional
(nome_recurso, tipo_recurso,
quantidade, estado_conservacao)
VALUES
('Notebook',
'Tecnologia',
10,
'Ótimo');

INSERT INTO uso_recurso
(id_recurso, id_curso, quantidade_utilizada)
VALUES
(1,1,5);

SELECT * FROM aluno;
SELECT * FROM professor;
SELECT * FROM curso;
SELECT * FROM matricula;
SELECT * FROM voluntario;
SELECT * FROM participacao_voluntario;
SELECT * FROM doador;
SELECT * FROM doacao;
SELECT * FROM recurso_educacional;
SELECT * FROM uso_recurso;


