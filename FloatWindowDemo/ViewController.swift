//
//  ViewController.swift
//  FloatWindowDemo
//
//  Created by janlionly<jan_ron@qq.com> on 2019/11/15.
//  Copyright © 2019 janlionly. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instance(_ storyboardName: String, viewControllerIdentifier: String) -> UIViewController? {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerIdentifier)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initFloatWindow()
    }
    
    func initFloatWindow() {
        FloatWindow.shared.ballWidth = 60
        FloatWindow.shared.isShowPanExitView = true
        FloatWindow.shared.ballImage = UIImage(named: "beauty")
        
        // bottom label name
        let nameLabel = UILabel(frame: CGRect(x: 0, y: FloatWindow.shared.ballWidth - 16, width: FloatWindow.shared.ballWidth, height: 16))
        nameLabel.text = "Jane"
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 10)
        nameLabel.backgroundColor = UIColor.link.withAlphaComponent(0.5)
        FloatWindow.shared.ballView.addSubview(nameLabel)
        FloatWindow.shared.ballView.clipsToBounds = true
        
/* optional: set init stay postion (default: right of screen edge, middle of horizon)
        let screenSize = UIScreen.main.bounds
        FloatWindow.shared.stayPoint = CGPoint(x: screenSize.width - FloatWindow.shared.ballWidth - 10, y: 600)
// */
    }

    @IBAction func pushButtonTapped(_ sender: Any) {
        guard let test = UIStoryboard.instance("Main", viewControllerIdentifier: "TestViewController") else {
            return
        }

        FloatWindow.shared.push(root: test, in: self.navigationController)
    }
    
    @IBAction func openButtonTapped(_ sender: Any) {
        FloatWindow.shared.show()
    }
}

