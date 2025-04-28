FROM docker.io/bitnami/valkey-cluster:8.0.2

USER root

RUN install_packages git build-essential cmake

WORKDIR /tmp
RUN git clone https://github.com/valkey-io/valkey-json.git && \
    cd valkey-json && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make

RUN mkdir -p /opt/bitnami/valkey/modules && \
    cp /tmp/valkey-json/build/src/libjson.so /opt/bitnami/valkey/modules/ && \
    chmod 755 /opt/bitnami/valkey/modules/libjson.so

RUN apt-get purge -y --auto-remove git build-essential cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/valkey-json

WORKDIR /

USER 1001

CMD ["/opt/bitnami/scripts/valkey-cluster/run.sh", "--loadmodule", "/opt/bitnami/valkey/modules/libjson.so"]

# build command - docker build -f valkey.Dockerfile -t arjun1601/valkey:8.0.2 .