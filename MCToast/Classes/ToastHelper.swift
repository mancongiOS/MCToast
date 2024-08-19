//
//  ToastHelper.swift
//  MCToast
//
//  Created by qixin on 2024/8/19.
//

import Foundation
extension UIViewController {
    
    /// 获取当前控制器，少用！（内部实现使用了递归函数）
    static func current(_ window: UIWindow? = UIApplication.shared.keyWindow) -> UIViewController? {
        if let vc = window?.rootViewController {
            return UIViewController.findBest(vc: vc)
        } else {
            return nil
        }
    }
    
    private static func findBest(vc: UIViewController) -> UIViewController {
        if vc.presentedViewController != nil {
            return UIViewController.findBest(vc: vc.presentedViewController!)
        } else if vc.isKind(of: UISplitViewController.self) {
            let svc = vc as! UISplitViewController
            if svc.viewControllers.count > 0 {
                return UIViewController.findBest(vc: svc.viewControllers.last!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UINavigationController.self) {
            let svc = vc as! UINavigationController
            if svc.viewControllers.count > 0 {
                return UIViewController.findBest(vc: svc.topViewController!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UITabBarController.self) {
            let svc = vc as! UITabBarController
            if (svc.viewControllers?.count ?? 0) > 0 {
                return UIViewController.findBest(vc: svc.selectedViewController!)
            } else {
                return vc
            }
        } else {
            return vc
        }
    }
}


extension String {
    /// 计算字符串的高度
    func getHeight(font: UIFont, width: CGFloat, lineSpacing: CGFloat = 0) -> CGFloat {
        let statusLabelText: NSString = self as NSString
        let size = CGSize.init(width: width, height: 9000)
        
        var dic: [NSAttributedString.Key : Any] = [:]
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
        dic[NSAttributedString.Key.paragraphStyle] = paraStyle
        
        
        dic[NSAttributedString.Key.font] = font
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
        return strSize.height + 1
    }
    
}



//MARK: - 各种高度/宽度的获取
extension UIDevice {
    
    
    
    /// 顶部安全区域的高度 (20 / 44 / 47 / 59)
    static var topSafeAreaHeight: CGFloat {
        UIDevice.safeAreaInsets().top
    }
    
    /// 底部安全区域 (0 or 34)
    static var bottomSafeAreaHeight: CGFloat {
        UIDevice.safeAreaInsets().bottom
    }
}


//MARK: - 可以不关注。内部实现，为外部调用提供服务
extension UIDevice {
    
    fileprivate static func safeAreaInsets() -> (top: CGFloat, bottom: CGFloat) {
        
        // 既然是安全区域，非全面屏获取的虽然是0，但是毕竟有20高度的状态栏。也要空出来才可以不影响UI展示。
        let defalutArea: (CGFloat, CGFloat) = (20, 0)
        
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return defalutArea }
            guard let window = windowScene.windows.first else { return defalutArea }
            let inset = window.safeAreaInsets
            
            return (inset.top, inset.bottom)
            
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return defalutArea }
            let inset = window.safeAreaInsets
            return (inset.top, inset.bottom)
            
        } else {
            return defalutArea
        }
    }
}
extension UIEdgeInsets {
    var horizontal: CGFloat {
        return self.left + self.right
    }
    
    var vertical: CGFloat {
        return self.top + self.bottom
    }
}
