#!/bin/bash

# 视频文件目录（请使用绝对路径）
video_dir="/path/to/your/videos"

# 输出文件目录
output_dir="$video_dir/output"

# 创建输出目录（如果不存在）
mkdir -p "$output_dir"

# 批量处理视频文件
for video in "$video_dir"/*.mkv; do
    # 获取视频文件名（包括扩展名）
    filename=$(basename "$video")
    
    # 获取视频文件的绝对路径
    video_path=$(realpath "$video")
    
    # 字幕文件路径（假设字幕文件名与视频文件名相同，但扩展名为.ass）
    subtitle="$video_dir/${filename%.*}.ass"
    
    # 输出文件路径
    output="$output_dir/$filename"
    
    # 检查字幕文件是否存在
    if [ -f "$subtitle" ]; then
        # 获取字幕文件的绝对路径
        subtitle_path=$(realpath "$subtitle")
        
        # 运行ffmpeg添加字幕轨并设置为默认轨道
        ffmpeg -i "$video_path" -i "$subtitle_path" -c copy -c:s ass -map 0 -map 1 -disposition:s:0 default "$output"
        echo "字幕轨道已添加并设为默认: $output"
    else
        echo "字幕文件不存在: $subtitle"
    fi
done
