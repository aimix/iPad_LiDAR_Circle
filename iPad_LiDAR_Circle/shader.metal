//
//  shader.metal
//  iPad_LiDAR_Circle
//
//  Created by Maxime Montegnies on 4/30/20.
//  Copyright © 2020 Maxime Montegnies. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

struct MyNodeBuffer {
    float4x4 modelViewTransform;
    float4x4 modelViewProjectionTransform;
};

typedef struct {
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
} MyVertexInput;

struct SimpleVertex
{
    float4 position [[position]];
    float distance;
};

vertex SimpleVertex myVertex(MyVertexInput in [[ stage_in ]], constant MyNodeBuffer& scn_node [[buffer(1)]]) {
    SimpleVertex vert;
    vert.position = scn_node.modelViewProjectionTransform * float4(in.position, 1.0);
    vert.distance = length((scn_node.modelViewTransform * float4(in.position, 1.0)).xyz);
    return vert;
}

float edgeRadius(float radius, float size, float d){
  return smoothstep(radius + size, radius, d) * smoothstep(radius - size, radius, d);
}

fragment half4 myFragment(SimpleVertex in [[stage_in]])
{
    half4 color;
    float maxDistance = 2.0;
    float _distance = in.distance/maxDistance;
    float edge = edgeRadius(0.95, 0.015, _distance);
    color = half4(edge ,0.0 ,0.0, 1.0);
    return color;
}
