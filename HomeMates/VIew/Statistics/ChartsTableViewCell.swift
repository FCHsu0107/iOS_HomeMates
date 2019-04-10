//
//  ChartsTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/9.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import Charts

class ChartsTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: PieChartView!
    
    @IBOutlet weak var totalGroupPointsLbl: UILabel!
    
    var firstDataEntry = PieChartDataEntry(value: 0)
    
    var secondDataEntry = PieChartDataEntry(value: 0)
    
    var thirdDataEntry = PieChartDataEntry(value: 0)
    
    var numberOfDownloadDataEntries = [PieChartDataEntry]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupChartData()
        updateChartData()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupChartData() {
        chartView.chartDescription?.text = "描述文字"
        
        firstDataEntry.value = 20
        firstDataEntry.label = "AAA"
        
        secondDataEntry.value = 30
        secondDataEntry.label = "BBB"
        
        thirdDataEntry.value = 40
        thirdDataEntry.label = "CCC"
        
        numberOfDownloadDataEntries = [firstDataEntry, secondDataEntry, thirdDataEntry]
        let pointValues: [Double] = [firstDataEntry.value, secondDataEntry.value, thirdDataEntry.value]
        
        totalGroupPointsLbl.text = "家庭總積分：\(pointValues.reduce(0, +))"
    }
    
//    https://stackoverflow.com/questions/41197122/pie-chart-using-charts-library-with-swift-3
//    程式碼
    func updateChartData() {
        let chartDataSet = PieChartDataSet(values: numberOfDownloadDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.red, UIColor.orange, UIColor.blue]
       
        chartDataSet.colors = colors
        
        chartView.data = chartData

    }
}
