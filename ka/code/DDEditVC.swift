//
//  DDEditVC.swift
//  ka
//
//  Created by WY on 2019/7/26.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class DDEditVC: UIViewController {
    var signinStamp : TimeInterval = 0
    var signoutStamp : TimeInterval = 0
    let signinButton = UIButton()
    let signoutButton = UIButton()
    let confirm = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if signinStamp <= 0 &&  signoutStamp <= 0 {//新建
            self.title  = "新建"
        }else if signoutStamp <= 0{//手动第一次签退
            self.title  = "签退"
        }else {//手动修改加班时间
            self.title  = "编辑"
        }
        _layoutSubviews()
        setContentToUI()
        // Do any additional setup after loading the view.
    }
    func _layoutSubviews() {
        self.view.addSubview(signinButton)
        self.view.addSubview(signoutButton)
        self.view.addSubview(confirm)
        signinButton.frame = CGRect(x: 0, y: 222, width: self.view.bounds.width, height: 44)
        signoutButton.frame = CGRect(x: 0, y: signinButton.frame.maxY + 10, width: self.view.bounds.width, height: 44)
        confirm.frame = CGRect(x: 0, y: signoutButton.frame.maxY + 10, width: self.view.bounds.width, height: 44)
        confirm.setTitle("确定", for: UIControl.State.normal)
        signinButton.addTarget(self , action: #selector(action(sender:)), for: UIControl.Event.touchUpInside)
        signoutButton.addTarget(self , action: #selector(action(sender:)), for: UIControl.Event.touchUpInside)
        confirm.addTarget(self , action: #selector(action(sender:)), for: UIControl.Event.touchUpInside)
        signinButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        signoutButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        confirm.setTitleColor(UIColor.gray, for: UIControl.State.normal)
    }
    @objc func action(sender :UIButton)  {
        if sender == signinButton {
            let alert = DDTimeSelectView(showTimestamp:signinStamp)
            alert.done = {[weak self] timeStamp in
                
                self?.signinStamp = timeStamp
                self?.setContentToUI()
                mylog(timeStamp)
            }
            self.view.alert(alert)
        }else if sender == signoutButton{
            let alert = DDTimeSelectView(minimumTimestamp: signinStamp,showTimestamp:signoutStamp)
            alert.done = {[weak self] timeStamp in
                
                self?.signoutStamp = timeStamp
                self?.setContentToUI()
                mylog(timeStamp)
            }
            self.view.alert(alert)
        }else if sender == confirm{
            DDStorgeManager.share.insertOrUpdate(timeStamp: self.signinStamp)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                DDStorgeManager.share.insertOrUpdate(timeStamp: self.signoutStamp)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setContentToUI() {
        if signinStamp <= 0  {
            return
        }
        let signinDate = Date(timeIntervalSince1970: signinStamp)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy年MM月dd日HH点mm分ss秒"//"yyyy-MM-dd 'at' HH:mm"
        let signinString = dateFormater.string(from: signinDate)
        self.signinButton.setTitle(signinString, for: UIControl.State.normal)
        if signoutStamp <= 0  {
            return
        }
        let signoutDate = Date(timeIntervalSince1970: signoutStamp)
        let signoutString = dateFormater.string(from: signoutDate)
        self.signoutButton.setTitle(signoutString, for: UIControl.State.normal)
        
        let shichangHour = "\(Int(signoutStamp - signinStamp) / 3600 )"
        
        let shichangMinute = "\(Int(signoutStamp - signinStamp) % 3600 / 60)"
        let shichangString = "时长 \(shichangHour)小时\(shichangMinute)分"
        confirm.setTitle(shichangString, for: UIControl.State.normal)
        
    }
}




class DDTimeSelectView: DDAlertContainer {
    let sure = UIButton()
    let cancle = UIButton()
    let timePicker : UIDatePicker = UIDatePicker()
    var done : ((TimeInterval) -> ())?
    var selectYearRow = 0
    var selectMonthRow = 0
    /*
    convenience  init(minimumDatetimeStamp:TimeInterval = 1561959807){
        self.init()
        self.addSubview(timePicker)
        self.addSubview(sure)
        self.addSubview(cancle)
        timePicker.datePickerMode = .dateAndTime
        sure.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        cancle.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        cancle.setTitle("取消", for: UIControl.State.normal)
        sure.setTitle("确定", for: UIControl.State.normal)
        timePicker.minimumDate = Date(timeIntervalSince1970: 1561959807)
        timePicker.maximumDate = Date()
        
        timePicker.backgroundColor = UIColor.white
        sure.addTarget(self, action: #selector(sureClick(sender:)), for: UIControl.Event.touchUpInside)
        cancle.addTarget(self, action: #selector(cancleClick(sender:)), for: UIControl.Event.touchUpInside)
    }
    */
     init(frame: CGRect = CGRect.zero , minimumTimestamp:TimeInterval = 1561959807 , showTimestamp:TimeInterval = Date().timeIntervalSince1970) {
        super.init(frame: frame)
        self.addSubview(timePicker)
        self.addSubview(sure)
        self.addSubview(cancle)
        timePicker.datePickerMode = .dateAndTime
        
        
//        timePicker.calendar = Calendar.current;
        timePicker.locale = Locale(identifier: "zh_CN");
//        timePicker.timeZone = TimeZone.current;
//        datePicker.datePickerMode = .time;
        
        sure.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        cancle.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        cancle.setTitle("取消", for: UIControl.State.normal)
        sure.setTitle("确定", for: UIControl.State.normal)
        timePicker.minimumDate = Date(timeIntervalSince1970: minimumTimestamp)
        timePicker.maximumDate = Date()
        timePicker.date = Date(timeIntervalSince1970: showTimestamp)
        timePicker.backgroundColor = UIColor.white
        sure.addTarget(self, action: #selector(sureClick(sender:)), for: UIControl.Event.touchUpInside)
        cancle.addTarget(self, action: #selector(cancleClick(sender:)), for: UIControl.Event.touchUpInside)
    }
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(timePicker)
        self.addSubview(sure)
        self.addSubview(cancle)
        timePicker.datePickerMode = .dateAndTime
        sure.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        cancle.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        cancle.setTitle("取消", for: UIControl.State.normal)
        sure.setTitle("确定", for: UIControl.State.normal)
        timePicker.minimumDate = Date(timeIntervalSince1970: 1561959807)
        timePicker.maximumDate = Date()
        
        timePicker.backgroundColor = UIColor.white
        sure.addTarget(self, action: #selector(sureClick(sender:)), for: UIControl.Event.touchUpInside)
        cancle.addTarget(self, action: #selector(cancleClick(sender:)), for: UIControl.Event.touchUpInside)
    }
    */
    @objc func sureClick(sender:UIButton)  {
        mylog("确定")
        let selectedDateTimeStamp = timePicker.date.timeIntervalSince1970
        self.done?(selectedDateTimeStamp)
        self.remove()
        
    }
    @objc func cancleClick(sender:UIButton)  {
        mylog("取消")
        self.remove()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let timePickerH : CGFloat = UIScreen.main.bounds.width
        timePicker.frame = CGRect(x: 0, y: self.bounds.height - timePickerH, width: self.bounds.width, height: timePickerH)
        sure.frame = CGRect(x:self.bounds.width - 64, y: timePicker.frame.minY , width: 64, height: 44)
        cancle.frame = CGRect(x: 0, y: timePicker.frame.minY , width: 64, height: 44)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
