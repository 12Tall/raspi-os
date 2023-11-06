#include <kernel/time.h>

void delay(uint32_t count)
{
    asm volatile(
        /*%= 用于每次内联汇编时生成唯一的标识符，如`__delay_01:`*/
        "__delay_%=: \n\t subs %[count], %[count], #1 \n\t bne __delay_%=\n\t"
        : [count] "+r"(count)
        :
        : "cc");
}