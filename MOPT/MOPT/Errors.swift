//
//  Errors.swift
//  MOPT
//
//  Created by Gustavo Avena on 31/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

enum TimeError: Error {
    
    case StartError
    case EndError
    
}

enum QueryError: Error {
    case UserError
}

enum DBLayerError: Error {
}
