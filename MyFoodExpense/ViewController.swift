



import UIKit
import Charts

class ViewController:UIViewController,UIScrollViewDelegate,UITextFieldDelegate,ChartViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource{

    var box1 = Box(index:1)
    var box2 = Box(index:2)
    var box3 = Box(index:3)
    var box4 = Box(index:4)
    var box5 = Box(index:5)
    var box6 = Box(index:6)
    var BoxArray = [Box]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...6{
            BoxArray.append(Box.boxWithIndex(i))
        }

        for i in 1...6{
            let ingField = view.viewWithTag(i) as! UITextField
            ingField.delegate = self
        }

        for i in 11...16{
            let costpicker = view.viewWithTag(i) as! UIPickerView
            costpicker.delegate = self
            costpicker.dataSource = self

        }

    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return 4
        }else{
            return 100
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{

        }else{
            BoxArray[pickerView.tag - 11] = pickerView.
        }
    }


}
