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
    var father : Vertex? // Nó pai para gerar o caminho
    var cost: [Float] = []
    var uniformedCost: Float = 0
    var costToObjective : Float = 0
    var totalCost: Float = 0
    
    init(state: [Int]) {
        self.state = state
    }
    
    func addToSucessor(vertex: Vertex){
        self.sucessors.append(vertex)
    }
    
    func addFather(_ node: Vertex) {
        self.father = node
    }
    
    func setSuccessors(_ sucessors: [Vertex]) {
        self.sucessors = sucessors
    }
    
    func getCost(at index: Int) -> Float {
        return self.cost[index]
    }
    
    func getUniformCost() -> Float {
        return self.uniformedCost
    }
    
    func setUniformCost(_ uniformedCost: Float) {
        self.uniformedCost = uniformedCost
    }
    
    func getGreedyCost() -> Float{
        return self.costToObjective
    }
    
    func setNodeCost(_ cost: Float) {
        self.cost.append(cost)
    }
    
    func setGreedyCost(_ cost: Float){
        self.costToObjective = cost
    }
    
    func setTotalNodeCost(_ totalCost: Float){
        self.totalCost = totalCost
    }
}
