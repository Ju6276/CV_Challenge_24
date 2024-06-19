# CV_Challenge_24
Chen,Junpeng
Dong,Ju
Li,Xiaolin
Li,Zhiyun
Yu,Fengyi
Zhou,Nan

> [!IMPORTANT]
> **Deadline 09.07**
> **Presentation 10.07**

## 
> [!NOTE]
> [会议室链接] tbd
>
## 时间计划
- 1.st week:
- 2.end week: Foreground, spiderweb, five areas and corresponding GUIs
- 

## 任务分配
1. Foreground segmentation  _Dong,Ju_
2. Vanishing point; spider network segmentation _Chen,Junpeng/Dong,Ju/Li,Xiaolin/Zhou,Nan_
3. Extraction of five regions _Chen,Junpeng/Li,Xiaolin/Zhou,Nan_
4. GUI _Li,Zhiyun/Yu,Fengyi_
5. 3D-Reconstruction
6. Animation



## 原文链接
> [!TIP]
> **Computer Vision Challenge - SoSe 2024** (https://www.moodle.tum.de/pluginfile.php/5168450/mod_resource/content/1/Computer_Vision_Challenge_2024.pdf)
> [Tour Into the Picture:Using a Spidery Mesh Interface to Make Animation from a Single Image](http://graphics.cs.cmu.edu/courses/15-463/2011_fall/Papers/TIP.pdf)

## 一些资料
1. [示例](https://github.com/yli262/tour-into-the-picture).
2. [Youtube实现视频](https://www.youtube.com/watch?v=44V9I7Nrjw4)
3. [Youtube实现视频](https://www.youtube.com/watch?v=0lyFixtyvbs&t=8s])
4. [某个项项目描述]https://www.cs.cmu.edu/afs/cs.cmu.edu/academic/class/15463-f08/www/proj5/www/gme/-用于写缺点或者展望
5. ...
6. [Github readme编辑指令](https://docs.github.com/zh/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)

## 提交内容
- [ ] demo[TUM模板](https://portal.mytum.de/corporatedesign/index_html/vorlagen/index_videovorlagen)
- [ ] code
- [ ] poster[TUM模板](https://portal.mytum.de/corporatedesign/index_html/vorlagen/index_plakate)
- [ ] Readme

## Idee

Möglicher Workflow?_von Ju Dong_
1. Ein Bild wählen
2. Bildverarbeiten
3. Vordergrund setzen (nicht rekonstruierbar? ROI-Algorithm) 
4. Spinnennetz-Gitters erzeugen (only 1 Vanishing point? need to be improved ->2 Vanishing Points?)
5. 5 Zonen extrahieren 
6. die 3D Szene erzeugen

1.如果前景的图片是多边形，但是我最后只保存最左最右最上和最下的四个点？会不会建模的时候更简单？
2.是否可以考虑转换成灰度图？


