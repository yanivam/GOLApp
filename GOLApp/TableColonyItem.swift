//
//  TableColonyItem.swift
//  GOLApp
//
//  Created by Yaniv on 11/11/16.
//  Copyright © 2016 Yaniv Amiri. All rights reserved.
//

import UIKit

class TableColonyItem: NSObject {
    var name: String
    var colony : Colony
    var template: String
    
    init(name: String) {
        self.name = name
        colony = Colony(cName: name, wrapping: false)
        template = "Blank"
        super.init()
    }
    
    func templateSetter() {
        if(template == "Blank") {
            print("Empty template")
        }
        
        if(template == "Basic") {
            print("Basic template")
            colony.setColonyCellAlive(xCoor: 4, yCoor: 4)
            colony.setColonyCellAlive(xCoor: 4, yCoor: 3)
            colony.setColonyCellAlive(xCoor: 4, yCoor: 5)
            colony.setColonyCellAlive(xCoor: 5, yCoor: 4)
        }
        
        if(template == "Glider") {
            print("Glider template")
            colony.setColonyCellAlive(xCoor: 10, yCoor: 12)
            colony.setColonyCellAlive(xCoor: 10, yCoor: 13)
            colony.setColonyCellAlive(xCoor: 10, yCoor: 11)
            colony.setColonyCellAlive(xCoor: 11, yCoor: 12)
        }
    }
}
