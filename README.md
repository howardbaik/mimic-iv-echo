# Download with SLURM

First, export Physionet token in login session and submit from that same shell.

```{bash}
read -rs PHYSIONET_TOKEN && export PHYSIONET_TOKEN   # paste the token, press Enter; nothing echoes
sbatch download_echo.sh
```

`read -rs` keeps the token out of your shell history.

Then, create bash script:

```{bash}
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
```

Create the `logs/` directory before submitting. SLURM won’t create it, and the job will fail without it.

## Each bash command

```{bash}
#!/bin/bash
#SBATCH --job-name=mimic-echo-dl
#SBATCH --partition=scu-cpu
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --output=logs/%x-%j.out
```

- `#!/bin/bash` tells the system to run the file with bash.
- `--job-name=mimic-echo-dl` is a label for the job (appears in `squeue`).
- `--partition=scu-cpu` is which queue (group of nodes) to run on. A download doesn't need a GPU, so CPU.
- `--time=24:00:00` is the maximum wall-clock time (hours:minutes:seconds).
- `--cpus-per-task=2` is the number of CPU cores reserved for the job. The download is limited by network speed, not CPU.
- `--mem=4G` is the memory reserved.
- `--output=logs/%x-%j.out` is where printed output goes: job name plus job ID. The `logs/` folder has to exist before the job is submitted.

<br>

```{bash}
set -euo pipefail
```

Turns on bash’s “strict mode.” 

Each flag:

- `e` exits as soon as any command fails (returns a non-zero exit code). Without it, if physionet download failed, the script would carry on to whatever came next and could still finish “successfully.”
- `u` treats an undefined variable as an error. A typo like `$PHYSIONET_TOKNE$` would otherwise quietly become an empty string. That’s also why the token check in the script is written `${PHYSIONET_TOKEN:-}`: the :- supplies an empty default, so the check itself doesn’t trip -u when the variable is unset.
- `o` pipefail makes a pipeline fail if any command in it fails. Normally a pipeline’s exit status comes only from its last command, so in `physionet download ... | tee log.txt` a failed download would be hidden because tee succeeded.

<br>

```{bash}
if [[ -z "${PHYSIONET_TOKEN:-}" ]]; then
  echo "PHYSIONET_TOKEN not set" >&2
  exit 1
fi
```

Safety check: if the token is missing, the job stops right away with a clear message, instead of starting the download and failing partway through with a confusing authentication error.

<br>

```{bash}
physionet download mimic-iv-echo --version 1.0.1 \
  --output /path/to/lab/storage/mimic-iv-echo
```

- `physionet download mimic-iv-echo --version 1.0.1` downloads the dataset and fixes the release to version 1.0.1.
- `--output /path/to/lab/storage/mimic-iv-echo` is the folder where the files go. `/path/to/lab/storage` is a placeholder: replace it with your lab’s real project directory,

