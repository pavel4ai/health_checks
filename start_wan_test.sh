#!/bin/bash

# Start Prometheus metrics server (Flask API)
python3 /workspace/metrics_api.py &

# Start Gradio video generation UI
python3 /workspace/Wan2.1/gradio/t2v_14B_singleGPU.py --ckpt_dir /workspace/Wan2.1/Wan2.1-T2V-14B &

# Start NGINX for video streaming
nginx -g "daemon off;"
