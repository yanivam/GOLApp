import Foundation
class Colony : CustomStringConvertible {
    var ColonyCells: Set<ColonyCell>
    var name: String
    var evolutionNumber: Int = 0
    var wrapping = false
    let Size = 60
    
    init(cName: String, wrapping: Bool) {
        ColonyCells = []
        self.wrapping = wrapping
        self.name = cName
    }
    
    func setColonyCellAlive(xCoor: Int, yCoor: Int){
        if(withinBoundsForSet(x: xCoor, y: yCoor)){
            ColonyCells.insert(ColonyCell(xCoor, yCoor))
        }
    }
    
    func setColonyCellDead(xCoor: Int, yCoor: Int){
        ColonyCells.remove(ColonyCell(xCoor, yCoor))
    }
    
    func resetColony(){
        ColonyCells = []
    }
    
    var description: String{
        var desc: String = "Evolution #" + String(evolutionNumber) + "\n"
        for y in 0...Size{
            for x in 0...Size{
                if(isColonyCellAlive(xCoor: x, yCoor: Size-y)){
                    desc += "*"
                }
                else {
                    desc += " "
                }
            }
            desc += "\n"
        }
        return desc
    }
    
    
    func isColonyCellAlive(xCoor: Int, yCoor: Int)->Bool{
        return ColonyCells.contains(ColonyCell(xCoor, yCoor))
    }
    
    //Delete once better method.
    private func withinBoundsForSet(x: Int, y: Int)->Bool{
        return (x >= 0 && x < Size && y >= 0 && y < Size)
    }
    
    private func withinBounds(x: Int, y: Int)->Bool{
        if  wrapping {
            return true
        }
        else{
            return (x >= 0 && x < Size && y >= 0 && y < Size)
        }
    }
    
    private func wrapBound(coor: Int) -> Int {
        var newCoor = coor
        if wrapping {
            if coor >= Size {
                newCoor -= Size
            }
            if coor < 0 {
                newCoor += Size
            }
        }
        return newCoor
    }
    
    private func numberNeighbors(c : ColonyCell)->Int{
        var count = 0;
        if isColonyCellAlive(xCoor: wrapBound(coor: c.xCoor + 1), yCoor: wrapBound(coor: c.yCoor + 1)) {
            count+=1
        }
        if isColonyCellAlive(xCoor: wrapBound(coor: c.xCoor + 1), yCoor: c.yCoor) {
            count+=1
        }
        if isColonyCellAlive(xCoor: wrapBound(coor: c.xCoor + 1), yCoor: wrapBound(coor: c.yCoor - 1)) {
            count+=1
        }
        if isColonyCellAlive(xCoor: c.xCoor, yCoor: wrapBound(coor: c.yCoor + 1)) {
            count+=1
        }
        if isColonyCellAlive(xCoor: c.xCoor, yCoor: wrapBound(coor: c.yCoor - 1)) {
            count+=1
        }
        if isColonyCellAlive(xCoor: wrapBound(coor: c.xCoor - 1), yCoor: wrapBound(coor: c.yCoor + 1)) {
            count+=1
        }
        if isColonyCellAlive(xCoor: wrapBound(coor: c.xCoor - 1), yCoor: c.yCoor) {
            count+=1
        }
        if isColonyCellAlive(xCoor: wrapBound(coor: c.xCoor - 1), yCoor: wrapBound(coor: c.yCoor - 1)) {
            count+=1
        }
        return count
    }
    
    private func getAffectedColonyCells()->Set<ColonyCell>{
        var affectedColonyCells: Set<ColonyCell> = []
        for c in ColonyCells{
            if withinBounds(x: c.xCoor + 1, y: c.yCoor + 1) {
                affectedColonyCells.insert(ColonyCell(wrapBound(coor: c.xCoor + 1), wrapBound(coor: c.yCoor + 1)))
            }
            if withinBounds(x: c.xCoor + 1, y: c.yCoor) {
                affectedColonyCells.insert(ColonyCell(wrapBound(coor: c.xCoor + 1), c.yCoor))
            }
            if withinBounds(x: c.xCoor + 1, y: c.yCoor - 1) {
                affectedColonyCells.insert(ColonyCell(wrapBound(coor: c.xCoor + 1), wrapBound(coor: c.yCoor - 1)))
            }
            if withinBounds(x: c.xCoor , y: c.yCoor + 1) {
                affectedColonyCells.insert(ColonyCell(c.xCoor, wrapBound(coor: c.yCoor + 1)))
            }
            if withinBounds(x: c.xCoor, y: c.yCoor - 1) {
                affectedColonyCells.insert(ColonyCell(c.xCoor, wrapBound(coor: c.yCoor - 1)))
            }
            if withinBounds(x: c.xCoor - 1, y: c.yCoor + 1) {
                affectedColonyCells.insert(ColonyCell(wrapBound(coor: c.xCoor - 1), wrapBound(coor: c.yCoor + 1)))
            }
            if withinBounds(x: c.xCoor - 1, y: c.yCoor) {
                affectedColonyCells.insert(ColonyCell(wrapBound(coor: c.xCoor - 1), c.yCoor))
            }
            if withinBounds(x: c.xCoor - 1, y: c.yCoor - 1) {
                affectedColonyCells.insert(ColonyCell(wrapBound(coor: c.xCoor - 1), wrapBound(coor: c.yCoor - 1)))
            }
            affectedColonyCells.insert(ColonyCell(c.xCoor, c.yCoor))
        }
        return affectedColonyCells
    }
    
    
    func evolve(){
        var newColonyCells: Set<ColonyCell> = []
        for c in getAffectedColonyCells(){
            let neighborsCount = numberNeighbors(c: c)
            if(neighborsCount == 3){
                newColonyCells.insert(c)
            }
            if(isColonyCellAlive(xCoor: c.xCoor, yCoor: c.yCoor) && neighborsCount == 2){
                newColonyCells.insert(c)
            }
        }
        ColonyCells = newColonyCells
        evolutionNumber += 1
    }
}
////////
