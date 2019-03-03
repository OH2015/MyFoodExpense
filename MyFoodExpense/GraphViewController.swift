//
//  GraphViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/03/01.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var monthLabel: UILabel!

    var interval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        RecordArray = UserDefaults.standard.array(forKey: KEY.record.rawValue) as! [[[String]]]
        monthLabel.text = month()
        setChart()
    }

    @IBAction func back(_ sender: Any) {
        interval -= 1
        setChart()
        monthLabel.text = month()
    }

    @IBAction func force(_ sender: Any) {
        interval += 1
        setChart()
        monthLabel.text = month()
    }



    func setChart() {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        let monthData = dataInMonth()

        for i in 0..<numOfDaysInMonthOf()-1{
            var yVal = 0
            var dataInDay = [[[String]]]()
            for DataArray in monthData{
                let dateComponents = stringToDateComponents(strDate: DataArray[4][0])
                if dateComponents.day == i+1{
                    dataInDay.append(DataArray)
                }
            }
            for data in dataInDay{
                let intPrice = data[1].map{Int($0)}
                let dataprice = intPrice.reduce(0,{num1,num2 in
                    num1 + num2!
                })
                yVal += dataprice
            }
            let dataEntry = BarChartDataEntry(x: Double(i+1), y: Double(yVal))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(values: dataEntries, label: "金額")
        chartDataSet.drawValuesEnabled = false



        let chartData = BarChartData(dataSet: chartDataSet)
//        let ll = ChartLimitLine(limit: 10.0, label: "Target")

//        barChartView.rightAxis.addLimitLine(ll)
        barChartView.animate(yAxisDuration: 2.0)
        barChartView.xAxis.labelPosition = .bottom
        barChartView.borderLineWidth = 50
        barChartView.leftAxis.axisMinimum = 0
        barChartView.rightAxis.axisMinimum = 0
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.xAxis.spaceMin = 5
        barChartView.xAxis.spaceMax = 5
        barChartView.xAxis.granularity = 2
        barChartView.xAxis.labelCount = 6
        barChartView.xAxis.axisLineWidth = 3
        barChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 20)

        barChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 20)
        barChartView.scaleXEnabled = true
        barChartView.scaleYEnabled = true
        barChartView.rightAxis.labelFont = UIFont.systemFont(ofSize: 20)

        barChartView.data = chartData
    }

    func numOfDaysInMonthOf()->Int{
        var dateComponents = Calendar.current.dateComponents([.year,.month,.day], from: Date())
        dateComponents.month = dateComponents.month! + 1 + interval
        dateComponents.day = 0
        let date = Calendar.current.date(from: dateComponents)
        let dayCount = Calendar.current.component(.day, from: date!)

        return dayCount
    }

    func dataInMonth()->[[[String]]]{
        var dataInMonth = [[[String]]]()
        var currentMonth = Calendar.current.dateComponents([.month,.year], from: Date())
        currentMonth.month = currentMonth.month! + interval
        for DataArray in RecordArray{
            let strDate = DataArray[4][0]
            let dateComponents = stringToDateComponents(strDate: strDate)
            if dateComponents.year == currentMonth.year && dateComponents.month == currentMonth.month{
                dataInMonth.append(DataArray)
            }
        }
        return dataInMonth

    }
    func stringToDateComponents(strDate:String)->DateComponents{
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateStyle = .full
        f.timeStyle = .medium
        let date = f.date(from: strDate)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date!)
        return dateComponents
    }

    func month()->String{
        var calender = Calendar.current.dateComponents([.year,.month], from: Date())
        calender.month = calender.month! + interval

        if calender.month! > 0{
            calender.year = calender.year! + (calender.month!-1)/12
            calender.month = calender.month!%12
        }else{
            calender.year = calender.year! + calender.month!/12 - 1
            calender.month = 12-((12-calender.month!)%12)
        }
        if calender.month!%12 == 0{
            calender.month = 12
        }
        return "\(calender.year!)年\(calender.month!)月"

    }
}
