#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float3 color;
};

constant float2 positions[3] = {float2(0.0, 0.5), float2(-0.5, -0.5), float2(0.5, -0.5)};
constant float3 colors[3] = {float3(1.0, 0.0, 0.0), float3(0.0, 1.0, 0.0), float3(0.0, 0.0, 1.0)};

vertex VertexOut vertexMain(uint vid [[vertex_id]]) {
    VertexOut out;
    out.position = float4(positions[vid], 0.0, 1.0);
    out.color = colors[vid];

    return out;
}

fragment float4 fragmentMain(VertexOut in [[stage_in]]) {
    return float4(in.color, 1.0);
}
