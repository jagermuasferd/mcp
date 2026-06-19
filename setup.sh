#!/bin/bash
# Cria os 3 bancos de dados e executa os scripts de criação das tabelas.
# Uso: ./setup.sh [usuario_postgres] [senha_postgres]
# Padrão: usuário = postgres, senha = postgres

PGUSER="${1:-postgres}"
export PGPASSWORD="${2:-postgres}"

echo "=== Setup dos bancos de dados ==="
echo "Usuário: $PGUSER"
echo ""

run_sql() {
    local db="$1"
    local file="$2"
    psql -U "$PGUSER" -h localhost -d "$db" -f "$file" 2>&1
}

create_db() {
    local db="$1"
    psql -U "$PGUSER" -h localhost -d postgres -c "CREATE DATABASE $db;" 2>&1
}

# ── Clínica Veterinária ──────────────────────────────────────────────────────
echo ">>> Criando banco: clinica_veterinaria"
create_db clinica_veterinaria
echo ">>> Criando tabelas..."
run_sql clinica_veterinaria "$(dirname "$0")/clinica-veterinaria/banco.sql"
echo ""

# ── Oficina Mecânica ─────────────────────────────────────────────────────────
echo ">>> Criando banco: oficina_mecanica"
create_db oficina_mecanica
echo ">>> Criando tabelas..."
run_sql oficina_mecanica "$(dirname "$0")/oficina-mecanica/banco.sql"
echo ""

# ── Escola de Cursos Livres ──────────────────────────────────────────────────
echo ">>> Criando banco: escola_cursos"
create_db escola_cursos
echo ">>> Criando tabelas..."
run_sql escola_cursos "$(dirname "$0")/escola-cursos-livres/banco.sql"
echo ""

echo "=== Concluído! ==="
echo ""
echo "Bancos criados:"
echo "  clinica_veterinaria  →  clinica-veterinaria/"
echo "  oficina_mecanica     →  oficina-mecanica/"
echo "  escola_cursos        →  escola-cursos-livres/"
