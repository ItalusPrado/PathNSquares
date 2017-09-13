//
//  BidirectionalSearch.swift
//  ArtificialInteligence
//
//  Created by Gabriel Cavalcante on 01/09/17.
//  Copyright © 2017 Gabriel Cavalcante. All rights reserved.
//

import UIKit

enum BidirectionalType {
    case DepthXBreadth
    case DepthXDepth
    case BreadthXDepth
    case BreadthXBreadth
}

class BidirectionalSearch {
    
    var border1: [Vertex] = []
    var border2: [Vertex] = []
    var currentState1: Vertex!
    var currentState2: Vertex!
    var visited1: [[Int]] = []
    var visited2: [[Int]] = []
    var states: [State] = []
    var finalState: [Int]!
    var initialState: [Int]!
    var bidirectionalType: BidirectionalType
    var isStateFound: Int = 0
    
    init(states: [State], initialState: [Int], finalState: [Int], bidirectionalType: BidirectionalType) {
        self.states = states
        self.initialState = initialState
        self.finalState = finalState
        self.bidirectionalType = bidirectionalType
    }
    
    func isGoalState() -> Bool {
        if currentState1.state == currentState2.state || currentState1.state == finalState || currentState2.state == initialState {
            if currentState1.state == currentState2.state {
                addToVisited()
                print("CRUZAMENTO EM \(currentState1.state)")
                self.isStateFound = 0
            } else if currentState1.state == finalState {
                self.isStateFound = 1
            } else {
                self.isStateFound = 2
            }
            return true
        } else {
            return false
        }
    }
    
    func search() -> [[Int]] {
        
        print("\n\nBIDIRECTIONAL SEARCH")
        print("\nBorders:")
        
        if currentState1 == nil {
            currentState1 = Vertex(state: initialState)
        }
        
        if currentState2 == nil {
            currentState2 = Vertex(state: finalState)
        }
        
        while !isGoalState() {
            self.addToBorders(getSucessors(from: currentState1), getSucessors(from: currentState2))
            self.addToVisited()
            self.removeFromBorders()
        }
        
        return getPath()
    }
    
    func addToVisited() {
        self.visited1.append(currentState1.state)
        self.visited2.append(currentState2.state)
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
    
    func addToBorders(_ successors: [Vertex], _ predecessors: [Vertex]) {
        if !visited1.contains(where: { $0 == currentState1.state }){
            for successor in successors {
                self.border1.appendAtBeginning(newItem:successor)
            }
        }
        
        if !visited2.contains(where: { $0 == currentState2.state }){
            for predecessor in predecessors {
                self.border2.appendAtBeginning(newItem:predecessor)
            }
        }
        
//        print(currentState1.state)
//        print(currentState2.state)
//        printBorders()
    }
    
    func removeFromBorders() {
        switch self.bidirectionalType {
        case .BreadthXBreadth:
            self.currentState1 = border1.last
            self.border1.removeLast()
            self.currentState2 = border2.last
            self.border2.removeLast()
            break
        case .BreadthXDepth:
            self.currentState1 = border1.last
            self.border1.removeLast()
            self.currentState2 = border2.first
            self.border2.removeFirst()
            break
        case .DepthXBreadth:
            self.currentState1 = border1.first
            self.border1.removeFirst()
            self.currentState2 = border2.last
            self.border2.removeLast()
            break
        case .DepthXDepth:
            self.currentState1 = border1.first
            self.border1.removeFirst()
            self.currentState2 = border2.first
            self.border2.removeFirst()
            break
        }
    }
    
    func getPath() -> [[Int]] {
        var path1: [[Int]] = getPath(from: currentState1)
        var path2: [[Int]] = getPath(from: currentState2)
        
        print("\nPath:")
        if isStateFound == 0 {
            return addToPath(path1, path2)
        } else if isStateFound == 1 {
            path1.appendAtBeginning(newItem: finalState)
            return path1
        } else {
            path2.appendAtBeginning(newItem: initialState)
            return path2
        }
    }
    
    func getPath(from state: Vertex) -> [[Int]] {
        var path: [[Int]] = []
        var node = state
        repeat {
            if node.father != nil {
                path.append(node.father!.state)
                node = node.father!
            }
        } while(node.father != nil)
        
        return path
    }
    
    func addToPath(_ path1: [[Int]], _ path2: [[Int]]) -> [[Int]] {
        var path: [[Int]] = []
        for state in path1 {
            path.append(state)
        }
        for state in path2 {
            path.appendAtBeginning(newItem: state)
        }
        return path
    }
    
    func printBorders() {
        var statesBorder1:[[Int]] = []
        var statesBorder2:[[Int]] = []
        
        for node in border1 {
            statesBorder1.append(node.state)
        }
        
        for node in border2 {
            statesBorder2.append(node.state)
        }
        
        print(statesBorder1)
        print(statesBorder2)
        print("")
    }
}
