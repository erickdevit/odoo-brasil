#!/bin/bash

# Lista de módulos base necessários
BASE_MODULES=(
    "l10n_br_base"
    "l10n_br_coa"
    "l10n_br_fiscal"
    "l10n_br_account"
    "l10n_br_stock"
    "l10n_br_sale"
    "l10n_br_purchase"
    "l10n_br_nfe"
    "l10n_br_nfse"
    "uom_alias"
)

# Instala os módulos base
for module in "${BASE_MODULES[@]}"
do
    echo "Installing module: $module"
    odoo -i $module --stop-after-init
done

echo "All modules have been installed successfully!"