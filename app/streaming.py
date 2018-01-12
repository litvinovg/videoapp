import subprocess
import os
import time
import threading
from pathlib import Path
homeDir = os.path.expanduser("~")
def start(camera):
    if status(camera) == 2:
      scriptPath = homeDir + "/scripts/" + camera
      t_start = threading.Thread(target = startStreaming, args = (scriptPath,))
      if status(camera) == 2:
        t_start.start()
    else:
      pass 
def startStreaming(scriptPath):
    subprocess.call([scriptPath])
def stop(camera):
    pidFile = Path(homeDir + "/tmp/" + camera)
    if pidFile.is_file():
      with pidFile.open() as f:
        rawpid = f.readline()
        if rawpid == "":
          subprocess.call([ homeDir + "/scripts/system/stop.sh",camera])
          return
        pid = int(rawpid)
        pidFile.unlink()	
        subprocess.call([ homeDir + "/scripts/system/kill.sh",str(pid)])
    else:
      subprocess.call([ homeDir + "/scripts/system/stop.sh",camera])
def status(camera):
    pidFile = Path(homeDir + "/tmp/" + camera)
    if pidFile.is_file():
      with pidFile.open() as f: 
        rawpid = f.readline()
        if rawpid == "":
          return 1
        pid = int(rawpid)
        procFile = Path("/proc/" + str(pid))
        if procFile.is_dir():
          timediff = getTimeDiff("/proc/" + str(pid))
          if timediff < 30:
             return 3
          return 0
        else:
          return 1
    else:
      return 2
def getTimeDiff(procFile):
    stat = os.stat(procFile)
    mtime = stat.st_mtime
    now = time.time()
    timeDiff = now - mtime
    return timeDiff
