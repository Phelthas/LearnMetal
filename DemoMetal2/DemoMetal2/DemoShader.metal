//
//  DemoShader.metal
//  DemoMetal2
//
//  Created by billthaslu on 2024/1/23.
//

#include <metal_stdlib>
#include "DemoShaderType.h"
using namespace metal;


struct RasterizerData {
    float4 position [[position]];
    float2 textureCoordinate;
};

vertex RasterizerData vertexShader(const uint vertexID [[vertex_id]],
                                   constant DemoShaderVertex *vertices [[buffer(DemoShaderVertexInputIndexVertices)]]) {
    RasterizerData out;
    out.position = vector_float4(vertices[vertexID].position.x, vertices[vertexID].position.y, 0.0, 1.0);
    out.textureCoordinate = vertices[vertexID].textureCoordinate;
    return out;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]],
                               texture2d<half> colorTexture [[texture(DemoShaderTextureIndexBaseColor)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);
    const half4 colorSample = colorTexture.sample(textureSampler, in.textureCoordinate);
    return float4(colorSample);
}
