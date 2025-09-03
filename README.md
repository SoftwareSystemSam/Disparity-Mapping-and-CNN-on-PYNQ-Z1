# Real-time Depth Perception and Object Recognition Using FPGA-Accelerated Stereo Vision and Quantized Neural Networks

> **Author:** Samuel Brandon Smith (N11064196)  
> **Supervisor:** Dr. Jasmine Banks  
> **Institution:** Queensland University of Technology  
> **Year:** 2025

## Overview

This Honours project implements a real-time computer vision system combining **stereo depth perception** and **FPGA-accelerated object recognition**. The system addresses the challenge of performing computationally intensive computer vision tasks in resource-constrained embedded environments.

### Project Evolution
The initial goal was to implement both disparity mapping and CNN-based object recognition entirely on an FPGA. However, resource constraints led to a hybrid architecture:
- **RPI 5** handles stereo vision and disparity mapping
- **PYNQ-Z1 FPGA** performs accelerated CNN inference
- **TCP communication** enables real-time data exchange between devices

---

##  System Architecture

```
┌─────────────────┐   Object ID ( 0-9) ┌──────────────────┐
│   Raspberry Pi 5│◄────────────────── │    PYNQ-Z1 FPGA  │
│                 │    TCP/Ethernet    │                  │
│ • Dual cameras  │   32x32 ROI data   │ • CNN inference  │
│ • Disparity map │──────────────────► │ • FINN compiler  │
│ • Flask server  │                    │ • Object recog.  │
│ • OpenCV        │                    │                  │
└─────────────────┘                    └──────────────────┘
        │
        ▼
   Web Interface
   (Live viewing)
```

<img width="751" height="554" alt="rpi_cameras_pynq" src="https://github.com/user-attachments/assets/03d2fd46-0328-4870-8db5-6dd6ba470007" />

*Figure 1: RPI and PYNQ setup*


##  Hardware Requirements

| Component | Specification | Purpose |
|-----------|---------------|---------|
| **FPGA Board** | PYNQ-Z1 or PYNQ-Z2 | CNN inference acceleration |
| **Computing Platform** | Raspberry Pi 5 | Stereo vision processing |
| **Cameras** | 2x RPI Camera modules | Stereo image capture |
| **Connectivity** | Ethernet cable | TCP communication |
---

##  Key Features

-  **Real-time stereo vision** with dual RPI cameras
-  **FPGA-accelerated CNN** inference using quantized neural networks
-  **Web-based interface** via Flask server for live monitoring
-  **Disparity mapping** using OpenCV algorithms
-  **TCP communication** for efficient data transfer
-  **Optimized performance** through hardware-software co-design

## Datasets

### Training Data
- **CIFAR-10**: CNN training dataset for object classification
- **Framework**: Brevitas for quantization-aware training

### Testing Data
- **ETH3D Dataset**: Stereo vision benchmarking
- **Stereo EGO Motion Dataset**: Real-world stereo sequences
  - [Dataset Link](https://lmb.informatik.uni-freiburg.de/resources/datasets/StereoEgomotion.en.html)

---




![live_disparity](https://github.com/user-attachments/assets/cca29f6d-c333-47bc-bf03-3e223c5034a9)
*Figure 2: Disparity mapping and object detection live*

## Results

### Performance Metrics 
- **Frame Rate (FPS)**: ~15 FPS
- **System Latency**: 62ms
- **Classification Accuracy**: 80.33%
- **Detection Rate**: 76.2%
- **Distance Accuracy**: 10.56% relative error 

### Key Achievements
-  Successfully implemented hybrid FPGA-RPI architecture
-  Real-time disparity mapping at [X] FPS
-  FPGA-accelerated object recognition
-  Web-based monitoring interface

---

## Academic Context

This project was completed as part of my Engineering Honours degree at Queensland University of Technology under the supervision of Dr. Jasmine Banks. The work explores the intersection of computer vision, FPGA acceleration, and embedded systems design.

**Thesis Status**: [To be updated]

---

## Citation

If you use this work in your research, publications, or projects, please cite:

```bibtex
@misc{smith2025disparity,
    author = {Samuel Brandon Smith},
    title = {Real-time Depth Perception and Object Recognition Using FPGA-Accelerated Stereo Vision and Quantized Neural Networks},
    year = {2025},
    publisher = {QUT},
    howpublished = {\url{https://github.com/SoftwareSystemSam/Disparity-Mapping-and-CNN-on-PYNQ-Z1}},
    note = {QUT Honours Project}
}
```

---

## Disclaimer

This project is provided "as is" without warranty of any kind. Use at your own risk. This was developed as an Engineering Honours project and may contain bugs or incomplete features.

---

## Contact

- **Author**: Samuel Brandon Smith
- **Student ID**: N11064196  
- **Email**: n11064196@qut.edu.au or georgesamsquo@hotmail.com
- **Supervisor**: Dr. Jasmine Banks
- **Institution**: Queensland University of Technology

---

<div align="center">
  <strong>⭐ If this project helped you, please give it a star! ⭐</strong>
</div>
