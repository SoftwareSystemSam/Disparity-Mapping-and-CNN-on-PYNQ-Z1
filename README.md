This is my (Samuel Smith N11064196) QUT Honours project for 2025. This project is under the supervision of Dr Jasmine Banks. 

This projects initial aim was to implement disparity mapping and object recognition using CNN on an FPGA. Due to the resource constraints on the FPGA, both object recognition and disparity mapping could not be done on the FPGA or on the FPGA and the ARM. So an RPI 5 was introduced alongside two RPI cameras for the disparity mapping. An ethernet cable connects the two devices with both communicating via TCP, with the RPI sending 32 x 32 ROI images to the FPGA for object recognition. A flask server is also run when the live disparity mapping is running, so people can connect to the device via the IP address in a web browser.

The FPGA used for this project is the PYNQ-Z1. The CNN was trained using CIFAR-10 data. Created with Brevitas, and compiled for the FPGA using FINN. The disparity mapping is using OpenCV packages and the data set used for initially testing disparity mapping is the ETH3D data set as well as the Stereo EGO motion dataset (found here: https://lmb.informatik.uni-freiburg.de/resources/datasets/StereoEgomotion.en.html). To run this project, you need an RPI 5, and either a PYNQ Z1 or PYNQ Z2 (this project used a Z1 but a Z2 should still be able to run the FINN bit files).

<img width="751" height="554" alt="rpi_cameras_pynq" src="https://github.com/user-attachments/assets/03d2fd46-0328-4870-8db5-6dd6ba470007" />

*Figure 1: RPI and PYNQ setup*





https://github.com/user-attachments/assets/963628b5-31e3-48b0-8735-eabe6f099d1a


*Figure 2: Disparity mapping and object detection live*

 


## Disclaimer
This project is provided "as is" without warranty of any kind. Use at your own risk. This was developed as an Engineering Honours project and may contain bugs or incomplete feeatures.

## Citation and Attribution
If you use this work in your research, publications, or projects, please cite:

> Samuel Brandon Smith. "Real-time Depth Perception and Object
Recognition Using FPGA-Accelerated Stereo
Vision and Quantized Neural Networks". Github, 2025.
> Web. [Access Date] https://github.com/SoftwareSystemSam/Disparity-Mapping-and-CNN-on-PYNQ-Z1/edit/main/README.md
