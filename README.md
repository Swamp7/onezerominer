# onezerominer

Dockerized [OneZeroMiner](https://github.com/OneZeroMiner/onezerominer)
multi-algo NVIDIA GPU miner on a **CUDA 13.0.3 runtime base** (Ubuntu 24.04).

Image: [`swamp7/onezerominer`](https://hub.docker.com/r/swamp7/onezerominer)

## Tags

| Tag | OneZeroMiner version | Notes |
|---|---|---|
| `swamp7/onezerominer:latest` | 1.8.1 | rolls forward with each release |
| `swamp7/onezerominer:1.8.1` | 1.8.1 | Quantus perf +3%; NVIDIA driver 615+ compatibility fix; WSL2 init fix; NVML load fix; HiveOS stat + `-d` fix |

## Supported algorithms

OneZeroMiner is multi-algorithm. From `--help` in 1.8.1:

| Algo flag (`-a`) | Coin / notes |
|---|---|
| `dynex` | Dynex |
| `xelishashv3` | Xelis |
| `cryptix_ox8` | Cryptix |
| `qhash` | QubitCoin |
| `quantus` | Quantus Network |
| `zilliqa` | Zilliqa (second-algo dual-mining via `--a2`/`--o2`/`--w2`) |

Bundled example scripts live inside the image at `/onezerominer/` —
`pearl.sh`, `quantus.sh`, `xelis.sh`, `qubitcoin.sh`, `cryptix.sh`,
`dynex.sh`, `zil.sh`, plus `xelis_qubitcoin.sh` / `xelis_zil.sh` /
`dynex_zil.sh` for dual-mining combos. They use upstream's current
`-a` names and are the authoritative reference.

## Usage

```bash
docker run --gpus all swamp7/onezerominer:1.8.1 \
    -a pearl \
    -w prl1pYOUR_PRL_ADDRESS \
    -o stratum+tcp://prl.suprnova.cc:3373
```

Pass `-h` for the full flag list, `-d 0,1` to pin to specific GPU indices,
and `-l /log/ozm.log` with a mounted volume if you want a host-side log.

The bundled `*.sh` scripts inside the image (`pearl.sh`, `quantus.sh`, etc.)
show working `-a`/`-o` combinations for each supported coin.

## Base image

`nvidia/cuda:13.0.3-runtime-ubuntu24.04` — matches the latest driver branch
on the fleet (580+) and keeps the image small (no `-devel` tool chain).
Requires **NVIDIA driver ≥ 580** on the host.

The miner binary is a statically-linked ELF; no extra runtime libraries are
installed beyond `wget` + `ca-certificates` used only during the build (both
purged before the final layer).
