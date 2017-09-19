import UIKit

struct Tuple {
    let successor: Vertex
    let cost: Float
}

class Vertex: NSObject {
    
    var state = [Int]() // Posição da aresta
    var sucessors = [Vertex]() // Array com sucessores
    var father : Vertex? // Nó pai para gerar o caminho
    var information = [Tuple]()
    var someTuple: (successor: Vertex,cost: Float)? = nil
    var cost: Float = 0
    var costToObjective : Float = 0
    var totalCost: Float = 0
    
    init(state: [Int]) {
        self.state = state
    }
    
    func addToSucessor(vertex: Vertex){
        self.sucessors.append(vertex)
    }
    
    func addFather(_ node: Vertex) {
        self.father = node
    }
    
    func setSuccessors(_ sucessors: [Vertex]) {
        self.sucessors = sucessors
    }
    
    func getCost() -> Float {
        return self.cost
    }
    
    func getGreedyCost() -> Float{
        return self.costToObjective
    }
    
    func setNodeCost(_ cost: Float) {
        self.cost = cost
    }
    
    func setGreedyCost(_ cost: Float){
        self.costToObjective = cost
    }
    
    func setTotalNodeCost(_ totalCost: Float){
        self.totalCost = totalCost
    }
}
