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
    
    @IBOutlet weak var depth: UIButton!
    @IBOutlet weak var breadth: UIButton!
    @IBOutlet weak var bidirectional: UIButton!
    @IBOutlet weak var uniform: UIButton!
    @IBOutlet weak var greedy: UIButton!
    @IBOutlet weak var aStar: UIButton!
    
    
    var ambientSize : Int!
    var squaresQtd : Int!
    var squareSize: Int!
    var ambient : Ambient!
    var linePath = [[Int]]()
    var scene : SceneSquares!
    var buttonActivated = [0,0,0,0,0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ambient = Ambient(ambientSize: ambientSize, squaresQtd: squaresQtd, squareSize: squareSize)
        // Visual do problema
        ambient.prepareSucessors()
        
        configSceneView()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
    }
    
    func createPath(withSearch searchNumber: Int) -> [[Int]]{
        var states = [State]()
        
        for vertex in self.ambient.getVertex() {
            var successors: [Successor] = []
            
            for (index,successor) in vertex.sucessors.enumerated() {
                let newSuccessor = Successor(key: successor, cost: vertex.getCost(at: index), heuristicCost: successor.getGreedyCost())
                successors.append(newSuccessor)
            }
            
            let state = State(key: vertex, successors: successors)
            states.append(state)
        }
        
        let initialState = self.ambient.initialVertex
        let finalState = self.ambient.finalVertex
        
        print("\nInitial State:")
        print(initialState!)
        print("Final State:")
        print(finalState!)
        
        let agent = Agent(initialState: initialState!.state, finalState: finalState!.state, states: states)
        
        switch searchNumber {
        case 0:
            let path = agent.problemSolvingWithDepthSearch()
            return path
        case 1:
            let path = agent.problemSolvingWithBreadthSearch()
            return path
        case 2:
            let path = agent.problemSolvingWithBidirectionalSearch(.DepthXDepth)
            return path
        case 3:
            let path = agent.problemSolvingWithUniformedSearch()
            return path
        case 4:
            let path = agent.problemSolvingWithGreedySearch()
            return path
        default:
            let path = agent.problemSolvingWithAStarSearch()
            return path
        }
        
        //let path = self.startSearch()
        
    }
    
    @IBAction func startSearch(_ sender: UIButton) {
        switch sender {
            
        case self.depth:
            controlLines(withControlNumber: self.buttonActivated[0], andSearch: 0, andName: "depth", andColor: UIColor(red: 0, green: 204/255, blue: 204/255, alpha: 1))
//            linePath = createPath(withSearch: 0)
//            createPathLine(withColor: UIColor(red: 0, green: 204/255, blue: 204/255, alpha: 1), andName: "depth")
            break
        case self.breadth:
            controlLines(withControlNumber: self.buttonActivated[1], andSearch: 1, andName: "breadth", andColor: UIColor(red: 0, green: 0/255, blue: 204/255, alpha: 1))
//            linePath = createPath(withSearch: 1)
//            createPathLine(withColor: UIColor(red: 0, green: 0/255, blue: 204/255, alpha: 1), andName: "breadth")
            break
        case self.bidirectional:
            controlLines(withControlNumber: self.buttonActivated[2], andSearch: 2, andName: "bidirectional", andColor: UIColor(red: 204/255, green: 0, blue: 204/255, alpha: 1))
//            linePath = createPath(withSearch: 2)
//            createPathLine(withColor: UIColor(red: 204/255, green: 0, blue: 204/255, alpha: 1), andName: "bidirectional")
            break
        case self.uniform:
            controlLines(withControlNumber: self.buttonActivated[3], andSearch: 3, andName: "uniform", andColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1))
//            linePath = createPath(withSearch: 3)
//            createPathLine(withColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1), andName: "uniform")
            break
        case self.greedy:
            controlLines(withControlNumber: self.buttonActivated[4], andSearch: 4, andName: "greedy", andColor: UIColor(red: 204/255, green: 102/255, blue: 0/255, alpha: 1))
//            linePath = createPath(withSearch: 4)
//            createPathLine(withColor: UIColor(red: 204/255, green: 102/255, blue: 0/255, alpha: 1), andName: "greedy")
            break
        case self.aStar:
            controlLines(withControlNumber: self.buttonActivated[5], andSearch: 5, andName: "astar", andColor: UIColor(red: 255/255, green: 20/255, blue: 147/255, alpha: 1))
//            linePath = createPath(withSearch: 5)
//            createPathLine(withColor: UIColor(red: 255/255, green: 255/255, blue: 0, alpha: 1), andName: "astar")
            break
        default:
            print("Error in code")
        }
        
        //self.scene.showPath(path: linePath)
    }
    
    func controlLines(withControlNumber number: Int, andSearch search: Int, andName name: String, andColor color: UIColor){
        switch number {
        case 0:
            print("entrou aqui")
            linePath = createPath(withSearch: search)
            createPathLine(withColor: color, andName: name)
            self.buttonActivated[search] = 1
            return
        case 1:
            for node in self.scene.rootNode.childNodes{
                if node.name == name{
                    node.isHidden = true
                }
            }
            
            self.buttonActivated[search] = 2
            return
        default:
            for node in self.scene.rootNode.childNodes{
                if node.name == name{
                    node.isHidden = false
                }
            }
            self.buttonActivated[search] = 1
            return
        }
    }
    
    
    func returnPath(withAgent agent: Agent) -> [[Int]]{
        let path = agent.problemSolvingWithGreedySearch()
        return path
    }
    
    func configSceneView(){
        self.scene = SceneSquares(withData: ambient.returnAmbient(), vertexData: ambient.getVertex())
        
        self.scnView.backgroundColor = .white //UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        self.scnView.scene = scene
        //self.scnView.showsStatistics = true
        
        // CAMERA
        scnView.allowsCameraControl = true
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(ambient.returnAmbient()[0].count/2,ambient.returnAmbient().count,ambient.returnAmbient().count/2)
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
                print(node.positionBox)
                for nodeInfo in node.successorsBox{
                    let material = nodeInfo.geometry!.firstMaterial!
                    // highlight it
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 1
                    
                    // on completion - unhighlight
                    SCNTransaction.completionBlock = {
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = 1
                        
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
    func createPathLine(withColor color: UIColor, andName name: String) {
        for i in 0..<linePath.count-1 {
            createLine(between: linePath[i], and: linePath[i+1], withColor: color, andName: name)
        }
    }
    
    func createLine(between point1: [Int], and point2: [Int], withColor color: UIColor, andName name: String) {
        let vector1 = SCNVector3(CGFloat(point1[0]),1,CGFloat(point1[1]))
        let vector2 = SCNVector3(CGFloat(point2[0]), 1, CGFloat(point2[1]))
        print(vector1)
        print(vector2)
        let twoPointsNode1 = SCNNode()
        twoPointsNode1.name = name
        scene.rootNode.addChildNode(twoPointsNode1.buildLineInTwoPointsWithRotation(
            from: vector1, to: vector2, radius: 0.05, color: color))
    }
    
    @IBAction func searchBtn(_ sender: Any) {

    }
    
}
