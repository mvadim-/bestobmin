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
import Charts

class DetailedController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var Item: UIBarButtonItem!
    @IBOutlet weak var chart: UIBarButtonItem!
    var currency:String = ""
    var curList: Results<CurrencyObject>? = nil
    var chartView: LineChartView = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Item.title  = currency
        curList     = realmHelper.realmObjectslist(forCurrency: currency)
    }
    
    
    @IBAction func chart(_ sender: UIBarButtonItem) {
        tv.isHidden = true
        let rect = CGRect(
            origin: tv.frame.origin,
            size: tv.frame.size
        )
        chartView                           = LineChartView.init(frame:rect)
        chartView.delegate                  = self
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled               = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled          = true
        
        // x-axis
        let llXAxis                 = chartView.xAxis
        llXAxis.labelPosition       = .bottom
        llXAxis.gridLineDashLengths = [10, 10]
        llXAxis.gridLineDashPhase   = 0
        let leftAxis                = chartView.leftAxis
        leftAxis.removeAllLimitLines()

        // y-axis
        let min                                     = curList?.first
        leftAxis.axisMaximum                        = Double(min!.sell)! + 0.5
        leftAxis.axisMinimum                        = Double(min!.buy)! - 0.5
        leftAxis.gridLineDashLengths                = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled    = true
        
        chartView.rightAxis.enabled = false
        chartView.legend.form       = .line
        chartView.animate(xAxisDuration: 1.5)
        self.setDataCount(forDateInterval: 1)
        view.addSubview(chartView)
    }
    
    func setDataCount(forDateInterval date :Int) {
        
        var valuesBuy = [ChartDataEntry]()
        var valuesSell = [ChartDataEntry]()

        curList?.enumerated().forEach({(index, cm :CurrencyObject) in
            let today = Calendar(identifier: .gregorian).isDateInToday(cm.date)
            if (today) {
                valuesBuy.append(ChartDataEntry(x: Double(index), y: Double(cm.buy)!, data: cm.date))
                valuesSell.append(ChartDataEntry(x: Double(index), y: Double(cm.sell)!, data: cm.date))}
        })
        
        let setBuy                = LineChartDataSet(entries: valuesBuy, label: "Buy")
        setup(setBuy)
        setBuy.fillAlpha          = 0.8
        setBuy.fillColor          = .red
        
        let setSell                = LineChartDataSet(entries: valuesSell, label: "Sell")
        setup(setSell)
        setSell.fillAlpha          = 0.2
        setSell.fillColor          = .green
        
        let data                = LineChartData(dataSets: [setBuy,setSell])
        chartView.data          = data
    }
    
    private func setup(_ dataSet: LineChartDataSet) {
        dataSet.lineDashLengths             = nil
        dataSet.highlightLineDashLengths    = nil
        dataSet.setColors(dataSet.label == "Buy" ? .red : .green)
        dataSet.setCircleColor(dataSet.label == "Buy" ? .red : .green)
        dataSet.lineWidth                   = 1
        dataSet.circleRadius                = 3
        dataSet.drawCircleHoleEnabled       = false
        dataSet.valueFont                   = .systemFont(ofSize: 9)
        dataSet.formLineDashLengths         = nil
        dataSet.formLineWidth               = 1
        dataSet.formSize                    = 15
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
        let cell: DetailedCell          = tableView.dequeueReusableCell(withIdentifier: "detailedCell") as! DetailedCell
        guard let cm :CurrencyObject    = curList?[indexPath.row] else {return cell}
        let df          = DateFormatter()
        df.dateFormat   = "dd.MM hh:mm"
        let date        = df.string(from: cm.date)
        cell.date.text  = date
        cell.buy.text   = cm.buy
        cell.sell.text  = cm.sell
        return cell
    }
}
