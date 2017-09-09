import UIKit

class Ambient: NSObject {

    private var ambientSize : Int! // Tamanho do ambiente trabalhado
    private var squaresQtd : Int! // Quantidade de quadrados no problema
    private var matrix = [[Int]]() // Criação de uma matrix NxN que será o ambiente
    private var positions = [[Int]]() // Posições dos quadrados
    //Cada quadrado ocupa 4 pontos na matrix ambiente
    
    private var matrixVertex = [Vertex]()
    
    init(ambientSize: Int, squaresQtd: Int) {
        
        self.ambientSize = ambientSize
        self.squaresQtd = squaresQtd
        
        super.init()
        
        self.createAmbient()
        
        for point in self.positions{
            self.createVertex(point: [point[1],point[0]])
        }
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
                        matrixVertex[i].addToSucessor(vertex: matrixVertex[j])
                        matrixVertex[j].addToSucessor(vertex: matrixVertex[i])
                    }
                }
            }
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
        for i in stride(from: Double(firstPoint[0]), to: Double(secondPoint[0]), by: 0.1){
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
        for _ in 0..<ambientSize{
            array.append(0)
        }
        for _ in 0..<ambientSize{
            matrix.append(array)
        }
        
        // Adicionando quadrados
        for _ in 0..<squaresQtd{
            let x = Int(2+arc4random()%UInt32(ambientSize-5))
            let y = Int(1+arc4random()%UInt32(ambientSize-3))
            
            self.positions.append([x,y])
            self.matrix[y][x] = 1
            self.matrix[y+1][x] = 1
            self.matrix[y][x+1] = 1
            self.matrix[y+1][x+1] = 1
        }
        self.positions.sort{ $0.first! < $1.first! }
    }
    
    // Definindo as vertices de cada quadrado
    private func createVertex(point: [Int]){
        
        if matrix[point[0]-1][point[1]-1] != 1 && matrix[point[0]-1][point[1]-1] != 2{
            matrix[point[0]-1][point[1]-1] = 2
            let vertex = Vertex(state: [point[1]-1,point[0]-1])
            self.matrixVertex.append(vertex)
        }
        if matrix[point[0]+2][point[1]-1] != 1 && matrix[point[0]+2][point[1]-1] != 2{
            matrix[point[0]+2][point[1]-1] = 2
            let vertex = Vertex(state: [point[1]-1,point[0]+2])
            self.matrixVertex.append(vertex)
        }
        if matrix[point[0]-1][point[1]+2] != 1 && matrix[point[0]-1][point[1]+2] != 2{
            matrix[point[0]-1][point[1]+2] = 2
            let vertex = Vertex(state: [point[1]+2,point[0]-1])
            self.matrixVertex.append(vertex)
        }
        if matrix[point[0]+2][point[1]+2] != 1 && matrix[point[0]+2][point[1]+2] != 2{
            matrix[point[0]+2][point[1]+2] = 2
            let vertex = Vertex(state: [point[1]+2,point[0]+2])
            self.matrixVertex.append(vertex)
        }
    }
    
}
