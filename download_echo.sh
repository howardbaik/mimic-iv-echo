#!/bin/bash
#SBATCH --job-name=mimic-echo-dl
#SBATCH --partition=scu-cpu
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --output=logs/%x-%j.out

set -euo pipefail

if [[ -z "${PHYSIONET_TOKEN:-}" ]]; then
  echo "PHYSIONET_TOKEN not set" >&2
  exit 1
fi

physionet download mimic-iv-echo --version 1.0.1 \
  --output /path/to/lab/storage/mimic-iv-echo