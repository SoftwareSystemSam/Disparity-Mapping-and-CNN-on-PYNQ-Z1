This is my (Samuel Smith N11064196) QUT Honours project. This project is under the supervision of Dr Jasmine Banks. 
This project aims to implement disparity mapping and object recognition using CNN on an FPGA.
The FPGA used for this project is the PYNQ-Z1. The CNN was trained using CIFAR-10 data. Created with Brevitas, and compiled for the FPGA using FINN.
The disparity mapping is using OpenCV packages and the data set used for testing disparity mapping is the ETH3D data set as well as the Stereo EGO motion dataset (found here: https://lmb.informatik.uni-freiburg.de/resources/datasets/StereoEgomotion.en.html)

This project can be run on the pynq by simply copying this project into the JUPYTER_NOTEBOOKS folder on the pynq, opening up the jupyter notebooks files and running them.


Preliminary testing has shown that with the correct baseline and focal lengths, the disparity mapping can be done, proper ROI and distance estimations

![image](https://github.com/user-attachments/assets/899b4b5c-439a-45f3-8e21-9148bbe864f8)
