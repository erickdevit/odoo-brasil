# 🚀 Odoo Brasileiro - Docker Setup

Sistema Odoo 16 com localização brasileira completa, configurado com Docker para desenvolvimento e produção, incluindo integração com Traefik para HTTPS e gerenciamento de domínio.

## ✨ Características

-   **Odoo 16** com localização brasileira completa
-   **Docker & Docker Compose** para fácil implantação e orquestração
-   **PostgreSQL** como banco de dados
-   **Módulos brasileiros** (OCA) clonados diretamente no build da imagem
-   **NF-e** com parser XML robusto
-   **Compatibilidade Python 3.9**
-   **Imagem Docker auto-contida** (`erickwornex/odoobrasileiro:latest`)
-   **Traefik** integrado para **HTTPS automático** (Let's Encrypt) e roteamento de domínio
-   **Configuração SMTP** via variáveis de ambiente

## 🛠️ Módulos Incluídos

### Repositórios OCA (clonados durante o build)
-   **l10n-brazil**: Localização brasileira completa
-   **account-payment**: Módulos de pagamento
-   **bank-payment**: Pagamentos bancários
-   **product-attribute**: Atributos de produtos

### Módulos Principais (do Odoo e da localização)
-   `l10n_br_base`: Base da localização brasileira
-   `l10n_br_nfe`: Nota Fiscal Eletrônica
-   `l10n_br_account_nfe`: Integração contábil NF-e
-   `account_payment_partner`: Pagamentos por parceiro
-   Outros módulos padrão do Odoo 16

## 🚀 Implantação em Produção (Recomendado)

Esta seção detalha como implantar o Odoo usando a imagem Docker pré-construída e o Traefik para gerenciar seu domínio e HTTPS.

### Pré-requisitos
-   Servidor com **Docker** e **Docker Compose** instalados.
-   Um **domínio** (ou subdomínio) apontando para o IP público do seu servidor (ex: `odoo.seusite.com`).
-   Credenciais de um **servidor SMTP** para envio de e-mails.

### Passos

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/erickdevit/odoo-brasil.git
    cd odoo-brasil
    ```

2.  **Configure o `docker-compose.yml`:**
    Abra o arquivo `docker-compose.yml` e substitua os placeholders:
    -   **`SEU_EMAIL_AQUI@gmail.com`**: Seu e-mail para notificações do Let's Encrypt.
    -   **`odoo.SEU_DOMINIO_AQUI.com`**: O domínio completo que você configurou no DNS para acessar o Odoo.
    -   **Variáveis `SMTP_*`**: Preencha com os dados do seu provedor SMTP (servidor, porta, usuário, senha, SSL).

    Exemplo de configuração no `docker-compose.yml`:
    ```yaml
    # ... (trecho do arquivo docker-compose.yml) ...
    services:
      traefik:
        command:
          # ...
          - "--certificatesresolvers.myresolver.acme.email=seu.email@exemplo.com" # <-- SEU E-MAIL
          # ...
      odoo:
        image: erickwornex/odoobrasileiro:latest
        environment:
          - SMTP_SERVER=smtp.seuprovedor.com
          - SMTP_PORT=587
          - SMTP_USER=seu_usuario_smtp
          - SMTP_PASSWORD=sua_senha_smtp
          - SMTP_SSL=True
        labels:
          - "traefik.enable=true"
          - "traefik.http.routers.odoo.rule=Host(`odoo.seusite.com`)" # <-- SEU DOMÍNIO
          - "traefik.http.routers.odoo.entrypoints=web"
          - "traefik.http.routers.odoo-secure.rule=Host(`odoo.seusite.com`)" # <-- SEU DOMÍNIO
          - "traefik.http.routers.odoo-secure.entrypoints=websecure"
          - "traefik.http.routers.odoo-secure.tls=true"
          - "traefik.http.routers.odoo-secure.tls.certresolver=myresolver"
          - "traefik.http.services.odoo.loadbalancer.server.port=8069"
          # ...
    ```

3.  **Inicie os serviços:**
    No terminal do seu servidor, no diretório `odoo-brasil`, execute:
    ```bash
    docker-compose up -d
    ```
    O Docker irá baixar a imagem `erickwornex/odoobrasileiro:latest` e configurar o Traefik.

4.  **Acesse o Odoo:**
    Após alguns minutos (o Traefik precisa obter o certificado SSL), acesse seu Odoo pelo domínio configurado:
    `https://odoo.SEU_DOMINIO_AQUI.com`

5.  **Configure o banco de dados:**
    -   Crie um novo banco de dados.
    -   Master password: `mastersenha` (pode ser alterada nas variáveis de ambiente do Odoo no `docker-compose.yml` para produção).

### Implantação com Portainer ou Easypanel
Para Portainer ou Easypanel, o processo é similar:
1.  No painel da ferramenta, crie uma nova "Stack" (Portainer) ou "Application" (Easypanel).
2.  Cole todo o conteúdo do `docker-compose.yml` (já com seus dados preenchidos) no editor web da ferramenta.
3.  Implante a stack/aplicação.

## ⚙️ Construindo a Imagem do Zero (para Desenvolvimento/Customização)

Se você precisa modificar o código-fonte do Odoo ou dos módulos, ou apenas quer construir a imagem localmente, siga estes passos.

### Pré-requisitos
-   Docker
-   Docker Compose
-   Git

### Passos

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/erickdevit/odoo-brasil.git
    cd odoo-brasil
    ```

2.  **Construa a imagem Docker:**
    ```bash
    docker build -f docker/Dockerfile -t erickwornex/odoobrasileiro:latest .
    ```
    Este comando construirá a imagem `erickwornex/odoobrasileiro:latest` a partir do `Dockerfile` customizado.

3.  **Inicie os serviços (usando a imagem local):**
    Use o `docker-compose.yml` (já configurado para produção) ou crie um `docker-compose.dev.yml` simples para desenvolvimento, apontando para a imagem `erickwornex/odoobrasileiro:latest`.
    ```bash
    docker-compose up -d
    ```

4.  **Acesse o Odoo:**
    `http://localhost:8069` (se não estiver usando Traefik localmente)

## 📁 Estrutura do Projeto

```
odoo-brasil/
├── docker/
│   ├── Dockerfile          # Define como a imagem Docker do Odoo é construída
│   └── odoo.conf           # Configuração principal do Odoo
├── scripts/
│   └── entrypoint.sh       # Script de inicialização do contêiner Odoo
├── docker-compose.yml      # Orquestração dos serviços (Odoo, DB, Traefik)
├── requirements.txt        # Dependências Python adicionais
└── README.md               # Este arquivo
```

## 🔧 Configuração

### Portas
-   **Odoo HTTP**: 8069 (interno ao contêiner)
-   **Odoo Longpolling**: 8072 (interno ao contêiner)
-   **Traefik HTTP**: 80 (externo)
-   **Traefik HTTPS**: 443 (externo)
-   **PostgreSQL**: 5432 (interno)

### Variáveis de Ambiente (no `docker-compose.yml`)
-   **Banco de dados:**
    -   `POSTGRES_DB`: `postgres` (nome do banco de dados inicial)
    -   `POSTGRES_USER`: `odoo`
    -   `POSTGRES_PASSWORD`: `odoo_password` (altere para produção!)
-   **Odoo:**
    -   `admin_passwd`: `mastersenha` (senha mestra do Odoo, altere para produção!)
    -   `SMTP_SERVER`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASSWORD`, `SMTP_SSL`: Configurações do seu servidor de e-mail.

## 🎯 Funcionalidades

### NF-e (Nota Fiscal Eletrônica)
-   ✅ Importação de XML NF-e
-   ✅ Parser robusto para `nfeProc`
-   ✅ Suporte a namespaces XML
-   ✅ Integração contábil automática

### Localização Brasileira
-   ✅ Plano de contas brasileiro
-   ✅ Regimes fiscais (Simples, Lucro Presumido, Real)
-   ✅ CNAE e códigos fiscais
-   ✅ Validações de CPF/CNPJ

### Pagamentos
-   ✅ Módulos de pagamento bancário
-   ✅ Integração com bancos brasileiros
-   ✅ Gestão de parceiros

## 🐛 Correções Aplicadas (durante o desenvolvimento)

### Python 3.9 Compatibility
-   ✅ Corrigido operador `|` para união de tipos
-   ✅ Patch aplicado em `party_mixin.py`

### XML Parser NF-e
-   ✅ Suporte a `nfeProc` como root tag
-   ✅ Extração automática de `NFe`
-   ✅ Fallback robusto para parsing

### Dependências
-   ✅ `account_payment_partner` adicionado
-   ✅ Repositório `bank-payment` integrado
-   ✅ Todas as dependências Python resolvidas

### Configuração de Imagem
-   ✅ `Dockerfile` otimizado para build multi-stage
-   ✅ `entrypoint.sh` e `odoo.conf` ajustados para inicialização limpa
-   ✅ `addons_path` corrigido para módulos internos da imagem
-   ✅ `CMD` do Dockerfile ajustado para evitar conflitos

## 🔍 Troubleshooting

### Problema: Aplicação inacessível
```bash
# Verificar logs do Odoo
docker-compose logs odoo

# Verificar logs do Traefik (se estiver usando)
docker-compose logs traefik

# Reiniciar serviços
docker-compose restart
```

### Problema: Erro de dependência (durante o build)
```bash
# Rebuild da imagem sem cache
docker build -f docker/Dockerfile -t erickwornex/odoobrasileiro:latest .
```

### Problema: Erro ao importar NF-e
-   Verifique se o CNPJ da sua empresa está configurado corretamente no Odoo (Configurações > Empresas).
-   Verifique se o XML está no formato padrão da SEFAZ.

## 📝 Logs

### Ver logs do Odoo
```bash
docker-compose logs -f odoo
```

### Ver logs do PostgreSQL
```bash
docker-compose logs -f db
```

### Ver logs do Traefik (se estiver usando)
```bash
docker-compose logs -f traefik
```

## 💾 Backup

### Backup do banco de dados
```bash
docker-compose exec db pg_dump -U odoo postgres > backup.sql
```

### Backup dos arquivos do Odoo
```bash
docker-compose exec odoo tar -czf /tmp/odoo_data.tar.gz /var/lib/odoo
```

## 🤝 Contribuição

1.  Fork o projeto
2.  Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3.  Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4.  Push para a branch (`git push origin feature/AmazingFeature`)
5.  Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👨‍💻 Autor

**Erick Dev** - [GitHub](https://github.com/erickdevit)

## 🙏 Agradecimentos

-   [OCA (Odoo Community Association)](https://odoo-community.org/)
-   [l10n-brazil](https://github.com/OCA/l10n-brazil)
-   [account-payment](https://github.com/OCA/account-payment)
-   [bank-payment](https://github.com/OCA/bank-payment)

---

⭐ **Se este projeto te ajudou, considere dar uma estrela!**
