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
var Ingredients = ["なし"]
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

    var ingpickerView: UIPickerView! = UIPickerView()
    @IBOutlet weak var personPickerView: UIPickerView!

    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var perCost: UILabel!

    @IBOutlet weak var scrollView: MyScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentView2: UIView!

    @IBOutlet weak var pageControll: UIPageControl!

    var barChartView: BarChartView!

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == ingpickerView{
            return Ingredients.count
        }else if pickerView == personPickerView{
            return Person.count
        }else{
            return Prices.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == ingpickerView{
            return Ingredients[row]
        }else if pickerView == personPickerView{
            return Person[row]
        }else{
            return Prices[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == personPickerView{
            currentPerson = Int(Person[row])!
        }else if pickerView == ingpickerView{
            return
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
        switch tag {
        case 1:
            let taxValue = Int(Double(cost1) * 0.08)
            if tax1.currentTitle == "税込"{
                self.calculate()
            }else{
                cost1 += taxValue
                self.calculate()
                cost1 -= taxValue
            }
        case 2:
            let taxValue = Int(Double(cost2) * 0.08)
            if tax2.currentTitle == "税込"{
                self.calculate()
            }else{
                cost2 += taxValue
                self.calculate()
                cost2 -= taxValue
            }
        case 3:
            let taxValue = Int(Double(cost3) * 0.08)
            if tax3.currentTitle == "税込"{
                self.calculate()
            }else{
                cost3 += taxValue
                self.calculate()
                cost3 -= taxValue
            }
        case 4:
            let taxValue = Int(Double(cost4) * 0.08)
            if tax4.currentTitle == "税込"{
                self.calculate()
            }else{
                cost4 += taxValue
                self.calculate()
                cost4 -= taxValue
            }
        case 5:
            let taxValue = Int(Double(cost5) * 0.08)
            if tax5.currentTitle == "税込"{
                self.calculate()
            }else{
                cost5 += taxValue
                self.calculate()
                cost5 -= taxValue
            }
        case 6:
            let taxValue = Int(Double(cost6) * 0.08)
            if tax6.currentTitle == "税込"{
                self.calculate()
            }else{
                cost6 += taxValue
                self.calculate()
                cost6 -= taxValue
            }
        default:
            return
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

        barChartView.removeFromSuperview()
        drawChart()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0...100{
            Prices.append(String(10*i))
        }

        scrollView.isDirectionalLockEnabled = true

//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
//        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
//        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
//        toolbar.setItems([cancelItem, doneItem], animated: true)


//        ingpickerView.delegate = self
//        ingpickerView.showsSelectionIndicator = true
//        ingpickerView.dataSource = self

//        ingredients1.inputView = ingpickerView
//        ingredients1.inputAccessoryView = toolbar
//        ingredients2.inputView = ingpickerView
//        ingredients2.inputAccessoryView = toolbar
//        ingredients3.inputView = ingpickerView
//        ingredients3.inputAccessoryView = toolbar
//        ingredients4.inputView = ingpickerView
//        ingredients4.inputAccessoryView = toolbar
//        ingredients5.inputView = ingpickerView
//        ingredients5.inputAccessoryView = toolbar

        self.prices1.delegate = self
        self.prices2.delegate = self
        self.prices3.delegate = self
        self.prices4.delegate = self
        self.prices5.delegate = self
        self.prices6.delegate = self

        scrollView.delegate = self

        drawChart()
    }

    func setChart(y: [Double]) {

        // グラフタイトル
        barChartView.chartDescription?.text = "testestest"

        // アニメーション
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)

        //横軸を非表示
        barChartView.xAxis.enabled = false

        // y軸
        var data = [BarChartDataEntry]()

        for (i, val) in y.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(i), y: val)
            data.append(dataEntry)
        }
        // グラフをセット

        let DataSet = BarChartDataSet(values: data, label: "test_charts")
        barChartView.data = BarChartData(dataSet: DataSet)
        // グラフの色
        DataSet.colors = ChartColorTemplates.vordiplom()

    }

    func drawChart(){

        barChartView = BarChartView.init(frame: CGRect(x: 20, y: 200, width: self.view.frame.width - 40, height:self.view.frame.size.height - 300))

        self.barChartView.delegate = self

        let Costs = [Double(cost1),Double(cost2),Double(cost3),Double(cost4),Double(cost5),Double(cost6)]
        setChart(y: Costs)

        self.contentView2.addSubview(barChartView)
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

    @objc
    func cancel() {
        ingredients1.text = ""
        ingredients1.endEditing(true)
        ingredients2.text = ""
        ingredients2.endEditing(true)
        ingredients3.text = ""
        ingredients3.endEditing(true)
        ingredients4.text = ""
        ingredients4.endEditing(true)
        ingredients5.text = ""
        ingredients5.endEditing(true)
        ingredients6.text = ""
        ingredients6.endEditing(true)
    }

//    @objc
    func done() {
        ingredients1.endEditing(true)
        ingredients2.endEditing(true)
        ingredients3.endEditing(true)
        ingredients4.endEditing(true)
        ingredients5.endEditing(true)
        ingredients6.endEditing(true)
    }

}


