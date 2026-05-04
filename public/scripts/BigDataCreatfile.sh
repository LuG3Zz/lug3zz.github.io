#!/bin/bash

# HDFS 目标目录
HDFS_DIR="/user/lubingren"

# 1. 创建 HDFS 目录（如果不存在）
hdfs dfs -mkdir -p $HDFS_DIR

# 2. 创建本地临时目录
LOCAL_TMP="/tmp/hadoop_test_files"
mkdir -p $LOCAL_TMP

# 3. 生成文件内容
echo "this is file1.txt" > $LOCAL_TMP/file1.txt
echo "this is file2.txt" > $LOCAL_TMP/file2.txt
echo "this is file3.txt" > $LOCAL_TMP/file3.txt
echo "this is file4.abc" > $LOCAL_TMP/file4.abc
echo "this is file5.abc" > $LOCAL_TMP/file5.abc

# 4. 上传到 HDFS
echo "正在上传文件到 HDFS..."
hdfs dfs -put -f $LOCAL_TMP/file1.txt $HDFS_DIR/
hdfs dfs -put -f $LOCAL_TMP/file2.txt $HDFS_DIR/
hdfs dfs -put -f $LOCAL_TMP/file3.txt $HDFS_DIR/
hdfs dfs -put -f $LOCAL_TMP/file4.abc $HDFS_DIR/
hdfs dfs -put -f $LOCAL_TMP/file5.abc $HDFS_DIR/

# 5. 清理本地临时文件
rm -rf $LOCAL_TMP

# 6. 验证结果
echo ""
echo "=== HDFS 文件列表 ==="
hdfs dfs -ls $HDFS_DIR

echo ""
echo "=== 文件内容验证 ==="
for file in file1.txt file2.txt file3.txt file4.abc file5.abc; do
    echo "--- $file ---"
    hdfs dfs -cat $HDFS_DIR/$file
done

echo ""
echo "✅ 所有文件创建完成！"
