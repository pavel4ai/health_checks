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

# Start continuous disk performance monitoring
echo "💾 Running Continuous Disk Performance Benchmark..."
while true; do
    fio --name=rand_read --ioengine=libaio --iodepth=4 --rw=randread --bs=128k --numjobs=1 --size=1G --runtime=60 --time_based --filename=/workspace/testfile --group_reporting > /workspace/fio_output.log
    sleep 5  # Run `fio` every 5 seconds
done &

# Create directory for renamed videos
mkdir -p /workspace/generated_videos

# Rename and move generated videos continuously
echo "♻️ Monitoring new videos and renaming them..."
while true; do
    count=1
    for file in /workspace/Wan2.1/t2v_*.mp4; do
        if [[ -f "$file" ]]; then
            new_name="/workspace/generated_videos/test${count}.mp4"
            mv "$file" "$new_name"
            echo "Renamed: $file → $new_name"
            ((count++))
            if ((count > 10)); then break; fi
        fi
    done
    sleep 5  # Check every 5 seconds
done &

# Generate the video serving web page
/workspace/video_serving.sh

echo "✅ WAN Video Test Environment is now running!"
echo "👉 Visit http://localhost:7860 to generate videos"
echo "👉 Visit http://localhost:9090 for system performance dashboard"
echo "👉 Visit http://localhost:8081/videos/ to stream generated videos"
echo "👉 Run iperf3 -c <SERVER_IP> -p 5201 -R -P 4 to test network performance"
