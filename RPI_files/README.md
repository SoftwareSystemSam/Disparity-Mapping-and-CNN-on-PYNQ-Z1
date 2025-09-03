Put these files on the RPI (Recommmend using an RPI 5 or higher due to threading capabilities needed).

You need two RPI cameras, an ethernet cable to connect the RPI to the FPGA and a chessboard for calibration.  You also need to setup both the RPI and the FPGA with static IP addresses. You can use OpenCVs chessboard here (which is what I did) https://github.com/opencv/opencv/blob/4.x/doc/pattern.png

Tips for the calibration: 
* Print off the chessboard onto a piece of paper and stick that to something firm like a piece of cardboard. You need to be able to move the chessboard back and forth from the cameras for calibration.
* Ensure that your chessboard prints to the exact size needed for calibration (box size needs to be 25mm wide).
* Make sure the chessboard is smooth and flat because bumps in the paper can distort the calibration.
* It also helps when moving the chessboard to rotate it like a steering wheel and move it to the edges of the cameras FOV. You may need to try this step a few times, especially if your disparity mapping is coming out with nothing.
* Play around with the calibration and see what works best for you.
* If you want to quit mid calibration just press q when on the camera screen.
* You can see an example of calibration in the video below.



https://github.com/user-attachments/assets/7875d40f-b666-4726-ae68-2bb85fa5d197



The files in this directoy can be loaded onto the RPI for use. Each file is numbered for the order of which you run them.

So first you run calibration_stereo_1.py. This python script will attempt to locate the chessboard so that it can calibrate the cameras for stereo imaging.

Once that is done, run stereo_calibrate_2.py. This will take those calibration images and put them into a file necessary for live disparity mapping.

Once the stereo calibration is complete, run the FINN_TO_RPI code on the FPGA. This will open up a TCP connection and wait for data from the RPI. Once the FPGA TCP connection is waiting, you can run disparity_live. The RPI will initialise everything needed for disparity mapping, create a flask server so people can view the feed, and establish the TCP connection the FPGA. While disparity mapping is running, to fine tune the num_disparities and block_size you can use the keys ('-', '=', '[', ']'). You can press 'b' to print out benchmarking for performance analysis. If you want to quit just press 'q' when on the camera screen.


<img width="1897" height="925" alt="dog test" src="https://github.com/user-attachments/assets/0994ecf2-0082-4fd7-a223-ac2a049f657b" />
