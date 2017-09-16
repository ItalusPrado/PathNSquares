//
//  Search.swift
//  ArtificialInteligence
//
//  Created by Gabriel Cavalcante on 14/09/17.
//  Copyright © 2017 Gabriel Cavalcante. All rights reserved.
//

import UIKit

protocol SearchProtocol {
    func search(from initialState: [Int]) -> [[Int]]
    
    func getSucessors(from node: Vertex) -> [Vertex]
    
    func addToBorder(_ successors: [Vertex])
}
