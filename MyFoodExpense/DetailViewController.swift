//
//  DetailViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/27.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var Row:Int?
    let uds = UserDefaults.standard

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var perPriceLabel: UILabel!
    @IBOutlet weak var totalTaxButton: UIButton!
    @IBOutlet weak var personLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RecordArray = uds.array(forKey: KEY.record.rawValue) as! [[[String]]]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var DataArray = RecordArray[Row!]
        return DataArray[0].count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
    }



}
