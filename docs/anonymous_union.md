在C 语言中可以定义`Union` 来存储不同类型的数据。但是该类型的变量只能在函数体中声明。在嵌入式系统开发的过程中，可以通过将匿名位域（一种特殊的结构体）和无符号整型组合成一个`Union`，这样就可以通过两种不同的方式来操作数据了。  

```c
// 串口表示寄存器，32 位
typedef union Uart_flags
{
    struct  // 匿名结构，这样可以通过union 名直接访问内部变量
    {
        uint8_t clear_to_send : 1;
        uint8_t data_set_ready : 1;
        uint8_t data_carrier_detected : 1;
        uint8_t busy : 1;
        uint8_t receive_queue_empty : 1;
        uint8_t transmit_queue_full : 1;
        uint8_t receive_queuq_full : 1;
        uint8_t transmit_queue_empty : 1;
        uint8_t ring_indicator : 1;
        uint32_t padding : 23;
    };
    uint32_t as_int;
} uart_flags_t;

// 如果定义为全局变量，则会报错
void test_union()
{
    uart_flags_t f;
    f.clear_to_send = 1;
}
```