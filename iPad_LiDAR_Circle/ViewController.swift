//
//  ViewController.swift
//  iPad_LiDAR_Circle
//
//  Created by Maxime Montegnies on 4/30/20.
//  Copyright © 2020 Maxime Montegnies. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

  @IBOutlet weak var arSceneView: ARSCNView!
  @IBOutlet weak var InfoScanning: UIVisualEffectView!

  let customMaterial: SCNMaterial = SCNMaterial()
  var sceneAnchors = Dictionary<UUID, SCNNode>()

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUpMaterial()
  }

  func setUpMaterial(){
    let program = SCNProgram()
    program.vertexFunctionName = "myVertex"
    program.fragmentFunctionName = "myFragment"
    customMaterial.program = program
    customMaterial.blendMode = .screen
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    arSceneView.delegate = self
    arSceneView.session.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //
    let configuration = ARWorldTrackingConfiguration()
    guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else {return}
    configuration.sceneReconstruction = .mesh
    arSceneView.session.run(configuration)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    arSceneView.session.pause()
  }

  func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    for anchor in anchors{
      var scnNode: SCNNode?
      if let meshAnchor = anchor as? ARMeshAnchor {
        let scnGeo = SCNGeometry.fronMeshAnchor(meshAnchor: meshAnchor, material: customMaterial)
        scnNode = SCNNode(geometry: scnGeo)
        if let node = scnNode {
          node.simdTransform = anchor.transform
          sceneAnchors[anchor.identifier] = node
          arSceneView.scene.rootNode.addChildNode(node)
        }
      }
    }
  }

  func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    InfoScanning.isHidden = true
    for anchor in anchors {
      if let node = sceneAnchors[anchor.identifier] {
        if let meshAnchor = anchor as? ARMeshAnchor {
          node.geometry = SCNGeometry.fronMeshAnchor(meshAnchor: meshAnchor, material: customMaterial)
          node.geometry?.materials[0] = self.customMaterial
        }
        node.simdTransform = anchor.transform
      }
    }
  }
  
}
