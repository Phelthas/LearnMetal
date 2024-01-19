//
//  DemoShaderTypes.h
//  DemoMetal1
//
//  Created by billthaslu on 2024/1/18.
//

#ifndef DemoShaderTypes_h
#define DemoShaderTypes_h

#include <simd/simd.h>

typedef enum DemoVertexInputIndex {
    DemoVertexInputIndexVertices = 0,
    DemoVertexInputIndexViewportSize = 1,
} DemoVertexInputIndex;

typedef struct {
    vector_float2 position;
    vector_float4 color;
} Demovertex;

#endif /* DemoShaderTypes_h */
