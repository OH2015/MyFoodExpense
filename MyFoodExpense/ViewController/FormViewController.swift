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
    var row = 0
    let uds = UserDefaults.standard
    var audioPlayer:AVAudioPlayer!
    let notificationCenter = NotificationCenter.default

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
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        let tableHeight = scrHeight*0.55
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

    @IBAction func tapped(_ sender: UITextField) {
        let cell = sender.superview?.superview as! InputTableViewCell
        row = tableView.indexPath(for: cell)!.row
    }

    @IBAction func tapped2(_ sender: NumberTextField) {
        let cell = sender.superview?.superview as! InputTableViewCell
        row = tableView.indexPath(for: cell)!.row
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
        var IntPrices = prices.map{Int($0)}
        let DoublePrices = prices.map{Double($0)!}
        let plusTax = DoublePrices.map{($0 * taxRate!).rounded()}
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
        nonTaxTotalLabel.text = String(nonTaxTotalPrice)
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
        DataArray = [names,prices,tax,[taxRate],[date],[Title],[String(TaxTotalPrice)],[String(nonTaxTotalPrice)]]
        var recordArray = uds.array(forKey: KEY.record.rawValue)
        recordArray?.append(DataArray)
        uds.set(recordArray, forKey: KEY.record.rawValue)
        let storyboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        nextView.selectedIndex = 1

        self.present(nextView, animated: false, completion: nil)
    }
//======================キーボード=======================================================================
    @objc func keyboardWillShow(_ notification: NSNotification){
        let userInfo = (notification as NSNotification).userInfo
        let keyboardFrame = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let cell = tableView.cellForRow(at: [0,row])
        let cellFrame = view.convert(cell!.frame, from: tableView)
        let overlap = cellFrame.maxY - keyboardFrame.minY

        if  overlap > 0{
            view.transform = CGAffineTransform(translationX: 0, y: -overlap)
        }

    }

    @objc func keyboardWillHide(_ notification: NSNotification){
        UIView.animate(withDuration: 1.0, animations: { () in
            self.view.transform = CGAffineTransform.identity
        })
    }

    func removeObserver() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver() // Notificationを画面が消えるときに削除
    }



}

