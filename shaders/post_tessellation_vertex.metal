#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]] [[invariant]];
    float clipDistances [[clip_distance]] [8];
    float pointSize [[point_size]];
    float3 color;
    float2 texCoord [[user(locn0)]];
    float3 normal [[shared]];
};

[[vertex, patch(triangle, 8)]]
VertexOut vertexMain(VertexIn in [[stage_in]], uint b_instance [[base_instance]], uint iid [[instance_id]], ushort pid [[patch_id]], float3 pos_in_patch [[position_in_patch]]) {
    VertexOut out;
    out.position = in.position;

    return out;
}
