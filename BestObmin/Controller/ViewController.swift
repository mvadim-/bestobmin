//
//  ViewController.swift
//  BestObmin
//
//  Created by Vadym Maslov on 11/1/17.
//  Copyright © 2017 Vadym Maslov. All rights reserved.
//

import UIKit
import SwiftSoup
import SKActivityIndicatorView
import RealmSwift


class ViewController: UIViewController {
    @IBOutlet weak var curTV: UITableView!
    var curList             = [VMCurrencyModel?]()
    lazy var refreshControl = UIRefreshControl()
    static let myURLString  = "http://bestobmin.com.ua"
    var curLimit            = "opt"
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        refreshData((Any).self)
    }
    
    func setup() -> Void {
        curTV.dataSource                = self
        curTV.delegate                  = self
        curTV.rowHeight                 = 60
        refreshControl.attributedTitle  = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:#selector(refreshData(_:)), for: .valueChanged)
        if #available(iOS 11.0, *) {
            curTV.refreshControl = refreshControl
        } else {
            curTV.addSubview(refreshControl)
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch  Data
        DispatchQueue.global().async {
            self.updateSources()
        }
    }
    
    @IBAction func gurt(_ sender: UIBarButtonItem) {
        sender.title = (sender.title == "$$$") ? "$" : "$$$"
        curLimit = (sender.title == "$$$") ? "rozdrib" : "opt"
        updateSources()
    }
    
    func updateSources() -> Void {
        SKActivityIndicator.show("Updating...", userInteractionStatus: false)
        guard let myURL = URL(string: ViewController.myURLString) else {
            print("Error: \(ViewController.myURLString) doesn't seem to be a valid URL")
            return
        }
        
        guard let myHTMLString = try? String(contentsOf: myURL, encoding: .utf8)else {
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {self.refreshControl.endRefreshing()}
            }
            return
        }
        
        do {
            let doc: Document   = try SwiftSoup.parse(myHTMLString)
            let table: Elements = try doc.getElementsByAttributeValue("id", curLimit)
            let rows: Elements  = try (table.array().first?.getElementsByClass("row"))!
            self.curList        = []
            for cur: Element in rows{
                let cm = VMCurrencyModel(cur)
                curList.append(cm)
            }
            DispatchQueue.main.async {
                SKActivityIndicator.dismiss()
                self.curTV.reloadData()
                self.refreshControl.endRefreshing()
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "curCell") as! CurrencyTableViewCell
        guard let cm                     = curList[indexPath.row] else {return cell}
        let flag                         = cm.flag.components(separatedBy: "/")
        cell.buy.text                    = cm.buy
        cell.sell.text                   = cm.sell
        cell.currency.text               = cm.currency
        cell.flag.image                  = UIImage(named: flag.last!)
        updateDB(cur: cm)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let vc = presentingViewController as! DetailedController
        let vc = storyboard?.instantiateViewController(withIdentifier: "Details") as! DetailedController

        let cm = curList[indexPath.row]
        vc.currency = cm?.currency ?? ""
        present(vc, animated: true, completion: nil)
        
    }
    
    func updateDB(cur:VMCurrencyModel) {
        let realmObj        = CurrencyObject()
        realmObj.currency   = cur.currency
        realmObj.buy        = cur.buy
        realmObj.sell       = cur.sell
        realmObj.date       = Date()
        realmObj.flag       = cur.flag.components(separatedBy: "/").last!
        let realm = try! Realm()
        try! realm.write {
            realm.add(realmObj)
        }
    }
}
