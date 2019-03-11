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
        if isFirstNumber && (sender.tag == 0 || sender.tag == 100){
            return
        }
        if  performingMath{
            if operation != 11{
//=以外の記号をformulaに足す
                let button = view.viewWithTag(operation) as! customButton
                formula = formula + button.currentTitle!
                ex = ex + button.currentTitle!
            }
            label.text = sender.currentTitle!
            equalTapped = false
            performingMath = false
        }
        else{
            label.text = label.text! + sender.currentTitle!

        }
        isFirstNumber = false
        formulaLabel.text = ex + label.text!

    }


    @IBAction func buttons(_ sender: UIButton) {
        audioPlayer.currentTime = 0.1
        audioPlayer.play()
        if (!performingMath || operation == 11) && label.text != ""{//まだ記号が押されてないか、=を押した直後
            formula = formula + label.text!
            ex = ex + label.text!
            if !equalTapped{//=を押した直後以外はラベルに小数点は入っていない
                formula = formula + ".0"
            }
        }
        if label.text != "" && sender.tag != 11 && sender.tag != -1{
// 初めて記号をタップした時のみに,確定した数値をformulaに足す。
            formulaLabel.text = ex + sender.currentTitle!
            operation = sender.tag
            performingMath = true;
        }
        else if sender.tag == 11 // = が押された時の処理
        {
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

            var expression = NSExpression(format: rightFormula)
            let result = expression.expressionValue(with: nil, context: nil) as! Double?
            if var result = result{
                if String(result).hasSuffix(".0"){
                    let intResult = String(result).replacingOccurrences(of: ".0", with: "")
                    label.text = String(intResult)
                    formulaLabel.text = ex + "=" + String(intResult)
                    equalTapped = false
                }else{
                    label.text = String(result)
                    formulaLabel.text = ex + "=" + String(result)
                }

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
    }


}
