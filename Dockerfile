ARG IMAGE=containers.intersystems.com/intersystems/iris-community:latest-cd
FROM $IMAGE

ARG COMMIT_ID="ifindsudachi"

USER root   
        
ENV ISC_TEMP_DIR=/intersystems/iris/samples

RUN apt-get update 
RUN apt-get install -y curl
ENV PATH=$PATH:/root/.cargo/bin
RUN curl https://sh.rustup.rs -sSf > /rust.sh
RUN sh /rust.sh -y
RUN python3 -m pip install --target /usr/irissys/mgr/python sudachipy
RUN python3 -m pip install --target /usr/irissys/mgr/python sudachidict_core

USER ${ISC_PACKAGE_MGRUSER}

COPY src/Samples/ $ISC_TEMP_DIR/
COPY iris.script /tmp/iris.script

USER root

RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /intersystems/iris/samples

USER ${ISC_PACKAGE_MGRUSER}

RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly
