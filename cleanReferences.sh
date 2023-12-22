#!/bin/bash

# 检查是否提供目录路径作为参数
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

directory_path=$1
backlog_file="$directory_path/BACKLOG.md"

# 创建 BACKLOG.md 文件
touch "$backlog_file"

# 递归遍历目录下的所有 Markdown 文件，排除 README.md、SUMMARY.md 和 BACKLOG.md
find "$directory_path" -type f -name "*.md" \
  | grep -E -v "(README\.md|SUMMARY\.md|BACKLOG\.md)" \
  | while read -r md_file; do

    # 检查 Markdown 文件中是否包含 "## 参考" 行
    if grep -q "## 参考" "$md_file"; then
        echo "Moving references from $md_file to $backlog_file."
        
        # 提取 "## 参考" 行的行号
        line_number=$(grep -n "## 参考" "$md_file" | cut -d ':' -f 1)

        # 将 "## 参考" 行后面的内容追加到 BACKLOG.md 文件
        tail -n +"$line_number" "$md_file" | grep -v "## 参考" >> "$backlog_file"

        # 删除原文件中 "## 参考" 行及其后面的内容
        sed -i "${line_number},\$d" "$md_file"
    fi

done

echo "Script completed."
