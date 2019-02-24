



import UIKit
import Charts

class ViewController:UIViewController,UIScrollViewDelegate,UITextFieldDelegate,ChartViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource{

    @IBOutlet weak var TotalCostLabel: UILabel!

    @IBOutlet weak var PerCostLabel: UILabel!

    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var pageControll: UIPageControl!
    var box1 = Box(index:1)
    var box2 = Box(index:2)
    var box3 = Box(index:3)
    var box4 = Box(index:4)
    var box5 = Box(index:5)
    var box6 = Box(index:6)
    var BoxArray = [Box]()
    var TotalCost = 0
    var Person = 1
    var date = Date()
    var DataArray = [BoxArray,Person,date]

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...100{
            PriceArray.append(10*i)
        }
        BoxArray = [box1,box2,box3,box4,box5,box6]
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
            let box = BoxArray[i]
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
        for i in 1...6{
            TotalCost += BoxArray[i].cost
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
        var Costs = [Double]()
        var Ingredients = [String]()
        for i in 1...6{
            Costs.append(Double(BoxArray[i].cost))
            Ingredients.append(BoxArray[i].ingredient)
        }

        var dataset = [PieChartDataEntry]()
//値段が入っているデータだけエントリーする
        for i in 0...Costs.count-1{
            if Costs[i] != 0 {
                dataset.append(PieChartDataEntry(value: Costs[i],label: Ingredients[i]))
            }
        }

        let dataSet = PieChartDataSet(values: dataset,label: "")
        dataSet.colors = ChartColorTemplates.colorful()
        let chartData = PieChartData(dataSet: dataSet)

        pieChartView.data = chartData
    }

    @IBAction func storeValue(_ sender: Any) {
        let secVC = secondViewController()
        secVC.pickDataFromKey()
        DispatchQueue.main.async {
            self.setData()
            self.performSegue(withIdentifier: "popUpSegue", sender: nil)
        }
    }

    func setData(){
        let f = DateFormatter()
        f.dateStyle = .full
        f.locale = Locale(identifier: "ja_JP")


        for i in 1...6{
            let ingField = view.viewWithTag(i) as! UITextField
            BoxArray[i].ingredient = ingField.text ?? ""
        }
    }

    func reloadData(){
        for i in 1...6{
            let ingField = view.viewWithTag(i) as! UITextField
            let costPicker = view.viewWithTag(i+10) as! UIPickerView
            let personPicker = view.viewWithTag(0) as! UIPickerView
            let taxButton = view.viewWithTag(i+20) as! UIButton
            let box = BoxArray[i]
            let cost = box.cost
            let tax = box.tax

//            ingField.text =
//            cost =
//            tax =
//            Person =
            if tax == "税抜き"{}else{
                taxButton.setTitle("税込", for: .normal)
            }
            costPicker.selectRow(cost/10, inComponent: 0, animated: true)
            personPicker.selectRow(Person-1, inComponent: 0, animated: true)
        }
        DispatchQueue.main.async {
            self.taxInclude()
        }
    }

    @IBAction func unwiiiin(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControll.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        done()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        done()
        return true
    }

    func done() {
        for i in 1...6{
            let ingField = view.viewWithTag(i) as! UITextField
            ingField.endEditing(true)
        }
        drawChart()
    }



}
