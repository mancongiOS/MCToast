
# Toast For Swift
* Swift语言实现的Toast交互功能库。
* 内部处理了线程问题。
* 支持UI的高度自定义。配置toast的小图标，文字大小和颜色等
* 使用简单。
* 内部处理了多个toast提示重叠显示的问题。
* 
# 使用
1. 支持cocoPods
  ```
  pod 'MCToast'
  ```
2. 全部配置Toast的UI
```
public class MCToastConfig: NSObject {
    public static let shared = MCToastConfig()
    
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
3. 使用起来吧！
```
MCToast.mc_text("这是一个纯文本的展示")
MCToast.mc_text("这是一个很长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长的纯文本的展示")
MCToast.mc_loading()
MCToast.mc_success("设置成功")
MCToast.mc_failure("设置失败")
MCToast.mc_warning("警告")
MCToast.mc_warning("等待")
MCToast.mc_other("其他")
MCToast.mc_statusBar("有内容更新啦，赶紧看看吧", backgroundColor: nil)
MCToast.mc_remove()
```
# 说明
1. 由于Toast是展示在Window上的，页面返回正在显示的Toast并不会消失。可以在页面的生命周期内调用MCToast.mc_remove()方法达到页面返回消失的目的。
