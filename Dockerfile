FROM geopython/pygeoapi:0.22.0

ARG DEB_PACKAGES="\
    git \
    gdal-bin \
    libgdal-dev"

ARG PYTHON_PACKAGES="\
    starlette \
    uvicorn \
    git+https://github.com/kartverket/DOK.Arealanalyse.Process.git@main"

COPY pygeoapi-config.yml /pygeoapi/pygeoapi-config.yml
COPY entrypoint.sh /dokanalyse-entrypoint.sh

RUN apt update -y \
    && apt --no-install-recommends install -y ${DEB_PACKAGES} \
    && /venv/bin/python3 -m pip install --no-cache-dir gdal==$(gdal-config --version) ${PYTHON_PACKAGES} \
    && chmod +x /dokanalyse-entrypoint.sh

ENTRYPOINT [ "/dokanalyse-entrypoint.sh" ]
