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
    
    let ambient = Ambient(ambientSize: 30, squaresQtd: 40)
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
        let path = agent.problemSolvingWithDepthSearch()
        print(path)
        return path
    }

    func configSceneView(){
        self.scene = SceneSquares(withData: ambient.returnAmbient())
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
