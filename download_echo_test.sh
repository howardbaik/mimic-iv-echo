#!/bin/bash
#SBATCH --job-name=mimic-echo-p10
#SBATCH --partition=preempt_cpu
#SBATCH --qos=low
#SBATCH --time=08:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --output=logs/%x-%j.out

set -euo pipefail

if [[ -z "${PHYSIONET_TOKEN:-}" ]]; then
  echo "PHYSIONET_TOKEN not set" >&2
  exit 1
fi

/home/hob4005/.local/bin/physionet download mimic-iv-echo --version 1.0.1 \
  --include "files/p10/*" \
  --output /athena/holstelab/scratch/hob4005
