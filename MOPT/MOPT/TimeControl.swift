//
//  TimeControl.swift
//  MOPT
//
//  Created by Gustavo Avena on 30/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class TimeControl: NSObject {
    var expectedTime: TimeInterval?
    var startTime: Date?
    var endTime: Date?
    
    
//    init() {
        // TODO: initialize with current time. No expected time.
//    }
    
    
    init(expectedTime: TimeInterval? = nil) {
        self.expectedTime = expectedTime
        self.startTime = nil
        self.endTime = nil
    }
}
