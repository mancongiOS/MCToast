//
//  ViewController.swift
//  MCToast
//
//  Created by 562863544@qq.com on 11/25/2019.
//  Copyright (c) 2019 562863544@qq.com. All rights reserved.
//

import UIKit
import MCToast
import Lottie

class ViewController: UIViewController {

    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 最好写在appdelegate中
        configToast()

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

    lazy var dataArray = [
        "纯文本",
        "长段纯文本",
        "文本的Y偏移量",
        "状态-成功",
        "状态-失败",
        "状态-警告",
        "状态-自定义",
        "显示在状态栏",
        "loading-系统",
        "loading-帧动画",
        "loading-json动画（依赖了Lottie三方库）",
        "页面返回时，Toast的处理",
        "多个状态切换的处理",
        "动态改变文字内容"
        ]
}

extension ViewController {
    func configToast() {
        /// 是否需要配置UI
        //        MCToastConfig.shared.background.size = CGSize.init(width: 200, height: 200)
        //        MCToastConfig.shared.icon.size = CGSize.init(width: 150, height: 150)
        //        MCToastConfig.shared.icon.successImage = UIImage.init(named: "code")
        
//        MCToastConfig.shared.text.offset = (UIScreen.main.bounds.size.height / 2 - 120 - 150)
        MCToastConfig.shared.respond = MCToast.MCToastRespond.respond
    }
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
        
        cell.textLabel?.text = "\(indexPath.row + 1). " + dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        switch indexPath.row {
        case 0:
            self.mc_text("这是一个纯文本的展示", duration: 2)
        case 1:
            MCToast.mc_text("这是一个很长长长长长长长长长长长长长长长的纯文本的展示")
        case 2:
            MCToast.mc_text("居中显示", offset: 0)
        case 3:
            MCToast.mc_success("可能出现的长文本提示长文本内容")
        case 4:
            MCToast.mc_failure("失败")
        case 5:
            MCToast.mc_warning("警告")
        case 6:
            MCToast.mc_codeSuccess()
        case 7:
            self.mc_statusBar("有内容更新啦，赶紧看看吧")
            break
        case 8:
            MCToast.mc_loading(duration: 0)
        case 9:
           let images = [
               UIImage.init(named: "loading1"),
               UIImage.init(named: "loading2"),
               UIImage.init(named: "loading3"),
               UIImage.init(named: "loading4"),
               UIImage.init(named: "loading5"),
               UIImage.init(named: "loading6"),
               UIImage.init(named: "loading7"),
           ]
           MCToast.mc_loading(imageNames: images)
        case 10:
//            let animation = Animation.named("JSON动画")
            MCToast.mc_loading(animation: nil, animationSpeed: 1, duration: 0, respond: .default) {
                print("取消了")
            }
            break
        case 11:
            let vc = LoadingViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 12:
            MCToast.mc_text("开始上传", offset: 0, callback: {
                MCToast.mc_loading(text: "上传中...", duration: 5, callback: {
                    MCToast.mc_success("上传完成")
                })
            })
        case 13:
            let image = UIImage.init(named: "codesend")
            let truples = MCToast.showStatus(nil, text: "倒计时", iconImage: image, duration: 5, respond: .respond)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                UIView.animate(withDuration: 0.2) {
                    truples.label.text = "倒计时 3"
                    truples.imageView.image = UIImage.init(named: "toast_success")
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                UIView.animate(withDuration: 0.2) {
                    truples.label.text = "倒计时 2"
                    truples.imageView.image = UIImage.init(named: "toast_failure")
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                UIView.animate(withDuration: 0.2) {
                    truples.label.text = "倒计时 1"
                    truples.imageView.image = UIImage.init(named: "toast_warning")
                }
            }
        default:
            break
        }
    }
}


extension MCToast {
    
    /// 发送验证码成功
    public static func mc_codeSuccess() {
        let image = UIImage.init(named: "codesend")
        MCToast.showStatus(nil, text: "发送验证码成功", iconImage: image, duration: 2, respond: .respond)
    }
}
