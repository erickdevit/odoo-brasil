#!/bin/bash
set -e

# Defaults (can be overridden via environment)
HOST=${DB_HOST:-db}
PORT=${DB_PORT:-5432}
USER=${DB_USER:-odoo}

echo "Aguardando PostgreSQL em ${HOST}:${PORT}..."
until pg_isready -h "$HOST" -p "$PORT" -U "$USER" >/dev/null 2>&1; do
  sleep 1
done
echo "PostgreSQL pronto. Iniciando Odoo..."

exec odoo "$@"