#include <metal_stdlib>
using namespace metal;

#define TEST_TEMPLATE__SCALARS(template_func) \
template_func(bool); \
template_func(int8_t); \
template_func(int16_t); \
template_func(int32_t); \
template_func(int64_t); \
template_func(uint8_t); \
template_func(uint16_t); \
template_func(uint32_t); \
template_func(uint64_t); \
template_func(half); \
template_func(float);

// TODO: ucomment ulong
#define TEST_TEMPLATE__ATOMIC_SCALARS(template_func) \
template_func(int); \
template_func(uint); \
/*template_func(ulong);*/ \
template_func(float);

void testAtomic(float f32) {
#define ATOMIC_STORE_EXPLICIT(addrspace, mem_scope, type) __metal_atomic_store_explicit((addrspace type*)nullptr, type(0), int(0), mem_scope)
#define ATOMIC_STORE_EXPLICIT__THREADGROUP(type) ATOMIC_STORE_EXPLICIT(threadgroup, __METAL_MEMORY_SCOPE_THREADGROUP__, type)
#define ATOMIC_STORE_EXPLICIT__DEVICE(type) ATOMIC_STORE_EXPLICIT(device, __METAL_MEMORY_SCOPE_DEVICE__, type)
    // TODO: uncomment
    //TEST_TEMPLATE__ATOMIC_SCALARS(ATOMIC_STORE_EXPLICIT__THREADGROUP)
    TEST_TEMPLATE__ATOMIC_SCALARS(ATOMIC_STORE_EXPLICIT__DEVICE);

#define ATOMIC_LOAD_EXPLICIT(addrspace, mem_scope, type) __metal_atomic_load_explicit((addrspace type*)nullptr, int(0), mem_scope)
#define ATOMIC_LOAD_EXPLICIT__THREADGROUP(type) ATOMIC_LOAD_EXPLICIT(threadgroup, __METAL_MEMORY_SCOPE_THREADGROUP__, type)
#define ATOMIC_LOAD_EXPLICIT__DEVICE(type) ATOMIC_LOAD_EXPLICIT(device, __METAL_MEMORY_SCOPE_DEVICE__, type)
    // TODO: uncomment
    //TEST_TEMPLATE__ATOMIC_SCALARS(ATOMIC_LOAD_EXPLICIT__THREADGROUP)
    TEST_TEMPLATE__ATOMIC_SCALARS(ATOMIC_LOAD_EXPLICIT__DEVICE);
}
