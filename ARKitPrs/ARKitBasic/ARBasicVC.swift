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
    @IBOutlet weak var sliderX: UISlider!
    @IBOutlet weak var sliderY: UISlider!
    @IBOutlet weak var sliderZ: UISlider!

    @IBOutlet weak var segColor: UISegmentedControl!
    @IBOutlet weak var segForma: UISegmentedControl!

    
    private let arConfig = ARWorldTrackingConfiguration()
    private var vector: SCNVector3!
    private var forma = Forma.caja
    private var colorForma = ColorForma.rojo

    enum Forma {
        case caja
        case piramide
        case capsula
        case toro
        
        var geometria: SCNGeometry {
            switch self {
            case .caja:
                return SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.02)
            case .piramide:
                return SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
            case .capsula:
                return SCNCapsule(capRadius: 0.1, height: 0.3)
            case .toro:
                return SCNTorus(ringRadius: 0.2, pipeRadius: 0.1)
            }
        }
    }
    
    enum ColorForma {
        case rojo
        case verde
        case azul
        case amarillo
        
        var color: UIColor {
            switch self {
            case .rojo:     return UIColor.red
            case .verde:    return UIColor.green
            case .azul:     return UIColor.blue
            case .amarillo: return UIColor.yellow
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onSegForma(segForma)
        onSegColor(segColor)
        onSliderPosition(sliderZ)
        vwScene.session.run(arConfig)
        vwScene.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        vwScene.autoenablesDefaultLighting = true  // Luz por defecto
    }
    
    private func add3Dobject() {
        let node = SCNNode()
        node.geometry = forma.geometria
        node.geometry?.firstMaterial?.diffuse.contents = colorForma.color // Color de la caja
        node.geometry?.firstMaterial?.specular.contents = UIColor.white // Color con el que refleja la luz
        node.position = vector
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
    
    @IBAction func onSegColor(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:  colorForma = .verde
        case 2:  colorForma = .azul
        case 3:  colorForma = .amarillo
        default: colorForma = .rojo
        }
    }
    
    @IBAction func onSegForma(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:  forma = .piramide
        case 2:  forma = .capsula
        case 3:  forma = .toro
        default: forma = .caja
        }
    }
    
    @IBAction func onSliderPosition(_ sender: UISlider) {
        vector = SCNVector3(sliderX.value, sliderY.value, sliderZ.value)
    }
    
}
