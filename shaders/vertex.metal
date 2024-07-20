#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float3 color [[attribute(1)]];
    float2 texCoord [[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]] [[invariant]];
    float clipDistances [[clip_distance]] [8];
    float pointSize [[point_size]];
    float3 color;
    float2 texCoord [[user(locn0)]];
    float3 normal [[shared]];
    uchar index1 [[render_target_array_index]];
    uint index2 [[viewport_array_index]];
};

[[vertex]]
VertexOut vertexMain(VertexIn in [[stage_in]], uint a_count [[amplification_count]], uint aid [[amplification_id]], uint b_instance [[base_instance]], uint b_vertex [[base_vertex]], uint iid [[instance_id]], uint vid [[vertex_id]]) {
    return {};
}
