# Introduction

The AIR (Apple's intermediate representation) format is nothing else than LLVM bytecode. It can be dissassemble with the `llvm-dis` tool. However, assembling the `.ll` file again with `llvm-as` will produce a slightly different bytecode which gives `LLVM ERROR: Invalid bitcode file!` when trying to bundle it into a `.metallib` file. That's because `llvm-dis` automatically adds the `memory(none)` to all functions, but Metal uses LLVM 4.0 which didn't have the attribute yet.

## Example

Let's take a look at a very simple Metal shading language example:

```c++
#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float3 color;
};

constant float2 positions[3] = {float2(0.0, 0.5), float2(-0.5, -0.5), float2(0.5, -0.5)};
constant float3 colors[3] = {float3(1.0, 0.0, 0.0), float3(0.0, 1.0, 0.0), float3(0.0, 0.0, 1.0)};

vertex VertexOut vertexMain(uint vertexID [[vertex_id]]) {
    VertexOut out;
    out.position = float4(positions[vertexID], 0.0, 1.0);
    out.color = colors[vertexID];

    return out;
}

fragment float4 fragmentMain(VertexOut in [[stage_in]]) {
    return float4(in.color, 1.0);
}
```

The corresponding (disassembled) AIR file looks like this:

```ll
; ModuleID = 'shaders/simple.ir'
source_filename = "shaders/simple.metal"
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v16:16:16-v24:32:32-v32:32:32-v48:64:64-v64:64:64-v96:128:128-v128:128:128-v192:256:256-v256:256:256-v512:512:512-v1024:1024:1024-n8:16:32"
target triple = "air64-apple-macosx14.0.0"

@_ZL9positions = internal unnamed_addr addrspace(2) constant [3 x <2 x float>] [<2 x float> <float 0.000000e+00, float 5.000000e-01>, <2 x float> <float -5.000000e-01, float -5.000000e-01>, <2 x float> <float 5.000000e-01, float -5.000000e-01>], align 8
@_ZL6colors = internal unnamed_addr addrspace(2) constant [3 x <3 x float>] [<3 x float> <float 1.000000e+00, float 0.000000e+00, float 0.000000e+00>, <3 x float> <float 0.000000e+00, float 1.000000e+00, float 0.000000e+00>, <3 x float> <float 0.000000e+00, float 0.000000e+00, float 1.000000e+00>], align 16

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define <{ <4 x float>, <3 x float> }> @vertexMain(i32 noundef %0) local_unnamed_addr #0 {
  %2 = zext i32 %0 to i64
  %3 = getelementptr inbounds [3 x <2 x float>], ptr addrspace(2) @_ZL9positions, i64 0, i64 %2
  %4 = load <2 x float>, ptr addrspace(2) %3, align 8, !tbaa !28
  %5 = shufflevector <2 x float> %4, <2 x float> poison, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>
  %6 = shufflevector <4 x float> %5, <4 x float> <float poison, float poison, float 0.000000e+00, float 1.000000e+00>, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  %7 = getelementptr inbounds [3 x <3 x float>], ptr addrspace(2) @_ZL6colors, i64 0, i64 %2
  %8 = load <3 x float>, ptr addrspace(2) %7, align 16, !tbaa !28
  %9 = insertvalue <{ <4 x float>, <3 x float> }> undef, <4 x float> %6, 0
  %10 = insertvalue <{ <4 x float>, <3 x float> }> %9, <3 x float> %8, 1
  ret <{ <4 x float>, <3 x float> }> %10
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define <4 x float> @fragmentMain(<4 x float> %0, <3 x float> %1) local_unnamed_addr #1 {
  %3 = shufflevector <3 x float> %1, <3 x float> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 poison>
  %4 = insertelement <4 x float> %3, float 1.000000e+00, i64 3
  ret <4 x float> %4
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) "approx-func-fp-math"="true" "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-infs-fp-math"="true" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "unsafe-fp-math"="true" }
attributes #1 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) "approx-func-fp-math"="true" "frame-pointer"="all" "min-legal-vector-width"="128" "no-builtins" "no-infs-fp-math"="true" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "unsafe-fp-math"="true" }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5, !6, !7, !8}
!air.vertex = !{!9}
!air.fragment = !{!15}
!air.compile_options = !{!21, !22, !23}
!llvm.ident = !{!24}
!air.version = !{!25}
!air.language_version = !{!26}
!air.source_file_name = !{!27}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 5]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{i32 7, !"air.max_device_buffers", i32 31}
!4 = !{i32 7, !"air.max_constant_buffers", i32 31}
!5 = !{i32 7, !"air.max_threadgroup_buffers", i32 31}
!6 = !{i32 7, !"air.max_textures", i32 128}
!7 = !{i32 7, !"air.max_read_write_textures", i32 8}
!8 = !{i32 7, !"air.max_samplers", i32 16}
!9 = !{ptr @vertexMain, !10, !13}
!10 = !{!11, !12}
!11 = !{!"air.position", !"air.arg_type_name", !"float4", !"air.arg_name", !"position"}
!12 = !{!"air.vertex_output", !"generated(5colorDv3_f)", !"air.arg_type_name", !"float3", !"air.arg_name", !"color"}
!13 = !{!14}
!14 = !{i32 0, !"air.vertex_id", !"air.arg_type_name", !"uint", !"air.arg_name", !"vertexID"}
!15 = !{ptr @fragmentMain, !16, !18}
!16 = !{!17}
!17 = !{!"air.render_target", i32 0, i32 0, !"air.arg_type_name", !"float4"}
!18 = !{!19, !20}
!19 = !{i32 0, !"air.position", !"air.center", !"air.no_perspective", !"air.arg_type_name", !"float4", !"air.arg_name", !"position", !"air.arg_unused"}
!20 = !{i32 1, !"air.fragment_input", !"generated(5colorDv3_f)", !"air.center", !"air.perspective", !"air.arg_type_name", !"float3", !"air.arg_name", !"color"}
!21 = !{!"air.compile.denorms_disable"}
!22 = !{!"air.compile.fast_math_enable"}
!23 = !{!"air.compile.framebuffer_fetch_enable"}
!24 = !{!"Apple metal version 32023.155 (metalfe-32023.155)"}
!25 = !{i32 2, i32 6, i32 0}
!26 = !{!"Metal", i32 3, i32 1, i32 0}
!27 = !{!"/Users/samuliak/Documents/metal-air-docs/shaders/simple.metal"}
!28 = !{!29, !29, i64 0}
!29 = !{!"omnipotent char", !30, i64 0}
!30 = !{!"Simple C++ TBAA"}
```

This document will go over 3 main parts of the shader code:
1. The header
2. The body
3. The metadata

## The header

The header header is rather simple. It contains the following information:
- (debug) Source filename - contains the path to the source file.
- Data layout - TODO
- Target triple - this is a typical LLVM target triple. The format is `<arch>-<vendor>-<system>`. The architecture is always `air64` and the vendor is always `apple`. The system is the operating system the shader is compiled for and it includes version as well. The table of possible values is below:
  | System | Description |
  |--------|-------------|
  | macosxXX.XX.XX | macOS version XX.XX.XX |
  | iosXX.XX.XX | iOS version XX.XX.XX |
  | tvosXX.XX.XX | tvOS version XX.XX.XX |
  | watchosXX.XX.XX | watchOS version XX.XX.XX |

## The body

The body is the main part of the shader. It contains the actual shader code. It uses LLVM 4.0. However, there are some slight differences to the regular LLVM IR. The main differences are:
- Pointers can be qualified with `addrspace(X)`. Specifying no address space is the equivalent of `thread` address space in Metal shading language. The table for valid address spaces can be found below.
- Cast instructions that convert to or from integers and floating-point numbers (i.e. `sitofp`, `fptoui`) are not allowed (TODO: check this). Instead, AIR uses conversion functions from the AIR standard library. The table for valid conversion functions can be found in the [standard library functions](#conversion_functions) section. Extend and truncate instructions like `trunc` and `zext` are supported.

Adress spaces:

| Address space | Description |
|---------------|-------------|
| 1 | device |
| 2 | constant |
| 3 | threadgroup |
| 4 | threadgroup_imageblock |
| 5 | ray_data |
| 6 | object_data |
| none | thread |

### AIR standard library

Every function in the standard library is prefixed with `air.`. The Metal shading language compiler supports calls to these functions by builtins, but the builtins are prefixed with `__metal_` instead. For instance, the `air.discard_fragment` function is equivalent to the `__metal_discard_fragment` builtin in Metal shading language, which in turn is called by the `discard_fragment` function that is meant to be used by programmers. However, it's not always named like this. For instance, `air.atomic.global.store` is called `__metal_atomic_store_explicit` in Metal shading language.

TODO: write about the AIR functions having i1 argument at the end, while the Metal builtins don't have it.

The standard library functions are usually templated, so there are many possible permutations of the same function. Therefore, this document will list the functions in a more general way and provide all possible template types. Many functions will have `<T.signedness>`, which means that if `T` is an integer, it will be either `s` or `u` depending on the signedness of the integer. Otherwise, it will be omitted (together with the `.` before it).

Because the standard library is huge, this section is broken down into several sections.

#### Atomic

TODO

| AIR standard library function | Description | Arguments | Valid template types | Valid address spaces |
| ----------------------------- | ----------- | --------- | -------------------- | -------------------- |
| `void @air.atomic.global.store.<T>(ptr addrspace(X) nocapture, T, i32, i32, i1)` | TODO | TODO | `i32`, `f32` (TODO: can it be `i64` as well?) | `device` or `threadgroup` |
| `T @air.atomic.global.load.<T>(ptr addrspace(X) nocapture, i32, i32, i1)` | TODO | TODO | `i32`, `f32` (TODO: can it be `i64` as well?) | `device` or `threadgroup` |
| `T @air.atomic.global.xchg.<T>(ptr addrspace(X) nocapture, T, i32, i32, i1)` | TODO | TODO | `i32`, `f32` (TODO: can it be `i64` as well?) | `device` or `threadgroup` |
| `T @air.atomic.global.cmpxchg.weak.<T>(ptr addrspace(X) nocapture, ptr nocapture, T, i32, i32, i32, i1)` | TODO | TODO | `i32`, `f32` (TODO: can it be `i64` as well?) | `device` or `threadgroup` |
| `T @air.atomic.global.add.<T.signedness>.<T>(ptr addrspace(X) nocapture, T, i32, i32, i1)` | TODO | TODO | `i32`, `f32` (TODO: can it be `i64` as well?) | `device` or `threadgroup` |
| `T @air.atomic.global.and.<T.signedness>.<T>(ptr addrspace(X) nocapture, T, i32, i32, i1)` | TODO | TODO | `i32` (TODO: can it be `i64` as well?) | `device` or `threadgroup` |
| `T @air.atomic.global.max.<T.signedness>.<T>(ptr addrspace(X) nocapture, T, i32, i32, i1)` | TODO | TODO | `i32` (TODO: can it be `i64` as well?) | `device` or `threadgroup` |
| `T @air.atomic.global.min.<T.signedness>.<T>(ptr addrspace(X) nocapture, T, i32, i32, i1)` | TODO | TODO | `i32` (TODO: can it be `i64` as well?) | `device` or `threadgroup` |
| `T @air.atomic.global.or.<T.signedness>.<T>(ptr addrspace(X) nocapture, T, i32, i32, i1)` | TODO | TODO | `i32` (TODO: can it be `i64` as well?) | `device` or `threadgroup` |
| `T @air.atomic.global.sub.<T.signedness>.<T>(ptr addrspace(X) nocapture, T, i32, i32, i1)` | TODO | TODO | `i32`, `f32` (TODO: can it be `i64` as well?) | `device` or `threadgroup` |
| `T @air.atomic.global.xor.<T.signedness>.<T>(ptr addrspace(X) nocapture, T, i32, i32, i1)` | TODO | TODO | `i32` (TODO: can it be `i64` as well?) | `device` or `threadgroup` |

#### Command buffer

| AIR standard library function | Metal API equivalent | Arguments | Valid template types | Valid address spaces |
| ----------------------------- | ----------- | --------- | -------------------- | -------------------- |
| `i32 @air.get_size_command_buffer(ptr addrspace(X) nocapture readonly)` | TODO | TODO | none | any |
| `void @air.set_pipeline_state_compute_command(ptr addrspace(X) nocapture, i32, ptr addrspace(X) readonly)` | TODO | TODO | none | any |
| `void @air.set_kernel_buffer_compute_command.p1i8(ptr addrspace(X1) nocapture, i32, ptr addrspace(X2), i64, i32)` | TODO | TODO | none | `X1`: any, `X2`: `device` or `constant` |
| `void @air.concurrent_dispatch_threadgroups_compute_command(ptr addrspace(X) nocapture, i32, <3 x i32>, <3 x i32>)` | TODO | TODO | none | any |
| `void @air.concurrent_dispatch_threads_compute_command(ptr addrspace(X) nocapture, i32, <3 x i32>, <3 x i32>)` | TODO | TODO | none | any |
| `void @air.set_barrier_compute_command(ptr addrspace(X) nocapture, i32)` | TODO | TODO | none | any |
| `void @air.clear_barrier_compute_command(ptr addrspace(X) nocapture, i32)` | TODO | TODO | none | any |
| `void @air.set_stage_in_region_compute_command(ptr addrspace(X) nocapture, i32, <3 x i32>, <3 x i32>)` | TODO | TODO | none | any |
| `void @air.set_threadgroup_memory_length_compute_command(ptr addrspace(X) nocapture, i32, i32, i32)` | TODO | TODO | none | any |
| `void @air.set_imageblock_size_compute_command(ptr addrspace(X) nocapture, i32, <2 x i16>)` | TODO | TODO | none | any |
| `void @air.reset_compute_command(ptr addrspace(X) nocapture, i32)` | TODO | TODO | none | any |
| `void @air.copy_compute_command(ptr addrspace(X) nocapture, i32, ptr addrspace(X) nocapture readonly, i32)` | TODO | TODO | none | any |
| `void @air.set_pipeline_state_render_command(ptr addrspace(X) nocapture, i32, ptr addrspace(X) readonly)` | TODO | TODO | none | any |
| `void @air.set_vertex_buffer_render_command.p1i8(ptr addrspace(X1) nocapture, i32, ptr addrspace(X2), i64, i32)` | TODO | TODO | none | `X1`: any, `X2`: `device` or `constant` |
| `void @air.set_fragment_buffer_render_command.p1i8(ptr addrspace(X1) nocapture, i32, ptr addrspace(X2), i32)` | TODO | TODO | none | `X1`: any, `X2`: `device` or `constant` |
| `void @air.set_object_buffer_render_command.p1i8(ptr addrspace(X1) nocapture, i32, ptr addrspace(X2), i32)` | TODO | TODO | none | `X1`: any, `X2`: `device` or `constant` |
| `void @air.set_object_threadgroup_memory_length_render_command(ptr addrspaceX1) nocapture, i32, i32, i32)` | TODO | TODO | none | any |
| `void @air.set_mesh_buffer_render_command.p1i8(ptr addrspace(X1) nocapture, i32, ptr addrspace(X2), i32)` | TODO | TODO | none | `X1`: any, `X2`: `device` or `constant` |
| `void @air.draw_primitives_render_command(ptr addrspace(X) nocapture, i32, i32, i32, i32, i32, i32)` | TODO | TODO | none | any |
| `void @air.draw_indexed_primitives_render_command.p1<T>(ptr addrspace(X1) nocapture, i32, i32, i32, ptr addrspace(X2), i32, i32, i32)` | TODO | TODO | `i16` or `i32` | `X1`: any, `X2`: `device` or `constant` |
| `void @air.draw_patches_render_command.p1i32.p1i8(ptr addrspace(X1) nocapture, i32, i32, i32, i32, ptr addrspace(X2), i32, i32, ptr addrspace(X2), i32, float)` | TODO | TODO | none | `X1`: any, `X2`: `device` or `constant` |
| `void @air.draw_indexed_patches_render_command.p1i32.p1i8.p1i8(ptr addrspace(X1) nocapture, i32, i32, i32, i32, ptr addrspace(x2), ptr addrspace(x2), i32, i32, ptr addrspace(x2), i32, float)` | TODO | TODO | none | `X1`: any, `X2`: `device` or `constant` |
| `void @air.draw_mesh_threadgroups_render_command(ptr addrspace(X) nocapture, i32, <3 x i32>, <3 x i32>, <3 x i32>)` | TODO | TODO | none | any |
| `void @air.draw_mesh_threads_render_command(ptr addrspace(X) nocapture, i32, <3 x i32>, <3 x i32>, <3 x i32>)` | TODO | TODO | none | any |
| `void @air.set_barrier_render_command(ptr addrspace(X) nocapture, i32)` | TODO | TODO | none | any |
| `void @air.clear_barrier_render_command(ptr addrspace(X) nocapture, i32)` | TODO | TODO | none | any |
| `void @air.reset_render_command(ptr addrspace(X) nocapture, i32)` | TODO | TODO | none | any |
| `void @air.copy_render_command(ptr addrspace(1) nocapture, i32, ptr addrspace(1) nocapture readonly, i32)` | TODO | TODO | none | any |

TODO: add the rest of the standard library functions

<a name="conversion_functions"></a>
#### Conversion (special)

| AIR standard library function | LLVM equivalent |
| ----------------------------- | --------------- |
| i8 @air.convert.s.i8.f.f16(half) | fptosi |
| i8 @air.convert.s.i8.f.f32(float) | fptosi |
| i16 @air.convert.s.i16.f.f16(half) | fptosi |
| i16 @air.convert.s.i16.f.f32(float) | fptosi |
| i32 @air.convert.s.i32.f.f16(half) | fptosi |
| i32 @air.convert.s.i32.f.f32(float) | fptosi |
| u8 @air.convert.u.u8.f.f16(half) | fptoui |
| u8 @air.convert.u.u8.f.f32(float) | fptoui |
| u16 @air.convert.u.u16.f.f16(half) | fptoui |
| u16 @air.convert.u.u16.f.f32(float) | fptoui |
| u32 @air.convert.u.u32.f.f16(half) | fptoui |
| u32 @air.convert.u.u32.f.f32(float) | fptoui |
| half @air.convert.f.f16.s.i8(i8) | sitofp |
| half @air.convert.f.f16.s.i16(i8) | sitofp |
| half @air.convert.f.f16.s.i32(i8) | sitofp |
| half @air.convert.f.f16.u.u8(i8) | uitofp |
| half @air.convert.f.f16.u.u16(i8) | uitofp |
| half @air.convert.f.f16.u.u32(i8) | uitofp |
| float @air.convert.f.f32.s.i8(i8) | sitofp |
| float @air.convert.f.f32.s.i16(i8) | sitofp |
| float @air.convert.f.f32.s.i32(i8) | sitofp |
| float @air.convert.f.f32.u.u8(i8) | uitofp |
| float @air.convert.f.f32.u.u16(i8) | uitofp |
| float @air.convert.f.f32.u.u32(i8) | uitofp |

## The metadata

The metadata is the bottom part of the AIR file. It contains the following information:
- LLVM module flags (`llvm.module.flags`) - An array of [module flags](#module_flags).
- (optional) Vertex functions (`air.vertex`) - An array of [vertex functions](#vertex_functions).
- (optional) Fragment functions (`air.fragment`) - An array of [fragment functions](#fragment_functions).
- (optional) Kernerl functions (`air.kernel`) - An array of [kernel functions](#kernel_functions).
- (optional) Mesh functions (`air.mesh`) - An array of [mesh functions](#mesh_functions).
- (optional) Object functions (`air.object`) - An array of [object functions](#object_functions).
- Compile options (`air.compile_options`) - An array of [compile options](#compile_options).
- LLVM identifier (`llvm.ident`) - A string identifying the Metal compiler. See [below](#llvm_identifier).
- AIR version (`air.version`) - A 3 element array containing the major, minor and patch version of the AIR file format.
- Source language (`air.language_version`) - A 4 element array containing the name of the source language and the major, minor and patch version of the source language.
- Source filename (`air.source_file_name`) - The path to the source file.

<a name="module_flags"></a>
TODO

### Entry points

The entry points are the functions that are called by the Metal API. In the context of the AIR metadata, an entry point is an array containing the following information:
- The function pointer to be called by the Metal API.
- (optional) An array of outputs (except for `kernel` entry points) - stage-specific
- (optional) An array of inputs - These contain the stage-specific inputs as well as the general inputs that are described [below](#general_inputs).
- (optional) An array of attributes - These contain the stage-specific attributes (for instance patch type and control point count in case of post-tesselation vertex function). See the [attributes] section of the corresponding stage.

Each input and output can have both positional and named arguments. Positional arguments and named arguments can interleave (TODO: check this). Named arguments are specified as 2 arguments with the first one being the name of the argument and the second one being the value of the argument. Each argument can have the following 2 named arguments:

| Argument | Valid types | Possible values | Description | Mandatory |
| -------- | ----------- | --------------- | ----------- | --------- |
| `air.arg_type_name` | any | any | The name of the type of the argument. | no (debug) |
| `air.arg_name` | any | any | The name of the argument. | no (debug) |

TODO: format this nicely
Note: The `Valid types` column refers to the types that the argument can have.

Additionally, every input must have the following positional arguments:
| Argument | Valid types | Possible values | Description | Mandatory |
| -------- | ----------- | --------------- | ----------- | --------- |
| `0` | `i32` | any | The index of the input in the function signature. | yes |

Since the 0th positional argument is mandatory for every input, it won't be mentioned in this document more.

<a name="general_inputs"></a>
#### General inputs

TODO

<a name="vertex_functions"></a>
#### Vertex functions

TODO

TODO: write about void vertex functions

##### Attributes
| Argument | Possible values | Description | Mandatory |
| -------- | --------------- | ----------- | --------- |
| `air.patch` | `triangle`, `quad` | The type of the patch. | yes |
| `air.control_point_count` | `<0..32>` | The number of control points in the patch. | no |

##### Inputs
| Argument | Valid types | Possible values | Description | Mandatory |
| -------- | ----------- | --------------- | ----------- | --------- |
| `1` (if `air.patch` attribute not specified) | `ushort`, `uint` | `air.amplification_count`, `air.amplification_id`, `air.base_instance`, `air.base_vertex`, `air.instance_id`, `air.vertex_id`, `air.vertex_input`,  | Specifies wether the input is builtin (and which builtin) or user defined. | yes |
| `1` (if `air.patch` attribute specified) | (`ushort`, `uint` if `air.base_instance`, `air.instance_id` or `air.patch_id`), (`float3` if `air.position_in_patch` and patch type is `triangle`, otherwise `float2`) | `air.base_instance`, `air.instance_id`, `air.patch_id`, `air.position_in_patch`,  | Specifies wether the input is builtin (and which builtin) or user defined. | yes |
| `air.location_index` (if `1` is `air.vertex_input`) | any | any `i32` | The location index of the vertex input used to match with vertex inputs specified using vertex descriptor in the Metal API. | yes |
| `2` | any | seems to always be 1 (TODO: check this) | ? | ? |

##### Outputs
| Argument | Valid types | Possible values | Description | Mandatory |
| -------- | ----------- | --------------- | ----------- | --------- |
| `0` | (`float4` if `air.position`), (`float`, `float[N]` if `air.clip_distance`), (`float` if `air.point_size`), otherwise any | `air.position`, `air.clip_distance`, `air.point_size`, `air.vertex_output` | Specifies wether the output is builtin (and which builtin) or user defined. | yes |
| `1` (if `0` is `air.position`) | `float4` | `air.invariant` | If specified, the output is assumed to be the same for every vertex in a draw call. | no |
| `1` (if `0` is `air.vertex_output`) | any | any `str` (TODO: can this really be anything?) | The string used to match the vertex output with the corresponding fragment input. | yes |
| `2` | any | 'air.shared' | If specified, the output is assumed to be the same for every vertex in a draw call. | no |
| `air.clip_distance_array_size` (if `0` is `air.clip_distance`) | `float`, `float[N]` | any `i32` | Specifies the size of the clip distance array. If not present, the output must not have an array type. | no |

<a name="fragment_functions"></a>
#### Fragment functions

TODO

<a name="kernel_functions"></a>
#### Kernel functions

TODO

<a name="mesh_functions"></a>
#### Mesh functions

TODO

<a name="object_functions"></a>
#### Object functions

TODO

<a name="compile_options"></a>
TODO

<a name="llvm_identifier"></a>
