import cv2
import numpy as np
import glob
import os

#Settings

pattern_size = (9,6) #inner corners
square_size = 0.025 # meters (25mm)

image_dir = "calib_images"
image_format = "png"

# Load image paths

left_images = sorted(glob.glob(os.path.join(image_dir, "left_*.png")))
right_images = sorted(glob.glob(os.path.join(image_dir, "right_*.png")))

assert len(left_images) == len(right_images), "Mismatched stereo pair count"

#Perpare object points (0,0,0), (1,0,0), ..., (8,5,0)
objp = np.zeros((pattern_size[0]*pattern_size[1],3), np.float32)
objp[:,:2] = np.indices(pattern_size).T.reshape(-1,2)
objp *= square_size

objpoints = [] # 3D points
imgpoints_left = [] #2D points left
imgpoints_right = [] #2D points right

for left_path, right_path in zip(left_images,right_images):
	img_left = cv2.imread(left_path, cv2.IMREAD_GRAYSCALE)
	img_right = cv2.imread(right_path, cv2.IMREAD_GRAYSCALE)
	
	retL, cornersL = cv2.findChessboardCorners(img_left,pattern_size)
	retR, cornersR = cv2.findChessboardCorners(img_right, pattern_size)
	
	if retL and retR:
		objpoints.append(objp)
		imgpoints_left.append(cornersL)
		imgpoints_right.append(cornersR)
		

# Image size
h,w = img_left.shape[:2]
image_size = (w,h)

#Calibrate individual camera

retL, K1, D1, _, _ = cv2.calibrateCamera(objpoints, imgpoints_left, image_size, None, None)
retR, K2, D2, _, _ = cv2.calibrateCamera(objpoints, imgpoints_right, image_size, None, None)

#Stereo calibration

flags = cv2.CALIB_FIX_INTRINSIC
criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 100, 1e-5)

ret, K1, D1, K2, D2, R, T, E, F = cv2.stereoCalibrate(
    objpoints, imgpoints_left, imgpoints_right,
    K1, D1, K2, D2, image_size,
    criteria=criteria, flags=flags
)

#Rectification

R1, R2, P1, P2, Q, _, _ = cv2.stereoRectify(K1, D1, K2, D2, image_size, R, T)

# Save it all now

np.savez("calibration_data.npz",
		K1=K1, D1=D1,
		K2=K2, D2=D2,
		R=R, T=T,
		R1=R1, R2=R2,
		P1=P1, P2=P2,
		Q=Q,
		image_size=image_size)
		
print("Calibration complete! Saved to calibration_data.npz")
