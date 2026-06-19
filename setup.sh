#!/bin/bash

export PATH="/snap/bin:/home/ryan/.local/bin:$PATH"

CONTAINER="postgres-trabalho"
PG_PORT=5432
PG_USER="postgres"
PG_PASS="postgres"

echo "=== trabalho faculdade2 devtools ==="

# ── Docker / PostgreSQL ──────────────────────────────────────────────────────
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
  echo "[1/3] Container '$CONTAINER' já está rodando."

elif docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
  echo "[1/3] Iniciando container '$CONTAINER' existente..."
  docker start "$CONTAINER"

else
  echo "[1/3] Criando container '$CONTAINER'..."
  docker run -d \
    --name "$CONTAINER" \
    -e POSTGRES_PASSWORD="$PG_PASS" \
    -e TZ=America/Sao_Paulo \
    -e PGTZ=America/Sao_Paulo \
    -p "$PG_PORT":5432 \
    postgres:16
fi

# ── Aguarda o PostgreSQL aceitar conexões ────────────────────────────────────
echo "    Aguardando PostgreSQL na porta $PG_PORT..."
for i in $(seq 1 20); do
  PGPASSWORD="$PG_PASS" psql -U "$PG_USER" -h localhost -p "$PG_PORT" -d postgres -c '\q' &>/dev/null && break
  sleep 1
done

if ! PGPASSWORD="$PG_PASS" psql -U "$PG_USER" -h localhost -p "$PG_PORT" -d postgres -c '\q' &>/dev/null; then
  echo "Erro: PostgreSQL não respondeu. Verifique se o Docker está rodando."
  exit 1
fi
echo "    PostgreSQL ativo na porta $PG_PORT"

# ── Corrige timezone (Brazil/East não é reconhecido pelo pg:16) ──────────────
CURRENT_TZ=$(PGPASSWORD="$PG_PASS" psql -U "$PG_USER" -h localhost -p "$PG_PORT" -d postgres -tAc "SHOW timezone;" 2>/dev/null)
if [ "$CURRENT_TZ" != "America/Sao_Paulo" ]; then
  echo "    Corrigindo timezone: $CURRENT_TZ → America/Sao_Paulo"
  PGPASSWORD="$PG_PASS" psql -U "$PG_USER" -h localhost -p "$PG_PORT" -d postgres \
    -c "ALTER SYSTEM SET timezone = 'America/Sao_Paulo'; SELECT pg_reload_conf();" &>/dev/null
fi

# ── Cria bancos e tabelas ────────────────────────────────────────────────────
DIR="$(cd "$(dirname "$0")" && pwd)"

create_db_and_tables() {
  local db="$1"
  local sql="$2"

  PGPASSWORD="$PG_PASS" psql -U "$PG_USER" -h localhost -p "$PG_PORT" -d postgres \
    -c "SELECT 1 FROM pg_database WHERE datname='$db'" | grep -q 1 \
    || PGPASSWORD="$PG_PASS" psql -U "$PG_USER" -h localhost -p "$PG_PORT" -d postgres \
       -c "CREATE DATABASE $db;" &>/dev/null

  PGPASSWORD="$PG_PASS" psql -U "$PG_USER" -h localhost -p "$PG_PORT" -d "$db" -f "$sql" &>/dev/null
  echo "    $db ✓"
}

echo "[2/3] Criando bancos e tabelas..."
create_db_and_tables d_clinica_veterinaria "$DIR/clinica-veterinaria/banco.sql"
create_db_and_tables d_oficina_mecanica   "$DIR/oficina-mecanica/banco.sql"
create_db_and_tables d_escola_cursos      "$DIR/escola-cursos-livres/banco.sql"

echo "    Host: localhost | User: $PG_USER | Senha: $PG_PASS"

# ── DBeaver ──────────────────────────────────────────────────────────────────
echo "[3/3] Abrindo DBeaver..."
flatpak run io.dbeaver.DBeaverCommunity &>/dev/null &

echo ""
echo "Pronto! Bancos disponíveis:"
echo "  d_clinica_veterinaria  →  branch clinica-veterinaria"
echo "  d_oficina_mecanica     →  branch oficina-mecanica"
echo "  d_escola_cursos        →  branch escola-cursos-livres"
