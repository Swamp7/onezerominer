FROM nvidia/cuda:8.0-devel-ubuntu16.04

RUN rm /etc/apt/sources.list.d/cuda.list

RUN apt update \
    && apt -y install wget \
    && wget https://github.com/OneZeroMiner/onezerominer/releases/download/v1.2.5/onezerominer-linux-1.2.5.tar.gz \
    && tar xvzf onezerominer-linux-1.2.5.tar.gz \
    && rm onezerominer-linux-1.2.5.tar.gz

WORKDIR /onezerominer-linux

ENTRYPOINT ["./onezerominer"]
