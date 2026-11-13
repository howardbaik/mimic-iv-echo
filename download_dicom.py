"""Download one DICOM file from MIMIC-IV-ECHO v1.0.1 into ./data/."""

import getpass
import shutil
from pathlib import Path

import physionet

SLUG = "mimic-iv-echo"
VERSION = "1.0.1"
FILE = "files/p10/p10690270/s95240362/95240362_0004.dcm"


username = input("PhysioNet username: ")
password = getpass.getpass("PhysioNet password: ")

cached = physionet.fetch(
    SLUG, FILE, version=VERSION, username=username, password=password
)

out_dir = Path("data")
out_dir.mkdir(exist_ok=True)

dest = out_dir / Path(FILE).name
shutil.copy2(cached, dest)
print(f"Cached at: {cached}")
print(f"Copied to: {dest}")
