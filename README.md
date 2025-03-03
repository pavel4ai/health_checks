# GPU Server Health Checks & GPU Stress Testing Suite using AI Video generation
Pavel's AI & System Performance Benchmarking Toolkit

This suite designed to evaluate:

- GPU performance & scaling efficiency using AI-driven video generation.
- System resource utilization (GPU, CPU, Memory, Disk I/O).
- Network performance (Bandwidth, Latency, Jitter) via iperf3.
- Storage performance (Read/Write Speed) via fio.
- Real-time monitoring and visualization using Prometheus & Grafana.
- Seamless video streaming of AI-generated content via NGINX & FFmpeg.

🚀 Built for testing cloud GPUs (H100, H200, B200) & local hardware. 
🖥️ Supports single-GPU benchmarking with AI-generated video. Multi GPU support coming soon.
🔍 Provides real-time system telemetry & stress testing tools.

## Quick Start Guide

1️⃣ Start the Container
Run the container with full GPU access and required ports mapped:
```sh 
docker run --gpus all -it --name wan2.1-t2v-14b -v wan2.1-t2v-14b:/workspace -p 7860:7860 -p 9090:9090 -p 8081:8081 -p 5201:5201 wan2.1-t2v-14b-stress-test
```

2️⃣ Download Model Weights
Inside the container, manually download the Wan2.1-T2V-14B model weights:
```sh
huggingface-cli download Wan-AI/Wan2.1-T2V-14B --local-dir /workspace/Wan2.1/Wan2.1-T2V-14B
```

3️⃣ Start Stress Test & Monitoring
Inside the container, run the main test suite:
```sh
/workspace/start_wan_video_test.sh
```

### Features & Testing Modules   
🎥 AI Video Generation (Gradio)  
Start Video Generation UI:  
📌 Visit http://localhost:7860  
📌 Manually generate up to 10 videos for performance testing.  

📊 System Performance Dashboard (Prometheus & Grafana)  
Monitor System Metrics in Real Time:  
📌 Visit http://localhost:9090  
📌 Metrics Captured:  

##### GPU Utilization (%)  
##### VRAM Consumption (GB)  
##### CPU Usage (%)  
##### Memory Usage (%)  
##### Disk Read/Write Speed (via fio)  
##### Network I/O (via iperf3)  

📡 Streaming AI-Generated Videos  
📌 Visit http://localhost:8081/videos/  
📌 Videos stream in a continuous loop via FFmpeg & NGINX.  

🌐 Network Performance Testing (iperf3)  
➡️ Start iperf3 Server  
Inside the container:
```sh
/workspace/start_iperf3.sh
```
➡️ Run iperf3 Test from a Remote Machine (assumes iperf3 is installed)
On another machine, run:
```sh
iperf3 -c <SERVER_IP> -p 5201 -R -P 4
```
📌 Breakdown of Parameters:

-c <SERVER_IP> → Connect to the stress test container.
-p 5201 → Use port 5201 for network testing.
-R → Reverse test (Upload speed measurement).
-P 4 → 4 parallel streams (to stress network bandwidth).

💾 Disk Performance Benchmarking (fio)
Storage Read/Write Speed Test (Runs automatically as part of stress test).
📌 Uses fio to measure disk read/write speeds & I/O latency.
📌 Logs results into Prometheus for historical tracking.

🛠️ Troubleshooting
1️⃣ Missing Model Weights?
Ensure you've downloaded the model weights inside the container:
```sh
huggingface-cli download Wan-AI/Wan2.1-T2V-14B --local-dir /workspace/Wan2.1/Wan2.1-T2V-14B
```

2️⃣ GPU Not Detected?
Check if NVIDIA drivers are installed and Docker has GPU access:
```sh
nvidia-smi
```
If nvidia-smi doesn’t work inside the container, restart it with GPU support.

3️⃣ Ports Not Working?
Ensure you started the test manually:
```sh
/workspace/start_wan_video_test.sh
```
