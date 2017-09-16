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
    var states: [State]!
    var successor: [Vertex]? = nil
    var cost: Int = 0
    
    init(initialState: [Int], finalState: [Int], states: [State]) {
        self.initialState = initialState
        self.finalState = finalState
        self.states = states
    }
    
    func problemSolvingWithBreadthSearch() -> [[Int]] {
        let breadthSearch = BreadthSearch(states: states, finalState: finalState)
        
        return breadthSearch.search(from: initialState)
    }
    
    func problemSolvingWithDepthSearch() -> [[Int]] {
        let depthSearch = DepthSearch(states: states, finalState: finalState)
        
        return depthSearch.search(from: initialState)
    }
    
    func problemSolvingWithBidirectionalSearch(_ type: BidirectionalType) -> [[Int]] {
        let bidirectionalSearch = BidirectionalSearch(states: states,initialState: initialState, finalState: finalState, bidirectionalType: type)
        
        return bidirectionalSearch.search()
    }
    
    func problemSolvingWithUniformedSearch() -> [[Int]] {
        let uniformedSearch = UniformedSearch(states: states, finalState: finalState)
        
        return uniformedSearch.search(from: initialState)
    }
    
    func problemSolvingWithGreedySearch() -> [[Int]] {
        let greedySearch = GreedySearch(states: states, finalState: finalState)
        
        return greedySearch.search(from: initialState)
    }
}
