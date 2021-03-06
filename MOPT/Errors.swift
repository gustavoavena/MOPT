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

enum CKHandlerError: Error {
    case NoRecordFound
	case FetchByID
}

enum QueryError: Error {
    case UserError
    case UserByEmail
}

enum DBLayerError: Error {
}

