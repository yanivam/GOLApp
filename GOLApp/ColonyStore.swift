//
//  ColonyStore.swift
//  GOLApp
//
//  Created by Yaniv on 11/9/16.
//  Copyright © 2016 Yaniv Amiri. All rights reserved.
//

class ColonyStore {
    var allColonyItems = [TableColonyItem]()

    func removeItem(TableColonyItem: TableColonyItem) {
        if let index = allColonyItems.index(of: TableColonyItem) {
            allColonyItems.remove(at: index)
        }
    }

    func moveItem(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        //Get reference to object being moved so you can reinsert it
        let movedTableColonyItem = allColonyItems[fromIndex]
    
        //Remove it from array
        allColonyItems.remove(at: fromIndex)
    
        //Insert in new spot
        allColonyItems.insert(movedTableColonyItem, at: toIndex)
    }

    func createItem() -> TableColonyItem {
        let newTableColonyItem = TableColonyItem(name: "")
        
        allColonyItems.append(newTableColonyItem)
    
        return newTableColonyItem
    
    }
    //
}
