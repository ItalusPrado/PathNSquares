//
//  SearchManager.swift
//  ArtificialInteligence
//
//  Created by Gabriel Cavalcante on 14/09/17.
//  Copyright © 2017 Gabriel Cavalcante. All rights reserved.
//

import UIKit

class SearchManager {
    
    func getPath(_ currentState: Vertex, _ finalState: [Int]) -> [[Int]] {
        var path: [[Int]] = []
        path.append(finalState)
        var node = currentState
        repeat {
            if node.father != nil {
                path.append(node.father!.state)
                node = node.father!
            }
        } while(node.father != nil)
        
        print("\nPath:")
        print(path)
        return path
    }
    
    func printBorder(_ border: [Vertex]) {
        var statesBorder:[[Int]] = []
        for node in border {
            statesBorder.append(node.state)
        }
        print(statesBorder)
    }
    
    func isGoalState(_ currentState: Vertex, _ finalState: [Int]) -> Bool {
        if currentState.state == finalState {
            return true
        } else {
            return false
        }
    }
}
