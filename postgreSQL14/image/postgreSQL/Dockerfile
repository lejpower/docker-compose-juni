FROM postgres:14

RUN apt-get update && \
    apt-get clean && \
    apt-get install -y default-mysql-client vim procps net-tools sysstat && \
    rm -fr /var/lib/apt/lists/*