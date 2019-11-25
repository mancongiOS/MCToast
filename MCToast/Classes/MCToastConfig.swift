//
//  MCToastConfig.swift
//  MCComponentFunction_Example
//
//  Created by 满聪 on 2019/7/8.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit




public class MCToastConfig: NSObject {
    public static let shared = MCToastConfig()
    
    /// 设置交互区域 默认导航栏下禁止交互
    public var eventType = MCToastEventType.navBarRespond
    public var background = Background()
    public var icon = Icon()
    public var text = Text()

    
    /// 自动隐藏的时长
    public var autoClearTime: CGFloat = 1.5

    
    public struct Background {
        /// toast 的背景颜色
        public var color: UIColor = UIColor.init(white: 0, alpha: 0.8)
        /// toast的size
        public var size: CGSize = CGSize.init(width: 150, height: 110)
    }
    
    public struct Icon {
        /// toast icon的size
        public var size: CGSize = CGSize.init(width: 40, height: 40)
        public var successImage: UIImage?
        public var failureImage: UIImage?
        public var waitImage: UIImage?
        public var warningImage: UIImage?
        public var otherImage: UIImage?
    }
    
    public struct Text {
        public var textColor: UIColor?
        public var font: UIFont = UIFont.systemFont(ofSize: 15)
    }
}

