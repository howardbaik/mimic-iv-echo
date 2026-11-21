#!/bin/bash
#SBATCH --job-name=mimic-echo-test
#SBATCH --partition=preempt_cpu
#SBATCH --qos=low
#SBATCH --time=00:15:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --output=logs/%x-%j.out

set -euo pipefail

if [[ -z "${PHYSIONET_TOKEN:-}" ]]; then
  echo "PHYSIONET_TOKEN not set" >&2
  exit 1
fi

physionet download mimic-iv-echo --version 1.0.1 \
  --include "files/p10/p10690270/s95240362/95240362_0004.dcm" \
  --output /athena/holstelab/scratch/hob4005/mimic-iv-echo 
