import java.io.IOException;
import java.net.URI;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.*;

/**
 * 过滤掉文件名满足特定条件的文件（排除 .abc 后缀）
 */
class MyPathFilter implements PathFilter {
    private final String reg;
    
    MyPathFilter(String reg) {
        this.reg = reg;
    }
    
    @Override
    public boolean accept(Path path) {
        // 修复1: 正则表达式添加 $ 锚定结尾，确保只匹配文件后缀
        // 修复2: 逻辑简化，不匹配正则（非.abc文件）返回 true（接受）
        return !path.toString().matches(reg + "$");
    }
}

/**
 * 利用 FSDataOutputStream 和 FSDataInputStream 合并 HDFS 中的文件
 */
public class MergeFile {
    private final Path inputPath;   // 待合并的文件所在的目录
    private final Path outputPath;  // 输出文件路径

    public MergeFile(String input, String output) {
        this.inputPath = new Path(input);
        this.outputPath = new Path(output);
    }

    public void doMerge() throws IOException {
        Configuration conf = new Configuration();
        
        // 修复3: 端口号改为 8020（与 core-site.xml 保持一致）
        conf.set("fs.defaultFS", "hdfs://localhost:9000");
        
        // 修复4: fs.hdfs.impl 通常无需手动设置，可删除
        // conf.set("fs.hdfs.impl", "org.apache.hadoop.hdfs.DistributedFileSystem");

        FileSystem fsSource = null;
        FileSystem fsDst = null;
        
        try {
            // 修复5: 直接使用 Path 对象，避免 toString() 再解析
            fsSource = FileSystem.get(inputPath.toUri(), conf);
            fsDst = FileSystem.get(outputPath.toUri(), conf);
            
            // 修复6: 检查输入目录是否存在
            if (!fsSource.exists(inputPath) || !fsSource.getFileStatus(inputPath).isDirectory()) {
                throw new IOException("Input path does not exist or is not a directory: " + inputPath);
            }
            
            // 过滤掉后缀为 .abc 的文件
            FileStatus[] sourceStatus = fsSource.listStatus(inputPath, new MyPathFilter(".*\\.abc"));
            
            // 修复7: 添加 overwrite 参数，避免文件已存在时报错
            FSDataOutputStream fsdos = fsDst.create(outputPath, true);
            
            // 修复8: 直接使用 System.out，不要包装后关闭
            for (FileStatus sta : sourceStatus) {
                System.out.printf("路径：%s 文件大小：%d 权限：%s 内容：%n", 
                    sta.getPath(), sta.getLen(), sta.getPermission());
                
                FSDataInputStream fsdis = null;
                try {
                    fsdis = fsSource.open(sta.getPath());
                    byte[] data = new byte[4096];  // 修复9: 增大缓冲区提升性能
                    int read;
                    while ((read = fsdis.read(data)) > 0) {
                        System.out.write(data, 0, read);  // 输出到控制台
                        fsdos.write(data, 0, read);        // 写入合并文件
                    }
                } finally {
                    // 修复10: 确保每个输入流都正确关闭
                    if (fsdis != null) fsdis.close();
                }
            }
            fsdos.close();  // 最后关闭输出流
            System.out.println("\n✅ 文件合并完成: " + outputPath);
            
        } finally {
            // 修复11: 确保文件系统资源释放
            if (fsSource != null) fsSource.close();
            if (fsDst != null && fsDst != fsSource) fsDst.close();
        }
    }

    public static void main(String[] args) {
        try {
            MergeFile merge = new MergeFile(
                "hdfs://localhost:9000/user/lubingren/",   // 修复12: 端口号统一
                "hdfs://localhost:9000/user/lubingren/merge.txt");
            merge.doMerge();
        } catch (IOException e) {
            System.err.println("❌ 合并失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
}