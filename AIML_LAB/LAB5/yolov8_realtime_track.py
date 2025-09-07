#!/usr/bin/env python3
"""
Real-time Object Detection + Tracking with YOLOv8 (Ultralytics) and OpenCV

Features:
- Loads a pre-trained YOLOv8 model (default: yolov8n.pt).
- Opens your default webcam and processes frames in real time.
- Runs tracking (ByteTrack) to assign persistent IDs to objects across frames.
- Draws bounding boxes, class labels, confidences, and unique track IDs.
- Press 'q' or ESC to quit.

Dependencies:
    pip install ultralytics opencv-python

Usage:
    python yolov8_realtime_track.py               # uses default webcam (0) and yolov8n.pt
    python yolov8_realtime_track.py --source 1    # use a different webcam index
    python yolov8_realtime_track.py --model yolov8s.pt
    python yolov8_realtime_track.py --conf 0.5

Notes:
- Tracking backend used here is ByteTrack (fast and accurate for real-time).
- If you specifically want SORT, you'd need to integrate a SORT implementation yourself.
"""
import ultralyitcs
import argparse
import sys
from typing import Optional

import cv2
import numpy as np

# Ultralytics (YOLOv8)
try:
    from ultralytics import YOLO
except Exception as e:
    print("Ultralytics not installed. Install with: pip install ultralytics", file=sys.stderr)
    raise

def parse_args():
    p = argparse.ArgumentParser(description="YOLOv8 real-time detection + tracking")
    p.add_argument("--source", type=str, default="0", help="Webcam index or video path (default: 0)")
    p.add_argument("--model", type=str, default="yolov8n.pt", help="YOLOv8 model path or name")
    p.add_argument("--conf", type=float, default=0.35, help="Confidence threshold")
    p.add_argument("--iou", type=float, default=0.5, help="IoU threshold for NMS")
    p.add_argument("--imgsz", type=int, default=640, help="Inference image size")
    p.add_argument("--tracker", type=str, default="bytetrack.yaml", help="Ultralytics tracker config (e.g., bytetrack.yaml, botsort.yaml)")
    p.add_argument("--show_fps", action="store_true", help="Overlay FPS counter")
    return p.parse_args()

def draw_boxes(
    frame: np.ndarray,
    boxes_xyxy: np.ndarray,
    classes: np.ndarray,
    confs: np.ndarray,
    track_ids: Optional[np.ndarray],
    class_names: dict
) -> np.ndarray:
    """Draw bounding boxes, labels, confidences, and track IDs on the frame."""
    h, w = frame.shape[:2]

    for i, (x1, y1, x2, y2) in enumerate(boxes_xyxy):
        cls_id = int(classes[i]) if classes is not None else -1
        conf = float(confs[i]) if confs is not None else 0.0
        tid = int(track_ids[i]) if track_ids is not None and track_ids[i] is not None else -1

        # Clamp/convert coords to int for drawing
        x1, y1, x2, y2 = map(lambda v: int(max(0, min(v, w if v in (x1, x2) else h))), (x1, y1, x2, y2))

        # Rectangle
        cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)

        # Label text
        cls_name = class_names.get(cls_id, str(cls_id))
        label = f"{cls_name} {conf:.2f}"
        if tid >= 0:
            label = f"ID {tid} | " + label

        # Background box for text
        (tw, th), baseline = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.6, 2)
        th = th + baseline
        cv2.rectangle(frame, (x1, max(0, y1 - th - 4)), (x1 + tw + 4, y1), (0, 255, 0), thickness=-1)
        cv2.putText(frame, label, (x1 + 2, y1 - 6), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 0), 2, cv2.LINE_AA)

    return frame

def main():
    args = parse_args()

    # Resolve source: numeric webcam index or path
    source = args.source
    if source.isdigit():
        source = int(source)

    # Load model
    model = YOLO(args.model)

    # Using Ultralytics built-in tracker in a streaming fashion.
    # We iterate over results to draw our own overlays.
    # persist=True keeps tracker state across frames.
    stream = model.track(
        source=source,
        stream=True,
        imgsz=args.imgsz,
        conf=args.conf,
        iou=args.iou,
        tracker=args.tracker,
        persist=True,
        verbose=False,
        show=False  # we'll handle display ourselves
    )

    # Class names mapping
    names = model.names if hasattr(model, "names") else {}

    # FPS tracking
    prev_time = None
    fps = 0.0

    window_name = "YOLOv8 • Real-time Detection + Tracking (press 'q' or ESC to quit)"
    cv2.namedWindow(window_name, cv2.WINDOW_NORMAL)

    for result in stream:
        # Original frame
        frame = result.orig_img.copy()

        # Extract predictions
        boxes = result.boxes
        if boxes is not None and len(boxes) > 0:
            xyxy = boxes.xyxy.cpu().numpy() if hasattr(boxes.xyxy, "cpu") else boxes.xyxy
            cls = boxes.cls.cpu().numpy().astype(int) if hasattr(boxes.cls, "cpu") else boxes.cls.astype(int)
            conf = boxes.conf.cpu().numpy() if hasattr(boxes.conf, "cpu") else boxes.conf
            # Track IDs are available when using .track()
            ids = None
            if hasattr(boxes, "id") and boxes.id is not None:
                ids = boxes.id.cpu().numpy() if hasattr(boxes.id, "cpu") else boxes.id

            frame = draw_boxes(frame, xyxy, cls, conf, ids, names)

        # FPS overlay
        if args.show_fps:
            import time
            now = time.time()
            if prev_time is not None:
                dt = now - prev_time
                if dt > 0:
                    fps = 1.0 / dt
            prev_time = now
            text = f"FPS: {fps:.1f}"
            (tw, th), baseline = cv2.getTextSize(text, cv2.FONT_HERSHEY_SIMPLEX, 0.7, 2)
            cv2.rectangle(frame, (10, 10), (10 + tw + 8, 10 + th + baseline + 8), (0, 0, 0), -1)
            cv2.putText(frame, text, (14, 10 + th + 2), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 255, 255), 2, cv2.LINE_AA)

        cv2.imshow(window_name, frame)

        key = cv2.waitKey(1) & 0xFF
        if key in (27, ord('q')):  # ESC or 'q'
            break

    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
