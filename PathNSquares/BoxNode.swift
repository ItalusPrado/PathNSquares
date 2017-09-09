//
//  BoxNode.swift
//  PathNSquares
//
//  Created by Italus Rodrigues do Prado on 09/09/17.
//  Copyright © 2017 Italus Rodrigues do Prado. All rights reserved.
//

import UIKit
import SceneKit

class BoxNode: SCNNode {

    init(size: CGFloat, color: UIColor, position: [Int]) {
        super.init()
        
        self.geometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        self.geometry?.materials.first?.diffuse.contents = color
        //self.eulerAngles = SCNVector3(-Double.pi/2,0,0)
        
        self.position = SCNVector3(position[1],0,position[0])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
