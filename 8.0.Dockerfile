FROM druidoo/odoo:8.0-base
USER root

# Install other iotbox requirements
RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
		usbutils \
	&& rm -Rf /var/lib/apt/lists/* /tmp/* \
	&& apt-get clean

# Install odoo with sparse-checkout (only hw_* addons)
RUN git clone --no-local --no-checkout --depth 1 --branch $ODOO_VERSION https://github.com/$ODOO_SOURCE $SOURCES/odoo && \
	cd $SOURCES/odoo && \
	git config core.sparsecheckout true && \
	printf "/*\n!/addons/*\naddons/web\naddons/hw_*\n" | tee --append .git/info/sparse-checkout > /dev/null && \
	git read-tree -mu HEAD

RUN pip install --no-cache-dir $SOURCES/odoo

# Install other dependancies
RUN pip install --no-cache-dir \
		netifaces

# Simulate odoo bin
RUN if [ -f /home/odoo/.local/bin/openerp-server ]; then cp /home/odoo/.local/bin/openerp-server /home/odoo/.local/bin/odoo; fi
RUN if [ -f /usr/local/bin/openerp-server ]; then cp /usr/local/bin/openerp-server /usr/local/bin/odoo; fi

# Custom entrypoints
COPY resources/$ODOO_VERSION/entrypoint.d/ $RESOURCES/entrypoint.d/
