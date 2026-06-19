# Clínica Veterinária — MVC + JDBC + PostgreSQL

Sistema de gerenciamento de clínica veterinária desenvolvido em Java com padrão MVC, JDBC puro e banco de dados PostgreSQL.

---

## Pré-requisitos

| Ferramenta | Versão mínima |
|------------|---------------|
| Java (JDK) | 17            |
| Maven      | 3.8+          |
| PostgreSQL | 14+           |

---

## Estrutura do Projeto

```
clinica-veterinaria/
├── pom.xml
└── src/main/java/com/clinica/
    ├── Main.java                     ← Ponto de entrada (demonstra o fluxo completo)
    ├── model/
    │   ├── Tutor.java
    │   ├── Animal.java
    │   └── Consulta.java
    ├── repository/                   ← Acesso ao banco via JDBC
    │   ├── TutorRepository.java
    │   ├── AnimalRepository.java
    │   └── ConsultaRepository.java
    ├── service/                      ← Regras de negócio
    │   ├── TutorService.java
    │   ├── AnimalService.java
    │   └── ConsultaService.java
    ├── controller/                   ← Coordena Service e exibe resultados
    │   ├── TutorController.java
    │   ├── AnimalController.java
    │   └── ConsultaController.java
    └── util/
        └── Conexao.java              ← Configuração da conexão com o banco
```

---

## Configuração do Banco de Dados

### 1. Crie o banco no PostgreSQL

```sql
CREATE DATABASE clinica_veterinaria;
```

### 2. Execute os scripts abaixo na ordem (respeita as foreign keys)

```sql
CREATE TABLE tutor (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    endereco  VARCHAR(200),
    telefone  VARCHAR(20)
);

CREATE TABLE animal (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    especie   VARCHAR(50)  NOT NULL,
    raca      VARCHAR(50),
    tutor_id  INT NOT NULL,
    CONSTRAINT fk_animal_tutor FOREIGN KEY (tutor_id) REFERENCES tutor(id)
);

CREATE TABLE consulta (
    id         SERIAL PRIMARY KEY,
    animal_id  INT            NOT NULL,
    data       DATE           NOT NULL,
    motivo     VARCHAR(200)   NOT NULL,
    valor      NUMERIC(10, 2) NOT NULL CHECK (valor >= 0),
    CONSTRAINT fk_consulta_animal FOREIGN KEY (animal_id) REFERENCES animal(id)
);
```

### 3. Configure a conexão

Abra `src/main/java/com/clinica/util/Conexao.java` e ajuste os dados:

```java
private static final String URL      = "jdbc:postgresql://localhost:5432/clinica_veterinaria";
private static final String USER     = "postgres";   // seu usuário PostgreSQL
private static final String PASSWORD = "postgres";   // sua senha PostgreSQL
```

---

## Como Executar

### Via IntelliJ IDEA

1. `File → Open` → selecione a pasta **`clinica-veterinaria`**
2. Aguarde o Maven baixar as dependências automaticamente
3. Abra `src/main/java/com/clinica/Main.java`
4. Clique no botão **▶ Run** ao lado do método `main`

### Via terminal (Maven)

```bash
mvn compile
mvn exec:java
```

---

## Regras de Negócio

| # | Regra |
|---|-------|
| 1 | Não é permitido registrar consulta para animal não cadastrado |
| 2 | Valor da consulta não pode ser negativo — lança `IllegalArgumentException` |
| 3 | É possível listar todas as consultas de um determinado animal |
| 4 | É possível listar todos os animais vinculados a um determinado tutor |

---

## O que o `Main.java` demonstra

1. Cadastra um tutor (`Carlos Souza`)
2. Cadastra um animal (`Rex`, Labrador) vinculado ao tutor
3. Registra uma consulta (`Check-up anual`, R$ 150,00)
4. Lista todas as consultas do animal
5. Lista todos os animais do tutor
6. Tenta registrar consulta com valor negativo — exibe mensagem de erro (regra de negócio)
