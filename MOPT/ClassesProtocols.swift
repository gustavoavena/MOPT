//
//  ClassesProtocols.swift
//  MOPT
//
//  Created by Gustavo Avena on 204//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import Foundation

typealias ObjectID = String


protocol MoptObject {
	// TODO: define protocols
	var ID: ObjectID {
		get
	}
}



// TODO: implement protocols for type restrictions when calling the CKHandler methods.
