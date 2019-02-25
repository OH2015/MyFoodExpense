



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

    @IBOutlet weak var personPicker: UIPickerView!
    @IBOutlet weak var pageControll: UIPageControl!
    let userDefaults = UserDefaults.standard
    var box1 = Box(index:1)
    var box2 = Box(index:2)
    var box3 = Box(index:3)
    var box4 = Box(index:4)
    var box5 = Box(index:5)
    var box6 = Box(index:6)
    var Person = 1
    var date:String = ""
    var BoxQueue = [Box]()

    override func viewDidLoad() {
        super.viewDidLoad()
        userDefaults.register(defaults: [KEY.box.rawValue:[[Box]](),
                                         KEY.data.rawValue:[[String]]()])

        for i in 0...100{
            PriceArray.append(10*i)
        }
        BoxQueue = [box1,box2,box3,box4,box5,box6]
        for i in 1...6{
            let ingField = view.viewWithTag(i) as! UITextField
            ingField.placeholder = "食材"
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
        personPicker.dataSource = self
        personPicker.delegate = self

    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == -1{
            return 4
        }else{
            return 100
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == -1{
            return String(row+1)
        }else{
            return String(PriceArray[row])
        }


    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == -1{
            Person = row+1
        }else{
            BoxQueue[pickerView.tag - 11].cost = PriceArray[row]
        }
        taxInclude()
    }

    @IBAction func taxChanged(_ sender: UIButton) {
        if sender.currentTitle == "税抜き"{
            sender.setTitle("税込", for: .normal)
            sender.setTitleColor(.red, for: .normal)
        }else{
            sender.setTitle("税抜き", for: .normal)
            sender.setTitleColor(.black, for: .normal)
        }
        let box = BoxQueue[sender.tag-21]
        box.tax = sender.currentTitle!
        taxInclude()
    }

    func taxInclude(){
        for i in 0...5{
            let box = BoxQueue[i]
            let Tax = Int(Double(box.cost) * 0.08)
            if box.tax == "税抜き"{
                box.cost += Tax
            }
            self.calculate()
            DispatchQueue.main.async {
                if box.tax == "税抜き"{
                    box.cost -= Tax
                }
            }

        }
    }

    func calculate(){
        var TotalCost = 0
        for i in 0...5{
            TotalCost += BoxQueue[i].cost
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
        for i in 0...5{
            Costs.append(Double(BoxQueue[i].cost))
            Ingredients.append(BoxQueue[i].ingredient)
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
        let f = DateFormatter()
        f.dateStyle = .full
        f.locale = Locale(identifier: "ja_JP")
        date = f.string(from: Date())
        ingSet.removeAll()
        costSet.removeAll()
        taxSet.removeAll()
        DataSet.removeAll()
        for i in 0...5{
            ingSet.append(BoxQueue[i].ingredient)
            costSet.append(String(BoxQueue[i].cost))
            taxSet.append(BoxQueue[i].tax)
        }
        DispatchQueue.main.async {
            DataSet.append(String(self.Person))
            DataSet.append(self.date)
        }
    }

    func reloadData(Ind: Int){
        BoxArray = userDefaults.array(forKey: KEY.box.rawValue) as! [[[String]]]
        DataArray = userDefaults.array(forKey: KEY.data.rawValue)!
        BoxSet = BoxArray[Ind]
        DataSet = DataArray[Ind] as! [String]
//        BoxSet = [ingSet[0...5],costSet[0...5],taxSet[0...5]]
//        DataSet = [Person,date,Title]

        ingSet = BoxSet[0]
        costSet = BoxSet[1]
        taxSet = BoxSet[2]

        for i in 1...6{
            let ingField = view.viewWithTag(i) as! UITextField
            let taxButton = view.viewWithTag(i+20) as! UIButton
            let box = BoxQueue[i-1]

            box.ingredient = ingSet[i-1]
            box.cost = Int(costSet[i-1])!
            box.tax = taxSet[i-1]
            ingField.text = box.ingredient
            if box.tax == "税抜き"{}else{
                taxButton.setTitle("税込", for: .normal)
            }
        }
        print(box1.ingredient,box1.cost,box1.tax)
        Person = Int(DataSet[0])!
        pickerView1.selectRow(box1.cost/10, inComponent: 0, animated: true)
        pickerView2.selectRow(box2.cost/10, inComponent: 0, animated: true)
        pickerView3.selectRow(box3.cost/10, inComponent: 0, animated: true)
        pickerView4.selectRow(box4.cost/10, inComponent: 0, animated: true)
        pickerView5.selectRow(box5.cost/10, inComponent: 0, animated: true)
        pickerView6.selectRow(box6.cost/10, inComponent: 0, animated: true)
        personPicker.selectRow(Person-1, inComponent: 0, animated: true)

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
            let box = BoxQueue[i-1]
            box.ingredient = ingField.text ?? ""
            ingField.endEditing(true)
        }
        drawChart()
    }



}
