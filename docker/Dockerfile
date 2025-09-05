# Use ARG to define versions, facilitating maintenance and updating
ARG ODOO_VERSION=16.0
ARG NODE_VERSION=16

# --- Build Stage (Builder) ---
FROM odoo:${ODOO_VERSION} as builder

# Re-declare ARGs to make them available in the build stage
ARG ODOO_VERSION
ARG NODE_VERSION

USER root

# Install system dependencies for compilation and Node.js
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-dev \
    build-essential \
    python3-pip \
    git \
    libxml2-dev \
    libxslt1-dev \
    libsasl2-dev \
    libldap2-dev \
    libjpeg-dev \
    zlib1g-dev \
    curl \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g less less-plugin-clean-css rtlcss --force \
    && apt-get purge -y --auto-remove curl gnupg build-essential python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install --no-cache-dir -r /tmp/requirements.txt && \
    python3 -m pip install --no-cache-dir \
      erpbrasil.base>=2.3.0 \
      erpbrasil.assinatura \
      erpbrasil.transmissao \
      erpbrasil.edoc \
    && find /usr/local/lib/python*/dist-packages/ -type d -name '__pycache__' -exec rm -r {} + || true

# Clone OCA repositories, install their requirements, and apply patch
ARG ODOO_VERSION
RUN git clone --depth=1 --branch=${ODOO_VERSION} https://github.com/OCA/l10n-brazil.git /opt/odoo/l10n-brazil && \
    git clone --depth=1 --branch=${ODOO_VERSION} https://github.com/OCA/product-attribute.git /opt/odoo/product-attribute && \
    git clone --depth=1 --branch=${ODOO_VERSION} https://github.com/OCA/account-payment.git /opt/odoo/account-payment && \
    git clone --depth=1 --branch=${ODOO_VERSION} https://github.com/OCA/bank-payment.git /opt/odoo/bank-payment && \
    pip3 install --no-cache-dir -r /opt/odoo/l10n-brazil/requirements.txt && \
    sed -i 's/list | tuple/(list, tuple)/g' /opt/odoo/l10n-brazil/l10n_br_base/models/party_mixin.py


# --- Final Stage (Runtime) ---
FROM odoo:${ODOO_VERSION}

USER root

# Install only necessary runtime system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libxml2-dev libxslt1-dev libsasl2-dev libldap2-dev libjpeg-dev \
    dos2unix zlib1g-dev postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy artifacts from the builder stage
COPY --from=builder /usr/local/lib/python3.9/dist-packages /usr/local/lib/python3.9/dist-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
COPY --from=builder /opt/odoo/ /opt/odoo/

# Copy configuration, entrypoint and adjust permissions
COPY docker/odoo.conf.gemini /etc/odoo/odoo.conf
COPY scripts/entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh && \
    chown -R odoo:odoo /opt/odoo /etc/odoo/odoo.conf

USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD []

EXPOSE 8069 8072