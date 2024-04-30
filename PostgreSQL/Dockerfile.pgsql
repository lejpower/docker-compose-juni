FROM postgres:12.11

ENV POSTGRES_PASSWORD postgres

RUN apt-get update && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*
