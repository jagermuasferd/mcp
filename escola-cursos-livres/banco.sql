-- Escola de Cursos Livres — Script de criação do banco de dados
-- Execute este arquivo no DBeaver conectado ao banco: d_escola_cursos
-- (crie o banco antes: CREATE DATABASE d_escola_cursos;)

CREATE TABLE IF NOT EXISTS aluno (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    email     VARCHAR(100) NOT NULL UNIQUE,
    telefone  VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS curso (
    id                 SERIAL PRIMARY KEY,
    nome               VARCHAR(100) NOT NULL,
    descricao          TEXT,
    carga_horaria      INT NOT NULL,
    vagas_totais       INT NOT NULL,
    vagas_disponiveis  INT NOT NULL
);

CREATE TABLE IF NOT EXISTS matricula (
    id          SERIAL PRIMARY KEY,
    aluno_id    INT            NOT NULL,
    curso_id    INT            NOT NULL,
    data        DATE           NOT NULL,
    valor_pago  NUMERIC(10, 2) NOT NULL CHECK (valor_pago >= 0),
    CONSTRAINT fk_matricula_aluno FOREIGN KEY (aluno_id) REFERENCES aluno(id),
    CONSTRAINT fk_matricula_curso FOREIGN KEY (curso_id) REFERENCES curso(id),
    CONSTRAINT uq_matricula_aluno_curso UNIQUE (aluno_id, curso_id)
);
