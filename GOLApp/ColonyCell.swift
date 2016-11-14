//
//  Cell.swift
//  GOLApp
//
//  Created by Yaniv on 11/9/16.
//  Copyright © 2016 Yaniv Amiri. All rights reserved.
//

import Foundation

struct ColonyCell: Hashable, Equatable {
    
    var hashValue: Int {
        return xCoor.hashValue ^ yCoor.hashValue
    }
    
    let xCoor: Int
    let yCoor: Int
    
    init(_ xCoor: Int,_ yCoor: Int) {
        self.xCoor = xCoor
        self.yCoor = yCoor
    }
}

func == (lhs: ColonyCell, rhs: ColonyCell) -> Bool {
    return lhs.xCoor == rhs.xCoor && lhs.yCoor == rhs.yCoor
}
