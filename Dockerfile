FROM nvidia/cuda:13.0.3-runtime-ubuntu24.04

ARG OZM_VERSION=1.8.2
ARG TARBALL_URL=https://github.com/OneZeroMiner/onezerominer/releases/download/v${OZM_VERSION}/onezerominer-linux-${OZM_VERSION}.tar.gz

RUN rm -f /etc/apt/sources.list.d/cuda.list

# OneZeroMiner is a static ELF — no runtime deps beyond the NVIDIA driver libs
# the container runtime mounts (libcuda / libnvidia-ml). Keep the layer tiny.
RUN apt-get update \
    && apt-get -y install --no-install-recommends wget ca-certificates \
    && wget -O /tmp/ozm.tar.gz "$TARBALL_URL" \
    && tar -xzf /tmp/ozm.tar.gz -C / \
    && mv /onezerominer-linux /onezerominer \
    && rm /tmp/ozm.tar.gz \
    && chmod +x /onezerominer/onezerominer \
    && apt-get -y purge wget \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /onezerominer

ENTRYPOINT ["./onezerominer"]
