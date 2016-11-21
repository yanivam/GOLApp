//
//  TableColonyItem.swift
//  GOLApp
//
//  Created by Yaniv on 11/11/16.
//  Copyright © 2016 Yaniv Amiri. All rights reserved.
//

import UIKit

class ColonyView: UIView{
    var currentFates = [NSValue: Bool]()
    var currentColony = Colony(cName: "Test", wrapping: true)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            let location = touch.location(in: self)
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
            let location = touch.location(in: self)
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

