//
//  DemoShaderType.h
//  DemoMetal2
//
//  Created by billthaslu on 2024/1/22.
//

#ifndef DemoShaderType_h
#define DemoShaderType_h

#include <simd/simd.h>

typedef enum DemoShaderVertexInputIndex {
    DemoShaderVertexInputIndexVertices = 0,
    DemoShaderVertexInputIndexViewportSize = 1,
} DemoShaderVertexInputIndex;

typedef enum DemoShaderTextureIndex {
    DemoShaderTextureIndexBaseColor = 0,
} DemoShaderTextureIndex;

typedef struct {
    vector_float2 position;
    vector_float2 textureCoordinate;
} DemoShaderVertex;

#endif /* DemoShaderType_h */
