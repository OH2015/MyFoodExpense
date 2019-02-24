



import UIKit
import Charts

class ViewController:UIViewController,UIScrollViewDelegate,UITextFieldDelegate,ChartViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource{

    @IBOutlet weak var TotalCostLabel: UILabel!

    @IBOutlet weak var PerCostLabel: UILabel!

    @IBOutlet weak var pieChartView: PieChartView!

    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView3: UIPickerView!
    @IBOutlet weak var pickerView4: UIPickerView!
    @IBOutlet weak var pickerView5: UIPickerView!
    @IBOutlet weak var pickerView6: UIPickerView!

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

        pickerView1.delegate = self
        pickerView2.delegate = self
        pickerView3.delegate = self
        pickerView4.delegate = self
        pickerView5.delegate = self
        pickerView6.delegate = self
        pickerView1.dataSource = self
        pickerView2.dataSource = self
        pickerView3.dataSource = self
        pickerView4.dataSource = self
        pickerView5.dataSource = self
        pickerView6.dataSource = self

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
        for i in 1...6{
            let box = BoxArray[i-1]
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
            TotalCost += BoxArray[i-1].cost
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
            Costs.append(Double(BoxArray[i-1].cost))
            Ingredients.append(BoxArray[i-1].ingredient)
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
        self.setData()
        self.performSegue(withIdentifier: "popUpSegue", sender: nil)

    }

    func setData(){
//        let f = DateFormatter()
//        f.dateStyle = .full
//        f.locale = Locale(identifier: "ja_JP")
        date = Date()
        DataArray.removeAll()
        DispatchQueue.main.async {
            DataArray.append(self.BoxArray)
            DataArray.append(self.Person)
            DataArray.append(self.date)
        }



    }

    func reloadData(Ind: Int){
        for i in 1...6{
            let ingField = view.viewWithTag(i) as! UITextField
            let costPicker = view.viewWithTag(i+10) as! UIPickerView
            let taxButton = view.viewWithTag(i+20) as! UIButton
            let personPicker = view.viewWithTag(0) as! UIPickerView
            let box = BoxArray[i-1]
            var cost = box.cost
            var tax = box.tax
            var ing = box.ingredient

            let recordArray = UserDefaults.standard.array(forKey: "KEY_RecordArray")
            let dataArray = recordArray![Ind] as! [Any]
            let newboxArray = dataArray[0] as! [Box]
            let newBox = newboxArray[i-1]
            cost = newBox.cost
            tax = newBox.tax
            Person = recordArray![1] as! Int
            ing = newBox.ingredient
            ingField.text = ing
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
            let box = BoxArray[i-1]
            box.ingredient = ingField.text ?? ""
            ingField.endEditing(true)
        }
        drawChart()
    }



}
