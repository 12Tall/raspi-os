
## GCC 汇编语句  

```c
/* 等效NOP */  
asm("mov r0, r0");  

/* 代码美化 */  
asm(
    "mov r0, r0\n\t"
    "mov r0, r0\n\t"
    "mov r0, r0\n\t"
    "mov r0, r0"
);
```

## 掺杂C 表达式的形式   
```c
asm(code : output operand list : input operand list : clobber list: label list);
/* 代码: 输出操作数: 输入操作数: clobbered 寄存器列表: 标签 */

/* 循环移位示例（禁止编译器优化） */
int x, y ;
asm volatile (
    "mov %[result], %[value], ror #1" // 汇编指令
    : [result] "=r" (y)   // 输出result
    : [value] "r" (x)     // 输入x
    );   
```
操作数通过`%` 进行引用，并且可以不指定寄存器或者内存地址。完全由编译器决定。并且操作数具有独立的命名空间，仅在当前汇编代码段中可以使用。  

### 操作数修饰符  
- 约束： 主要是指操作数的类型，常用的是`r` 表示使用寄存器  
- 修饰：用于修饰操作数的可操作性：  
    - `=` 只写操作数  
    - `+` 读写操作数，常用于输出操作数  
    - `&` 仅用于输出寄存器，当汇编代码中可能占用寄存器的情况
一般来说，输出操作数是只写的，输入是只读的。  
```c  
/* 当输入操作数与输出操作数相同时，可以采用`+r` 修饰输出操作数并省略输入操作数 */
asm("mov %[value], %[value], ror #1" : [value] "+r" (y));
```

### clobbered 寄存器列表  
大概表示受影响的寄存器列表，除了`r0~r15` 之外，还有两个特殊的情况`memory` 表示内存已修改；`cc` 表示`FLAG` 寄存器被修改。

## 参考资料  
1. [GCC's assembler syntax](https://www.felixcloutier.com/documents/gcc-asm.html)  
2. [扩展asm](https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html)