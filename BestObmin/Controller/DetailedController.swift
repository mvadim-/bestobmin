//
//  DetailedController.swift
//  BestObmin
//
//  Created by Vadym Maslov on 13.11.2020.
//  Copyright © 2020 Vadym Maslov. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DetailedController: UIViewController {
    
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var Item: UIBarButtonItem!
    var currency:String = ""
    var curList: Results<CurrencyObject>? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        Item.title = currency
        let realm = try! Realm()
        let predicate = NSPredicate(format: "currency = %@", "\(currency)")

        curList = realm.objects(CurrencyObject.self).filter(predicate).sorted(byKeyPath: "date", ascending: false)
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeVC(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension DetailedController :UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return curList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailedCell  = tableView.dequeueReusableCell(withIdentifier: "detailedCell") as! DetailedCell
       
        guard let cm :CurrencyObject = curList?[indexPath.row] else {return cell}
       
        let df = DateFormatter()
        df.dateFormat = "MM-dd hh:mm"
        let date = df.string(from: cm.date)
        
        cell.date.text = date
        cell.buy.text = cm.buy
        cell.sell.text = cm.sell
        return cell
    }
    
    
    
    
}
