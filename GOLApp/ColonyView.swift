import UIKit

class ColonyView: UIView{
    var currentColony: Colony = Colony(cName: "Test", wrapping: true)
    var currentFates = [NSValue:Bool]()
    var cellLength : CGFloat = 0
    var xBorder : CGFloat = 0
    var yBorder : CGFloat = 0
    var borderView : UIView = UIView()
    
    var coordinates: UILabel = UILabel()
    
    //var lostAmount = Float(0)
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    func updateColony(newColony: Colony, newCoordinates: UILabel){
        currentColony = newColony
        coordinates = newCoordinates
    }
    
    func updateCellDimensions(){
        if(frame.height > frame.width){
            //lostAmount = ceilf(Float(frame.height.truncatingRemainder(dividingBy: 60)) / Float(60))
            cellLength = frame.width / 60
            yBorder = ((frame.height - frame.width) / 2)
        }
        else{
            //lostAmount = ceilf(Float(frame.width.truncatingRemainder(dividingBy: 60)) / Float(60))
            cellLength = frame.height / 60
            xBorder = ((frame.width - frame.height) / 2)
        }
        let borderFrame = CGRect(x: xBorder, y: yBorder, width: frame.width - (2 * xBorder), height: frame.height - (2 * yBorder))
        borderView = UIView(frame: borderFrame)
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = UIColor.black.cgColor
        addSubview(borderView)
    }
    
    /*func updateColonyView(){
        updateCellDimensions()
        for view in borderView.subviews{
            view.removeFromSuperview()
        }
        for singleCell in currentColony.ColonyCells{
            let singleFrame = CGRect(x: Int(CGFloat(singleCell.xCoor) * cellLength), y: Int(CGFloat(singleCell.yCoor) * cellLength), width: (Int(cellLength) + 1), height: (Int(cellLength) + 1))
            //let context = UIGraphicsGetCurrentContext()
            //context!.setFillColor(red: 0.0, green: 0.0, blue: 100.0, alpha: 0.5)
            //context!.fill(CGRect(x: 400, y: 500, width: 1000, height: 1000))
            let singleView = UIView(frame: singleFrame)
            singleView.backgroundColor = UIColor.black
            borderView.addSubview(singleView)
        }
    }*/
    
    override func draw(_ rect: CGRect) {
        updateCellDimensions()
        let context = UIGraphicsGetCurrentContext()
        for singleCell in currentColony.ColonyCells{
            let singleFrame = CGRect(x: Int(xBorder + CGFloat(singleCell.xCoor) * cellLength), y: Int(yBorder + CGFloat(singleCell.yCoor) * cellLength), width: (Int(cellLength) + 1), height: (Int(cellLength) + 1))
            context!.fill(singleFrame)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            let location = touch.location(in: borderView)
            let colonyX = Int(location.x / cellLength)
            let colonyY = Int(location.y / cellLength)
            if(borderView.bounds.contains(location)){
                coordinates.text = "x: \(colonyX) y: \(59-colonyY)"
                var fate = false
                if currentColony.isColonyCellAlive(xCoor: colonyX, yCoor: colonyY){
                    currentColony.setColonyCellDead(xCoor: colonyX, yCoor: colonyY)
                    fate = false
                }else{
                    currentColony.setColonyCellAlive(xCoor: colonyX, yCoor: colonyY)
                    fate = true
                }
                currentFates[key] = fate
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            let location = touch.location(in: borderView)
            let colonyX = Int(location.x / cellLength)
            let colonyY = Int(location.y / cellLength)
            if(borderView.bounds.contains(location)){
                coordinates.text = "x: \(colonyX) y: \(59-colonyY)"
                if currentColony.isColonyCellAlive(xCoor: colonyX, yCoor: colonyY) && !currentFates[key]!{
                    currentColony.setColonyCellDead(xCoor: colonyX, yCoor: colonyY)
                    setNeedsDisplay()
                }else if(!currentColony.isColonyCellAlive(xCoor: colonyX, yCoor: colonyY) && currentFates[key]!){
                    currentColony.setColonyCellAlive(xCoor: colonyX, yCoor: colonyY)
                    setNeedsDisplay()
                }
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
