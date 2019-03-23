//
//  FormViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/26.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
import AVFoundation

class FormViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AVAudioPlayerDelegate{

    var names = [String]()
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
    var audioPlayer:AVAudioPlayer!

    @IBOutlet weak var nonTaxTotalLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
//---------------------------------viewDidLoad----------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        let img = UIImage(named: "image")
        view.backgroundColor = UIColor(patternImage: img!)
        uds.register(defaults: [KEY.record.rawValue:[[[String]]]()])

        tableView.delegate = self
        tableView.dataSource = self
        names = [String](repeating: "", count: cellCount)
        tax = [String](repeating: "税抜き", count: cellCount)
        prices = [String](repeating: "", count: cellCount)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)


        let audioPath = Bundle.main.path(forResource: "nock", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }

        audioPlayer.delegate = self
        audioPlayer.volume = 0.4
        audioPlayer.prepareToPlay()

    }
//----------------------------------tableView----------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InputTableViewCell
        cell.backgroundColor = cellColor
        let name = names[indexPath.row]
        let price = prices[indexPath.row]
        let tax = self.tax[indexPath.row]
        cell.setValue(name:name,tax:tax,price:price)

        let ingField = cell.viewWithTag(1) as! UITextField
        ingField.delegate = self


        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let scrHeight = self.view.frame.height
        let tableHeight = scrHeight*0.60
        if Int(tableHeight)/cellCount > 60{
            return 60
        }else{
            return tableHeight/CGFloat(cellCount)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        cellCount -= 1
        reloadValue()
        tableView.deleteRows(at: [indexPath], with: .automatic)

    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if tableView.isEditing{
            return true
        }
        return false
    }



    @IBAction func wrote(_ sender: UITextField) {
        reloadValue()
    }

    @IBAction func costChanged(_ sender: NumberTextField) {
        reloadValue()
    }

    @IBAction func taxChanged(_ sender: UIButton) {
        audioPlayer.currentTime = 0.5
        audioPlayer.play()
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
        if cellCount == 0{return}
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
            if realTitle == ""{
                self.Title = "notitle"
            }
            self.store()
        }))
        self.present(alert,animated: true)
    }

    @IBAction func insertCell(_ sender: Any) {
        view.endEditing(true)
        if cellCount < 10{
            reloadValue()
            names.append("")
            tax.append("税抜き")
            prices.append("")
            cellCount += 1
            tableView.reloadData()
        }
    }

    @IBAction func removeCell(_ sender: Any) {
        if cellCount > 0{
            cellCount -= 1
            reloadValue()
            tableView.reloadData()
        }
    }

    @IBAction func taxRateChange(_ sender: UISegmentedControl) {
        audioPlayer.currentTime = 0.5
        audioPlayer.play()
        switch sender.selectedSegmentIndex {
        case 0:taxRate = "0.08"
        case 1:taxRate = "0.10"
        default:break
        }
        reloadValue()
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
        names.removeAll()
        prices.removeAll()
        tax.removeAll()
        if cellCount == 0{
            totalPriceLabel.text = "0"
            taxValueLabel.text = "(税0円)"
            return
        }
        for i in 0...cellCount-1{
            let cell = tableView.cellForRow(at: [0,i])
            let ingField = cell?.viewWithTag(1) as! UITextField
            let priceField = cell?.viewWithTag(2) as! NumberTextField
            var price = priceField.text
            if price == "" {
                price = "0"
            }
            let taxButton = cell?.viewWithTag(3) as! UIButton
            names.append(ingField.text ?? "")
            prices.append(price!)
            tax.append(taxButton.currentTitle!)
        }
        taxInclude()
    }

    func taxInclude(){
        let taxRate = Double(self.taxRate)
        let DoublePrices = prices.map{Double($0)!}
        var taxPriceTotal = 0.0
        var nontaxPriceTotal = 0.0
        for i in 0...cellCount-1{
            if tax[i] == "税抜き"{
                nontaxPriceTotal += DoublePrices[i]
            }else{
                taxPriceTotal += DoublePrices[i]
            }
        }
        TaxTotalPrice = Int(round(nontaxPriceTotal * (1.0+taxRate!) + taxPriceTotal))
        nonTaxTotalPrice = Int(round(nontaxPriceTotal + taxPriceTotal * 1.0/(1.0+taxRate!)))

        totalPriceLabel.text = String(TaxTotalPrice)
        nonTaxTotalLabel.text = String(nonTaxTotalPrice)
        taxValueLabel.text = "(税\(TaxTotalPrice-nonTaxTotalPrice)円)"
    }



    func store(){
        setValue()
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        let randomTime = Int.random(in: -1000000...1000000)
        date = f.string(from: Date().addingTimeInterval(TimeInterval(randomTime)))
        DataArray = [names,prices,tax,[taxRate],[date],[Title],[String(TaxTotalPrice)],[String(nonTaxTotalPrice)]]
        var recordArray = uds.array(forKey: KEY.record.rawValue)
        recordArray?.append(DataArray)
        uds.set(recordArray, forKey: KEY.record.rawValue)
        let storyboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        nextView.selectedIndex = 1

        self.present(nextView, animated: false, completion: nil)
    }

    func setValue(){
        names.removeAll()
        prices.removeAll()
        tax.removeAll()
        for i in 0...cellCount-1{
            let cell = tableView.cellForRow(at: [0,i])
            let ingField = cell?.viewWithTag(1) as! UITextField
            let priceField = cell?.viewWithTag(2) as! NumberTextField
            let price = priceField.text
            if price == "" || price == "0"{continue}
            let taxButton = cell?.viewWithTag(3) as! UIButton
            names.append(ingField.text ?? "")
            prices.append(price!)
            tax.append(taxButton.currentTitle!)
        }

    }

}

