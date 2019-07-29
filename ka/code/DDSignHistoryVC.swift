//
//  DDSignHistoryVC.swift
//  ka
//
//  Created by WY on 2019/7/25.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class DDSignHistoryVC: UIViewController {
    let totalTime = UILabel()
    var totalTimeInterval : TimeInterval = 0
    var dataArr = [(signin:TimeInterval,signout:TimeInterval)](){
        didSet{
            jiabanArr.removeAll()
            totalTimeInterval = 0
            var totalTimeInHour = totalTimeInterval / 3600
            for time  in dataArr  {
                let set = Set([Calendar.Component.year , Calendar.Component.month ,Calendar.Component.day,Calendar.Component.weekday])
                let a = Calendar.current.dateComponents(set, from: Date(timeIntervalSince1970: time.signin))
                var jiabanshichang : TimeInterval = time.signout - time.signin
                let weakDayStr = "\(a.weekday ?? 0)"
                if !(weakDayStr == "1" ||  weakDayStr == "7"){// "周日"
                    jiabanshichang  -= 30600
                    if jiabanshichang < 10800{//工作日加够3个小时才算
                        jiabanshichang = 0
                    }
                }else{}
//                var  shichangHour = jiabanshichang / 3600
                if jiabanshichang <= 0 {jiabanshichang = 0 }
                mylog(jiabanshichang)
                let sult = jiabanshichang.truncatingRemainder(dividingBy: 1800)
//                mylog(sult)
//                mylog(jiabanshichang)
//                mylog(jiabanshichang - sult)
                jiabanshichang = jiabanshichang - sult//不满半个小时的部分不算
                totalTimeInterval += jiabanshichang
                jiabanArr.append(jiabanshichang)
            }
            
            totalTime.text = String(format: "总时长:  %.03f", totalTimeInterval / 3600)
        }
    }
    var jiabanArr = [TimeInterval ]()
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    let editBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "签到记录"
        self.view.backgroundColor = UIColor.white
        configNaviBar()
        self.confitTableView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getDate()
    }
    func getDate()  {
        self.dataArr = DDStorgeManager.share.readTotalSignDate()
        self.tableView.reloadData()
    }
    @objc func chooseTime() {
        self.view.removeAllMaskView(maskClass: DDMonthSelectView.self)
        let alert = DDMonthSelectView()
        alert.done = {[weak self ] year , month  in
            mylog("\(year)   \(month)")
            self?.dataArr = DDStorgeManager.share.readTotalSignDate(year: year, month: month)
            self?.editBtn.setTitle("\(month)月", for: UIControl.State.normal)
            self?.tableView.reloadData()
        }
        self.view.alert(alert)
    }
   func configNaviBar() {
    
        editBtn.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        editBtn.setTitle("filter", for: UIControl.State.normal)
        editBtn.backgroundColor = UIColor.clear
        editBtn.addTarget(self, action: #selector(chooseTime), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editBtn)
        
    }
    
    /*
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
*/


}
extension DDSignHistoryVC  : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  returnCell : SignHistoryCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SignHistoryCell") as? SignHistoryCell{
            returnCell = cell
        }else{
            let cell = SignHistoryCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "SignHistoryCell")
            returnCell = cell
        }
        returnCell.model = self.dataArr[indexPath.row]
        return returnCell
    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return UITableViewCell.EditingStyle.delete
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        mylog(indexPath)
//    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "edit") { (action , indexPath) in
            self.toEditOrAdd(indexPath: indexPath)
            mylog(indexPath)
        }
        let delete = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "delete") {[weak self ] (action , indexPath) in
            if let model = self?.dataArr[indexPath.row]{
                DDStorgeManager.share.deleteRow(signin: model.signin, signout: model.signout)
                self?.getDate()
            }
            
        }
        edit.backgroundColor = UIColor.brown
        delete.backgroundColor = UIColor.red
        return [edit , delete]
    }
    func toEditOrAdd(indexPath: IndexPath)  {
        let model = self.dataArr[indexPath.row]
        let vc = DDEditVC()
        vc.signinStamp = model.signin
        vc.signoutStamp = model.signout
        self.navigationController?.pushViewController(vc , animated: true )
    }
    func confitTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        totalTime.textAlignment = .center
        totalTime.textColor = UIColor.orange
        totalTime.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
        tableView.tableHeaderView = totalTime
        //            tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height )
    }
}

class SignHistoryCell: UITableViewCell {
    var model : (signin:TimeInterval,signout:TimeInterval)? = (signin:0,signout:0){
        didSet{
            if let time = model{
                let set = Set([Calendar.Component.year , Calendar.Component.month ,Calendar.Component.day,Calendar.Component.weekday])
                let a = Calendar.current.dateComponents(set, from: Date(timeIntervalSince1970: time.signin))
                var jiabanshichang : TimeInterval = time.signout - time.signin
                let weakDayStr = "\(a.weekday ?? 0)"
                let dayStr = "\(a.day ?? 0)"
                if weakDayStr == "1"{
                    weakDay.text = "周日   \(dayStr)号"
                    weakDay.textColor = UIColor.red
                    timeInterval.textColor = UIColor.orange
                }else if weakDayStr == "2"{
                    weakDay.text = "周一   \(dayStr)号"
                    weakDay.textColor = UIColor.gray
                    jiabanshichang  -= 30600//工作日加够三个小时以上才算加班
                    if jiabanshichang >= 10800{
                        timeInterval.textColor = UIColor.orange
                    }else{timeInterval.textColor = UIColor.lightGray}
                }else if weakDayStr == "3"{
                    weakDay.text = "周二   \(dayStr)号"
                    weakDay.textColor = UIColor.gray
                    jiabanshichang  -= 30600
                    if jiabanshichang >= 10800{
                        timeInterval.textColor = UIColor.orange
                    }else{timeInterval.textColor = UIColor.lightGray}
                }else if weakDayStr == "4"{
                    weakDay.text = "周三   \(dayStr)号"
                    weakDay.textColor = UIColor.gray
                    jiabanshichang  -= 30600
                    if jiabanshichang >= 10800{
                        timeInterval.textColor = UIColor.orange
                    }else{timeInterval.textColor = UIColor.lightGray}
                }else if weakDayStr == "5"{
                    weakDay.text = "周四   \(dayStr)号"
                    weakDay.textColor = UIColor.gray
                    jiabanshichang  -= 30600
                    if jiabanshichang >= 10800{
                        timeInterval.textColor = UIColor.orange
                    }else{timeInterval.textColor = UIColor.lightGray}
                }else if weakDayStr == "6"{
                    weakDay.text = "周五   \(dayStr)号"
                    weakDay.textColor = UIColor.gray
                    jiabanshichang  -= 30600
                    if jiabanshichang >= 10800{
                        timeInterval.textColor = UIColor.orange
                    }else{timeInterval.textColor = UIColor.lightGray}
                }else if weakDayStr == "7"{
                    weakDay.text = "周六   \(dayStr)号"
                    weakDay.textColor = UIColor.red
                    timeInterval.textColor = UIColor.orange
                }
                
                
                let signinDate = Date(timeIntervalSince1970: time.signin)
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "HH:mm:ss"//"yyyy-MM-dd 'at' HH:mm"
                let signinString = dateFormater.string(from: signinDate)
                self.signin.text = "\(signinString)"
                
                if time.signout <= 0 {
                    self.signout.text = ""
                    layoutIfNeeded()
                    setNeedsLayout()
                    return
                }
                
                let signoutDate = Date(timeIntervalSince1970: time.signout)
                let signoutString = dateFormater.string(from: signoutDate)
                self.signout.text = "\(signoutString)"
                if jiabanshichang  < 0 {
                    jiabanshichang  = 0
                }
                let sult = jiabanshichang.truncatingRemainder(dividingBy: 1800)
                //                mylog(sult)
                //                mylog(jiabanshichang)
                //                mylog(jiabanshichang - sult)
                jiabanshichang = jiabanshichang - sult//不满半个小时的部分不算
                let shichangHour = String(format: "%.03f", (jiabanshichang) / 3600)
//                let shichangHour = "\(Int(time.signout - time.signin) / 3600 )"
//                let shichangMinute = "\(Int(time.signout - time.signin) % 3600 / 60)"
                self.timeInterval.text = " \(shichangHour)"
            }
            
            
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    let weakDay = UILabel()
    let signin = UILabel()
    let signout = UILabel()
    let timeInterval = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(weakDay)
        self.contentView.addSubview(signin)
        self.contentView.addSubview(signout)
        self.contentView.addSubview(timeInterval)
        signin.textColor = UIColor.lightGray
        signout.textColor = UIColor.lightGray
        signin.textAlignment = .center
        signout.textAlignment = .center
        timeInterval.textColor = UIColor.lightGray
        weakDay.textAlignment = .center
        timeInterval.textAlignment = .center
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let timeH :CGFloat = 22
        let signinY : CGFloat = self.bounds.height/2 - timeH
        let signoutY : CGFloat = self.bounds.height  / 2
        let weakW : CGFloat = 111
        let jabanW : CGFloat = 64
        weakDay.frame = CGRect(x: 0, y: 0, width: weakW, height: self.bounds.height)
        signin.frame = CGRect(x: weakW, y: signinY, width: self.bounds.width - jabanW - weakW, height: timeH)
        signout.frame = CGRect(x: weakW, y: signoutY, width: self.bounds.width - jabanW - weakW, height: timeH)
        timeInterval.frame = CGRect(x: self.bounds.width - jabanW, y: 0, width: jabanW, height: self.bounds.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

