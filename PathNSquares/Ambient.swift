import UIKit

class Ambient: NSObject {

    private var ambientSize : Int! // Tamanho do ambiente trabalhado
    private var squareSize : Int!
    private var squaresQtd : Int! // Quantidade de quadrados no problema
    private var matrix = [[Int]]() // Criação de uma matrix NxN que será o ambiente
    private var positions = [[Int]]() // Posições dos quadrados
    var initialVertex : Vertex!
    var finalVertex : Vertex!
    
    //Cada quadrado ocupa 4 pontos na matrix ambiente
    
    private var matrixVertex = [Vertex]()
    
    init(ambientSize: Int, squaresQtd: Int, squareSize: Int) {
        self.squareSize = squareSize
        self.ambientSize = ambientSize
        self.squaresQtd = squaresQtd
        
        super.init()
        
        self.createAmbient()
        
        for point in self.positions{
            self.createVertex(point: [point[1],point[0]])
        }
        self.objectivePoints()
        matrixVertex.sort{$0.state.first! < $1.state.first!}
        
    }
    
    func returnAmbient() -> [[Int]]{
        return self.matrix
    }
    
    func printAmbient(){
        for line in self.matrix{
            print(line)
        }
    }
    
    func prepareSucessors(){
        for i in 0..<matrixVertex.count{
            for j in i..<matrixVertex.count{
                if i != j{
                    if createSucessors(firstVertex: matrixVertex[i].state, secondVertex: matrixVertex[j].state){
                        
                        
                        let uniformeCost = sqrt(powf(Float(matrixVertex[j].state[0]-matrixVertex[i].state[0]),2.0)+powf(Float(matrixVertex[j].state[1]-matrixVertex[i].state[1]),2.0))
                        // Testes Loucos
                        matrixVertex[i].information.append(Tuple(successor: matrixVertex[j], cost: uniformeCost))
                        matrixVertex[j].information.append(Tuple(successor: matrixVertex[i], cost: uniformeCost))
                        
                        // Fim dos testes loucos
                        matrixVertex[i].setNodeCost(uniformeCost)
                        matrixVertex[j].setNodeCost(uniformeCost)
                        matrixVertex[i].addToSucessor(vertex: matrixVertex[j])
                        matrixVertex[j].addToSucessor(vertex: matrixVertex[i])
                    }
                }
            }
            let greedyCost = sqrt(powf(Float(finalVertex.state[0]-matrixVertex[i].state[0]),2.0)+powf(Float(finalVertex.state[1]-matrixVertex[i].state[1]),2.0))
            if i == 0 {
                print(matrixVertex[i].state)
                print(greedyCost)
            }
            matrixVertex[i].setGreedyCost(greedyCost)
        }
    }
    
    func getVertex() -> [Vertex]{
        return matrixVertex
    }
    
    //-------------------- Private Functions --------------------
    
    private func createSucessors(firstVertex: [Int], secondVertex: [Int]) -> Bool{
        var sucessor = false
        
        // Verificando se é uma linha que não é diagonal (a equação da reta não funciona direito nesses casos
        if firstVertex[0] == secondVertex[0] || firstVertex[1] == secondVertex[1]{
            sucessor = lineHorVer(firstPoint: firstVertex, secondPoint: secondVertex)
            //print("\(firstVertex) - \(secondVertex) = \(sucessor) - Igual")
        } else {
            sucessor = lineDiag(firstPoint: firstVertex, secondPoint: secondVertex)
            //print("\(firstVertex) - \(secondVertex) = \(sucessor) = Diagonal")
        }
        //print("\(firstVertex) - \(secondVertex) = \(sucessor)")
        return sucessor
    }
    
    private func lineDiag(firstPoint: [Int], secondPoint: [Int]) -> Bool{
        
        let equation = generateEquation(firstPoint: firstPoint, secondPoint: secondPoint)
        for i in stride(from: Double(firstPoint[0]), to: Double(secondPoint[0]), by: 0.01){
            let y = Int(round((-(Float(equation[0])*Float(i)+Float(equation[2])))/Float(equation[1])))
            if matrix[y][Int(round(i))] == 1{
                return false
            }
        }
        return true
    }
    private func lineHorVer(firstPoint: [Int], secondPoint: [Int]) -> Bool{
        
        if firstPoint[0] == secondPoint[0]{ // Vertical
            if firstPoint[1] < secondPoint[1]{
                for point in firstPoint[1]...secondPoint[1] {
                    if matrix[point][firstPoint[0]] == 1 {
                        return false
                    }
                }
            } else {
                for point in secondPoint[1]...firstPoint[1] {
                    if matrix[point][firstPoint[0]] == 1 {
                        return false
                    }
                }
            }
        } else { // Horizontal
            if firstPoint[0] < secondPoint[0]{
                for point in firstPoint[0]...secondPoint[0] {
                    if matrix[firstPoint[1]][point] == 1{
                        return false
                    }
                }
            } else {
                for point in secondPoint[0]...firstPoint[0] {
                    if matrix[firstPoint[1]][point] == 1{
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    // Criando função da reta [0] = X ; [1] = Y
    private func generateEquation(firstPoint: [Int], secondPoint: [Int]) -> [Int]{
        let a = -(secondPoint[1]-firstPoint[1])
        let b = secondPoint[0]-firstPoint[0]
        let c = a*(-firstPoint[0])+b*(-firstPoint[1])
        //print("\(a)x+\(b)y+\(c)")
        return [a,b,c]
        
    }
    
    private func createAmbient(){
        
        var array = [Int]()
        
        // Adicionando zeros a matriz
        for _ in 0..<(ambientSize*2)-2{
            array.append(0)
        }
        for _ in 0..<ambientSize{
            matrix.append(array)
        }
        
        // Adicionando quadrados
        for _ in 0..<squaresQtd{
            let x = Int(1+arc4random()%UInt32(self.matrix[0].count-squareSize-1))
            let y = Int(1+arc4random()%UInt32(self.matrix.count-squareSize-1))
            
            self.positions.append([x,y])
            for point in 0..<self.squareSize{
                for point2 in 0..<self.squareSize{
                    //print("\(y+point)-\(x+point2)")
                    self.matrix[y+point][x+point2] = 1
                }
            }
        }
        
        self.positions.sort{ $0.first! < $1.first! }
        
        
        
    }
    
    func objectivePoints(){
        // Adicionando inicial e final na matriz de data
        var col1 = Int(arc4random()%UInt32(self.matrix[0].count))
        var row1 = Int(arc4random()%UInt32(self.matrix.count))
        
        var col2 = Int(arc4random()%UInt32(self.matrix[0].count))
        var row2 = Int(arc4random()%UInt32(self.matrix.count))
        
        while self.matrix[row1][col1] == 1 || self.matrix[row1][col1] == 2 {
            col1 = Int(arc4random()%UInt32(self.matrix[0].count))
            row1 = Int(arc4random()%UInt32(self.matrix.count))
        }
        self.matrix[row1][col1] = 3
        self.initialVertex = Vertex(state: [col1,row1])
        
        while self.matrix[row2][col2] == 1 || self.matrix[row2][col2] == 2 || self.matrix[row2][col2] == 3 {
            col2 = Int(arc4random()%UInt32(self.matrix[0].count))
            row2 = Int(arc4random()%UInt32(self.matrix.count))
        }
        
        self.matrix[row2][col2] = 3
        self.finalVertex = Vertex(state: [col2,row2])
        
        self.matrixVertex.append(self.initialVertex)
        self.matrixVertex.append(self.finalVertex)
    }
    
    // Definindo as vertices de cada quadrado
    private func createVertex(point: [Int]){
        
        if matrix[point[0]-1][point[1]-1] != 1 && matrix[point[0]-1][point[1]-1] != 2{
            matrix[point[0]-1][point[1]-1] = 2
            let vertex = Vertex(state: [point[1]-1,point[0]-1])
            self.matrixVertex.append(vertex)
        }
        if matrix[point[0]+squareSize][point[1]-1] != 1 && matrix[point[0]+squareSize][point[1]-1] != 2{
            matrix[point[0]+squareSize][point[1]-1] = 2
            let vertex = Vertex(state: [point[1]-1,point[0]+squareSize])
            self.matrixVertex.append(vertex)
        }
        if matrix[point[0]-1][point[1]+squareSize] != 1 && matrix[point[0]-1][point[1]+squareSize] != 2{
            matrix[point[0]-1][point[1]+squareSize] = 2
            let vertex = Vertex(state: [point[1]+squareSize,point[0]-1])
            self.matrixVertex.append(vertex)
        }
        if matrix[point[0]+squareSize][point[1]+squareSize] != 1 && matrix[point[0]+squareSize][point[1]+squareSize] != 2{
            matrix[point[0]+squareSize][point[1]+squareSize] = 2
            let vertex = Vertex(state: [point[1]+squareSize,point[0]+squareSize])
            self.matrixVertex.append(vertex)
        }
        
    }
    
}
