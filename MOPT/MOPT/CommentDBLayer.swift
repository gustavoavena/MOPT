//
//  CommentDBLayer.swift
//  MOPT
//
//  Created by Gustavo Avena on 30/03/17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit

class CommentDBLayer: NSObject {
    
    let myContainer: CKContainer
    
    let publicDB: CKDatabase
    
    override init() {
        myContainer = CKContainer.default()
        publicDB = myContainer.publicCloudDatabase
    }


}
