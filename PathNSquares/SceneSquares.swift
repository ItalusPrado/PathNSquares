//
//  SceneSquares.swift
//  PathNSquares
//
//  Created by Italus Rodrigues do Prado on 09/09/17.
//  Copyright © 2017 Italus Rodrigues do Prado. All rights reserved.
//

import UIKit
import SceneKit

class SceneSquares: SCNScene {
    
    var ball : SCNNode!
    var boxVertex = [BoxNode]()
    var vertex = [Vertex]()
    var info = [[Int]]()
    
    init(withData data: [[Int]], vertexData vertex: [Vertex]) {
        self.vertex = vertex
        self.info = data
        
        super.init()
        
        self.configureLight()
        self.generateBoxes(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBall(position: [Int]){
        let geometry = SCNSphere(radius: 0.1)
        geometry.materials.first?.diffuse.contents = UIColor.black
        
        self.ball = SCNNode(geometry: geometry)
        self.ball.position = SCNVector3(CGFloat(position[0]),0.5,CGFloat(position[1]))
        
        self.rootNode.addChildNode(self.ball)
    }
    
    func showPath(path: [[Int]]){
        var pathBall = path
        let remove = SCNAction.run { _ in
            let move = SCNAction.move(to: SCNVector3(CGFloat(pathBall.last![0]),0.5,CGFloat(pathBall.last![1])), duration: 2)
            self.ball.runAction(move)
            pathBall.removeLast()
        }
        let wait = SCNAction.wait(duration: 3)
        let repeatAction = SCNAction.repeat(SCNAction.sequence([remove,wait]), count: path.count)
        if !path.isEmpty{
            self.rootNode.runAction(repeatAction)
        }
    }
    
    func generateBoxes(data: [[Int]]){
        
        for line in 0..<data.count{
            var node : BoxNode!
            for col in 0..<data[0].count{
                if data[line][col] == 0{
                    node = BoxNode(size: 1, color: .white, position: [line,col])
                } else if data[line][col] == 1{
                    node = BoxNode(size: 1, color: .red, position: [line,col])
                } else if data[line][col] == 3 {
                    node = BoxNode(size: 1, color: .blue, position: [line,col])
                    boxVertex.append(node)
                } else {
                    node = BoxNode(size: 1, color: .green, position: [line,col])
                    boxVertex.append(node)
                    
                }
                self.rootNode.addChildNode(node)
            }
        }
        setSuccessorOnBox()
    }
    
    func setSuccessorOnBox(){
        for vertexPoint in self.vertex{
            for box in self.boxVertex{
                if box.positionBox == vertexPoint.state{
                    for successor in vertexPoint.sucessors{
                        for boxSuccessor in self.boxVertex{
                            if successor.state == boxSuccessor.positionBox{
                                box.successorsBox.append(boxSuccessor)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func configureLight(){
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: Float(self.info[0].count/2), y: 30, z: 10)
        self.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        self.rootNode.addChildNode(ambientLightNode)
    }
}
