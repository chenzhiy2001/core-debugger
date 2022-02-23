# CoreDebugger
这个Docker容器提供了在线vscode、[gdbgui](https://www.gdbgui.com/)、rust工具链以及`qemu-system-riscv64`等[rCore-Tutorial-v3](https://rcore-os.github.io/rCore-Tutorial-Book-v3/index.html)需要的工具
（暂无文件存储功能，关闭容器前务必保存项目）。

## 如何使用
### 拉取镜像
```dockerfile
docker pu
```

也可以自己构建。
### 构建docker容器

1. 在[sifive官网](https://www.sifive.com/software)下载risc-v工具链（往下拉找到GNU Embedded Toolchain — v2020.12.8, 下载ubuntu版本），
或者试试直接访问
[这里](https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-linux-ubuntu14.tar.gz)。下载后将该文件复制到本项目的目录下。
2. 
```shell
docker build -t gdbgui-test . 
```
### 启动镜像
```dockerfile
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it --rm -v $PWD:/sharedFolder --name gdbgui-test-1 -p 3000:3000 -p 5000:5000  gdbgui-test 
```
运行后，终端会提示在线vscode的网页地址，一般是`localhost:3000`。

### 编译、运行、调试
1. 将`/home/workspace/Makefile`中的PROJECT_NAME和`gdb_startup_cmd.txt`中的rCore-Tutorial-v3修改为您的的项目的文件夹名。
2. （可选）使用[github镜像站](https://doc.fastgit.org/zh-cn/guide.html)
```makefile
make fast_github
```
2. 编译、运行
```makefile
make build_run_project
```
3. 调试
```makefile
make run_gdbgui
```
运行后，终端会提示在线vscode的网页地址。打开它即可使用gdbgui调试。（弹出窗口会被浏览器屏蔽）

### gdbgui how to
左下角是gdb的文本终端。

右上角`SI`按钮步进。

详见[gdbgui官网](https://www.gdbgui.com/screenshots/)

## To-do List
- [ ] 上传镜像到docker hub
- [ ] 复位功能
- [ ] 提升稳定性
    - [ ] 简单rust程序
    - [ ] rcore-tutorial-v3
- [ ] 添加堆栈查看功能
    - [ ] 排查问题。是gdb没生成堆栈信息还是gdbgui没解析？
- [ ] vscode和gdbgui融合
- [ ] 高级功能
    - [ ] 多用户
    - [ ] 文件存储
    - [ ] 花哨的图形界面
- [ ] 支持uCore等其他项目
    - [ ] 符号表问题

