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
    var timer = Timer()
    var currentFates = [NSValue: Bool]()
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var colonyView: UIView!
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
        //Status Bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        colonyView.layer.borderWidth = 4
        colonyView.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    @IBAction func addNewItem(sender: AnyObject) {
        //Create a new item and add it to the store
        let newItem = colonyStore.createItem()
        
        
        //Figure out where that item is in the array
        let index = colonyStore.allColonyItems.index(of: newItem)
        let indexPath = NSIndexPath(row: index!, section: 0)
        //Insert this new row into the table
        
        tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
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
        evolutionSpeed.value = 0.0
        evolutionSpeedChanged(sender: evolutionSpeed)
        wrappingSwitch.isOn = currentColony.wrapping
        coordinates.text = "x:     y:     "
        updateColonyView()
    }
    
    func evolve(){
        currentColony.evolve()
        updateColonyView()
    }
    
    func updateColonyView(){
        evolutionLabel.text = ("Evolution #" + String(currentColony.evolutionNumber))
        for view in colonyView.subviews{
            view.removeFromSuperview()
        }
        for singleCell in currentColony.ColonyCells{
            let singleFrame = CGRect(x: (singleCell.xCoor * 10), y: (singleCell.yCoor * 10), width: 10, height: 10)
            let singleView = UIView(frame: singleFrame)
            singleView.backgroundColor = UIColor.black
            colonyView.addSubview(singleView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            let location = touch.location(in: colonyView)
            let colonyX = Int(location.x / 10)
            let colonyY = Int(location.y / 10)
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
            let colonyX = Int(location.x / 10)
            let colonyY = Int(location.y / 10)
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

//To do: Movement set dead. Get good evolution range. Stop from going off colony. Show x: y: coordinates to user. What to do with x: y: for multiple touches? Way to clear colony? What to do for default (Default colony or CGRect hiding when nothing selected)? Hide Colony when deleted?
