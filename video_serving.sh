#!/bin/bash

echo "🌐 Creating video streaming page..."

cat <<EOF > /workspace/generated_videos/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Live Video Streaming</title>
    <style>
        body { text-align: center; font-family: Arial, sans-serif; }
        video { width: 80%; max-width: 720px; }
    </style>
</head>
<body>
    <h1>Live Video Streaming</h1>
    <video id="videoPlayer" controls autoplay loop>
        <source src="test1.mp4" type="video/mp4">
        Your browser does not support HTML5 video.
    </video>
    <script>
        let videoIndex = 1;
        const maxVideos = 10;
        const videoElement = document.getElementById("videoPlayer");

        videoElement.onended = function () {
            videoIndex = (videoIndex % maxVideos) + 1;
            videoElement.src = "test" + videoIndex + ".mp4";
            videoElement.play();
        };
    </script>
</body>
</html>
EOF

echo "✅ Video streaming page is ready! Access it at http://localhost:8081/videos/"
