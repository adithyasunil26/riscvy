import os
import glob
import subprocess

f=glob.glob("*/*.core")

passed_cores = []
failed_cores = []

for i in f:
  core_name = i.split("/")[-1].split(".")[0]
  k = os.system("fusesoc --cores-root . run --target=lint " + core_name)
  if k==0:
    passed_cores.append(core_name)
  else:
    failed_cores.append(core_name)
  
print("Passed Cores: ", passed_cores)
print("Failed Cores: ", failed_cores)

if len(failed_cores) > 0:
  exit(1)