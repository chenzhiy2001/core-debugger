# CoreDebugger
这个Docker容器提供了在线vscode、一键调试工具、rust工具链以及`qemu-system-riscv64`等[rCore-Tutorial-v3](https://rcore-os.github.io/rCore-Tutorial-Book-v3/index.html)需要的工具
（暂无文件存储功能，关闭容器前务必保存项目）。

## 如何使用

### 构建docker容器

在[sifive官网](https://www.sifive.com/software)下载risc-v工具链（往下拉找到GNU Embedded Toolchain — v2020.12.8, 下载ubuntu版本），
或者试试直接访问
[这里](https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-linux-ubuntu14.tar.gz)。下载后将该文件复制到本项目的目录下。

构建容器：
```shell
docker build -t gdbgui-test . 
```
### 启动镜像
```dockerfile
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it --rm -v $PWD:/sharedFolder --name gdbgui-test-1 -p 3000:3000 -p 5000:5000  gdbgui-test 
```
启动后，终端会提示在线vscode的网页地址，一般是`localhost:3000`。

### 编译、运行、调试
将`/home/workspace/Makefile`中的`PROJECT_NAME`变量和`launch.json`中的`rCore-Tutorial-v3`修改为欲调试项目的文件夹名。

（可选）使用[github镜像站](https://doc.fastgit.org/zh-cn/guide.html)：
```makefile
make fast_github
```
编译、运行：
```makefile
make build_run_project
```
调试(目前需手动操作。待插件完善后再添加make debug指令):
0. `openvscode-server --install-extension webfreak.debug`
1. 创建launch,json:
```json
{
    "configurations": [
        {
            "type": "gdb",
            "request": "attach",
            "name": "Attach to qemu",
            "executable": "/home/workspace/rCore-Tutorial-v3/os/target/riscv64gc-unknown-none-elf/release/os",
            "target": ":1234",
            "remote": true,
            "cwd": "${workspaceRoot}",
            "valuesFormatting": "parseText",
            "gdbpath": "/home/workspace/riscv64-unknown-elf-toolchain-10.2.0-2020.12.8-x86_64-linux-ubuntu14/bin/riscv64-unknown-elf-gdb"
        },
    ]
}
```
2. 点击▶按钮


## To-Do List

- [ ] 提升稳定性
    - [ ] rcore-tutorial-v3
- [ ] 复位功能
- [ ] 高级功能
    - [ ] 多用户
    - [ ] 文件存储
    - [ ] 花哨的图形界面
- [ ] 上传镜像到docker hub
- [ ] 支持uCore等其他项目
    - [ ] 符号表问题

