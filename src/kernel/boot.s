.section ".text.boot"

.global _start

_start:
    @ ARM 芯片中，存储系统是由协处理器CP15 完成的
    @ 读取协处理器寄存器CP15
    
    mrc p15, #0, r1, c0, c0, #5  @ 读取CP15 中的c0 到主处理器的r1 
    and r1, r1, #3  @ 猜测应该是获取协处理器的编号
    cmp r1, #0
    bne halt  @ 设置只有主处理器运行  

    mov sp, #0x8000  @ 设置堆栈的栈顶指针

    ldr r4, =__bss_start  @ 设置bss 段的范围
    ldr r9, =__bss_end
    mov r5, #0  @ 载入立即数
    mov r6, #0
    mov r7, #0
    mov r8, #0
    b       2f  @ 无条件跳转 到标签2 forward

1:
    stmia r4!, {r5-r8} @ 将r5-r8 的数据提取出来，放到r4 指向的区域

2:
    cmp r4, r9
    blo 1b      @ branch low 跳转到标签1 backward  

    ldr r3, =kernel_main  @ 获取C 入口函数地址
    blx r3  @ 带返回和状态切换的跳转指令，类似于call

halt:
    wfe  @ WFI(Wait for interrupt)和WFE(Wait for event)
    b halt
