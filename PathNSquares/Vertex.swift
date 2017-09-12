//
//  Vertex.swift
//  PathNSquares
//
//  Created by Italus Rodrigues do Prado on 04/09/17.
//  Copyright © 2017 Italus Rodrigues do Prado. All rights reserved.
//

import UIKit

class Vertex: NSObject {
    
    var state = [Int]() // Posição da aresta
    var sucessors = [Vertex]() // Array com sucessores
    var costSuccessors = [Int]()
    var father : Vertex? // Nó pai para gerar o caminho
    
    init(state: [Int]) {
        self.state = state
    }
    
    func addToSucessor(vertex: Vertex, uniformCost: Int){
        self.sucessors.append(vertex)
        self.costSuccessors.append(uniformCost)
    }
    
    func addFather(_ node: Vertex) {
        self.father = node
    }
    
    func setSuccessors(_ sucessors: [Vertex]) {
        self.sucessors = sucessors
    }
    
    func getCost(position: Int) -> Int {
        return self.costSuccessors[position]
    }
}
