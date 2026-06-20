# Surgical Guardian v4

**Real-time laparoscopic surgical safety monitoring system using AI**

Surgical Guardian v4 is a computer vision system that monitors laparoscopic surgery in real-time, detecting surgical tools, organs, and blood vessels, then alerting surgeons when instruments approach critical structures like the cystic artery and duct.

---

## Overview

This system uses a fine-tuned YOLOv8 model to detect and track:
- **7 surgical tools**: bipolar, clipper, grasper, hook, irrigator, scissors, specimen bag
- **7 organ types**: liver, gallbladder, abdominal wall, fat, GI tract, connective tissue, liver ligament
- **2 critical vessels**: Cystic Artery, Cystic Duct

When a tool approaches too close to a vessel, the system triggers audio and visual alerts at three severity levels: CAUTION, WARNING, and CRITICAL.

---

## Features

- **Real-time detection** using YOLOv8 computer vision
- **Proximity alerting** with tiered audio warnings (600Hz/800Hz/1100Hz beeps)
- **Motion analysis** with tool velocity tracking and approach direction
- **Temporal smoothing** to prevent bbox flickering
- **HUD overlay** showing FPS, tool counts, alert statistics
- **Session recording** with annotated video output
- **CSV logging** of all proximity events
- **Session reports** with safety assessment scores

---

## Quick Start

### Prerequisites

- Python 3.8+
- Webcam, IP camera (DroidCam), or video file
- (Optional) GPU with CUDA for faster inference

### Installation

```bash
pip install -r requirements.txt
```

### Running

```bash
# Live DroidCam camera
python surgical_guardian_v4.py

# Video file
python surgical_guardian_v4.py --source path/to/video.mp4

# Webcam
python surgical_guardian_v4.py --source 0

# Custom model and confidence
python surgical_guardian_v4.py --model best.pt --conf 0.25
```

---

## Docker Deployment

### Build Image

```bash
docker build -t surgical-guardian .
```

### Run Container

```bash
docker run --gpus all \
  -e SOURCE=http://YOUR_DROIDCAM_IP:4747/video \
  -v $(pwd)/sg_output:/app/sg_output \
  surgical-guardian
```

### Docker Compose

```bash
SOURCE=http://YOUR_IP:4747/video docker compose up
```

---

## Keyboard Controls

| Key | Action |
|-----|--------|
| `Q` / `ESC` | Quit and save report |
| `P` | Pause / Resume |
| `S` | Save screenshot |
| `R` | Reset session stats |
| `+` / `-` | Adjust confidence threshold |

---

## Project Structure

```
├── surgical_guardian_v4.py   # Main application
├── best/                     # YOLOv8 model weights
├── Dockerfile               # Container definition
├── docker-compose.yml       # Docker Compose config
├── requirements.txt         # Python dependencies
└── .github/workflows/       # CI/CD pipeline
```

---

## Output Files

Running the application creates a `sg_output/` directory containing:

- `session_YYYYMMDD_HHMMSS.mp4` — Annotated video recording
- `alert_log_YYYYMMDD_HHMMSS.csv` — CSV log of all proximity alerts
- `session_report_YYYYMMDD_HHMMSS.txt` — Post-session safety report
- `screenshot_HHMMSS.jpg` — Manual screenshots

---

## Technical Details

- **Model**: YOLOv8 (fine-tuned on laparoscopic surgery dataset)
- **Framework**: Ultralytics, OpenCV, PyTorch
- **Display**: Xvfb (virtual display) for headless Docker deployment
- **Audio**: winsound (Windows) / system beep (Linux/macOS)

---

## License

MIT License

---

## Authors

Surgical Guardian v4 — Safety-First Edition
