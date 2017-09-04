//
//  Vertex.swift
//  PathNSquares
//
//  Created by Italus Rodrigues do Prado on 04/09/17.
//  Copyright © 2017 Italus Rodrigues do Prado. All rights reserved.
//

import UIKit

class Vertex: NSObject {
    
    var position = [Int]() // Posição da aresta
    var sucessors = [Vertex]() // Array com sucessores
    var father : Vertex? // Nó pai para gerar o caminho
    
    init(position: [Int]) {
        self.position = position
    }
    
    func addToSucessor(vertex: Vertex){
        self.sucessors.append(vertex)
    }
}
