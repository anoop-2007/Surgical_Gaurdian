# ============================================================
# Surgical Guardian v4 — Docker Image (Local Deployment)
# ============================================================
# Base: ultralytics image includes torch + torchvision + CUDA
# ============================================================

FROM ultralytics/ultralytics:latest

# Prevent ultralytics auto-update prompts
ENV ULTRALYTICS_API_KEY=0
ENV YOLO_VERBOSE=0

# Install system dependencies including Xvfb for virtual display
# and sox for audio alerts on Linux
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11-utils \
    sox \
    libsox-fmt-all \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Install Python dependencies first (layer cache optimization)
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy only application code (model weights are mounted at runtime)
COPY surgical_guardian_v4.py /app/

# Create output directory
RUN mkdir -p /app/sg_output

# Environment variables
ENV DISPLAY=:99
ENV PYTHONUNBUFFERED=1

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD python -c "import cv2; import ultralytics; print('OK')" || exit 1

# Run with Xvfb virtual display for cv2.imshow() compatibility
# Model weights (best.pt) must be mounted via volume or placed in /app/
CMD bash -c "Xvfb :99 -screen 0 1280x720x24 -ac +extension GLX +render -noreset & \
    sleep 2 && \
    python surgical_guardian_v4.py \
    --source \"${SOURCE:-http://100.91.39.55:4747/video}\" \
    --model \"${MODEL:-/app/best/best.pt}\" \
    --conf \"${CONF:-0.30}\" \
    ${NO_RECORD:+--no-record} \
    ${NO_LOG:+--no-log}"
