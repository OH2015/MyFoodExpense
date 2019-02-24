



import UIKit
import Charts

class ViewController:UIViewController,UIScrollViewDelegate,UITextFieldDelegate,ChartViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource{

    @IBOutlet weak var TotalCostLabel: UILabel!

    @IBOutlet weak var PerCostLabel: UILabel!
    var box1 = Box(index:1)
    var box2 = Box(index:2)
    var box3 = Box(index:3)
    var box4 = Box(index:4)
    var box5 = Box(index:5)
    var box6 = Box(index:6)
    var BoxArray = [Box]()
    var TotalCost = 0
    var Person = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...100{
            PriceArray.append(10*i)
        }
        for i in 1...6{
            BoxArray.append(Box.boxWithIndex(i))
        }

        for i in 1...6{
            let ingField = view.viewWithTag(i) as! UITextField
            ingField.delegate = self
        }

        for i in 11...16{
            let costpicker = view.viewWithTag(i) as! UIPickerView
            costpicker.delegate = self
            costpicker.dataSource = self

        }

    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return 4
        }else{
            return 100
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return String(row)
        }else{
            return String(PriceArray[row])
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            Person = row+1
        }else{
            BoxArray[pickerView.tag - 11].cost = PriceArray[row]
        }
    }

    @IBAction func taxChanged(_ sender: UIButton) {
        if sender.currentTitle == "税抜き"{
            sender.setTitle("税込", for: .normal)
            sender.setTitleColor(.red, for: .normal)
        }else{
            sender.setTitle("税抜き", for: .normal)
            sender.setTitleColor(.darkGray, for: .normal)
        }

        taxInclude()
    }

    func taxInclude(){
        for i in 0...6{
            let box = Box.boxWithIndex(i)
            let Tax = Int(Double(box.cost) * 1.08)
            if box.tax == "税抜き"{
                box.cost += Tax
            }
            self.calculate()
            if box.tax == "税抜き"{
                box.cost -= Tax
            }

        }

    }

    func calculate(){
        for i in 0...6{

        }
        if TotalCost == 0{
            PerCostLabel.text = "0"
        }else{
            let perc = TotalCost / Person
            PerCostLabel.text = String(perc)

        }
        TotalCostLabel.text = String(TotalCost)
        drawChart()
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



}
