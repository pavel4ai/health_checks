from flask import Flask, jsonify
from prometheus_client import start_http_server, Gauge
import psutil
import subprocess
import re

app = Flask(__name__)

# Metrics
gpu_usage = Gauge("gpu_utilization", "Current GPU Utilization (%)")
cpu_usage = Gauge("cpu_utilization", "Current CPU Utilization (%)")
mem_usage = Gauge("memory_usage", "Current Memory Usage (%)")
disk_read_bw = Gauge("disk_read_bw", "Disk Read Bandwidth (MB/s)")
disk_write_bw = Gauge("disk_write_bw", "Disk Write Bandwidth (MB/s)")

def collect_metrics():
    try:
        # Get GPU Utilization
        gpu_util = subprocess.check_output(["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"]).decode().strip()
        gpu_usage.set(float(gpu_util))

        # Get CPU Utilization
        cpu_util = psutil.cpu_percent(interval=1)
        cpu_usage.set(cpu_util)

        # Get Memory Usage
        mem_util = psutil.virtual_memory().percent
        mem_usage.set(mem_util)

        # Get Disk Performance from fio log
        with open("/workspace/fio_output.log", "r") as file:
            log_data = file.read()
            read_bw_match = re.search(r"READ: bw=([\d.]+)MiB/s", log_data)
            write_bw_match = re.search(r"WRITE: bw=([\d.]+)MiB/s", log_data)

            if read_bw_match:
                disk_read_bw.set(float(read_bw_match.group(1)))
            if write_bw_match:
                disk_write_bw.set(float(write_bw_match.group(1)))

    except Exception as e:
        print("Error collecting metrics:", str(e))

@app.route("/metrics")
def metrics():
    collect_metrics()
    return jsonify({
        "gpu_usage": gpu_usage._value.get(),
        "cpu_usage": cpu_usage._value.get(),
        "memory_usage": mem_usage._value.get(),
        "disk_read_bw": disk_read_bw._value.get(),
        "disk_write_bw": disk_write_bw._value.get()
    })

if __name__ == "__main__":
    start_http_server(9090)  # Prometheus endpoint
    app.run(host="0.0.0.0", port=9090)
