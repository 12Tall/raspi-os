/* 程序入口 */
ENTRY(_start) 
 
/* 段设置 */
SECTIONS
{
    /* 所有段的默认偏移地址 */
    . = 0x8000;
    /* 设置标签地址等于当前地址`0x8000` */
    __start = .;
    __text_start = .;

    /* 将所有的`.text.boot` 和`.text` 段汇总为`.text` 段 */
    .text :
    {
        /* KEEP 表示禁止编译器优化 */
        /* 另有PROVIDE 定义一个全局符号表，方便其他c 文件引用 */
        KEEP(*(.text.boot)) 
        *(.text)
    }
    /* 段按4096 字节对齐 */
    . = ALIGN(4096); 
    __text_end = .;
 
    /* 同样设置只读数据段 */
    __rodata_start = .;
    .rodata :
    {
        *(.rodata)
    }
    . = ALIGN(4096); 
    __rodata_end = .;
 
    /* 设置数据段（初始化） */
    __data_start = .;
    .data :
    {
        *(.data)
    }
    . = ALIGN(4096); 
    __data_end = .;
 
    /* 数据段（未初始化） */
    __bss_start = .;
    .bss :
    {
        bss = .;
        *(.bss)
    }
    . = ALIGN(4096); 
    __bss_end = .;
    __end = .;
}