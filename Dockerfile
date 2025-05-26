FROM debian:bookworm-slim

ARG TZ="Etc/UTC"
ARG LANG="en_US.UTF-8"
ARG ADD_DEB_PACKAGES="\
    libsqlite3-mod-spatialite \
    libgdal-dev \    
    python3-dask \
    python3-elasticsearch \
    python3-fiona \
    python3-gdal \
    python3-jsonpatch \
    python3-netcdf4 \
    python3-pandas \
    python3-psycopg2 \
    python3-pymongo \
    python3-pyproj \
    python3-rasterio \
    python3-scipy \
    python3-shapely \
    python3-tinydb \
    python3-xarray \
    python3-zarr \
    python3-mapscript \
    python3-pytest \
    python3-pyld"

ENV TZ=${TZ} \
    LANG=${LANG} \
    DEBIAN_FRONTEND="noninteractive" \
    DEB_BUILD_DEPS="\
    curl \
    git \
    unzip" \
    DEB_PACKAGES="\
    locales \
    tzdata \
    gunicorn \
    python3-dateutil \
    python3-gevent \
    python3-greenlet \
    python3-pip \
    python3-tz \
    python3-yaml \
    ${ADD_DEB_PACKAGES}"

WORKDIR /pygeoapi
COPY . /pygeoapi

RUN apt update -y \
    && apt upgrade -y \
    && apt --no-install-recommends install -y ${DEB_PACKAGES} ${DEB_BUILD_DEPS} \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && echo "For ${TZ} date=$(date)" && echo "Locale=$(locale)"  \
    && mkdir /schemas.opengis.net \
    && curl -O http://schemas.opengis.net/SCHEMAS_OPENGIS_NET.zip \
    && unzip ./SCHEMAS_OPENGIS_NET.zip "ogcapi/*" -d /schemas.opengis.net \
    && rm -f ./SCHEMAS_OPENGIS_NET.zip \
    && pip3 install --break-system-packages -r requirements-docker.txt \
    && pip3 install --break-system-packages -r requirements-admin.txt \    
    && pip3 install --break-system-packages -e . \
    && pip3 install --break-system-packages git+https://github.com/kartverket/DOK.Arealanalyse.Process@main \
    && cp /pygeoapi/docker/default.config.yml /pygeoapi/local.config.yml \
    && cp /pygeoapi/docker/entrypoint.sh /entrypoint.sh  \
    && chmod +x /entrypoint.sh \
    && apt remove --purge -y gcc ${DEB_BUILD_DEPS} \
    && apt clean \
    && apt autoremove -y  \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

