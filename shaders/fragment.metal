#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]] [[center_no_perspective]];
    float4 color [[flat]];
    float2 texCoord [[center_perspective]];
    float3 normal [[sample_no_perspective]];
};

struct FragmentOut {
    float4 color0 [[color(0)]];
    float4 color1 [[color(1)]];
};

[[fragment]]
FragmentOut fragmentMain(VertexOut in [[stage_in]],
                         ushort a_count [[amplification_count]],
                         ushort aid [[amplification_id]],
                         float2 coord [[barycentric_coord]],
                         float4 prevColor [[color(0)]],
                         bool front [[front_facing]],
                         float2 p_coord [[point_coord]],
                         uint pid [[primitive_id]],
                         ushort rtg_index [[render_target_array_index]],
                         uint sid [[sample_id]],
                         uint s_mask [[sample_mask]],
                         uint t_index_in_threadgroup [[thread_index_in_quadgroup]],
                         uint t_index_in_simdgroup [[thread_index_in_simdgroup]],
                         uint t_per_simdgroup [[threads_per_simdgroup]],
                         uint vp_index [[viewport_array_index]]) {
    return {};
}
