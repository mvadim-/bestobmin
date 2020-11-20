//
//  realmHelper.swift
//  BestObmin
//
//  Created by Vadym Maslov on 16.11.2020.
//  Copyright © 2020 Vadym Maslov. All rights reserved.
//

import Foundation
import RealmSwift

class realmHelper {
    
    class func realmObjectslist(forCurrency currency:String) -> Results<CurrencyObject> {
        let realm       = try! Realm()
        let predicate   = NSPredicate(format: "currency = %@", "\(currency)")
        return realm.objects(CurrencyObject.self).filter(predicate).sorted(byKeyPath: "date", ascending: false)
    }
    
    class func deleteObjects() {
        let realm   = try! Realm()
        let curList = realm.objects(CurrencyObject.self)
        curList.forEach({(cm :CurrencyObject) in
            if cm.buy == "" {
                try! realm.write {
                    realm.delete(cm)
                }
            }
        })
    }
    
}
