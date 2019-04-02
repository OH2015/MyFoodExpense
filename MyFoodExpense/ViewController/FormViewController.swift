//
//  FormViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/26.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

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
    var numbers = ["1"]
    var cellCount = 1
    let uds = UserDefaults.standard
    let dataList = [Int](1...9).map{String($0)}
    var audioPlayer:AVAudioPlayer!
    let unitID = "ca-app-pub-5237111055443143/2461971379"

    let cellColor = #colorLiteral(red: 0.5841977863, green: 0.6957643865, blue: 0.9686274529, alpha: 1)

    @IBOutlet weak var taxTitleLabel: UILabel!
    @IBOutlet weak var nonTaxTotalLabel: CustomLabel!
    @IBOutlet weak var totalPriceLabel: CustomLabel!
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
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch{
            print("error!")
        }


        audioPlayer.delegate = self
        audioPlayer.volume = 0.4
        audioPlayer.prepareToPlay()

    }
//==============viewDidLayoutSubviews===========================================
    override func viewDidLayoutSubviews(){
        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)

        let safeArea = self.view.safeAreaInsets.top
        admobView.frame.origin = CGPoint(x:0, y:safeArea)
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)

        admobView.adUnitID = unitID

        admobView.rootViewController = self
        admobView.load(GADRequest())
        self.view.addSubview(admobView)
    }
//----------------------------------tableView------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InputTableViewCell
        cell.backgroundColor = cellColor
        let name = names[indexPath.row]
        let price = prices[indexPath.row]
        let tax = self.tax[indexPath.row]
        let number = numbers[indexPath.row]
        cell.setValue(name:name,tax:tax,price:price,number:number)

        let ingField = cell.viewWithTag(10) as! UITextField
        ingField.delegate = self
        let numberField = cell.viewWithTag(1) as! NumberTextField
        numberField.delegate = self

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


// =====================================================================

    @IBAction func wrote(_ sender: UITextField) {
        reloadValue()
    }

    @IBAction func costChanged(_ sender: NumberTextField) {
        reloadValue()
    }

    @IBAction func numberChanged(_ sender: NumberTextField) {
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
            if self.Title == ""{
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
            numbers.append("1")
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
        let t = Int(Double(taxRate)! * 100)
        taxTitleLabel.text = "+\(t)%"
        reloadValue()
    }

//=============================================================================

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == -1{
            Title = textField.text ?? ""
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let tag = textField.tag
        let maxLength = tag
        let str = textField.text!
        if str.count < maxLength || string == "" || tag == -1{
            return true
        }
        return false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func reloadValue(){
        names.removeAll()
        prices.removeAll()
        tax.removeAll()
        numbers.removeAll()
        if cellCount == 0{
            totalPriceLabel.text = "0"
            nonTaxTotalLabel.text = "0"
            return
        }
        for i in 0...cellCount-1{
            let cell = tableView.cellForRow(at: [0,i])
            let ingField = cell?.viewWithTag(10) as! UITextField
            let priceField = cell?.viewWithTag(8) as! NumberTextField
            let numberField = cell?.viewWithTag(1) as! NumberTextField
            var price = priceField.text
            var number = numberField.text
            if price == "" {
                price = "0"
            }
            if number == ""{
                number = "0"
            }
            let taxButton = cell?.viewWithTag(3) as! UIButton
            names.append(ingField.text ?? "")
            prices.append(price!)
            numbers.append(number!)
            tax.append(taxButton.currentTitle!)
        }
        taxInclude()
    }

    func taxInclude(){
        let taxRate = Double(self.taxRate)
        var DoublePrices = prices.map{Double($0)!}
        for (i,price) in DoublePrices.enumerated(){
            DoublePrices[i] = price * Double(numbers[i])!
        }
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
    }

    func store(){
        setValue()
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        date = f.string(from: Date())
        DataArray = [names,prices,tax,[taxRate],[date],[Title],[String(TaxTotalPrice)],[String(nonTaxTotalPrice)],numbers]
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
        numbers.removeAll()
        for i in 0...cellCount-1{
            let cell = tableView.cellForRow(at: [0,i])
            let priceField = cell?.viewWithTag(8) as! NumberTextField
            let price = priceField.text
            let numberField = cell?.viewWithTag(1) as! NumberTextField
            let number = numberField.text ?? "0"
            if price == "" || price == "0" || number == "0"{
                continue
            }
            let ingField = cell?.viewWithTag(10) as! UITextField
            let taxButton = cell?.viewWithTag(3) as! UIButton
            names.append(ingField.text ?? "")
            prices.append(price!)
            numbers.append(number)
            tax.append(taxButton.currentTitle!)
        }

    }

}

