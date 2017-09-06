//
//  Agent.swift
//  ArtificialInteligence
//
//  Created by Gabriel Cavalcante on 18/07/17.
//  Copyright © 2017 Gabriel Cavalcante. All rights reserved.
//

import UIKit

class Agent {
    
    var initialState: [Int]!
    var finalState: [Int]!
    var states: [Vertex : [Vertex]]!
    var successor: [Vertex]? = nil
    var cost: Int = 0
    
    init(initialState: [Int], finalState: [Int], states: [Vertex : [Vertex]]) {
        self.initialState = initialState
        self.finalState = finalState
        self.states = states
    }
    
    func problemSolvingWithBreadthSearch() -> [[Int]] {
        let breadthSearch = BreadthSearch(states: states, finalState: finalState)
        
        return breadthSearch.search(from: initialState)
    }
}
