-- Clínica Veterinária — Script de criação do banco de dados
-- Execute este arquivo no DBeaver conectado ao banco: d_clinica_veterinaria
-- (crie o banco antes: CREATE DATABASE d_clinica_veterinaria;)

CREATE TABLE IF NOT EXISTS tutor (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    endereco  VARCHAR(200),
    telefone  VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS animal (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    especie   VARCHAR(50)  NOT NULL,
    raca      VARCHAR(50),
    tutor_id  INT NOT NULL,
    CONSTRAINT fk_animal_tutor FOREIGN KEY (tutor_id) REFERENCES tutor(id)
);

CREATE TABLE IF NOT EXISTS consulta (
    id         SERIAL PRIMARY KEY,
    animal_id  INT            NOT NULL,
    data       DATE           NOT NULL,
    motivo     VARCHAR(200)   NOT NULL,
    valor      NUMERIC(10, 2) NOT NULL CHECK (valor >= 0),
    CONSTRAINT fk_consulta_animal FOREIGN KEY (animal_id) REFERENCES animal(id)
);
