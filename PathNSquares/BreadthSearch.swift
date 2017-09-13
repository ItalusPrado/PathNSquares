//
//  BreadthSearch.swift
//  ArtificialInteligence
//
//  Created by Gabriel Cavalcante on 18/07/17.
//  Copyright © 2017 Gabriel Cavalcante. All rights reserved.
//

import UIKit

class BreadthSearch {
    
    var border: [Vertex] = []
    var currentState: Vertex!
    var finalState: [Int]!
    var states: [State]
    private var visited: [[Int]] = []
    
    init(states: [State], finalState: [Int]) {
        self.states = states
        self.finalState = finalState
    }
    
    func isGoalState(_ node: Vertex) -> Bool {
        if node.state == finalState {
            return true
        } else {
            return false
        }
    }
    
    func search(from initialState: [Int]) -> [[Int]] {
        
        print("\n\nBREADTH SEARCH")
        print("\nBorders:")
        
        if currentState == nil {
            currentState = Vertex(state: initialState)
        }
        
        while !isGoalState(currentState) {
            self.addToBorder(getSucessors(from: currentState))
            self.visited.append(currentState.state)
            self.currentState = border.last
            self.border.removeLast()
        }
        
        return getPath()
    }
    
    func getSucessors(from node: Vertex) -> [Vertex] {
        var successors: [Vertex] = []
        
        for state in states {
            if state.getKey().state == node.state {
                for successor in state.getSuccessors() {
                    let newNode = Vertex(state: successor.getKey().state)
                    newNode.addFather(node)
                    successors.append(newNode)
                }
            }
        }
        
        return successors
    }
    
    func addToBorder(_ successors: [Vertex]) {
        if !visited.contains(where: { $0 == currentState.state }){
            for successor in successors {
                self.border.appendAtBeginning(newItem:successor)
            }
        }
        
//        print(currentState.state)
//        printBorder()
    }
    
    func getPath() -> [[Int]] {
        var path: [[Int]] = []
        path.append(finalState)
        var node = currentState
        repeat {
            if node!.father != nil {
                path.append(node!.father!.state)
                node = node!.father
            }
        } while(node!.father != nil)
        
        print("\nPath:")
        return path
    }
    
    func printBorder() {
        var statesBorder:[[Int]] = []
        for node in border {
            statesBorder.append(node.state)
        }
        print(statesBorder)
    }
}
