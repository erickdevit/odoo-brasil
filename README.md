# 🚀 Odoo Brasil - Docker Setup

Sistema Odoo 16 com localização brasileira completa, configurado com Docker para desenvolvimento e produção.

## ✨ Características

- **Odoo 16** com localização brasileira completa
- **Docker & Docker Compose** para fácil deploy
- **PostgreSQL** como banco de dados
- **Módulos brasileiros** pré-configurados
- **NF-e** com parser XML robusto
- **Compatibilidade Python 3.9** corrigida

## 🛠️ Módulos Incluídos

### Repositórios OCA
- **l10n-brazil**: Localização brasileira completa
- **account-payment**: Módulos de pagamento
- **bank-payment**: Pagamentos bancários
- **product-attribute**: Atributos de produtos

### Módulos Principais
- `l10n_br_base`: Base da localização brasileira
- `l10n_br_nfe`: Nota Fiscal Eletrônica
- `l10n_br_account_nfe`: Integração contábil NF-e
- `account_payment_partner`: Pagamentos por parceiro

## 🚀 Instalação Rápida

### Pré-requisitos
- Docker
- Docker Compose
- Git

### Passos

1. **Clone o repositório**
```bash
git clone https://github.com/erickdevit/odoo-brasil.git
cd odoo-brasil
```

2. **Suba os serviços**
```bash
docker-compose up -d
```

3. **Acesse o Odoo**
```
http://localhost:8069
```

4. **Configure o banco de dados**
- Crie um novo banco
- Master password: `mastersenha`

## 📁 Estrutura do Projeto

```
odoo-brasil/
├── docker/
│   ├── Dockerfile          # Imagem customizada do Odoo
│   └── odoo.conf          # Configuração do Odoo
├── scripts/
│   └── entrypoint.sh      # Script de inicialização
├── docker-compose.yml     # Orquestração dos serviços
├── requirements.txt      # Dependências Python
└── README.md             # Este arquivo
```

## 🔧 Configuração

### Portas
- **Odoo**: 8069
- **Longpolling**: 8072
- **PostgreSQL**: 5432 (interno)

### Variáveis de Ambiente
```bash
# Banco de dados
POSTGRES_DB=odoo
POSTGRES_PASSWORD=odoo
POSTGRES_USER=odoo

# Odoo
ODOO_MASTER_PASSWORD=mastersenha
```

## 🎯 Funcionalidades

### NF-e (Nota Fiscal Eletrônica)
- ✅ Importação de XML NF-e
- ✅ Parser robusto para `nfeProc`
- ✅ Suporte a namespaces XML
- ✅ Integração contábil automática

### Localização Brasileira
- ✅ Plano de contas brasileiro
- ✅ Regimes fiscais (Simples, Lucro Presumido, Real)
- ✅ CNAE e códigos fiscais
- ✅ Validações de CPF/CNPJ

### Pagamentos
- ✅ Módulos de pagamento bancário
- ✅ Integração com bancos brasileiros
- ✅ Gestão de parceiros

## 🐛 Correções Aplicadas

### Python 3.9 Compatibility
- ✅ Corrigido operador `|` para união de tipos
- ✅ Patch aplicado em `party_mixin.py`

### XML Parser NF-e
- ✅ Suporte a `nfeProc` como root tag
- ✅ Extração automática de `NFe`
- ✅ Fallback robusto para parsing

### Dependências
- ✅ `account_payment_partner` adicionado
- ✅ Repositório `bank-payment` integrado
- ✅ Todas as dependências Python resolvidas

## 🔍 Troubleshooting

### Problema: Aplicação inacessível
```bash
# Verificar logs
docker-compose logs odoo

# Reiniciar serviços
docker-compose restart
```

### Problema: Erro de dependência
```bash
# Rebuild da imagem
docker-compose build --no-cache
docker-compose up -d
```

### Problema: Importação NF-e falha
- O parser XML está configurado para lidar com diferentes estruturas
- Verifique se o XML está no formato padrão da SEFAZ

## 📝 Logs

### Ver logs do Odoo
```bash
docker-compose logs -f odoo
```

### Ver logs do PostgreSQL
```bash
docker-compose logs -f db
```

## 🚀 Deploy em Produção

### Variáveis de Segurança
```bash
# Altere estas variáveis em produção
POSTGRES_PASSWORD=sua_senha_segura
ODOO_MASTER_PASSWORD=sua_master_senha
```

### Backup
```bash
# Backup do banco
docker-compose exec db pg_dump -U odoo odoo > backup.sql

# Backup dos arquivos
docker-compose exec odoo tar -czf /tmp/odoo_data.tar.gz /var/lib/odoo
```

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👨‍💻 Autor

**Erick Dev** - [GitHub](https://github.com/erickdevit)

## 🙏 Agradecimentos

- [OCA (Odoo Community Association)](https://odoo-community.org/)
- [l10n-brazil](https://github.com/OCA/l10n-brazil)
- [account-payment](https://github.com/OCA/account-payment)
- [bank-payment](https://github.com/OCA/bank-payment)

---

⭐ **Se este projeto te ajudou, considere dar uma estrela!**