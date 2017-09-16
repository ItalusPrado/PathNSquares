//
//  A*Search.swift
//  ArtificialInteligence
//
//  Created by Gabriel Cavalcante on 14/09/17.
//  Copyright © 2017 Gabriel Cavalcante. All rights reserved.
//

import UIKit

class AStarSearch: SearchProtocol {
    
    var border: [Vertex] = []
    var currentState: Vertex!
    var finalState: [Int]!
    var states: [State]
    var visited: [[Int]] = []
    let searchManager = SearchManager()
    
    init(states: [State], finalState: [Int]) {
        self.states = states
        self.finalState = finalState
    }
    
    func search(from initialState: [Int]) -> [[Int]] {
        
        print("\n\nA* SEARCH")
        print("\nBorders:")
        
        if currentState == nil {
            currentState = Vertex(state: initialState)
        }
        
        while !searchManager.isGoalState(currentState, finalState) {
            self.addToBorder(getSucessors(from: currentState))
            self.visited.append(currentState.state)
            self.currentState = border.first
            self.border.removeFirst()
        }
        
        return searchManager.getPath(currentState, finalState)
    }
    
    func getSucessors(from node: Vertex) -> [Vertex] {
        var successors: [Vertex] = []
        
        for state in states {
            if state.getKey().state == node.state {
                for successor in state.getSuccessors() {
                    
                    let newNode = Vertex(state: successor.getKey().state)
                    newNode.addFather(node)
                    
                    let newCost = node.cost+successor.getCost()
                    newNode.setNodeCost(newCost)
                    
                    let heuristicCost = successor.getHeuristicCost()
                    newNode.setGreedyCost(heuristicCost)
                    
                    let totalCost = newCost + heuristicCost
                    newNode.setTotalNodeCost(totalCost)
                    
                    successors.append(newNode)
                }
            }
        }
        
        return successors
    }
    
    func addToBorder(_ successors: [Vertex]) {
        if !visited.contains(where: { $0 == currentState.state }) {
            let sortedSuccessors = successors.sorted(by: {$0.0.totalCost > $0.1.totalCost})
            for successor in sortedSuccessors {
                self.border.appendAtBeginning(newItem:successor)
            }
        }
        
        print(currentState.state)
        print(currentState.totalCost)
//        searchManager.printBorder(border)
    }
}

