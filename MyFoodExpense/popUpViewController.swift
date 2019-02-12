//
//  popUpViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/11.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController {

    @IBOutlet weak var titleText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch:UITouch in touches{
            let tag = touch.view!.tag
            if tag == 1{
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        titles.append(titleText.text ?? "noTitle")
        let dataArray = [ing1s,ing2s,ing3s,ing4s,ing5s,ing6s,ct1s,ct2s,ct3s,ct4s,ct5s,ct6s,taxFlags1,taxFlags2,taxFlags3,taxFlags4,taxFlags5,taxFlags6,titles,dates,person]
        let userDefaults = UserDefaults.standard
        DispatchQueue.main.async {
            userDefaults.set(dataArray, forKey: "KEY_dataArray")
            performSegue(withIdentifier: "storeSegue", sender: nil)
        }



    }


}
