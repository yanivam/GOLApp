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
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar//
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets

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
    
}
