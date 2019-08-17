//
//  DDHopeVC.swift
//  ka
//
//  Created by WY on 2019/8/17.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class DDHopeVC: UIViewController {
    let label1 = UILabel()
    let label2 = UILabel()
    let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(label1)
        label1.textAlignment = .right
        self.view.addSubview(label2)
        label1.frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width * 0.6, height: 44)
        label2.frame = CGRect(x: label1.frame.maxX, y: 300, width: UIScreen.main.bounds.width * 0.4, height: 44)
        // Do any additional setup after loading the view.
        label2.textColor = UIColor.red
        randomLeNum()
        self.view.addSubview(button)
        button.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        button.frame = CGRect(x: 0, y: 555, width: UIScreen.main.bounds.width, height: 88)
        button.setTitle("big", for: UIControl.State.normal)
        button.setTitle("double", for: UIControl.State.selected)
        button.addTarget(self , action: #selector(switchType(sender:)), for: UIControl.Event.touchUpInside)
    }
    @objc func switchType(sender:UIButton)  {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            randomShuangNum()
        }else{
            randomLeNum()
        }
    }
    func randomLeNum()  {
        label1.frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width * 0.6, height: 44)
        label2.frame = CGRect(x: label1.frame.maxX, y: 300, width: UIScreen.main.bounds.width * 0.4, height: 44)
        label1.textColor = UIColor.blue
        label2.textColor = UIColor.red
        let leFrontNum = ["title01":01 , "title02":02, "title03":03 , "title04":04,
                             "title05":05, "title06":06, "title07":07, "title08":08,
                             "title09":09, "title10":10, "title11":11, "title12":12,
                             "title13":13, "title14":14, "title15":15, "title16":16,
                             "title17":17, "title18":18, "title19":19, "title20":20,
                            "title21":21, "title22":22, "title23":23, "title24":24,
                            "title25":25, "title26":26, "title27":27, "title28":28,
                            "title29":29, "title30":30, "title31":31, "title32":32,
                            "title33":33, "title34":34, "title35":35]
        let leBackNum = ["title01":01 , "title02":02, "title03":03 , "title04":04,
                          "title05":05, "title06":06, "title07":07, "title08":08,
                          "title09":09, "title10":10, "title11":11, "title12":12]
        var frantNumArr = [Int]()
        var backNumArr = [Int]()
        var frantNumStr = ""
        var backNumStr = ""
        for (index , dict ) in leFrontNum.enumerated() {
            frantNumArr.append(dict.value)
            if index >= 4{
                frantNumArr.sort()
                break
            }
        }
        for  (_ , n)    in frantNumArr.enumerated() {
            frantNumStr +=  String(format: "   %02d", n)
        }
        for (index , dict ) in leBackNum.enumerated() {
            backNumArr.append(dict.value)
            if index >= 1{
                backNumArr.sort()
                break
            }
        }
        for  (_ , n)    in backNumArr.enumerated() {
            backNumStr +=  String(format: "   %02d", n)
        }
        print(frantNumStr)
        print(backNumStr)
        label1.text = frantNumStr
        label2.text = backNumStr
    }
    func randomShuangNum()  {
        label1.frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width * 0.7, height: 44)
        label2.frame = CGRect(x: label1.frame.maxX, y: 300, width: UIScreen.main.bounds.width * 0.7, height: 44)
        label1.textColor = UIColor.red
        label2.textColor = UIColor.blue
        let shuangFrontNum = ["title01":01 , "title02":02, "title03":03 , "title04":04,
                              "title05":05, "title06":06, "title07":07, "title08":08,
                              "title09":09, "title10":10, "title11":11, "title12":12,
                              "title13":13, "title14":14, "title15":15, "title16":16,
                              "title17":17, "title18":18, "title19":19, "title20":20,
                              "title21":21, "title22":22, "title23":23, "title24":24,
                              "title25":25, "title26":26, "title27":27, "title28":28,
                              "title29":29, "title30":30, "title31":31, "title32":32,
                              "title33":33]
        let shuangBackNum =  ["title01":01 , "title02":02, "title03":03 , "title04":04,
                              "title05":05, "title06":06, "title07":07, "title08":08,
                              "title09":09, "title10":10, "title11":11, "title12":12,
                              "title13":13, "title14":14, "title15":15, "title16":16]
        var frantNumArr = [Int]()
        var backNumArr = [Int]()
        var frantNumStr = ""
        var backNumStr = ""
        for (index , dict ) in shuangFrontNum.enumerated() {
            frantNumArr.append(dict.value)
            if index >= 5{
                frantNumArr.sort()
                break
            }
        }
        for (_ , n)  in frantNumArr.enumerated() {
            frantNumStr += String(format: "   %02d", n)
        }
        
        for (index , dict ) in shuangBackNum.enumerated() {
            backNumArr.append(dict.value)
            if index >= 0{
                backNumArr.sort()
                break
            }
        }
        for  (_ , n)    in backNumArr.enumerated() {
            backNumStr += String(format: "   %02d", n)
        }
        print(frantNumStr)
        print(backNumStr)
        label1.text = frantNumStr
        label2.text = backNumStr
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
