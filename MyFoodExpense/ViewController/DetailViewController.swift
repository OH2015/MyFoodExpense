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
    @IBOutlet weak var taxValueLabel: UILabel!
    @IBOutlet weak var nonTaxTotalLabel: UILabel!
    @IBOutlet weak var taxTitleLabel: UILabel!

    var DataArray = [[String]]()
    var prices = [String]()
    var tax = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        RecordArray = uds.array(forKey: KEY.record.rawValue) as! [[[String]]]
        DataArray = RecordArray[Row!]

        totalPriceLabel.text = DataArray[6][0]
        nonTaxTotalLabel.text = DataArray[7][0]
        let taxValue = Int(DataArray[6][0])! - Int(DataArray[7][0])!
        let taxRate = DataArray[3][0]
        taxValueLabel.text = "(消費税 \(taxValue)円)"
        let t = Int(Double(taxRate)!*100)
        taxTitleLabel.text = "+\(t)%"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! detailTableViewCell
        let count = DataArray[1].count
        if indexPath.row >= count{
            cell.setCell(name: "", price: "", tax: "")
            return cell
        }
        let name = DataArray[0][indexPath.row]
        let price = DataArray[1][indexPath.row]
        let tax = DataArray[2][indexPath.row]
        cell.setCell(name: name, price: price, tax: tax)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let scrHeight = self.view.frame.height
        let tableHeight = scrHeight * 0.6

        return tableHeight/CGFloat(10)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }









}
