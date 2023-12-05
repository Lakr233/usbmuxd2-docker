FROM ubuntu:latest

WORKDIR /app

COPY setup.sh setup.sh
RUN apt update -y &&\
    ./setup.sh && \
    rm -rf /var/lib/apt/lists/*

COPY build.sh build.sh
RUN ./build.sh -c -p /app/

COPY main.sh /app/main.sh
CMD ["/app/main.sh"]
