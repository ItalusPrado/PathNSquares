//
//  SceneKitViewController.swift
//  PathNSquares
//
//  Created by Italus Rodrigues do Prado on 09/09/17.
//  Copyright © 2017 Italus Rodrigues do Prado. All rights reserved.
//

import UIKit
import SceneKit

class SceneKitViewController: UIViewController {

    @IBOutlet weak var scnView: SCNView!
    
    let ambient = Ambient(ambientSize: 40, squaresQtd: 20)
    var linePath = [[Int]]()
    var scene : SceneSquares!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data do problema
        ambient.printAmbient()
        ambient.prepareSucessors()
        
        // Visual do problema
        linePath = createPath()
        configSceneView()
        self.scene.setBall(position: linePath.last!)
        self.scene.showPath(path: linePath)
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        createPathLine()
    }
    
    func createPath() -> [[Int]]{
        var states = [Vertex: [Vertex]]()
        
        for vertex in self.ambient.getVertex() {
            states[vertex] = vertex.sucessors
        }
        
        let initialState = self.ambient.getVertex().first?.state
        let finalState = self.ambient.getVertex().last?.state
        
        print("\nInitial State:")
        print(initialState!)
        print("Final State:")
        print(finalState!)
        
        let agent = Agent(initialState: initialState!, finalState: finalState!, states: states)
        
        print("\nTESTE DE BUSCA DE LARGURA\n")
        let path = agent.problemSolvingWithBreadthSearch()
        print(path)
        return path
    }
    
    func configSceneView(){
        self.scene = SceneSquares(withData: ambient.returnAmbient(), vertexData: ambient.getVertex())
        
        self.scnView.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        self.scnView.scene = scene
        self.scnView.showsStatistics = true
        
        // CAMERA
        scnView.allowsCameraControl = true
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(ambient.returnAmbient().count/2,ambient.returnAmbient().count,ambient.returnAmbient().count/2)
        cameraNode.eulerAngles = SCNVector3(-Double.pi/2,0,0)
        self.scnView.scene?.rootNode.addChildNode(cameraNode)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            if let node = result.node as? BoxNode{
                
                for nodeInfo in node.successorsBox{
                    let material = nodeInfo.geometry!.firstMaterial!
                    // highlight it
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.5
                    
                    // on completion - unhighlight
                    SCNTransaction.completionBlock = {
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = 0.5
                        
                        material.emission.contents = UIColor.black
                        
                        SCNTransaction.commit()
                    }
                    
                    material.emission.contents = UIColor.red
                    
                    SCNTransaction.commit()
                }
                
            }
            
        }
    }

    //MARK: Create Line Functions
    func createPathLine() {
        for i in 0..<linePath.count-1 {
            createLine(between: linePath[i], and: linePath[i+1])
        }
    }
    
    func createLine(between point1: [Int], and point2: [Int]) {
        let vector1 = SCNVector3(point1[0],0,point1[1])
        let vector2 = SCNVector3(point2[0], 0, point2[1])
        let twoPointsNode1 = SCNNode()
        scene.rootNode.addChildNode(twoPointsNode1.buildLineInTwoPointsWithRotation(
            from: vector1, to: vector2, radius: 0.6, color: .gray))
    }
}
