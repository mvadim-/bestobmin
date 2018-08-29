//
//  VMCurrencyModel.swift
//  BestObmin
//
//  Created by Vadym Maslov on 11/2/17.
//  Copyright © 2017 Vadym Maslov. All rights reserved.
//

import UIKit
import SwiftSoup

class VMCurrencyModel: NSObject {
    var currency = ""
    var sell     = ""
    var buy      = ""
    var flag     = ""
    
    convenience init(_ el: Element) {
        self.init()
        do {
            self.currency = try el.getElementsByClass("currency").text()
            self.flag     = try el.getElementsByAttribute("alt").attr("src")
            self.buy      = try el.getElementsByClass("digit_bg left_digit_bg").text()
            self.sell     = try el.getElementsByClass("digit_bg right_digit_bg").text()
        }
        catch let error {
            print("Error: \(error)")
        }
    }
}
