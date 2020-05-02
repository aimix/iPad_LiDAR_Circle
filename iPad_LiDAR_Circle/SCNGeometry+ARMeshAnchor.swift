//
//  SCNGeometry+ARMeshAnchor.swift
//  iPad_LiDAR_Circle
//
//  Created by Maxime Montegnies on 4/30/20.
//  Copyright © 2020 Maxime Montegnies. All rights reserved.
//

import SceneKit
import ARKit

extension SCNGeometry {
  public static func fronMeshAnchor (meshAnchor: ARMeshAnchor, material: SCNMaterial)-> SCNGeometry {

    // Mesh Anchor
    let meshGeometry = meshAnchor.geometry

    // Vertices source
    let vertices = meshGeometry.vertices
    let verticesSource = SCNGeometrySource(buffer: vertices.buffer, vertexFormat: vertices.format, semantic: .vertex, vertexCount: vertices.count, dataOffset: vertices.offset, dataStride: vertices.stride)

    // Indices Element
    let faces = meshGeometry.faces
    let facesData = Data(bytesNoCopy: faces.buffer.contents(), count: faces.buffer.length, deallocator: .none)
    let facesElement = SCNGeometryElement(data: facesData, primitiveType: .triangles, primitiveCount: faces.count, bytesPerIndex: faces.bytesPerIndex)

    // Geometry
    let geometry = SCNGeometry(sources: [verticesSource], elements: [facesElement])
    geometry.materials = [material]
    
    return geometry
    
  }
}
