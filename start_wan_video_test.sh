#!/bin/bash

echo "🚀 Starting WAN Video Test Environment"

# Start Prometheus Metrics Server
echo "📊 Starting Prometheus Metrics API on port 9090..."
python3 /workspace/wan_test_metrics_api.py &

# Start Gradio Video Generation UI
echo "🎥 Starting Gradio video generation UI on port 7860..."
python3 /workspace/Wan2.1/gradio/t2v_14B_singleGPU.py --ckpt_dir /workspace/Wan2.1/Wan2.1-T2V-14B &

# Start NGINX Video Streaming Server
echo "📡 Starting NGINX video streaming server on port 8081..."
nginx -g "daemon off;" &

# Start iperf3 server
echo "🌐 Starting iperf3 network performance test server on port 5201..."
iperf3 -s &

# Run disk performance test using fio
echo "💾 Running Disk Performance Benchmark..."
fio --name=rand_read --ioengine=libaio --iodepth=4 --rw=randread --bs=128k --numjobs=1 --size=1G --runtime=60 --time_based --filename=/workspace/testfile --group_reporting

echo "✅ WAN Video Test Environment is now running!"
echo "👉 Visit http://localhost:7860 to generate videos"
echo "👉 Visit http://localhost:9090 for system performance dashboard"
echo "👉 Visit http://localhost:8081/videos/ to stream generated videos"
echo "👉 Run iperf3 -c <SERVER_IP> -p 5201 -R -P 4 to test network performance"
