//
//  ViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/05.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
import Charts


var Prices = [String]()

let Person = ["1","2","3","4"]

class ViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate ,ChartViewDelegate{

    var TotalCost = 0
    var currentPerson = 1
    var cost1 = 0
    var cost2 = 0
    var cost3 = 0
    var cost4 = 0
    var cost5 = 0
    var cost6 = 0

    @IBOutlet weak var ingredients1: UITextField!
    @IBOutlet weak var ingredients2: UITextField!
    @IBOutlet weak var ingredients3: UITextField!
    @IBOutlet weak var ingredients4: UITextField!
    @IBOutlet weak var ingredients5: UITextField!
    @IBOutlet weak var ingredients6: UITextField!

    @IBOutlet weak var prices1: UIPickerView!
    @IBOutlet weak var prices2: UIPickerView!
    @IBOutlet weak var prices3: UIPickerView!
    @IBOutlet weak var prices4: UIPickerView!
    @IBOutlet weak var prices5: UIPickerView!
    @IBOutlet weak var prices6: UIPickerView!

    @IBOutlet weak var tax1: UIButton!
    @IBOutlet weak var tax2: UIButton!
    @IBOutlet weak var tax3: UIButton!
    @IBOutlet weak var tax4: UIButton!
    @IBOutlet weak var tax5: UIButton!
    @IBOutlet weak var tax6: UIButton!

    @IBOutlet weak var personPickerView: UIPickerView!

    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var perCost: UILabel!

    @IBOutlet weak var scrollView: MyScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentView2: UIView!
    @IBOutlet weak var pieChartView: PieChartView!

    @IBOutlet weak var pageControll: UIPageControl!

    var startcolor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    var endcolor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == personPickerView{
            return Person.count
        }else{
            return Prices.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == personPickerView{
            return Person[row]
        }else{
            return Prices[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == personPickerView{
            currentPerson = Int(Person[row])!
        }else{
            switch pickerView.tag{
            case 1:cost1 = Int(Prices[row])!
            case 2:cost2 = Int(Prices[row])!
            case 3:cost3 = Int(Prices[row])!
            case 4:cost4 = Int(Prices[row])!
            case 5:cost5 = Int(Prices[row])!
            case 6:cost6 = Int(Prices[row])!
            default:
                return
            }
        }
        taxInclude(tag: pickerView.tag)
    }


    @IBAction func taxChanged(_ sender: UIButton) {
        if sender.currentTitle == "税抜き"{
            sender.setTitle("税込", for: .normal)
            sender.setTitleColor(.red, for: .normal)
        }else{
            sender.setTitle("税抜き", for: .normal)
            sender.setTitleColor(.darkGray, for: .normal)
        }

        taxInclude(tag: sender.tag)
    }

    func taxInclude(tag: Int){
        let taxValue1 = Int(Double(cost1) * 0.08)
        let taxValue2 = Int(Double(cost2) * 0.08)
        let taxValue3 = Int(Double(cost3) * 0.08)
        let taxValue4 = Int(Double(cost4) * 0.08)
        let taxValue5 = Int(Double(cost5) * 0.08)
        let taxValue6 = Int(Double(cost6) * 0.08)
        if tax1.currentTitle == "税抜き"{
            cost1 += taxValue1
        }
        if tax2.currentTitle == "税抜き"{
            cost2 += taxValue2
        }
        if tax3.currentTitle == "税抜き"{
            cost3 += taxValue3
        }
        if tax4.currentTitle == "税抜き"{
            cost4 += taxValue4
        }
        if tax5.currentTitle == "税抜き"{
            cost5 += taxValue5
        }
        if tax6.currentTitle == "税抜き"{
            cost6 += taxValue6
        }
        self.calculate()
        if tax1.currentTitle == "税抜き"{
            cost1 -= taxValue1
        }
        if tax2.currentTitle == "税抜き"{
            cost2 -= taxValue2
        }
        if tax3.currentTitle == "税抜き"{
            cost3 -= taxValue3
        }
        if tax4.currentTitle == "税抜き"{
            cost4 -= taxValue4
        }
        if tax5.currentTitle == "税抜き"{
            cost5 -= taxValue5
        }
        if tax6.currentTitle == "税抜き"{
            cost6 -= taxValue6
        }
}

    func calculate(){
        TotalCost = cost1 + cost2 + cost3 + cost4 + cost5 + cost6
        if TotalCost == 0{
            perCost.text = "0"
        }else{
            let perc = TotalCost / currentPerson
            perCost.text = String(perc)

        }
        totalCost.text = String(TotalCost)
        drawChart()


    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ingredients1.placeholder = "食材"
        ingredients2.placeholder = "食材"
        ingredients3.placeholder = "食材"
        ingredients4.placeholder = "食材"
        ingredients5.placeholder = "食材"
        ingredients6.placeholder = "食材"

        var guradColors:[CGColor] = [startcolor.cgColor,endcolor.cgColor]
        let guradLayer:CAGradientLayer = CAGradientLayer()
        guradLayer.colors = guradColors
        guradLayer.frame = self.contentView.bounds
        self.contentView2.layer.insertSublayer(guradLayer, at: 0)

        for i in 0...100{            Prices.append(String(10*i))
        }

        scrollView.isDirectionalLockEnabled = true

        self.prices1.delegate = self
        self.prices2.delegate = self
        self.prices3.delegate = self
        self.prices4.delegate = self
        self.prices5.delegate = self
        self.prices6.delegate = self

        scrollView.delegate = self
    }

    func drawChart(){
        pieChartView.drawHoleEnabled = false

        let Costs = [Double(cost1),Double(cost2),Double(cost3),Double(cost4),Double(cost5),Double(cost6)]
        let Ingredients = [ingredients1?.text,ingredients2?.text,ingredients3?.text,ingredients4?.text,ingredients5?.text,ingredients6?.text]

        var dataset = [PieChartDataEntry]()

        for i in 0...Costs.count-1{
            if Costs[i] != 0 {
                dataset.append(PieChartDataEntry(value: Costs[i],label: Ingredients[i]))
            }
        }

        let dataSet = PieChartDataSet(values: dataset,label: "")
        dataSet.colors = ChartColorTemplates.colorful()
        let chartData = PieChartData(dataSet: dataSet)

        print (dataSet)

        pieChartView.data = chartData
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        done()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        done()
        return true
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControll.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
    }

    func done() {
        ingredients1.endEditing(true)
        ingredients2.endEditing(true)
        ingredients3.endEditing(true)
        ingredients4.endEditing(true)
        ingredients5.endEditing(true)
        ingredients6.endEditing(true)
        drawChart()
    }

}


