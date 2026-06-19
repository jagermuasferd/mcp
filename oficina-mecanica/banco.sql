-- Oficina Mecânica — Script de criação do banco de dados
-- Execute este arquivo no DBeaver conectado ao banco: oficina_mecanica
-- (crie o banco antes: CREATE DATABASE oficina_mecanica;)

CREATE TABLE IF NOT EXISTS cliente (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    telefone  VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS veiculo (
    id          SERIAL PRIMARY KEY,
    placa       VARCHAR(10)  NOT NULL UNIQUE,
    modelo      VARCHAR(100) NOT NULL,
    ano         INT,
    cliente_id  INT NOT NULL,
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE IF NOT EXISTS ordem_servico (
    id                  SERIAL PRIMARY KEY,
    veiculo_id          INT            NOT NULL,
    descricao_problema  TEXT           NOT NULL,
    valor               NUMERIC(10, 2) NOT NULL CHECK (valor >= 0),
    status              VARCHAR(10)    NOT NULL DEFAULT 'ABERTA',
    CONSTRAINT fk_os_veiculo FOREIGN KEY (veiculo_id) REFERENCES veiculo(id),
    CONSTRAINT chk_status CHECK (status IN ('ABERTA', 'CONCLUIDA'))
);
