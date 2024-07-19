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
#define TEST_TEMPLATE__ATOMIC_SCALARS_NO_FP(template_func) \
template_func(int); \
template_func(uint); \
/*template_func(ulong);*/

#define TEST_TEMPLATE__ATOMIC_SCALARS(template_func) \
TEST_TEMPLATE__ATOMIC_SCALARS_NO_FP(template_func) \
template_func(float);

void testAtomic(float f32) {
#define ATOMIC_STORE_EXPLICIT(type) __metal_atomic_store_explicit((device type*)nullptr, type(0), int(0), __METAL_MEMORY_SCOPE_DEVICE__)
    TEST_TEMPLATE__ATOMIC_SCALARS(ATOMIC_STORE_EXPLICIT);

#define ATOMIC_LOAD_EXPLICIT(type) __metal_atomic_load_explicit((device type*)nullptr, int(0), __METAL_MEMORY_SCOPE_DEVICE__)
    TEST_TEMPLATE__ATOMIC_SCALARS(ATOMIC_LOAD_EXPLICIT);

#define ATOMIC_EXCHANGE_EXPLICIT(type) __metal_atomic_exchange_explicit((device type*)nullptr, type(0), int(0), __METAL_MEMORY_SCOPE_DEVICE__)
    TEST_TEMPLATE__ATOMIC_SCALARS(ATOMIC_EXCHANGE_EXPLICIT);

#define ATOMIC_COMPARE_EXCHANGE_WEAK_EXPLICIT(type) __metal_atomic_compare_exchange_weak_explicit((device type*)nullptr, (thread type*)nullptr, type(0), int(0), int(0), __METAL_MEMORY_SCOPE_DEVICE__)
    TEST_TEMPLATE__ATOMIC_SCALARS(ATOMIC_COMPARE_EXCHANGE_WEAK_EXPLICIT);

#define ATOMIC_FETCH_ADD_EXPLICIT(type) __metal_atomic_fetch_add_explicit((device type*)nullptr, type(0), int(0), __METAL_MEMORY_SCOPE_DEVICE__)
    TEST_TEMPLATE__ATOMIC_SCALARS(ATOMIC_FETCH_ADD_EXPLICIT);

#define ATOMIC_FETCH_AND_EXPLICIT(type) __metal_atomic_fetch_and_explicit((device type*)nullptr, type(0), int(0), __METAL_MEMORY_SCOPE_DEVICE__)
    TEST_TEMPLATE__ATOMIC_SCALARS_NO_FP(ATOMIC_FETCH_AND_EXPLICIT);

#define ATOMIC_FETCH_MAX_EXPLICIT(type) __metal_atomic_fetch_max_explicit((device type*)nullptr, type(0), int(0), __METAL_MEMORY_SCOPE_DEVICE__)
    TEST_TEMPLATE__ATOMIC_SCALARS_NO_FP(ATOMIC_FETCH_MAX_EXPLICIT);

#define ATOMIC_FETCH_MIN_EXPLICIT(type) __metal_atomic_fetch_min_explicit((device type*)nullptr, type(0), int(0), __METAL_MEMORY_SCOPE_DEVICE__)
    TEST_TEMPLATE__ATOMIC_SCALARS_NO_FP(ATOMIC_FETCH_MIN_EXPLICIT);

#define ATOMIC_FETCH_OR_EXPLICIT(type) __metal_atomic_fetch_or_explicit((device type*)nullptr, type(0), int(0), __METAL_MEMORY_SCOPE_DEVICE__)
    TEST_TEMPLATE__ATOMIC_SCALARS_NO_FP(ATOMIC_FETCH_OR_EXPLICIT);

#define ATOMIC_FETCH_SUB_EXPLICIT(type) __metal_atomic_fetch_sub_explicit((device type*)nullptr, type(0), int(0), __METAL_MEMORY_SCOPE_DEVICE__)
    TEST_TEMPLATE__ATOMIC_SCALARS(ATOMIC_FETCH_SUB_EXPLICIT);

#define ATOMIC_FETCH_XOR_EXPLICIT(type) __metal_atomic_fetch_xor_explicit((device type*)nullptr, type(0), int(0), __METAL_MEMORY_SCOPE_DEVICE__)
    TEST_TEMPLATE__ATOMIC_SCALARS_NO_FP(ATOMIC_FETCH_XOR_EXPLICIT);
}

void testCommandBuffer() {
    __metal_command_buffer_t commandBuffer;
    __metal_compute_pipeline_state_t computePipelineState;

    __metal_get_size_command_buffer(commandBuffer);

    __metal_set_pipeline_state_compute_command(commandBuffer, 0, computePipelineState);

    __metal_set_kernel_buffer_compute_command(commandBuffer, 0, (device void*)nullptr, 0, 0);

    __metal_concurrent_dispatch_threadgroups_compute_command(commandBuffer, 0, uint3(0), uint3(0));

    __metal_concurrent_dispatch_threads_compute_command(commandBuffer, 0, uint3(0), uint3(0));

    __metal_set_barrier_compute_command(commandBuffer, 0);

    __metal_clear_barrier_compute_command(commandBuffer, 0);
}
