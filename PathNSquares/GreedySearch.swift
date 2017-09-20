//
//  BreadthSearch.swift
//  ArtificialInteligence
//
//  Created by Gabriel Cavalcante on 18/07/17.
//  Copyright © 2017 Gabriel Cavalcante. All rights reserved.
//

import UIKit

class GreedySearch: SearchProtocol {
    
    var border: [Vertex] = []
    var currentState: Vertex!
    var finalState: [Int]!
    var states: [State]
    var visited: [[Int]] = []
    var cost: Int = 0
    let searchManager = SearchManager()
    
    init(states: [State], finalState: [Int]) {
        self.states = states
        self.finalState = finalState
    }
    
    func search(from initialState: [Int]) -> [[Int]] {
        
        print("\n\nGREEDY SEARCH")
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
                    newNode.setGreedyCost(successor.getHeuristicCost())
                    print(newNode.state)
                    print(newNode.costToObjective)
                    
                    successors.append(newNode)
                }
            }
        }
        
        return successors
    }
    
    func addToBorder(_ successors: [Vertex]) {
//        if !visited.contains(where: { $0 == currentState.state }) {
            let sortedSuccessors = successors.sorted(by: {$0.0.costToObjective > $0.1.costToObjective})
            for successor in sortedSuccessors {
                print(successor.costToObjective)
                self.border.appendAtBeginning(newItem:successor)
            }
//        }
        
//        print(currentState.state)
//        print(currentState.heuristicCost)
        searchManager.printBorder(border)
    }
}
