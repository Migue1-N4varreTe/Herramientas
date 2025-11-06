import subprocess, threading, os
def run_cc_command(cmd, callback=None):
    script_path = os.path.expanduser("~/scripts/CC.sh")
    def target():
        process = subprocess.run([script_path, cmd], capture_output=True, text=True, shell=True)
        if callback:
            callback(process.stdout)
        else:
            print(process.stdout)
    threading.Thread(target=target).start()
