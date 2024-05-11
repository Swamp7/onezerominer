FROM nvidia/cuda:12.1.0-runtime-ubuntu18.04

RUN rm /etc/apt/sources.list.d/cuda.list

RUN apt update \
    && apt -y install wget \
    && wget https://github.com/OneZeroMiner/onezerominer/releases/download/v1.3.3/onezerominer-linux-1.3.3.tar.gz \
    && tar xvzf onezerominer-linux-1.3.3.tar.gz \
    && rm onezerominer-linux-1.3.3.tar.gz

WORKDIR /onezerominer-linux

ENTRYPOINT ["./onezerominer"]
