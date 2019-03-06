//
//  FormViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/26.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class FormViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{

    var ingredients = [String]()
    var prices = [String]()
    var tax = [String]()
    var taxRate = "0.08"
    var date = ""
    var Title = ""
    var totalPrice = 0
    var nonTaxTotalPrice = 0
    var TaxTotalPrice = 0
    var DataArray = [[String]]()
    var cellCount = 3
    let uds = UserDefaults.standard

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
//---------------------------------viewDidLoad----------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        uds.register(defaults: [KEY.record.rawValue:[[[String]]]()])

        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
//----------------------------------tableView----------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = cellColor
        let ingField = cell.viewWithTag(1) as! UITextField
        ingField.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        cellCount -= 1
        tableView.deleteRows(at: [indexPath], with: .automatic)
        reloadValue()
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if tableView.isEditing{
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }

    @IBAction func wrote(_ sender: UITextField) {
        reloadValue()
    }

    @IBAction func costChanged(_ sender: NumberTextField) {
        reloadValue()
    }

    @IBAction func taxChanged(_ sender: UIButton) {
        if sender.currentTitle == "税抜き"{
            sender.setTitle("税込", for: .normal)
            sender.setTitleColor(UIColor.red, for: .normal)
        }else{
            sender.setTitle("税抜き", for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal)
        }
        reloadValue()
    }

    @IBAction func send(_ sender: Any) {
        let alert = UIAlertController(title: "データを保存します", message: "タイトルをつけてください", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {textField in
            textField.delegate = self
            textField.tag = -1
            })

        alert.addAction(
            UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "保存", style: .default, handler: {_ in
            self.view.endEditing(true)
            var realTitle = ""
            realTitle = self.Title.replacingOccurrences(of: " ", with: "")
            if realTitle != ""{
                self.store()
            }
        }))
        self.present(alert,animated: true)
    }

    @IBAction func insertCell(_ sender: Any) {
        cellCount += 1
        tableView.reloadData()
    }

    @IBAction func removeCell(_ sender: Any) {
        if cellCount > 0{
            cellCount -= 1
            tableView.reloadData()
        }
    }

    @IBAction func edit(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }

    @IBAction func taxRateChange(_ sender: UISegmentedControl) {
        reloadValue()
        switch sender.selectedSegmentIndex {
        case 0:taxRate = "0.08"
        case 1:taxRate = "0.10"
        default:break
        }
        taxInclude()
    }


    //-------------------------------------------------------------------------------------------

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == -1{
            Title = textField.text ?? ""
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func reloadValue(){
        ingredients.removeAll()
        prices.removeAll()
        tax.removeAll()
        for i in 0...cellCount-1{
            let cell = tableView.cellForRow(at: [0,i])
            let ingField = cell?.viewWithTag(1) as! UITextField
            let priceField = cell?.viewWithTag(2) as! NumberTextField
            var price = priceField.text
            if price == "" {
                price = "0"
            }
            let taxButton = cell?.viewWithTag(3) as! UIButton
            ingredients.append(ingField.text ?? "")
            prices.append(price!)
            tax.append(taxButton.currentTitle!)
        }
        taxInclude()
    }

    func taxInclude(){
        let taxRate = Double(self.taxRate)
        var IntPrices = prices.map{Int($0)}
        let DoublePrices = prices.map{Double($0)!}
        let plusTax = DoublePrices.map{$0 * taxRate!}
        let minusTax = DoublePrices.map{$0 * taxRate!/(1.00+taxRate!)}
        for i in 0...cellCount-1{
            if tax[i] == "税抜き"{
                IntPrices[i] = IntPrices[i]! + Int(plusTax[i])
            }
        }
        calculate(prices: IntPrices as! [Int], tax: true)
        for i in 0...cellCount-1{
            if tax[i] == "税抜き"{
                IntPrices[i] = IntPrices[i]! - Int(plusTax[i])
            }
        }
        for i in 0...cellCount-1{
            if tax[i] == "税込"{
                IntPrices[i] = IntPrices[i]! - Int(minusTax[i])
            }
        }
        calculate(prices: IntPrices as! [Int], tax: false)
        for i in 0...cellCount-1{
            if tax[i] == "税込"{
                IntPrices[i] = IntPrices[i]! + Int(minusTax[i])
            }
        }

        totalPriceLabel.text = String(TaxTotalPrice)
        taxValueLabel.text = "(税\(TaxTotalPrice-nonTaxTotalPrice)円)"
    }

    func calculate(prices: [Int],tax:Bool){
        totalPrice = 0
        prices.forEach{totalPrice += $0}
        if tax{
            TaxTotalPrice = totalPrice
        }else{
            nonTaxTotalPrice = totalPrice
        }
    }

    func store(){
        reloadValue()
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        let randomTime = Int.random(in: -1000000...1000000)
        date = f.string(from: Date().addingTimeInterval(TimeInterval(randomTime)))
        DataArray = [ingredients,prices,tax,[taxRate],[date],[Title],[String(TaxTotalPrice)],[String(nonTaxTotalPrice)]]
        var recordArray = uds.array(forKey: KEY.record.rawValue)
        recordArray?.append(DataArray)
        uds.set(recordArray, forKey: KEY.record.rawValue)
        let storyboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        nextView.selectedIndex = 1

        self.present(nextView, animated: false, completion: nil)


    }

}

