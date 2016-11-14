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
    var serialNumber: String?
    init(name: String, serialNumber: String?) {
        self.name = name
        colony = Colony(cName: name, wrapping: false)
        self.serialNumber = serialNumber
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let randomInt = arc4random_uniform(UInt32(UInt32.max))
            let chosenName = "Colony \(randomInt)"
            let randomSerialNumber = NSUUID().uuidString.components(separatedBy: "-").first!
            self.init(name: chosenName, serialNumber: randomSerialNumber)
        }
        else {
            self.init(name: "", serialNumber: nil)
        }
    }
}
