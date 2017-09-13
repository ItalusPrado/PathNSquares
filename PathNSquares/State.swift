//
//  State.swift
//  ArtificialInteligence
//
//  Created by ifce on 08/09/17.
//  Copyright © 2017 Gabriel Cavalcante. All rights reserved.
//

import UIKit

struct Successor {
    private var key: Vertex!
    private var cost: Int!
    
    init(key: Vertex, cost: Int) {
        self.key = key
        self.cost = cost
    }
    
    func getKey() -> Vertex {
        return self.key
    }
    
    func getCost() -> Int {
        return self.cost
    }
}

struct State {
    private var key: Vertex!
    private var successors: [Successor]!
    
    init(key: Vertex, successors: [Successor]) {
        self.key = key
        self.successors = successors
    }
    
    func getKey() -> Vertex {
        return self.key
    }
    
    func getSuccessors() -> [Successor] {
        return self.successors
    }
}
