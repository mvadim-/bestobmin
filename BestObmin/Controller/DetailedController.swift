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
        

        if sender.title == "Graph" {
            tv.isHidden = true
            chartView.isHidden = false
        } else{
            tv.isHidden = false
            chartView.isHidden = true
        }
        
        sender.title = (sender.title == "Graph") ? "Table" : "Graph"

        if chartView.isEmpty() {
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
            llXAxis.granularity = 1
            llXAxis.gridLineDashLengths = [10, 10]
            llXAxis.gridLineDashPhase   = 0
            let leftAxis                = chartView.leftAxis
            leftAxis.removeAllLimitLines()

            // y-axis
            let cur                                     = curList?.first
            leftAxis.axisMaximum                        = Double(cur!.sell)! + 0.2
            leftAxis.axisMinimum                        = Double(cur!.buy)! - 0.2
            leftAxis.gridLineDashLengths                = [5, 5]
            leftAxis.drawLimitLinesBehindDataEnabled    = true
            
            let df          = DateFormatter()
            df.dateFormat   = "EEEE, MMM d, yyyy"
            let date = df.string(from: cur!.date)
            
            let firstLegend = LegendEntry.init(label: "\(date)", form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor.black)
            chartView.legend.extraEntries.append(firstLegend)
            chartView.rightAxis.enabled = false
            chartView.legend.form       = .line
            chartView.animate(xAxisDuration: 0.5)
            self.setDataCount(forDateInterval: 1)
            view.addSubview(chartView)
        }
        
        
    }
    
    func setDataCount(forDateInterval date :Int) {
        
        var valuesBuy       = [ChartDataEntry]()
        var valuesSell      = [ChartDataEntry]()
        var valuesDates     = [String]()
        
        let df          = DateFormatter()
        df.dateFormat   = "hh:mm"
        
        curList?.enumerated().forEach({(index, cm :CurrencyObject) in
            let today = Calendar(identifier: .gregorian).isDateInToday(cm.date)
            if (today) {
                valuesBuy.append(ChartDataEntry(x: Double(index),
                                                y: Double(cm.buy)!))
                valuesSell.append(ChartDataEntry(x: Double(index),
                                                 y: Double(cm.sell)!))
                valuesDates.append(df.string(from: cm.date))
            }
        })
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:valuesDates)
        
        let setBuy                = LineChartDataSet(entries: valuesBuy, label: "Buy")
        setBuy.fillAlpha          = 0.8
        setBuy.fillColor          = .red
        setup(setBuy)

        let setSell                = LineChartDataSet(entries: valuesSell, label: "Sell")
        setSell.fillAlpha          = 0.2
        setSell.fillColor          = .green
        setup(setSell)

        let data        = LineChartData(dataSets: [setBuy,setSell])
        chartView.data  = data
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
