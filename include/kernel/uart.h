#include <stddef.h>
#include <stdint.h>

#ifndef __UART_H__
#define __UART_H__

// 串口表示寄存器，32 位
typedef union Uart_flags
{
    struct
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

#endif

void test_union()
{
    uart_flags_t f;
    f.clear_to_send = 1;
}