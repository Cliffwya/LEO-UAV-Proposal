FROM ubuntu:22.04

ARG NS3_VERSION=3.40
ARG VLC_COMMIT=6e33f5a18365d6e3e0a9f894a9d225617ada982a
ARG UID=1000
ENV DEBIAN_FRONTEND=noninteractive \
    NS3_DIR=/opt/ns3

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential cmake ninja-build g++ python3 python3-pip git wget ca-certificates \
        bzip2 rsync pkg-config gdb valgrind \
    && rm -rf /var/lib/apt/lists/*

# ns-3 (pinned). Only the modules we need get built, so the image build stays reasonable.

WORKDIR ${NS3_DIR}
RUN ./ns3 configure -d optimized --disable-examples --disable-tests --enable-modules=core \
    && ./ns3 build


RUN useradd -m -u ${UID} dev && chown -R dev:dev ${NS3_DIR}
USER dev
WORKDIR /workspace