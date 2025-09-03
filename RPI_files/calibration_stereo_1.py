import cv2
import numpy as np
from picamera2 import Picamera2
import time
import os

## Open CV functions for calibration with chessboard can be found here: https://docs.opencv.org/4.x/d9/d0c/group__calib3d.html#ga93efa9b0aa890de240ca32b11253dd4a
## Example calibration can be found here: https://docs.opencv.org/4.x/dc/dbb/tutorial_py_calibration.html

#Setup

pattern_size = (9,6) #inner corners of our chessboard
save_dir = "calib_images"
os.makedirs(save_dir,exist_ok = True)

picam2_left = Picamera2(0)
picam2_right = Picamera2(1)

config = picam2_left.create_video_configuration(main={"size":(640,480)})
picam2_left.configure(config)
picam2_right.configure(config)

picam2_left.start()
picam2_right.start()
time.sleep(2)

last_saved_time = time.time()
save_interval = 1.0 # seconds
img_id = 0

while img_id < 20:
    frame_left = cv2.cvtColor(picam2_left.capture_array("main"), cv2.COLOR_BGR2RGB)
    frame_right = cv2.cvtColor(picam2_right.capture_array("main"), cv2.COLOR_BGR2RGB)

    frame_left = cv2.flip(frame_left, -1)
    frame_right = cv2.flip(frame_right, -1)

    gray_left = cv2.cvtColor(frame_left, cv2.COLOR_RGB2GRAY)
    gray_right = cv2.cvtColor(frame_right, cv2.COLOR_RGB2GRAY)

    foundL, cornersL = cv2.findChessboardCorners(gray_left, pattern_size)
    foundR, cornersR = cv2.findChessboardCorners(gray_right, pattern_size)

    if foundL and foundR:
        # Refine corners
        criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 30, 0.01)
        cornersL = cv2.cornerSubPix(gray_left, cornersL, (11, 11), (-1, -1), criteria)
        cornersR = cv2.cornerSubPix(gray_right, cornersR, (11, 11), (-1, -1), criteria)

        vis_left = frame_left.copy()
        vis_right = frame_right.copy()
        cv2.drawChessboardCorners(vis_left, pattern_size, cornersL, foundL)
        cv2.drawChessboardCorners(vis_right, pattern_size, cornersR, foundR)

        combined = np.hstack((vis_left, vis_right))
        cv2.imshow("Calibration Checkerboard", combined)

        if time.time() - last_saved_time > save_interval:
            cv2.imwrite(f"{save_dir}/left_{img_id}.png", frame_left)
            cv2.imwrite(f"{save_dir}/right_{img_id}.png", frame_right)
            print(f"Successfully autosaved image pair {img_id}")
            img_id += 1
            last_saved_time = time.time()
    else:
        combined = np.hstack((frame_left, frame_right))
        cv2.imshow("Calibration Checkerboard", combined)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

picam2_left.stop()
picam2_right.stop()
