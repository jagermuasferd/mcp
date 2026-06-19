# Oficina Mecânica — MVC + JDBC + PostgreSQL

Sistema de gerenciamento de oficina mecânica desenvolvido em Java com padrão MVC, JDBC puro e banco de dados PostgreSQL.

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
oficina-mecanica/
├── pom.xml
└── src/main/java/com/oficina/
    ├── Main.java                        ← Ponto de entrada (demonstra o fluxo completo)
    ├── model/
    │   ├── Cliente.java
    │   ├── Veiculo.java
    │   └── OrdemServico.java
    ├── repository/                      ← Acesso ao banco via JDBC
    │   ├── ClienteRepository.java
    │   ├── VeiculoRepository.java
    │   └── OrdemServicoRepository.java
    ├── service/                         ← Regras de negócio
    │   ├── ClienteService.java
    │   ├── VeiculoService.java
    │   └── OrdemServicoService.java
    ├── controller/                      ← Coordena Service e exibe resultados
    │   ├── ClienteController.java
    │   ├── VeiculoController.java
    │   └── OrdemServicoController.java
    └── util/
        └── Conexao.java                 ← Configuração da conexão com o banco
```

---

## Configuração do Banco de Dados

### 1. Crie o banco no PostgreSQL

```sql
CREATE DATABASE d_oficina_mecanica;
```

### 2. Execute os scripts abaixo na ordem (respeita as foreign keys)

```sql
CREATE TABLE cliente (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    telefone  VARCHAR(20)
);

CREATE TABLE veiculo (
    id          SERIAL PRIMARY KEY,
    placa       VARCHAR(10)  NOT NULL UNIQUE,
    modelo      VARCHAR(100) NOT NULL,
    ano         INT,
    cliente_id  INT NOT NULL,
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE ordem_servico (
    id                  SERIAL PRIMARY KEY,
    veiculo_id          INT            NOT NULL,
    descricao_problema  TEXT           NOT NULL,
    valor               NUMERIC(10, 2) NOT NULL CHECK (valor >= 0),
    status              VARCHAR(10)    NOT NULL DEFAULT 'ABERTA',
    CONSTRAINT fk_os_veiculo FOREIGN KEY (veiculo_id) REFERENCES veiculo(id),
    CONSTRAINT chk_status CHECK (status IN ('ABERTA', 'CONCLUIDA'))
);
```

### 3. Configure a conexão

Abra `src/main/java/com/oficina/util/Conexao.java` e ajuste os dados:

```java
private static final String URL      = "jdbc:postgresql://localhost:5432/d_oficina_mecanica";
private static final String USER     = "postgres";   // seu usuário PostgreSQL
private static final String PASSWORD = "postgres";   // sua senha PostgreSQL
```

---

## Como Executar

### Via IntelliJ IDEA

1. `File → Open` → selecione a pasta **`oficina-mecanica`**
2. Aguarde o Maven baixar as dependências automaticamente
3. Abra `src/main/java/com/oficina/Main.java`
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
| 1 | Não é permitido abrir OS para veículo não cadastrado |
| 2 | Valor da OS não pode ser negativo — lança `IllegalArgumentException` |
| 3 | É possível consultar o histórico completo de manutenções de um veículo |
| 4 | O status da OS pode ser alterado de `ABERTA` para `CONCLUIDA` |

---

## O que o `Main.java` demonstra

1. Cadastra um cliente (`Maria Oliveira`)
2. Cadastra um veículo (`Honda Civic 2020`, placa `ABC-1234`) vinculado ao cliente
3. Abre uma OS (`Troca de óleo e filtro`, R$ 250,00)
4. Lista o histórico de OSs do veículo
5. Conclui a OS (status muda de `ABERTA` para `CONCLUIDA`)
6. Lista o histórico novamente para verificar o status atualizado
7. Tenta abrir OS com valor negativo — exibe mensagem de erro (regra de negócio)
