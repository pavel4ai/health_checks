# health_checks

 How to Use Pavel's Health Check Stress Tests

1. Start the container
''docker run --gpus all -it --name wan2.1-t2v-14b -v wan2.1-t2v-14b:/workspace -p 7860:7860 -p 9090:9090 -p 8081:8081 -p 5201:5201 wan2.1-t2v-14b-stress-test

2. Download model weigts 
''huggingface-cli download Wan-AI/Wan2.1-T2V-14B --local-dir /workspace/Wan2.1/Wan2.1-T2V-14B

3. Run the Gradio Video Generation UI
Visit: http://localhost:7860
Generate up to 10 videos manually.

4. View GPU & System Metrics while videos are generating 
Visit: http://localhost:9090

5. Stream Generated Videos
Visit: http://localhost:8081/videos/
Watch videos looping in sequence.

6. Test Network Performance (with iperf3) while videos are playing 
Start iperf3 Server
Inside the container:
/workspace/start_iperf3.sh

7. Run iperf3 Test from a Remote Machine
On another machine:

iperf3 -c <SERVER_IP OR DNS> -p 5201 -R -P 4
-c <SERVER_IP> → Connect to the server.
-p 5201 → Use port 5201.
-R → Reverse test (upload speed).
-P 4 → 4 parallel streams (to stress the link).
