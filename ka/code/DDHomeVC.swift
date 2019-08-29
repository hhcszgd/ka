//  DDHomeVC.swift
//  Created by WY on 2019/7/25.
//  Copyright © 2019 WY. All rights reserved.
import UIKit

class DDHomeVC: UIViewController {
    var timer : Timer?
    var currentTime : TimeInterval = 0
    let signButton = MyButton()
    let signinLabel = UILabel()
    let signoutLabel = UILabel()
    let shichangLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "签到"
        configSubviews()
        updateSignUI()
        configNaviBar()
        addTimer()
        configLeftBarbuttonItem()
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        AddFireAssistent.share.startFireFlowerWithTouches(touches: touches)
//    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touche moved ")
        AddFireAssistent.share.startByTouches(touches)
    }
    func configLeftBarbuttonItem()  {
            let editBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
            editBtn.setTitleColor(UIColor.gray, for: UIControl.State.normal)
            //        editBtn.setImage(UIImage.init(named: "history"), for: UIControl.State.normal)
            editBtn.setTitle("hope", for: UIControl.State.normal)
            editBtn.setTitle("hope", for: UIControl.State.selected)
            editBtn.backgroundColor = UIColor.clear
            editBtn.addTarget(self, action: #selector(editAction(sender:)), for: UIControl.Event.touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: editBtn)
            
    }
    @objc func editAction(sender:UIButton)  {
        mylog("xxxx")
        self.navigationController?.pushViewController(DDHopeVC(), animated: true)
    }
    func configNaviBar() {
        let editBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
        editBtn.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        editBtn.setTitle("history", for: UIControl.State.normal)
        editBtn.backgroundColor = UIColor.clear
        editBtn.addTarget(self, action: #selector(goSignHistory(sender:)), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editBtn)
        
    }
    @objc func goSignHistory(sender:UIButton) {
        self.navigationController?.pushViewController(DDSignHistoryVC(), animated: true)
    }
    @objc func signAction(sender:MyButton) {
        if currentTime <= 0 {
            return
        }
        DDStorgeManager.share.insertOrUpdate(timeStamp: currentTime)
//        DDStorgeManager.share.insertOrUpdate(timeStamp: 1564264550.6167521)
        
        updateSignUI()
    }
    func updateSignUI() {
        let time = DDStorgeManager.share.readTodaySignDate()
        if time.signin <= 0 {
            self.signinLabel.text = nil
            return
        }
        let signinDate = Date(timeIntervalSince1970: time.signin)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy年MM月dd日HH点mm分ss秒"//"yyyy-MM-dd 'at' HH:mm"
        let signinString = dateFormater.string(from: signinDate)
        self.signinLabel.text = "签到时间: \(signinString)"
        
        if time.signout <= 0{
            self.signoutLabel.text = nil
            return
        }
        
        let signoutDate = Date(timeIntervalSince1970: time.signout)
        let signoutString = dateFormater.string(from: signoutDate)
        self.signoutLabel.text = "签退时间: \(signoutString)"
        
        let shichangHour = "\(Int(time.signout - time.signin) / 3600 )"
        
        let shichangMinute = "\(Int(time.signout - time.signin) % 3600 / 60)"
        self.shichangLabel.text = "时长 \(shichangHour)小时\(shichangMinute)分"
    }
    func addTimer() {
        self.removeTimer()
        timer = Timer.init(timeInterval: 1, target: self , selector: #selector(daojishi), userInfo: nil , repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    @objc func daojishi() {
        self.refreshTime();
    }
    
    func refreshTime() {
        let date = Date()
        self.currentTime = date.timeIntervalSince1970
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy年MM月dd日HH点mm分ss秒"//"yyyy-MM-dd 'at' HH:mm"
        let dateString = dateFormater.string(from: date)
        signButton.setTitle(dateString, for: UIControl.State.normal)
    }
    
    func configSubviews()  {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(signButton)
        signButton.adjustsImageWhenHighlighted = false
        self.view.addSubview(signinLabel)
        self.view.addSubview(signoutLabel)
        self.view.addSubview(shichangLabel)
        signinLabel.textColor = UIColor.lightGray
        signinLabel.textAlignment = .center
        signoutLabel.textColor = UIColor.lightGray
        signoutLabel.textAlignment = .center
        shichangLabel.textColor = UIColor.lightGray
        shichangLabel.textAlignment = .center
        signButton.setBackgroundImage(UIImage(named: "signinbutton"), for: UIControl.State.normal)
        signButton.setTitle("准备签到", for: UIControl.State.normal)
        signButton.contentHorizontalAlignment = .center
        signButton.titleLabel?.numberOfLines = 2
        signButton.addTarget(self , action: #selector(signAction(sender:)), for: UIControl.Event.touchUpInside)
        layoutCustomSubviews()
    }
    func layoutCustomSubviews() {
        let signButtonWH = self.view.bounds.width * 0.9
        signinLabel.frame = CGRect(x: 0, y: 140, width: self.view.bounds.width, height: 30)
        signoutLabel.frame = CGRect(x: 0, y: signinLabel.frame.maxY + 14, width: self.view.bounds.width, height: 30)
        shichangLabel.frame = CGRect(x: 0, y: signoutLabel.frame.maxY + 14, width: self.view.bounds.width, height: 30)
        
        signButton.frame = CGRect(x: self.view.bounds.width/2 - signButtonWH/2 , y:  (self.view.bounds.height - signButtonWH * 1.11 )   , width: signButtonWH, height: signButtonWH)
    }
    deinit {
        self.removeTimer()
    }
}

class MyButton: UIButton {
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        AddFireAssistent.share.startFireFlowerWithTouches(touches: touches)
    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touche moved ")
//        AddFireAssistent.share.startByTouches(touches)
//    }
}
