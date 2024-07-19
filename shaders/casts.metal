#include <metal_stdlib>
using namespace metal;

void test() {
    int8_t i8 = 0;
    int16_t i16 = 0;
    int32_t i32 = 0;
    uint8_t u8 = 0;
    uint16_t u16 = 0;
    uint32_t u32 = 0;
    half f16 = 0.0;
    float f32 = 0.0;

    // i8
    i8 = i16;
    i8 = i32;
    i8 = u8;
    i8 = u16;
    i8 = u32;
    i8 = f16;
    i8 = f32;

    // i16
    i16 = i8;
    i16 = i32;
    i16 = u8;
    i16 = u16;
    i16 = u32;
    i16 = f16;
    i16 = f32;

    // i32
    i32 = i8;
    i32 = i16;
    i32 = u8;
    i32 = u16;
    i32 = u32;
    i32 = f16;
    i32 = f32;

    // u8
    u8 = i8;
    u8 = i16;
    u8 = i32;
    u8 = u16;
    u8 = u32;
    u8 = f16;
    u8 = f32;

    // u16
    u16 = i8;
    u16 = i16;
    u16 = i32;
    u16 = u8;
    u16 = u32;
    u16 = f16;
    u16 = f32;

    // u32
    u32 = i8;
    u32 = i16;
    u32 = i32;
    u32 = u8;
    u32 = u16;
    u32 = f16;
    u32 = f32;

    // f16
    f16 = i8;
    f16 = i16;
    f16 = i32;
    f16 = u8;
    f16 = u16;
    f16 = u32;
    f16 = f32;

    // f32
    f32 = i8;
    f32 = i16;
    f32 = i32;
    f32 = u8;
    f32 = u16;
    f32 = u32;
    f32 = f16;
}
