# 使用该脚本需要系统支持基本的linux 文件操作命令

# 1. 设置编译器路径
CC = D:/tools/Arm GNU Toolchain arm-none-eabi/13.2 Rel1/bin/arm-none-eabi-gcc# 注意尽量不要有空格

# 2. 设置编译标识
ifeq ($(RASPI_MODEL),1) # 指令与表达式之间要有空格
#   树莓派model1 用的芯片与2 和3 不同
#   注释不能有缩进
	CPU = arm1176jzf-s  
	DIRECTIVES = -D MODEL_1  
else  
	CPU = cortex-a7  
endif

CFLAGS = -mcpu=$(CPU) -fpic -ffreestanding $(DIRECTIVES)  # 编译标识，汇编与C 通用的部分  
CSRCFLAGS = -std=gnu99 -O2 -Wall -Wextra  # 编译标识，应该是用来编译C 代码的
LFLAGS = -ffreestanding -O2 -nostdlib  # 链接标识  

# 3. 设置文件及文件夹变量
HEAD_KERNEL = include
SRC_KERNEL = src/kernel
SOUCES_ASM = $(wildcard $(SRC_KERNEL)/*.s)# 通配符，用于匹配`SRC_KERNEL` 目录下的所有`.s` 文件，并返回一个列表
SOURCES_KERNEL = $(wildcard $(SRC_KERNEL)/*.c)# 如：src/kernel/boot.s
HEADERS = $(wildcard $(HEAD_KERNEL)/*.h)# 头文件通过kernel 或者common 前缀引用，所以不需要单独设置

SRC_COMMON = src/common
SOURCES_COMMON = $(wildcard $(SRC_COMMON)/*.c)

# 4. 设置目标对象文件目录
OBJ_DIR = build# 这里记得不要有空格
OBJECTS = $(patsubst $(SRC_KERNEL)/%.s, $(OBJ_DIR)/%.o, $(SOUCES_ASM))# 截取字符串，从`SOURCES_KERNEL` 中获取获取`%` 
OBJECTS += $(patsubst $(SRC_KERNEL)/%.c, $(OBJ_DIR)/%.o, $(SOURCES_KERNEL))# 文件路径，将其中符合`$(SRC_KERNEL)/%.c` 的记
OBJECTS += $(patsubst $(SRC_COMMON)/%.c, $(OBJ_DIR)/%.o, $(SOURCES_COMMON)) # 录替换为`$(OBJ_DIR)/%.o`，`%` 表示的部分不变

IMG_NAME = kernel.img


# 5. 编译与链接  
build: $(OBJECTS) $(HEADERS)  # $(OBJECTS) 是一个列表，对应着下面通配符指令
#   echo 前面加@ 表示该条命令不会被回显
	@echo Link:  
	@echo $(OBJECTS)  
	$(CC) -T linker.ld -o $(IMG_NAME) $(LFLAGS) $(OBJECTS)

# 6.1. 编译kernel/%.c  
$(OBJ_DIR)/%.o: $(SRC_KERNEL)/%.c  # 创建对象文件目录，并编译
#   $@     表示目标文件集合，冒号左边的  
#   $^     表示依赖文件集合，冒号右边的，自动去重  
#   $?     表示依赖文件集合，比目标文件新的  
#   $(@D)  表示当前指令的目录部分，mkdir 不能为不存在的目录创建子目录
#   $(@DF) 表示当前指令的文件部分
#   $<     表示依赖目标的第一个目标名字，这里其实就是$(SRC_KERNEL)/%.c 中第一个符合的c 文件
	mkdir -p $(@D) 
	$(CC) $(CFLAGS) -I$(SRC_KERNEL) -I$(HEAD_KERNEL) -c $< -o $@ $(CSRCFLAGS)

# 6.2. 编译kernel/%.s
$(OBJ_DIR)/%.o: $(SRC_KERNEL)/%.s  
	mkdir -p $(@D) 
	$(CC) $(CFLAGS) -I$(SRC_KERNEL) -c $< -o $@

# 6.3. 编译common/%.c 
$(OBJ_DIR)/%.o: $(SRC_KERNEL)/%.c  
	mkdir -p $(@D) 
	$(CC) $(CFLAGS) -I$(SRC_KERNEL) -I$(HEAD_KERNEL) -c $< -o $@ $(CSRCFLAGS)

clean:  
	rm -rf $(OBJ_DIR)
	rm $(IMG_NAME)

run: build  
#  -nographic 可以提供无界面的qemu 但是这样会进入调试模式，不好用
	qemu-system-arm -m 256 -M raspi2 -serial stdio -kernel $(IMG_NAME)
