//
//  ViewController.swift
//  PathNSquares
//
//  Created by Italus Rodrigues do Prado on 31/08/17.
//  Copyright © 2017 Italus Rodrigues do Prado. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let squaresQtd = 2 // Quantidade de quadrados no problema
    let ambientSize = 6 // Tamanho do ambiente trabalhado
    
    var ambient = [[Int]]() // Criação de uma matrix NxN que será o ambiente
    var positions = [[Int]]() // Posições iniciais X de cada quadrado
    //var positionsY = [Int]() // Posições iniciais Y de cada quadrado
    //Cada quadrado ocupa 4 pontos na matrix ambiente, sendo o positionsX e positionsY informando o ponto esquerdo-superior de cada quadrado
    
    var vertexPositions = [[Int]]() // A posição de todas as vértices de todos os quadrados
    
    var sucessors = [[[Int]]]() // A lista de sucessor, ordenado juntamente com os vertices
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAmbient()
        positions.sort{ $0.first! < $1.first! }

        for pos in positions{
            vertex(point: [pos[1],pos[0]])
        }
        vertexPositions.sort{$0.first! < $1.first!}
        for i in 0..<ambientSize{
            print(ambient[i])
        }
        for i in 0..<vertexPositions.count{
            var vector = [[Int]]()
            for j in i..<vertexPositions.count{
                if i != j{
                    if createSucessors(firstVertex: vertexPositions[i], secondVertex: vertexPositions[j]){
                         //print("\(vertexPositions[i]) - \(vertexPositions[j])")
                        vector.append(vertexPositions[j])
                    }
                }
            }
            sucessors.append(vector)
        }
        let pointA = [1,2]
        let pointB = [3,5]
        generateEquation(firstPoint: pointA, secondPoint: pointB)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Preparando os quadrados na matriz
    func createAmbient(){
        var array = [Int]()
        for _ in 0..<ambientSize{
            array.append(0)
        }
        for _ in 0..<ambientSize{
            ambient.append(array)
        }
        for _ in 0..<squaresQtd{
            let x = Int(2+arc4random()%UInt32(ambientSize-5))
            let y = Int(1+arc4random()%UInt32(ambientSize-3))
            
            positions.append([x,y])
//            positionsX.append(x)
//            positionsY.append(y)
            self.ambient[y][x] = 1
            self.ambient[y+1][x] = 1
            self.ambient[y][x+1] = 1
            self.ambient[y+1][x+1] = 1
        }
    }
    
    // Definindo as vertices de cada quadrado
    func vertex(point: [Int]){
        if ambient[point[0]-1][point[1]-1] != 1 && ambient[point[0]-1][point[1]-1] != 2{
            ambient[point[0]-1][point[1]-1] = 2
            vertexPositions.append([point[1]-1,point[0]-1])
        }
        if ambient[point[0]+2][point[1]-1] != 1 && ambient[point[0]+2][point[1]-1] != 2{
            ambient[point[0]+2][point[1]-1] = 2
            vertexPositions.append([point[1]-1,point[0]+2])
        }
        if ambient[point[0]-1][point[1]+2] != 1 && ambient[point[0]-1][point[1]+2] != 2{
            ambient[point[0]-1][point[1]+2] = 2
            vertexPositions.append([point[1]+2,point[0]-1])
        }
        if ambient[point[0]+2][point[1]+2] != 1 && ambient[point[0]+2][point[1]+2] != 2{
            ambient[point[0]+2][point[1]+2] = 2
            vertexPositions.append([point[1]+2,point[0]+2])
        }
    }
    
    // Criando os sucessores de cada vértice
    func createSucessors(firstVertex: [Int], secondVertex: [Int]) -> Bool{
        var sucessor = false
        
        // Verificando se é uma linha que não é diagonal (a equação da reta não funciona direito nesses casos
        if firstVertex[0] == secondVertex[0] || firstVertex[1] == secondVertex[1]{
            sucessor = lineHorVer(firstPoint: firstVertex, secondPoint: secondVertex)
            //print("\(firstVertex) - \(secondVertex) = \(sucessor) - Igual")
        } else {
            sucessor = lineDiag(firstPoint: firstVertex, secondPoint: secondVertex)
            //print("\(firstVertex) - \(secondVertex) = \(sucessor) = Diagonal")
        }
        print("\(firstVertex) - \(secondVertex) = \(sucessor)")
        return sucessor
    }
    
    func lineDiag(firstPoint: [Int], secondPoint: [Int]) -> Bool{
        
        let equation = generateEquation(firstPoint: firstPoint, secondPoint: secondPoint)
        for i in firstPoint[0]...secondPoint[0]{
            let y = Int(round((-(Float(equation[0])*Float(i)+Float(equation[2])))/Float(equation[1])))
            if ambient[y][i] == 1{
                return false
            }
        }
        return true
    }
    
    func lineHorVer(firstPoint: [Int], secondPoint: [Int]) -> Bool{
        
        if firstPoint[0] == secondPoint[0]{ // Vertical
            if firstPoint[1] < secondPoint[1]{
                for point in firstPoint[1]...secondPoint[1] {
                    if ambient[point][firstPoint[0]] == 1 {
                        return false
                    }
                }
            } else {
                for point in secondPoint[1]...firstPoint[1] {
                    if ambient[point][firstPoint[0]] == 1 {
                        return false
                    }
                }
            }
        } else { // Horizontal
            if firstPoint[0] < secondPoint[0]{
                for point in firstPoint[0]...secondPoint[0] {
                    if ambient[firstPoint[1]][point] == 1{
                        return false
                    }
                }
            } else {
                for point in secondPoint[0]...firstPoint[0] {
                    if ambient[firstPoint[1]][point] == 1{
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    // Criando função da reta [0] = X ; [1] = Y
    func generateEquation(firstPoint: [Int], secondPoint: [Int]) -> [Int]{
        let a = -(secondPoint[1]-firstPoint[1])
        let b = secondPoint[0]-firstPoint[0]
        let c = a*(-firstPoint[0])+b*(-firstPoint[1])
        //print("\(a)x+\(b)y+\(c)")
        return [a,b,c]
        
    }
    
    
}

