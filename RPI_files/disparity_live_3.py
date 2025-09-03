import cv2
import numpy as np
import time
import socket
import threading
import queue
import cProfile, pstats
from picamera2 import Picamera2
from collections import deque, Counter
from flask import Flask, Response

## Example of depth perception using stereo found here: https://learnopencv.com/depth-perception-using-stereo-camera-python-c/

# Setup labels so we know what object the FPGA detected

labels = ['Airplane', 'Automobile', 'Bird', 'Cat', 'Deer', 'Dog', 'Frog', 'Horse', 'Ship', 'Truck']
roi_queue = queue.Queue()
result_queue = queue.Queue()

# Shared frame storage
latest_frame = None
frame_lock = threading.Lock()

# Get the TCP conection setup to the PYNQ
HOST = '192.168.7.2' # FPGA IP
PORT = 9999

sock = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
sock.connect((HOST,PORT))

#### Functions ####
def select_closest_roi(contours,disparity,fx,baseline):
	"""Return ROI strictly based on closest depth"""
	best_depth = float('inf')
	best_roi = None
	max_area = (disparity.shape[0] * disparity.shape[1]) *0.3 # 30% of frame
	for cnt in contours:
		x,y,w,h = cv2.boundingRect(cnt)
		area = w*h
		aspect_ratio = w / float(h)
		
		if  3000 < area < max_area and 0.3 < aspect_ratio < 3.0:
			roi_disp = disparity[y:y + h, x:x + w]
			roi_valid = roi_disp[roi_disp > 1.0]
			
			# Check to see if the disparity inside the box is stable
			if roi_valid.size > 0 and np.std(roi_valid) < 30.0:
				mean_disp = np.mean(roi_valid)
				depth = (fx * baseline) / mean_disp
								
				if depth < best_depth:
					best_roi = (x,y,w,h)
					best_depth = depth
	return best_roi

def select_hybrid_roi(contours, disparity, fx, baseline):
	"""Return ROI based on closeness and area (weighted)"""
	best_score = -1
	best_roi = None
	max_area = (disparity.shape[0] * disparity.shape[1]) *0.3 # 30% of frame

	for cnt in contours:
		x,y,w,h = cv2.boundingRect(cnt)
		area = w*h
		aspect_ratio = w / float(h)
		
		if 3000 < area < max_area and 0.3 < aspect_ratio < 3.0:
			roi_disp = disparity[y:y + h, x:x + w]
			roi_valid = roi_disp[roi_disp > 1.0]
			
			# Check to see if the disparity inside the box is stable
			if roi_valid.size > 0 and np.std(roi_valid) < 30.0:
				mean_disp = np.mean(roi_valid)
				depth = (fx * baseline) / mean_disp
				
				#closer = better, bigger\
				score = (1.0/(depth + 1e-6)) * np.sqrt(area)
								
				if score > best_score:
					best_roi = (x,y,w,h)
					best_score = score
	return best_roi
	
app = Flask(__name__)

@app.route('/')
def video_feed():
	return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')


def generate_frames():
	global latest_frame
	while True:
		with frame_lock:
			if latest_frame is not None:
				#Encode as Jpeg
				ret, buffer = cv2.imencode('.jpg', latest_frame)
				frame = buffer.tobytes()
			else:
				continue # No frame yet, skip
		yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')
               
def get_local_ip():
	try:
		s =socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		s.connect(("8.8.8.8", 80)) # Googles DNS
		ip = s.getsockname()[0]
		s.close()
		return ip
	except Exception:
		return "127.0.0.1" # Fallback
		
def reset_disparity(num_disp, block_size):
	
	if num_disp < 16:
		num_disp = 16
	if num_disp %16 != 0:
		num_disp = (num_disp //16) *16
	# Ensure odd block size and >=5
	if block_size <5:
		block_size = 5
	if block_size % 2 == 0:
		block_size += 1
		
	#Create and configure StereoBM object
	stereo = cv2.StereoBM_create()
	stereo.setNumDisparities(num_disp)
	stereo.setBlockSize(block_size)
	print("Num Disparities = ", num_disp)
	print("Block size = ", block_size)
	return stereo, num_disp, block_size
#### End of Functions ####

### Threads ####
def fpga_worker():
	"""Thread to handle FPGA inference. """
	
	while True:
		roi_rgb = roi_queue.get()
		if roi_rgb is None:
			break
		
		roi_resized = cv2.resize(roi_rgb, (32,32), interpolation=cv2.INTER_AREA)
		cnn_input = roi_resized.astype(np.uint8).reshape(1,32,32,3)
		try:
			sock.sendall(cnn_input.tobytes())
			label_index = int.from_bytes(sock.recv(1), 'big')
			label = labels[label_index]
			result_queue.put(label)
		except Exception as e:
			print("FPGA error:", e)
			result_queue.put(None)


def run_flask():
	app.run(host='0.0.0.0', port=5000, debug = False, use_reloader=False)
	

	
#### End of Threads ####
# start the FPGA thread
fpga_thread = threading.Thread(target=fpga_worker,daemon = True)
fpga_thread.start()

# start the flask thread
flask_thread = threading.Thread(target=run_flask, daemon = True)
flask_thread.start()
label_buffer = deque(maxlen = 10)
#Load calibration data

calib = np.load("calibration_data.npz")
K1, D1 = calib["K1"], calib["D1"]
K2, D2 = calib["K2"], calib["D2"]
R1, R2 = calib["R1"], calib["R2"]
P1, P2 = calib["P1"], calib["P2"]
q = calib["Q"]

fx = q[0,0]
image_size_raw = tuple(calib["image_size"])

image_size_cv = tuple(int(x) for x in calib["image_size"])  # OpenCV needs width, height
image_size_pi = (image_size_cv[0], image_size_cv[1]) #PICAm wants height,width

# Rectification maps
map1L, map2L = cv2.initUndistortRectifyMap(K1,D1,R1,P1, image_size_cv, cv2.CV_16SC2)
map1R, map2R = cv2.initUndistortRectifyMap(K2,D2,R2,P2, image_size_cv, cv2.CV_16SC2)

#StereoBM setup
num_disp = 16
block_size = 5

stereo = cv2.StereoBM_create()
stereo.setNumDisparities(num_disp) # Must be divisble by 16
stereo.setBlockSize(block_size) # Must be odd, 5 to 255
stereo.setMinDisparity(0)
stereo.setUniquenessRatio(15)
stereo.setSpeckleWindowSize(100)
stereo.setSpeckleRange(16)

#Start cameras

picam2_left = Picamera2(0)
picam2_right = Picamera2(1)

config = picam2_left.create_video_configuration(main={"size": image_size_pi})
picam2_left.configure(config)
picam2_right.configure(config)

picam2_left.start()
picam2_right.start()
time.sleep(2)
fx = q[2,3]
baseline = 1.0 / q[3,2]

profile_next_loop = False

prev_time = time.time()
fps = 0

prev_box = None
alpha = 0.7 #smoothing factor between 0 and 1

local_ip = get_local_ip()
port = 5000

address_text = f"{local_ip}:{port}"

while True:
	if profile_next_loop:
		profiler = cProfile.Profile()
		profiler.enable()
	
	frame_left = picam2_left.capture_array("main")
	frame_right = picam2_right.capture_array("main")
	
	# Flip and convert
	
	frame_left = cv2.flip(cv2.cvtColor(frame_left, cv2.COLOR_BGR2GRAY),-1)
	frame_right = cv2.flip(cv2.cvtColor(frame_right, cv2.COLOR_BGR2GRAY), -1)
	
	#Prep FPS
	curr_time = time.time()
	fps = 1.0/(curr_time - prev_time)
	prev_time = curr_time
	
	# Rectify
	rect_left = cv2.remap(frame_left, map1L, map2L, cv2.INTER_LANCZOS4, cv2.BORDER_CONSTANT,0)
	rect_right = cv2.remap(frame_right, map1R, map2R, cv2.INTER_LANCZOS4, cv2.BORDER_CONSTANT,0)
	
	# Disparity mapping
	disparity_raw = stereo.compute(rect_left,rect_right)
	cv2.filterSpeckles(disparity_raw,0,200,32)
	
	disparity = disparity_raw.astype(np.float32) / 16.0
	disparity = disparity[:, num_disp:] # Attempt at cropping left invalid bands - it works
	
	# Normalise for display
	disp_vis = cv2.normalize(disparity, None, 0, 255, cv2.NORM_MINMAX)
	disp_vis = np.uint8(disp_vis)
	
	disp_colored = cv2.applyColorMap(disp_vis, cv2.COLORMAP_INFERNO)
	cv2.imshow("Disparity Heatmap", disp_colored)
	# Depth mapping
	
	depth_map = np.zeros_like(disparity)
	valid_disp = disparity > 0
	
	baseline = abs(1.0/q[3,2]) # Getting Baseline from Q matrix at Row 4, column 3 where it is -1/B
	
	depth_map[valid_disp] = (fx * baseline) / disparity[valid_disp] # Depth = f*b/disparity

	
	# This is optional and we can play with this
	mask = cv2.inRange(depth_map, 0.2, 10.0) # Only care about things that are 1 metre or 10 metres away
	#print("Depth min/max:", np.min(depth_map[valid_disp]), np.max(depth_map[valid_disp]))
		
	# Contour time
	contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
	contours = sorted(contours, key=cv2.contourArea, reverse=True)
	
	# ROI selection time
	best_roi = select_closest_roi(contours,disparity,fx,baseline)
	#or
	#best_roi = select_hybrid_roi(contours,disparity,fx,baseline)
	if best_roi:
			x,y,w,h = best_roi
			if prev_box is None:
				smoothed_box = (x,y,w,h)
			else:
				prev_x = int(alpha * x+ (1-alpha) * prev_box[0])
				prev_y = int(alpha * y+ (1-alpha) * prev_box[1])	
				prev_w = int(alpha * w+ (1-alpha) * prev_box[2])	
				prev_h = int(alpha * h+ (1-alpha) * prev_box[3])
				smoothed_box = (prev_x, prev_y, prev_w, prev_h)
				
			prev_box = smoothed_box
			x,y,w,h = smoothed_box	
		
			
			offset = num_disp
			
			x_corrected = smoothed_box[0] + offset

			
			roi_disp = disparity[y:y+h, x:x+w]
			roi_rgb = cv2.cvtColor(rect_left, cv2.COLOR_GRAY2BGR)[y:y+h,x_corrected:x_corrected+w]
			
			valid_roi_disp = roi_disp[roi_disp > 1.0]
			if valid_roi_disp.size > 0:
				mean_disp = np.mean(valid_roi_disp)
				#print("Mean disparity is:", mean_disp)
				depth = (fx * baseline) / mean_disp
				cv2.putText(disp_colored, f"{depth:.2f}m", (x,y-5), cv2.FONT_HERSHEY_SIMPLEX, 0., (255,255,255),1)
			else:
				depth = 0.0
			
			# Draw the rectangle
			roi_resized = cv2.resize(roi_rgb, (32,32), interpolation=cv2.INTER_AREA)
			cnn_input = roi_resized.astype(np.uint8).reshape(1,32,32,3)
			
			roi_queue.put(roi_rgb)
			
			try:
				label = result_queue.get_nowait()
				if label:
					label_buffer.append(label)
			except queue.Empty:
				pass
				
			if label_buffer:
				most_common_label, count = Counter(label_buffer).most_common(1)[0]
			else:
				most_common_label = "..."
				
			#Display on screen
			rect_display = cv2.cvtColor(rect_left, cv2.COLOR_GRAY2BGR)
			cv2.rectangle(rect_display, (x_corrected,y), (x_corrected+w, y+h), (0,255,0),2)
			cv2.putText(rect_display, f"{most_common_label} - {depth:.2f}m,", (x_corrected, y-10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0,255,0),2)
			cv2.putText(rect_display, f"FPS: {fps:.2f}", (10,25),cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255,255,255),2)
			cv2.putText(rect_display, address_text, (10,50), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255,255,255),2)
			#Flask stream
			with frame_lock:
				latest_frame = rect_display.copy()
			#Local window
			cv2.imshow("Rectified Left with Depth", rect_display)
			#cv2.imshow("Depth Mask", mask)
			#print("Non-zero mask pixels:", cv2.countNonZero(mask))
			
			if profile_next_loop:
				profiler.disable()
				profiler.dump_stats('pipeline_profile')
				p = pstats.Stats('pipeline_profile')
				p.strip_dirs().sort_stats('cumtime').print_stats(20)
				#break # Exit after profiling
				profile_next_loop = False # Or if you want you can just set profile_next_loop = false to keep runnning
	key = cv2.waitKey(1)
	if key == ord('='):
		num_disp += 16
		stereo,num_disp,block_size = reset_disparity(num_disp,block_size)
	elif key == ord('-'):
		num_disp -= 16
		stereo,num_disp,block_size = reset_disparity(num_disp,block_size)
	elif key == ord(']'):
		block_size += 2
		stereo,num_disp,block_size = reset_disparity(num_disp,block_size)
	elif key == ord('['):
		block_size -= 2
		stereo,num_disp,block_size = reset_disparity(num_disp,block_size)
	elif key == ord('b'): # Get the benchmark
		print("Profiling will start on next loop iteration....")
		profile_next_loop = True			
	elif key == ord('q'):
		break

		
		

picam2_left.stop()
picam2_right.stop()
roi_queue.put(None)
fpga_thread.join()
sock.close()
