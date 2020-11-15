//
//  DBModel.swift
//  BestObmin
//
//  Created by Vadym Maslov on 13.11.2020.
//  Copyright © 2020 Vadym Maslov. All rights reserved.
//

import RealmSwift

class CurrencyObject: Object {
    
    @objc dynamic var currency  :String = ""
    @objc dynamic var sell      :String = ""
    @objc dynamic var buy       :String = ""
    @objc dynamic var flag      :String = ""
    @objc dynamic var date      :Date   = Date()
    
}
