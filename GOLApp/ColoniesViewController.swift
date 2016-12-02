//
//  ViewController.swift
//  GOLApp
//
//  Created by Yaniv on 11/9/16.
//  Copyright © 2016 Yaniv Amiri. All rights reserved.
//

import UIKit

class ColoniesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var colonyStore: ColonyStore!
    var currentColony = Colony(cName: "Test", wrapping: true)
    //var currentFates = [NSValue:Bool]()
    var timer = Timer()
    let hidingFrame = CGRect(x: 315, y: 0, width: 1050, height: 1024)
    var hidingView : UIView? = nil
    
    /*var cellLength : CGFloat = 0
    var xBorder : CGFloat = 0
    var yBorder : CGFloat = 0*/
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var colonyView: ColonyView!
    @IBOutlet var evolutionLabel: UILabel!
    @IBOutlet var evolutionSpeed: UISlider!
    @IBOutlet var wrappingSwitch: UISwitch!
    @IBOutlet var coordinates: UILabel!
    
    
    @IBAction func evolutionSpeedChanged(sender: UISlider) {
        timer.invalidate() // just in case this button is tapped multiple times
        
        if(sender.value != 0){
            // start the timer
            timer = Timer.scheduledTimer(timeInterval: (0.3 / Double(sender.value)), target: self, selector: #selector(evolve), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func wrappingChanged(sender: UISwitch){
        currentColony.wrapping = sender.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //colonyView.updateCellDimensions()
        //colonyView.layer.borderWidth = 2
        //colonyView.layer.borderColor = UIColor.black.cgColor
        hidingView = UIView(frame: hidingFrame)
        hidingView!.backgroundColor = UIColor.darkGray
        view.addSubview(hidingView!)
    }
    
    /*func updateCellDimensions(){
        if(colonyView.frame.height > colonyView.frame.width){
            cellLength = colonyView.frame.width / 60
            yBorder = (colonyView.frame.height - colonyView.frame.width) / 2
        }
        else{
            cellLength = colonyView.frame.height / 60
            xBorder = (colonyView.frame.width - colonyView.frame.height) / 2
        }
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        //If you are currently in editing mode...
        if isEditing {
            //Change text of button to inform user of state
            sender.setTitle("Edit Colonies", for: .normal)
            
            //Turn off editing mode
            setEditing(false, animated: true)
        }
        else {
            //Change test of button to inform user of state
            sender.setTitle("Save edits", for: .normal)
            
            //Turn on editing mode
            hidingView!.isHidden = false
            setEditing(true, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableView")
        let item = colonyStore.allColonyItems[indexPath.row]
        cell?.textLabel?.text = item.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colonyStore.allColonyItems.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //If the table view is asking to commit a delete command
        if editingStyle == .delete {
            let item = colonyStore.allColonyItems[indexPath.row]
            //Remove the item from the store
            self.colonyStore.removeItem(TableColonyItem: item)
            
            //Also remove that row from the table view with an animation
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        colonyStore.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    //When colony from table is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentColony = colonyStore.allColonyItems[indexPath.row].colony
        colonyView.updateColony(newColony: currentColony, newCoordinates: coordinates)
        evolutionSpeed.value = 0.0
        evolutionSpeedChanged(sender: evolutionSpeed)
        wrappingSwitch.isOn = currentColony.wrapping
        coordinates.text = "x:     y:     "
        hidingView!.isHidden = true
        colonyView.setNeedsDisplay()
    }
    
    func evolve(){
        currentColony.evolve()
        evolutionLabel.text = ("Evolution #" + String(currentColony.evolutionNumber))
        colonyView.setNeedsDisplay()
    }
    
    /*func updateColonyView(){
        evolutionLabel.text = ("Evolution #" + String(currentColony.evolutionNumber))
        for view in colonyView.subviews{
            view.removeFromSuperview()
        }
        updateCellDimensions()
        for singleCell in currentColony.ColonyCells{
            let singleFrame = CGRect(x: Int(xBorder) + (singleCell.xCoor * Int(cellLength)), y: Int(yBorder) + (singleCell.yCoor * Int(cellLength)), width: Int(cellLength), height: Int(cellLength))
            let singleView = UIView(frame: singleFrame)
            singleView.backgroundColor = UIColor.black
            colonyView.addSubview(singleView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            let location = touch.location(in: colonyView)
            let colonyX = Int(location.x / cellLength)
            let colonyY = Int(location.y / cellLength)
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
            let location = touch.location(in: colonyView)
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
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        hidingView!.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        evolutionSpeed.value = 0
        //If the triggered segue is the "AddSegue" segue
        if segue.identifier == "AddSegue" {
        //Create a new item and add it to the store
        let newItem = colonyStore.createItem()
            
        //Figure out where that item is in the array
        let index = colonyStore.allColonyItems.index(of: newItem)
        let indexPath = NSIndexPath(row: index!, section: 0)
        //Insert this new row into the table
            
        tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
        //Get the item associated with this row and pass it along
        let item = newItem
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.tableColonyItem = item
            
        }
        
        if segue.identifier == "ChangeSegue" {
            if let row = tableView.indexPathForSelectedRow?.row {
                //Get the item associated with this row and pass it along
                let item = colonyStore.allColonyItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.tableColonyItem = item
            }
        }
    }
}
