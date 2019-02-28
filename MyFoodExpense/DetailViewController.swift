//
//  DetailViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/27.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
//DataArray = [ingredients,prices,tax,[String(person)],[date],[Title]]
class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var Row:Int?
    let uds = UserDefaults.standard

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var perPriceLabel: UILabel!
    @IBOutlet weak var totalTaxButton: UIButton!
    @IBOutlet weak var personLabel: UILabel!

    var DataArray = [[String]]()
    var totalPrice = 0
    var prices = [String]()
    var tax = [String]()
    var person = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        RecordArray = uds.array(forKey: KEY.record.rawValue) as! [[[String]]]
        DataArray = RecordArray[Row!]
        setValue()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var DataArray = RecordArray[Row!]
        return DataArray[0].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! detailTableViewCell
        var DataArray = RecordArray[Row!]
        let ing = DataArray[0][indexPath.row]
        let price = DataArray[1][indexPath.row]
        let tax = DataArray[2][indexPath.row]
        print(ing,price,tax)
        cell.setCell(ing: ing, price: price, tax: tax)
        return cell
    }

    @IBAction func totalTax(_ sender: UIButton) {
        if sender.currentTitle == "(税込)"{
            sender.setTitle("(税抜き)", for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal)
        }else{
            sender.setTitle("(税込)", for: .normal)
            sender.setTitleColor(UIColor.black, for: .normal)
        }
        taxInclude()
    }

    func setValue(){
        prices = DataArray[1]
        tax = DataArray[2]
        person = Int(DataArray[3][0])!
        taxInclude()
    }




    func taxInclude(){
        var IntPrices = prices.map{Int($0)}
        let DoublePrices = prices.map{Double($0)!}
        let plusTax = DoublePrices.map{$0 * 0.08}
        let minusTax = DoublePrices.map{$0 * 0.08/1.08}
        if totalTaxButton.currentTitle == "(税込)"{
            for i in 0...DataArray[0].count-1{
                if tax[i] == "税抜き"{
                    IntPrices[i] = IntPrices[i]! + Int(plusTax[i])
                }
            }
            calculate(prices: IntPrices as! [Int])
            for i in 0...DataArray[0].count-1{
                if tax[i] == "税抜き"{
                    IntPrices[i] = IntPrices[i]! - Int(plusTax[i])
                }
            }
        }else{
            for i in 0...DataArray[0].count-1{
                if tax[i] == "税込"{
                    IntPrices[i] = IntPrices[i]! - Int(minusTax[i])
                }
            }
            calculate(prices: IntPrices as! [Int])
            for i in 0...DataArray[0].count-1{
                if tax[i] == "税込"{
                    IntPrices[i] = IntPrices[i]! + Int(minusTax[i])
                }
            }
        }
    }

    func calculate(prices: [Int]){
        totalPrice = 0
        prices.forEach{totalPrice += $0}
        totalPriceLabel.text = String(totalPrice)
        perPriceLabel.text = String(totalPrice/person)
    }
}
