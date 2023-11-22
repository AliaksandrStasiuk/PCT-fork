#!/bin/bash

mkdir $2
mkdir $2/splited
mkdir $2/inferenced 

ffmpeg -i $1 -vf "fps=30" $2/splited/c01_%04d.jpeg

PYTHONPATH="$(dirname $0)/..":$PYTHONPATH python vis_tools/demo_img_with_mmdet.py vis_tools/cascade_rcnn_x101_64x4d_fpn_coco.py https://download.openmmlab.com/mmdetection/v2.0/cascade_rcnn/cascade_rcnn_x101_64x4d_fpn_20e_coco/cascade_rcnn_x101_64x4d_fpn_20e_coco_20200509_224357-051557b1.pth configs/pct_base_classifier.py weights/pct/swin_base.pth --img-root $2/splited/ --out-img-root $2/inferenced --thickness 2


ffmpeg -framerate 30 -pattern_type glob -i ''"$2"'/inferenced/*.png' -vf scale=1080:1080:force_original_aspect_ratio=decrease:eval=frame,pad=1080:1080:-1:-1:eval=frame -c:v libx264 -pix_fmt yuv420p $2/out.mp4