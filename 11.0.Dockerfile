FROM druidoo/odoo:11.0-base
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

# Custom entrypoints
COPY resources/$ODOO_VERSION/entrypoint.d/ $RESOURCES/entrypoint.d/
