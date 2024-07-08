

# Tour into the picture

[![Alt text](https://example.com/image.jpg)](https://github.com/Ju6276/CV_Challenge_24/blob/junpeng/image.png)

## Description
How to reconstruct 3D scenes from a single 2D picture or photograph based on Youichi Horry's Tour into the Picture?

## Documentation
Please follow these useful steps for the application:

1. Install and open MATLAB R2024a.
2. Add the project directory to your Matlab path
3. Make sure that the necessary toolboxes are already installed (see below)
4. Start the main file to use the application

## Environment
Experimental setup on Windows, MacOs and Ubuntu 20.04</br>
To run this application, you need the following toolboxes:
- **MATLAB R2024a**
- **Computer Vision Toolbox**
- **Image Processing Toolbox**

## GUI Usage
**Interface Overview**</br>
This interface offers two modes: Beginner Mode (default) and Expert Mode. Switch modes using the button at the bottom.

**1. Beginner Mode**</br>
Task Bar (Left): Follow the sequential tasks listed.
Image Display (Center): View related images for each task.
Tip Area (Bottom): Get step-by-step guidance and tips.

**2. Expert Mode**</br>
Icon Toolbar (Below Menu Bar): Use the tools in a left-to-right sequence.
Designed for experienced users with a streamlined layout.

**3. Menu Bar (Top)**</br>
Contains commonly used tools, including a reset tool to restart all steps or switch images.

**Usage Instructions**</br>
Step 1: Click to choose the picture. Right-click to reset.</br>
Step 2: If needed, select the foreground and click the location button below on the right. Right-click to reset.</br>
Step 3: Select the vanishing point and background. Right-click to reset.</br>
Step 4: Show the 3D Model. Adjust using x (left/right), y (up/down), z (zoom).</br>
Step 5: Click to screenshot.</br>
Step 6: Click to show the animation.</br>

**Enjoy using the GUI!**

## Algorithmus and Function

### 1. Foreground Object & Background Specification
In this project, it's relatively straighforward to draw the user-specified vanishing point as well as the rectangle for the rear wall using Graphical User Interface. In order to support the GUI application, we use Selection.m for background specification by computing the intersection determined from the vanishing point and inner rectangle (e.g. vertices 1,2,7,8). In Foreground_Selection.m, we employ a ROI for foreground and background seperation. The file stores 2D pixel coordinates and mask of foreground object so that we could extract foreground image to meet further requirements. After running these functions, we generate the spidery mesh and thereby extract five regions, which sets a fundamental for 3D reconstruction.

### 2. Perspective Viewing
For reconstructing 3D scenes, we first implement perspective transformation for background in To_Rectangle.m and To_Rectangle_Usage.m, in which we apply the perspective transformation to every segment.

### 3. 3D Reconstruction
In terms of the existence of foreground object, we have Build3DModel_withfore.m and Build3DModel_withoutfore.m for two different modes and GUI application can determine whether foreground object is specified or not. We transform 2D pixel coordinates into screen coordinates and normalize the size of screen coordinates. Considering view point, we use scale factor to calculate 3D vanishing point and 12 vertices of background as well as 4 vertices of foreground object. In addition, the function also show visualization results 
and we can model the foreground object on four walls (floor, ceiling, leftwall, rightwall).

### 4. Rendering
In order to map the texture to corresponding 3D surfaces , we implement rendering process in applyMask.m, SurfImage.m and Rendering.m using surf() for three-dimensional surface plot so that we visualize the rendered results in a xyz plot based on that. 

### 5. Animation
In Animation.m, we setup a virtual camera so that we could see the 3D model from different perspectives in GUI application. 


## Sample Videos and Images


## Group Work
**Group Work**</br>
**Image Segmentation, feature point extraction:** Ju</br>
**GUI-Design:** Zhiyun, Fengyi</br>
**5 Region Extraction:** Ju, Xiaolin, Zhiyun</br>
**3D Reconstruction**: Junpeng, Xiaolin, Nan</br>
**Rendering**: Ju</br>
**Poster:** Junpeng, Xiaolin, Nan</br>
**README:** Ju, Junpeng, Fengyi</br>




## Contact
For further questions, you can contact us at [e-mail address].

## Acknowledgements
Many thanks to all team members who contributed to this project:
-  <img src="https://github.com/junpeng2023.png" width="20" height="20" style="border-radius: 50%"> [Junpeng Chen](https://github.com/junpeng2023)
- Dong, Ju
- Li, Xiaolin
- Li, Zhiyun
- Yu, Fengyi
- Zhou, Nan