
# Toast For Swift


## 概要说明

**MCToast** 是Swift版本的HUD库，提供了显示纯文本的Toast，带有状态图片的Toast，带有loading样式的Toast。

主要优点：

* Swift语言实现的Toast交互功能库。
* MCToast内部控制显示在主线程中，保证了线程安全性。
* 提供了多种使用方式，方便快捷。
* 支持UI的高度自定义。配置toast的小图标，文字大小和颜色等
* 内部处理了多个toast提示重叠显示的问题。



Demo地址

[https://github.com/mancongiOS/MCToast](https://github.com/mancongiOS/MCToast)

## 样例展示

![示例1](https://github.com/mancongiOS/MCToast/blob/master/gif1-min.gif)

![示例2](https://github.com/mancongiOS/MCToast/blob/master/gif2-min.gif)

![示例3](https://github.com/mancongiOS/MCToast/blob/master/all.png)

# 

# 使用
#### 支持cocoPods

  ```
  pod 'MCToast'
  ```


#### 使用

* 显示纯文本

  ```
  // 可以这样用
  self.mc_text("这是一个纯文本的展示")
  // 也可以这样用
  MCToast.mc_text("这是一个很长长长长长长长长长长长长长长长的纯文本的展示")
  // 设置offset
  MCToast.mc_text("居中显示", offset: 0)
  ```

* 带状态的Toast

  ```
  /// 成功的Toast
  MCToast.mc_success("可能出现的长文本提示长文本内容")
  /// 失败的Toast
  MCToast.mc_failure("失败")
  /// 警告的Toast
  MCToast.mc_warning("警告")
  /// 自定义的状态Toast
  MCToast.mc_codeSuccess()
  
  extension MCToast {
      /// 发送验证码成功
      public static func mc_codeSuccess() {
          let image = UIImage.init(named: "codesend")
          MCToast.showStatus(nil, text: "发送验证码成功", iconImage: image, duration: 2, respond: .respond)
      }
  }
  ```

* loading

  ```
  /// 系统的loading
  MCToast.mc_loading()
  /// 自定义的帧动画loading
  MCToast.mc_loading(imageNames: images)
  /// Json动画的loading （集成了Lottie库）
  let animation = Animation.named("JSON动画")
  MCToast.mc_loading(animation: animation) 
  ```

* 其他更详细的使用请查看[Demo](https://github.com/mancongiOS/MCToast)





#### 配置Toast的UI显示

如果你需要自定义UI样式，可以通过设置MCToastConfig达到你的目的。

```
public class MCToastConfig: NSObject {
    public static let shared = MCToastConfig()
    
    /// 设置交互区域 默认导航栏下禁止交互
    public var respond = MCToast.MCToastRespond.navBarRespond
    
    /// 背景的设置
    public var background = Background()
    
    /// 状态Icon的设置
    public var icon = Icon()
    
    /// 文本的设置
    public var text = Text()
    
    /// 间距的设置
    public var spacing = MainAreaSpacing()
    
    /// 自动隐藏的时长
    public var duration: CGFloat = 1.5
}


extension MCToastConfig {
    public struct Background {
        /// toast 的背景颜色
        public var color: UIColor = UIColor.init(white: 0, alpha: 0.8)
        /// toast的size
        public var size: CGSize = CGSize.init(width: 135, height: 135)
    }
    
    public struct Icon {
        /// toast icon的size
        public var size: CGSize = CGSize.init(width: 50, height: 50)
        public var successImage: UIImage?
        public var failureImage: UIImage?
        public var warningImage: UIImage?
    }
    
    public struct Text {
        public var textColor: UIColor?
        public var font: UIFont = UIFont.systemFont(ofSize: 15)
        public var offset: CGFloat = (UIScreen.main.bounds.size.height / 2 - 120)
    }
    
    
    /// 主区域的间距
    public struct MainAreaSpacing {
        /// 外边距（toast距离屏幕边的最小边距）
        public var margin: CGFloat = 55
        /// 内边距（toast和其中的内容的最小边距）
        public var padding: CGFloat = 15
    }
}
```
示例：
```
/// 背景框的大小
MCToastConfig.shared.background.size = CGSize.init(width: 200, height: 200)
/// icon的大小
MCToastConfig.shared.icon.size = CGSize.init(width: 150, height: 150)
/// 不同状态下的Toast的icon图片
MCToastConfig.shared.icon.successImage = UIImage.init(named: "code")
```




# 说明
1. 由于Toast是展示在Window上的，页面返回正在显示的Toast并不会消失。可以在页面的生命周期内调用MCToast.mc_remove()方法达到页面返回消失的目的。
