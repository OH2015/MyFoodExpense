//
//  popUpViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/11.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var storeButton: UIButton!

    let SCREEN_SIZE = UIScreen.main.bounds.size
    let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        titleText.delegate = self
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)


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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleText.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleText.endEditing(true)
        return true
    }

    @objc func keyboardWillShow(_ notification: NSNotification){
        let userInfo = (notification as NSNotification).userInfo
        let keyboardFrame = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let fldFrame = view.convert(storeButton.frame, from: view.viewWithTag(2))

        let overlap = fldFrame.maxY - keyboardFrame.minY

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
    
    @IBAction func buttonTapped(_ sender: Any) {
        titles.append(titleText.text ?? "noTitle")
        let dataArray = [ing1s,ing2s,ing3s,ing4s,ing5s,ing6s,ct1s,ct2s,ct3s,ct4s,ct5s,ct6s,taxFlags1,taxFlags2,taxFlags3,taxFlags4,taxFlags5,taxFlags6,titles,dates,person]
        let userDefaults = UserDefaults.standard
        DispatchQueue.main.async {
            userDefaults.set(dataArray, forKey: "KEY_dataArray")
            self.performSegue(withIdentifier: "storeSegue", sender: nil)
        }



    }


}
