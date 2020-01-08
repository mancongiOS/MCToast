//
//  ViewController.swift
//  MCToast
//
//  Created by 562863544@qq.com on 11/25/2019.
//  Copyright (c) 2019 562863544@qq.com. All rights reserved.
//

import UIKit
import MCToast

class ViewController: UIViewController {

    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /// 是否需要配置UI
//        MCToastConfig.shared.background.size = CGSize.init(width: 200, height: 200)
//        MCToastConfig.shared.icon.size = CGSize.init(width: 150, height: 150)
//        MCToastConfig.shared.icon.successImage = UIImage.init(named: "code")

        MCToastConfig.shared.eventType = MCToastEventType.navBarRespond
        
        
        
        
        baseSetting()
        
        initUI()
    }
    
    // MARK: - Setter & Getter
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    lazy var dataArray = ["纯文本", "长段纯文本", "加载","成功","失败","警告", "等待","其他","状态栏","处理loading中页面返回","自定义Toast iconImage", "设置文本显示的Y偏移量"]
}



//MARK: UI的处理,通知的接收
extension ViewController {
    
    func baseSetting() {
        navigationItem.title = "Toast提示"
    }
    
    func initUI() {
        tableView.frame = view.frame
        view.addSubview(tableView)
    }
}

//MARK: 代理方法

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = UIColor.white
        
        cell.textLabel?.text = "展示" + dataArray[indexPath.row] + "提示"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        switch indexPath.row {
        case 0:
            
            MCToast.mc_text("这是一个纯文本的展示", autoClearTime: 2, font: UIFont.systemFont(ofSize: 15))
            
        
        case 1:
            MCToast.mc_text("这是一个很长长长长长长长长长长长长长长长的纯文本的展示",
                            autoClearTime: 2)

        case 2:
            MCToast.mc_loading(autoClearTime: 2)
        case 3:
            MCToast.mc_success("设置成功")
        case 4:
            MCToast.mc_failure("设置失败")
        case 5:
            MCToast.mc_warning("警告")
        case 6:
            MCToast.mc_warning("等待")
        case 7:
            MCToast.mc_other("其他")
        case 8:
            MCToast.mc_statusBar("有内容更新啦，赶紧看看吧", backgroundColor: nil)
        case 9:
            let vc = LoadingViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 10:
            MCToast.mc_codeSuccess()
        case 11:
            MCToast.mc_text("设置文本Toast的偏移量", offset: 200)
        default:
            break
        }
    }
}


extension MCToast {
    
    /// 发送验证码成功
    public static func mc_codeSuccess() {

        let image = UIImage.init(named: "codesend")
        MCToast.showNoticeWithText(.success, text: "发送验证码成功", iconImage: image, autoClear: true, autoClearTime: 2, font: UIFont.systemFont(ofSize: 15), eventType: MCToastEventType.navBarRespond)
    }
}
