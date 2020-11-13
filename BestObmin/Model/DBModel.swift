//
//  DBModel.swift
//  BestObmin
//
//  Created by Vadym Maslov on 13.11.2020.
//  Copyright © 2020 Vadym Maslov. All rights reserved.
//

import RealmSwift

class CurrencyObject: Object {
    
    @objc dynamic var currency    = ""
    @objc dynamic var sell        = ""
    @objc dynamic var buy         = ""
    @objc dynamic var flag        = ""
    @objc dynamic var date        = Date()
    
}
