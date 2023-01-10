ARG IMAGE=intersystemsdc/iris-community:preview

FROM ${IMAGE}

USER root

WORKDIR /opt/irisbuild

RUN mkdir /opt/irisbuild/data/ && \
  chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild && \
  chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild/data && \
  pip3 install --upgrade pip && \
  pip3 install pandas pyarrow fastparquet requests

USER ${ISC_PACKAGE_MGRUSER}

COPY iris.script iris.script
COPY src/python/download-trips-to-csv.py download.py

# uncomment more lines to load more data
RUN python3 download.py 2020 1
# RUN python3 download.py 2020 2
# RUN python3 download.py 2020 3

RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly 