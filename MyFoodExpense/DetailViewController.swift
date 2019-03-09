//
//  DetailViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/27.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
let cellColor = #colorLiteral(red: 0.6963857193, green: 0.819903064, blue: 1, alpha: 1)
//DataArray = [ingredients,prices,tax,[String(person)],[date],[Title]]
class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var Row:Int?
    let uds = UserDefaults.standard

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!

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
        let taxValue = Int(DataArray[6][0])! - Int(DataArray[7][0])!
        taxValueLabel.text = String(taxValue)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var DataArray = RecordArray[Row!]
        return DataArray[0].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! detailTableViewCell
        cell.backgroundColor = cellColor
        var DataArray = RecordArray[Row!]
        let ing = DataArray[0][indexPath.row]
        let price = DataArray[1][indexPath.row]
        let tax = DataArray[2][indexPath.row]
        print(ing,price,tax)
        cell.setCell(ing: ing, price: price, tax: tax)
        return cell
    }









}
