//
//  MCToast.swift
//  GMMCExtension
//
//  Created by 满聪 on 2019/4/19.
//



import Foundation
import UIKit

private let sn_topBar: Int = 1001


private let kScreenWidth = UIScreen.main.bounds.size.width
private let kScreenHeight = UIScreen.main.bounds.size.height

/// toast内边距 （toast和其中的内容的最小边距）
private let kMinPadding: CGFloat = 10
/// toast外边距 （toast距离屏幕边的最小边距）
private let kMinMargin: CGFloat = 30



/// Toast类型
public enum MCToastType {
    /// 纯文字
    case text
    /// 加载中
    case loading
    /// 成功
    case success
    /// 失败
    case failure
    /// 等待
    case wait
    /// 警告
    case warning
    /// 其他
    case other
}


public enum MCToastEventType {
    
    /// Toast展示期间不允许事件交互
    case noRespond
    /// Toast展示期间允许事件交互
    case respond
    /// Toast展示期间只允许导航条交互
    case navBarRespond
}

public class MCToast: NSObject {
    
    /// 管理所有的windows
    fileprivate static var windows = Array<UIWindow?>()
    fileprivate static let keyWindow = UIApplication.shared.keyWindow?.subviews.first as UIView?

    
    private override init() {
        super.init()
        
    }
    
    
    fileprivate static func safeAreaInsets() -> (top: CGFloat, bottom: CGFloat) {
        if #available(iOS 11.0, *) {
            
            let inset = UIApplication.shared.delegate?.window??.safeAreaInsets
            
            return (inset?.top ?? 0, inset?.bottom ?? 0)
        } else {
            return (0, 0)
        }
    }
    
    
    /* just for iOS 8
     */
    fileprivate static var degree: Double {
        get {
            return [0, 0, 180, 270, 90][UIApplication.shared.statusBarOrientation.hashValue] as Double
        }
    }
    
    
    // just for iOS 8
    fileprivate static func getRealCenter() -> CGPoint {
        if UIApplication.shared.statusBarOrientation.hashValue >= 3 {
            return CGPoint(x: keyWindow!.center.y, y: keyWindow!.center.x)
        } else {
            return keyWindow!.center
        }
    }
}






// MARK: - 在状态栏上显示提示框
extension MCToast {
    
    /// 在状态栏上显示提示框
    ///
    /// - Parameters:
    ///   - text: 显示的文字颜色
    ///   - autoClear: 是否自动隐藏
    ///   - autoClearTime: 自动隐藏时间
    ///   - font: 字体大小
    /// - Returns: UIWindow
    @discardableResult
    public static func noticeOnStatusBar(
        _ text: String,
        autoClear: Bool,
        autoClearTime: CGFloat,
        backgroundColor: UIColor?,
        font: UIFont) -> UIWindow {
        
        clearAllToast()

        
        var labelY: CGFloat = 0
        let labelHeight: CGFloat = 20
        
        
        let topSafeAreaHeight: CGFloat   = safeAreaInsets().top
        
        var frame = UIApplication.shared.statusBarFrame
        
        if frame.size.height > 20 {
            frame.size.height = topSafeAreaHeight + labelHeight
            labelY = topSafeAreaHeight
        } else {
            labelY = 0
        }
        
        
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        
        
        let view = UIView()
        
        if let color = backgroundColor {
            view.backgroundColor = color
        } else {
            view.backgroundColor = UIColor(red: 0x6a/0x100, green: 0xb4/0x100, blue: 0x9f/0x100, alpha: 1)
        }
        
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: labelY, width: frame.width, height: labelHeight)
        label.textAlignment = NSTextAlignment.center
        label.font = font
        label.textColor = UIColor.white
        label.text = text
        view.addSubview(label)
        
        window.frame = frame
        view.frame = frame
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            var array = [UIScreen.main.bounds.width, UIScreen.main.bounds.height]
            array = array.sorted(by: <)
            let screenWidth = array[0]
            let screenHeight = array[1]
            let x = [0, screenWidth/2, screenWidth/2, 10, screenWidth-10][UIApplication.shared.statusBarOrientation.hashValue] as CGFloat
            let y = [0, 10, screenHeight-10, screenHeight/2, screenHeight/2][UIApplication.shared.statusBarOrientation.hashValue] as CGFloat
            window.center = CGPoint(x: x, y: y)
            
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
        window.windowLevel = UIWindow.Level.statusBar
        window.isHidden = false
        window.addSubview(view)
        windows.append(window)
        
        var origPoint = view.frame.origin
        origPoint.y = -(view.frame.size.height)
        let destPoint = view.frame.origin
        view.tag = sn_topBar
        
        view.frame = CGRect(origin: origPoint, size: view.frame.size)
        UIView.animate(withDuration: 0.3, animations: {
            view.frame = CGRect(origin: destPoint, size: view.frame.size)
        }, completion: { b in
            if autoClear {
                self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
            }
        })
        return window
    }
}


// MARK: - 显示纯文字
extension MCToast {
    
    /// 显示纯文字
    ///
    /// - Parameters:
    ///   - text: 要显示的文字
    ///   - autoClear: 是否自动隐藏
    ///   - autoClearTime: 自动隐藏的时间
    ///   - font: 字体大小
    /// - Returns: UIWindow
    @discardableResult
    public static func showText(
        _ text: String,
        offset: CGFloat,
        autoClear: Bool,
        autoClearTime: CGFloat,
        font: UIFont,
        eventType: MCToastEventType) -> UIWindow {
        
        clearAllToast()
        
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = font
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        let labelWidth = kScreenWidth-(kMinMargin + kMinPadding) * 2
        
        let size = label.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))

        label.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)


        let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 2*kMinMargin, height: label.frame.height + 30)

        
        let mainView = MCToast.createMainView(frame: superFrame)
        
        
        let window = MCToast.createWindow(eventType: eventType, autoFrame: superFrame)
        

        window.addSubview(mainView)
        mainView.center = CGPoint.init(x: window.frame.size.width/2, y: kScreenHeight/2 - window.frame.origin.y + offset)
            
        mainView.addSubview(label)
        label.center = CGPoint.init(x: mainView.frame.size.width/2, y: mainView.frame.size.height/2)

        
        windows.append(window)

        if autoClear {
            self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
        }
        return window
    }
}



// MARK: - 网络等待 菊花转圈
extension MCToast {
    
    
    /// 菊花转圈图
    ///
    /// - Parameters:
    ///   - text: 提示文字
    ///   - font: 字体大小
    ///   - timeInterval: 隐藏的时间。 设置为0，不隐藏
    /// - Returns: UIWindow
    @discardableResult
    public static func loading(
        text: String,
        font: UIFont,
        autoClear: Bool,
        autoClearTime: CGFloat,
        eventType: MCToastEventType) -> UIWindow {
        
        clearAllToast()

        let kToastSize = MCToastConfig.shared.background.size
        var kToastImageSize = MCToastConfig.shared.icon.size

        if (kToastImageSize.width > kToastSize.width) || (kToastImageSize.height > kToastSize.height)  {
            kToastImageSize = CGSize.init(width: 40, height: 40)
        }
        
        
        
        let frame = CGRect(x: 0, y: 0, width: kToastSize.width, height: kToastSize.height)
        
        
        let window = MCToast.createWindow(eventType: eventType, autoFrame: frame)
        
        
        let mainView = MCToast.createMainView(frame: frame)
        
        window.addSubview(mainView)
        mainView.center = CGPoint.init(x: window.frame.size.width/2, y: kScreenHeight/2 - window.frame.origin.y)

        
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        
     
        let activityX = (kToastSize.width - kToastImageSize.width) / 2
        let activityY = ((kToastSize.height - kToastImageSize.height - 30) / 2)
        activity.frame = CGRect.init(x: activityX, y: activityY, width: kToastImageSize.width, height: kToastImageSize.height)
        activity.startAnimating()
        mainView.addSubview(activity)
        
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        
        
        label.frame = CGRect(x: 5, y: activity.frame.maxY + 12, width: kToastSize.width - 10, height: 18)
        mainView.addSubview(label)
                
        
        if autoClear {
            self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
        }

        
        return window
    }
}



// MARK: - 展示各种状态Toast
extension MCToast {
    
    
    /// 展示各种状态图
    ///
    /// - Parameters:
    ///   - type: toast的类型
    ///   - text: 文字
    ///   - iconImage: icon 图片。如果不为nil，优先用这个图

    ///   - autoClear: 是否自动隐藏
    ///   - autoClearTime: 自动隐藏的时间
    ///   - font: 字体的大小
    /// - Returns: UIWindow
    @discardableResult
    public static func showNoticeWithText(
        _ type: MCToastType,
        text: String,
        iconImage: UIImage?,
        autoClear: Bool,
        autoClearTime: CGFloat,
        font:UIFont,
        eventType: MCToastEventType) -> UIWindow {
        
        
        clearAllToast()
        
        let kToastSize = MCToastConfig.shared.background.size
        var kToastImageSize = MCToastConfig.shared.icon.size
        if (kToastImageSize.width > kToastSize.width) || (kToastImageSize.height > kToastSize.height)  {
            kToastImageSize = CGSize.init(width: 40, height: 40)
        }

        
        
        let frame = CGRect(x: 0, y: 0, width: kToastSize.width, height: kToastSize.height)
        
        let window = MCToast.createWindow(eventType: eventType, autoFrame: frame)
        
        let mainView = MCToast.createMainView(frame: frame)
        window.addSubview(mainView)
        mainView.center = CGPoint.init(x: window.frame.size.width/2, y: kScreenHeight/2 - window.frame.origin.y)

        
        var imageName = ""
        switch type {
        case .success:
            imageName = "toast_success"
        case .failure:
            imageName = "toast_failure"
        case .wait:
            imageName = "toast_wait"
        case .warning:
            imageName = "toast_warning"
        case .other:
            imageName = "toast_other"
        default:
            break
        }
        
        var image = Bundle.loadImage(imageName, from: "ToastBundle", in: "MCToast")
        
        
        /// 外部是否配置了展示的icon
        switch type {
        case .success:
            if let trueImage = MCToastConfig.shared.icon.successImage {
                image = trueImage
            }
        case .failure:
            if let trueImage = MCToastConfig.shared.icon.failureImage {
                image = trueImage
            }
        case .wait:
            if let trueImage = MCToastConfig.shared.icon.waitImage {
                image = trueImage
            }
        case .warning:
            if let trueImage = MCToastConfig.shared.icon.warningImage {
                image = trueImage
            }
        case .other:
            if let trueImage = MCToastConfig.shared.icon.otherImage {
                image = trueImage
            }
        default:
            break
        }

        if let showImage = iconImage {
            image = showImage
        }

        
        let checkmarkView = UIImageView(image: image)
       
        
        let checkmarkX = (kToastSize.width - kToastImageSize.width) / 2
        let checkmarkY = ((kToastSize.height - kToastImageSize.height - 30) / 2) + 2
        checkmarkView.frame = CGRect.init(x: checkmarkX, y: checkmarkY, width: kToastImageSize.width, height: kToastImageSize.height)
        
        mainView.addSubview(checkmarkView)
        
        let label = UILabel()
        label.frame = CGRect(x: 5, y: checkmarkView.frame.maxY + 12, width: kToastSize.width - 10, height: 18)

        label.font = font
        label.textColor = UIColor.white
        label.text = text
        label.textAlignment = NSTextAlignment.center
        mainView.addSubview(label)
        
        
        window.addSubview(mainView)
        windows.append(window)
        
        if autoClear {
            self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
        }
        return window
    }
}





fileprivate extension Selector {
    static let hideNotice = #selector(MCToast.hideNotice(_:))
}

extension MCToast {
    
    /// 隐藏
    @objc static func hideNotice(_ sender: AnyObject) {
        if let window = sender as? UIWindow {
            
            if let v = window.subviews.first {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    if v.tag == sn_topBar {
                        v.frame = CGRect(x: 0, y: -v.frame.height, width: v.frame.width, height: v.frame.height)
                    }
                    v.alpha = 0
                }, completion: { b in
                    
                    if let index = windows.firstIndex(where: { (item) -> Bool in
                        return item == window
                    }) {
                        windows.remove(at: index)
                    }
                })
            }
        }
    }
    
    
    /// 清空
    static func clearAllToast() {
        self.cancelPreviousPerformRequests(withTarget: self)
        windows.removeAll(keepingCapacity: false)
    }
}






extension MCToast {
    
    /// 创建Window
    static func createWindow(eventType: MCToastEventType, autoFrame: CGRect) -> UIWindow {
        
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        
        
        switch eventType {
        case .noRespond:
            window.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        case .navBarRespond:
            let vc = UIViewController.current()
            let rectNav = vc.navigationController?.navigationBar.frame
            let maxY = rectNav?.maxY ?? 0
            
            if vc.navigationController != nil && vc.navigationController?.navigationBar.isHidden == false {
                window.frame = CGRect.init(x: 0, y: maxY, width: kScreenWidth, height: kScreenHeight - maxY)
            } else {
                window.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            }
            
            
        case .respond:
            window.frame = autoFrame
            window.center = keyWindow!.center
        }
        


        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
        window.windowLevel = UIWindow.Level.alert
        window.isHidden = false
        
        return window
    }
    
    
    static func createMainView(frame: CGRect) -> UIView {
        
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = MCToastConfig.shared.background.color
        
        mainView.frame = frame

        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })

        return mainView
    }
}
