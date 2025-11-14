

import cv2
from ultralytics import YOLO
model = YOLO("yolov8n.pt")

# 2. Initialize webcam (0 = default camera)
cap = cv2.VideoCapture(0)

if not cap.isOpened():
    print("❌ Error: Could not access the webcam.")
    exit()
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)   # e.g., 1280 px
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
# 3. Process frames continuously
while True:
    ret, frame = cap.read()
    if not ret:
        print("❌ Error: Failed to grab frame.")
        break

    # 4. Run YOLOv8 detection
    results = model(frame)

    # 5. Annotate frame with bounding boxes & labels
    annotated_frame = results[0].plot()

    # 6. Display the annotated frame
    cv2.imshow("YOLOv8 Real-Time Detection", annotated_frame)

    # Exit on pressing 'q'
    if cv2.waitKey(1) & 0xFF == ord("q"):
        break

# 7. Cleanup
cap.release()
cv2.destroyAllWindows()
