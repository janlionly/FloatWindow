# FloatWindow

[![Version](https://img.shields.io/cocoapods/v/FloatWindow.svg?style=flat)](https://cocoapods.org/pods/FloatWindow)
[![License](https://img.shields.io/cocoapods/l/FloatWindow.svg?style=flat)](https://github.com/janlionly/FloatWindow/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/FloatWindow.svg?style=flat)](https://github.com/janlionly/FloatWindow)
![Swift](https://img.shields.io/badge/%20in-swift%205.1-orange.svg)

![FloatWindow demo image](https://media.giphy.com/media/JsCvFolCJhw18bSycY/giphy.gif)

## Description
**FloatWindow** like WeChat's floating ball can open a controller and hide it into a ball.


## Installation

### CocoaPods

```ruby
pod 'FloatWindow'
```

## Usage

```swift
 // init FloatWindow
 FloatWindow.shared.ballWidth = 60
 FloatWindow.shared.isShowPanExitView = true // pan to show exit view
 FloatWindow.shared.ballImage = UIImage(named: "beauty")
/* optional: set init stay postion (default: right of screen edge, middle of horizon)
        let screenSize = UIScreen.main.bounds
        FloatWindow.shared.stayPoint = CGPoint(x: screenSize.width - FloatWindow.shared.ballWidth - 10, y: 600)
// */
 
 // push a new controller to FloatWindow
 let controller = UIViewController()
 controller.view.backgroundColor = .yellow
 FloatWindow.shared.push(root: controller, in: self.navigationController)

 // hide the controller in FloatWindow
 FloatWindow.shared.hide()

 // show the origin controller in FloatWindow
 FloatWindow.shared.show()

 // or destroy the controller in FloatWindow
 FloatWindow.shared.destroy()
```

## Requirements

- iOS 9.0+
- Swift 4.2 to 5.1

## Author

Visit my github: [janlionly](https://github.com/janlionly)<br>
Contact with me by email: janlionly@gmail.com

## Contribute

I would love you to contribute to **FloatWindow**

## License

**FloatWindow** is available under the MIT license. See the [LICENSE](https://github.com/janlionly/FloatWindow/blob/master/LICENSE) file for more info.
