//
//  ARBasicVC.swift
//  ARKitBasic
//
//  Created by Miguel on 15/10/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import UIKit
import ARKit

class ARBasicVC: UIViewController {

    @IBOutlet weak var vwScene: ARSCNView!
    
    let arConfig = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vwScene.session.run(arConfig)
        vwScene.debugOptions = [.showFeaturePoints, .showWorldOrigin]
    }
    
    private func add3Dobject() {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0, 0, -0.4)
        vwScene.scene.rootNode.addChildNode(node)
    }

    private func resetSession() {
        vwScene.session.pause()
        vwScene.scene.rootNode.enumerateChildNodes { (aNode, _) in
            aNode.removeFromParentNode()
        }
        vwScene.session.run(arConfig, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - IBActions
    
    @IBAction func onBtnAddObj(_ sender: UIButton) {
        add3Dobject()
    }
    
    @IBAction func onBtnResetSession(_ sender: UIButton) {
        resetSession()
    }
}
