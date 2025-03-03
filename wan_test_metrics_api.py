from flask import Flask, jsonify
from prometheus_client import start_http_server, Gauge
import psutil
import subprocess

app = Flask(__name__)

# Metrics
gpu_usage = Gauge("gpu_utilization", "Current GPU Utilization (%)")
cpu_usage = Gauge("cpu_utilization", "Current CPU Utilization (%)")
mem_usage = Gauge("memory_usage", "Current Memory Usage (%)")

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

    except Exception as e:
        print("Error collecting metrics:", str(e))

@app.route("/metrics")
def metrics():
    collect_metrics()
    return jsonify({
        "gpu_usage": gpu_usage._value.get(),
        "cpu_usage": cpu_usage._value.get(),
        "memory_usage": mem_usage._value.get()
    })

if __name__ == "__main__":
    start_http_server(9090)  # Prometheus endpoint
    app.run(host="0.0.0.0", port=9090)
