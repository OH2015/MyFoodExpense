//
//  CalculatorViewController.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/03/04.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
import AVFoundation

class CalculatorViewController: UIViewController,AVAudioPlayerDelegate {

    var formula = ""
    var ex = ""

    var performingMath = false
    var equalTapped = false
    var isFirstNumber = true
    var dotUsed = false
    var audioPlayer:AVAudioPlayer!

    var operation = 0; //  + , - , × , ÷

    @IBOutlet weak var label: UILabel! // 計算結果表示
    @IBOutlet weak var formulaLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        let audioPath = Bundle.main.path(forResource: "クリック", ofType:"mp3")!
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

    @IBAction func numbers(_ sender: customButton) {   // 記号を打った直後にはラベルの中身を初期化する必要があるので分岐
        audioPlayer.currentTime = 0.1
        audioPlayer.play()
// .のみ入力はできないよ
        if isFirstNumber && (sender.tag == 100){return}
//  記号が押された後
        if performingMath{
            if operation != 11{// =じゃなければ記号をformulaに足す
                let button = view.viewWithTag(operation) as! customButton
                formula = formula + button.currentTitle!
                ex = ex + button.currentTitle!
            }
            label.text = sender.currentTitle!
            equalTapped = false
            performingMath = false
        }
//  2文字目以降
        else{
            dotUsed = (label.text?.contains("."))!
            let prefixIsZero = label.text?.hasPrefix("0")
//  .の重複仕様禁止
//  09みたいな数にならないように、0のあとは.しか使えないようにする
            if sender.tag == 100 && dotUsed{return}
            if sender.tag != 100 && prefixIsZero! && !dotUsed{
                label.text = label.text?.replacingOccurrences(of: "0", with: "")
            }
            label.text = label.text! + sender.currentTitle!
        }
        isFirstNumber = false
        formulaLabel.text = ex + label.text!
    }


    @IBAction func buttons(_ sender: UIButton) {
        audioPlayer.currentTime = 0.1
        audioPlayer.play()
        if (!performingMath || operation == 11) && label.text != ""{//初めて記号が押された時または=を押した直後
            formula = formula + label.text!
            ex = ex + label.text!
            dotUsed = (label.text?.contains("."))!
            let suffixIsDot = label.text?.hasSuffix(".")
            if !dotUsed{formula = formula + ".0"}
            if suffixIsDot!{
                formula = formula + "0"
                ex = ex + "0"
            }
        }
        if label.text != "" && sender.tag != 11 && sender.tag != -1{
            formulaLabel.text = ex + sender.currentTitle!
            operation = sender.tag
            performingMath = true
        }
        else if sender.tag == 11{ // = が押された時の処理
            equalTapped = true
            let plus = formula.hasSuffix("+")
            let minus = formula.hasSuffix("-")
            let by = formula.hasSuffix("×")
            let split = formula.hasSuffix("÷")
            if plus || minus || by || split || formula == ""{
                print("後ろに記号がついてるか、四季がないよ")
                return
            }

            let a = formula.replacingOccurrences(of: "×",with: "*")
            let rightFormula = a.replacingOccurrences(of: "÷", with: "/")

            let expression = NSExpression(format: rightFormula)
            let result = expression.expressionValue(with: nil, context: nil) as! Double?
            if let result = result{
                print("四捨五入\(round(result * pow(10.0, 6.0))/pow(10.0, 6.0))")
                let rouRs = round(result * pow(10.0, 6.0)) / pow(10.0, 6.0)
                var clearResult = String(rouRs)
                if String(rouRs).hasSuffix(".0"){
                    clearResult = String(rouRs).replacingOccurrences(of: ".0", with: "")
                    equalTapped = false
                }
                label.text = String(clearResult)
                formulaLabel.text = ex + "=" + String(clearResult)
                formula = ""
                ex = ""
                performingMath = true

                operation = 11
            }else{
                label.text = "error"
            }
        }
        else if sender.tag == -1{ // C が押された時の処理
            label.text = ""
            formulaLabel.text = ""
            formula = ""
            ex = ""
            operation = 0
            performingMath = false
            equalTapped = false
        }
        isFirstNumber = true
        dotUsed = false
    }


}
