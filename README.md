# raspi-os
raspi-os



## 参考资料  
1. [AndroidSecNotes](https://github.com/JnuSimba/AndroidSecNotes) 该仓库虽是安卓安全笔记，但是其中对`arm` 的汇编指令以及寄存器的介绍还不错  
2. [Building an Operating System for the Raspberry Pi](https://jsandler18.github.io/tutorial/dev-env.html) 本仓库重点抄袭的对象，开发环境的配置可以参考这里     
3. [raspi3-tutorial](https://github.com/bztsrc/raspi3-tutorial/) 上面仓库参考的对象  

### 遇到的问题  
#### 1. VSCode 代码提示的问题（编译器兼容性）  
需要修改`.vscode/c_cpp_properties.json` 来设置项目的属性：  
1. [x] [vscode 中用clang遇到问题：clang(pp_file_not_found)](https://www.jianshu.com/p/bc78efb11c61)  
2. [x] [identifier "Serial1" is undefined](https://github.com/microsoft/vscode-arduino/issues/866)  
3. [x] [Inline Assembly Error](https://github.com/microsoft/vscode-cpptools/issues/7011)

## logs  
- [2023-11-03] Build Dev Environment, refer to [Building an Operating System for the Raspberry Pi](https://jsandler18.github.io/tutorial/dev-env.html)  
  - Basic understanding of `linker script`  
  - Write `makefile` to auto compile project  
  - [ ] Comment of source code  
  - [x] Understand `asm` code