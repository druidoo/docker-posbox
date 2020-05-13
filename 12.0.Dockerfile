FROM druidoo/odoo:12.0-base

# Install odoo with sparse-checkout (only hw_* addons)
RUN git clone --no-local --no-checkout --depth 1 --branch $ODOO_VERSION https://github.com/$ODOO_SOURCE $SOURCES/odoo && \
	cd $SOURCES/odoo && \
	git config core.sparsecheckout true && \
	printf "/*\n!/addons/*\naddons/web\naddons/hw_*\n" | tee --append .git/info/sparse-checkout > /dev/null && \
	git read-tree -mu HEAD

RUN pip install --user --no-cache-dir $SOURCES/odoo

# Install other iotbox requirements
USER root
RUN apt-get update

RUN apt-get install -yqq --no-install-recommends \
		virtualenv \
		build-essential \
		libdbus-glib-1-dev \
		libgirepository1.0-dev \
		libcairo2-dev \
		cups \
		printer-driver-all \
		cups-ipp-utils \
		libcups2-dev \
		iw \
		openbox \
		libpq-dev \
		python-cups \
		python3-gi \
		python3-pyscard \
		python3-urllib3 \
		python3-dateutil \
		python3-decorator \
		python3-docutils \
		python3-feedparser \
		python3-pil \
		python3-jinja2 \
		python3-lxml \
		python3-mako \
		python3-mock \
		python3-openid \
		python3-psutil \
		python3-psycopg2 \
		python3-babel \
		python3-pydot \
		python3-pyparsing \
		python3-pypdf2 \
		python3-reportlab \
		python3-requests \
		python3-simplejson \
		python3-tz \
		python3-vatnumber \
		python3-werkzeug \
		python3-serial \
		python3-pip \
		python3-dev \
		python3-dbus \
		python3-netifaces \
		python3-passlib \
		python3-libsass \
		python3-qrcode \
		python3-html2text \
		python3-unittest2 \
		python3-simplejson

RUN echo "asd" \
	&& rm -Rf /var/lib/apt/lists/* /tmp/* \
	&& apt-get clean

USER odoo
RUN pip install --user --no-cache-dir \
		dbus-python \
		netifaces \
		gatt \
		pyusb==1.0.0b1 \
		evdev \
		gatt \
		v4l2 \
		polib \
		pycups \
		gobject \
		PyGObject

# TODO Check
# https://github.com/odoo/odoo/tree/054d4bc6bc219bcc6b0a64265e8d7e9c7423dbc8/addons/point_of_sale/tools/posbox/overwrite_after_init/usr/local/lib/python3.7/dist-packages

# Apply patches:
# - https://github.com/odoo/odoo/blob/12.0/addons/point_of_sale/tools/posbox/overwrite_after_init/usr/local/lib/python3.7/dist-packages/v4l2.py.iotpatch

# - maybe also https://github.com/odoo/odoo/blob/12.0/addons/point_of_sale/tools/posbox/overwrite_after_init/home/pi/odoo/odoo/http.py.iotpatch
# ~/.local/lib/python3.5/site-packages/odoo/http.py

COPY iotpatch/ $RESOURCES/iotpatch
RUN $RESOURCES/iotpatch/apply_iotpatch.sh

# Custom entrypoints
COPY entrypoint.d/ $RESOURCES/entrypoint.d/
