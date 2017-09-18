//
//  MainViewController.swift
//  PathNSquares
//
//  Created by Italus Rodrigues do Prado on 14/09/17.
//  Copyright © 2017 Italus Rodrigues do Prado. All rights reserved.
//

import UIKit
import SceneKit

class MainViewController: UIViewController {

    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var randomBtn: UIButton!
    @IBOutlet weak var chooseBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createScene()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.randomBtn.layer.cornerRadius = self.randomBtn.frame.size.height/4
        self.chooseBtn.layer.cornerRadius = self.randomBtn.layer.cornerRadius
        
        self.randomBtn.clipsToBounds = true
        self.chooseBtn.clipsToBounds = true
    }
    
    func createScene(){
        let scene = SCNScene()
        self.scnView.scene = scene
        
        // Center point
        let centerNode = SCNNode(geometry: SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0))
        centerNode.position = SCNVector3(0,0,0)
        centerNode.physicsBody = SCNPhysicsBody.dynamic()
        centerNode.physicsBody?.isAffectedByGravity = false
        centerNode.physicsBody?.angularDamping = 0
        centerNode.physicsBody?.angularVelocity = SCNVector4(1,1,1,0.2)
        scene.rootNode.addChildNode(centerNode)
        
        // Camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0,0,10)
        centerNode.addChildNode(cameraNode)
        scnView.pointOfView = cameraNode
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(0,0,10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        squares()
        
    }
    
    func squares(){
        
        for i in -4...4{
            for j in -4 ... 4{
                let position = SCNVector3(i*2,j*2,5-Int(arc4random()%10))
                
                let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
                box.materials.first?.diffuse.contents = UIColor.red
                let node = SCNNode(geometry: box)
                node.position = position
                
                node.physicsBody = SCNPhysicsBody.dynamic()
                node.physicsBody?.categoryBitMask = i
                node.physicsBody?.collisionBitMask = i
                node.physicsBody?.isAffectedByGravity = false
                node.physicsBody?.angularDamping = 0
                node.physicsBody?.angularVelocity = SCNVector4(Float(arc4random()%2),1,Float(arc4random()%2),0.5)
                self.scnView.scene?.rootNode.addChildNode(node)
            }
            
        }
        
    }
}
