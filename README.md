# onezerominer

Dockerized [OneZeroMiner](https://github.com/OneZeroMiner/onezerominer)
multi-algo NVIDIA GPU miner on a **CUDA 13.0.3 runtime base** (Ubuntu 24.04).

Image: [`swamp7/onezerominer`](https://hub.docker.com/r/swamp7/onezerominer)

## Tags

| Tag | OneZeroMiner version | Notes |
|---|---|---|
| `swamp7/onezerominer:latest` | 1.8.6 | rolls forward with each release |
| `swamp7/onezerominer:1.8.6` | 1.8.6 | pearlhash efficiency on RTX 3000/4000/5000; Turing + CMP 40/50HX perf (lock mem 810/405); CMP100-210 bump; **NEW: Zstd proof compression** (bandwidth/latency on pools that support it); **NEW: `--power-save <1-3>`** experimental power-saving on top of OC (works best with locked core clock; recommended for 5070Ti/5080/5090, RTX 2000, CMP non-HBM — lower-end 5000-series needs driver 610.43.03); new `--vcore-offset` + `--vcore-target` OC flags |
| `swamp7/onezerominer:1.8.5` | 1.8.5 | **Experimental CMP 30/40/50/70/90 HX mem locking** (5000/810/405 MHz) — +20–50% efficiency on core algos (needs driver 610.43.03); experimental mem-405 lock for RTX 2000/3000/4000/5000 (supported drivers: 595 + 610; NOT 580); V100 + CMP100-210 pearlhash bumps; new `--mclk` built-in OC; **opt-in pearlhash telemetry** sends active GPU names to pool on auth — opt out with `--disable-pearlhash-telemetry`; new `--stats-interval` |
| `swamp7/onezerominer:1.8.6` | 1.8.4 | pearlhash efficiency +2% on RTX 3000/4000/5000; minor Turing (RTX 2000 + CMP 50HX) kernel-1/-2 bumps; `--core-delay` option (apply core clocks + offset after N-second delay from startup — useful for staggering OC on cold rigs) |
| `swamp7/onezerominer:1.8.3` | 1.8.3 | pearlhash perf bump on RTX 2000/3000/4000/5000 locked-mem-810 kernel; **FIX: H100 invalid-proof-size bug from 1.8.2**; fix for rejected shares when GPU is shared with another process; quantus +2–4% (~10% on A100/H100); Parano1d perf bump |
| `swamp7/onezerominer:1.8.6` | 1.8.2 | Parano1d (poseidon2b) algo on all NVIDIA GPUs — 1% dev fee; pearlhash efficiency +4–6% on Ampere/Ada/Blackwell; +~4% on Hopper + Blackwell datacenter; Volta (V100 / CMP100-210) pearlhash support; Turing 2000 series mem-810 kernel via `--kernel 2`. **⚠️ H100 produces invalid proofs — use 1.8.3+ on H100.** |
| `swamp7/onezerominer:1.8.6` | 1.8.1 | Quantus perf +3%; NVIDIA driver 615+ compatibility fix; WSL2 init fix; NVML load fix; HiveOS stat + `-d` fix |

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
docker run --gpus all swamp7/onezerominer:1.8.6 \
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
