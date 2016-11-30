import UIKit

class ColonyView: UIView{
    var currentColony: Colony = Colony(cName: "Test", wrapping: true)
    var currentFates = [NSValue:Bool]()
    var cellLength : CGFloat = 0
    var xBorder : CGFloat = 0
    var yBorder : CGFloat = 0
    //var coordinates: String = ""
    var borderView : UIView? = nil
    
    var coordinates: UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    func updateColony(newColony: Colony, newCoordinates: UILabel){
        currentColony = newColony
        coordinates = newCoordinates
    }
    
    func updateCellDimensions(){
        if(frame.height > frame.width){
            cellLength = frame.width / 60
            yBorder = ((frame.height - frame.width) / 2)
            xBorder = (frame.width.truncatingRemainder(dividingBy: 60))
        }
        else{
            cellLength = frame.height / 60
            print(cellLength)
            xBorder = ((frame.width - frame.height) / 2) + (frame.width.truncatingRemainder(dividingBy: 60))
            yBorder = (frame.height.truncatingRemainder(dividingBy: 60))
        }
        let borderFrame = CGRect(x: xBorder, y: yBorder, width: frame.width - (2 * xBorder), height: frame.height - (2 * yBorder))
        borderView = UIView(frame: borderFrame)
        borderView!.layer.borderWidth = 2
        borderView!.layer.borderColor = UIColor.black.cgColor
        //addSubview(borderView!)
    }
    
    func updateColonyView(){
        for view in subviews{
            view.removeFromSuperview()
        }
        updateCellDimensions()
        for singleCell in currentColony.ColonyCells{
            let singleFrame = CGRect(x: Int(xBorder + (CGFloat(singleCell.xCoor) * cellLength)), y: Int(yBorder + (CGFloat(singleCell.yCoor) * cellLength)), width: Int(cellLength), height: Int(cellLength))
            let singleView = UIView(frame: singleFrame)
            singleView.backgroundColor = UIColor.black
            addSubview(singleView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            let location = touch.location(in: self)
            let colonyX = Int((location.x-xBorder) / cellLength)
            let colonyY = Int((location.y-yBorder) / cellLength)
            coordinates.text = "x: \(colonyX) y: \(59-colonyY)"
            var fate = false
            if currentColony.isColonyCellAlive(xCoor: colonyX, yCoor: colonyY){
                currentColony.setColonyCellDead(xCoor: colonyX, yCoor: colonyY)
                fate = false
            }else{
                currentColony.setColonyCellAlive(xCoor: colonyX, yCoor: colonyY)
                fate = true
            }
            updateColonyView()
            currentFates[key] = fate
            print(currentFates[key]!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            let location = touch.location(in: self)
            let colonyX = Int((location.x-xBorder) / cellLength)
            let colonyY = Int((location.y-yBorder) / cellLength)
            coordinates.text = "x: \(colonyX) y: \(59-colonyY)"
            if currentColony.isColonyCellAlive(xCoor: colonyX, yCoor: colonyY){
                if !currentFates[key]!{
                    currentColony.setColonyCellDead(xCoor: colonyX, yCoor: colonyY)
                    updateColonyView()
                }
            }else if(!currentColony.isColonyCellAlive(xCoor: colonyX, yCoor: colonyY) && currentFates[key]!){
                currentColony.setColonyCellAlive(xCoor: colonyX, yCoor: colonyY)
                updateColonyView()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let key = NSValue(nonretainedObject: touch)
            currentFates.removeValue(forKey: key)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentFates.removeAll()
    }
}
