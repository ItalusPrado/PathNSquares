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
    
    var squaresQtd : Int!
    var squareSize: Int!
    var ambientSize: Int!
    
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
    
    // View
    
    @IBAction func pressBtn(_ sender: UIButton) {
        if sender == self.randomBtn {
            ambientSize = Int(10+arc4random()%50)
            squaresQtd = Int(2+arc4random()%50)
            squareSize = Int(2+arc4random()%4)
            self.performSegue(withIdentifier: "mainToProblem", sender: self)
        } else {
            self.createAlertView()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToProblem"{
            let nextScene = segue.destination as! SceneKitViewController
            nextScene.squaresQtd = self.squaresQtd
            nextScene.ambientSize = self.ambientSize
            nextScene.squareSize = self.squareSize
            
        }
    }
    // Scene
    
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
    
    func createAlertView(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Ambient Size"
            textField.keyboardType = .numberPad
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Size Squares"
            textField.keyboardType = .numberPad
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Number Squares"
            textField.keyboardType = .numberPad
        }
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: {
            UIAlertAction in
            self.ambientSize = Int(alert.textFields![0].text!)
            self.squareSize = Int(alert.textFields![1].text!)
            self.squaresQtd = Int(alert.textFields![2].text!)
            
            if self.ambientSize <= self.squareSize{
                let newAlert = UIAlertController(title: "Ambient size smaller than Square size", message: "Please choose a bigger ambient size", preferredStyle: UIAlertControllerStyle.alert)
                newAlert.addAction(okAction)
                self.present(newAlert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "mainToProblem", sender: self)
            }
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
