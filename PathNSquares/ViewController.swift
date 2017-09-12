//
//  ViewController.swift
//  PathNSquares
//
//  Created by Italus Rodrigues do Prado on 31/08/17.
//  Copyright © 2017 Italus Rodrigues do Prado. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // Usando objetos
    let ambient = Ambient(ambientSize: 100, squaresQtd: 10, squareSize: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ambient.prepareSucessors()
        
        // Exemplo de como pegar todos os sucessores
        let sucessors = self.ambient.getVertex()[0].sucessors
        //print(self.ambient.getVertex()[0].sucessors.count)
        
        // Adicionando um pai um nó qualquer
        for sucessor in 0..<sucessors.count {
            if sucessor == 1 {
                sucessors[sucessor].father = self.ambient.getVertex()[0]
            }
        }
        
        // Verificando os pais de todos os nós
        let vertex = self.ambient.getVertex()
        
        for vert in vertex{
            print(vert.father?.state)
        }
        
        
        var states = [Vertex: [Vertex]]()
        
        for vertex in self.ambient.getVertex() {
            states[vertex] = vertex.sucessors
        }
        
        let initialState = self.ambient.getVertex().first?.state
        let finalState = self.ambient.getVertex().last?.state
    
        print("\nInitial State:")
        print(initialState!)
        print("Final State:")
        print(finalState!)
        
        let agent = Agent(initialState: initialState!, finalState: finalState!, states: states)
        
        print("\nTESTE DE BUSCA DE LARGURA\n")
        print(agent.problemSolvingWithBreadthSearch())
        print("\nTESTE DE BUSCA DE PROFUNDIDADE\n")
        print(agent.problemSolvingWithDepthSearch())
        print("\nTESTE DE BUSCA BIDIRECIONAL\n")
        print(agent.problemSolvingWithBidirectionalSearch(.BreadthXDepth))
        
    }

    
    
}

