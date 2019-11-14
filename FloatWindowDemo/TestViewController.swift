//
//  TestViewController.swift
//  FloatWindowDemo
//
//  Created by janlionly<jan_ron@qq.com> on 2019/11/15.
//  Copyright © 2019 janlionly. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cool float window"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        field.becomeFirstResponder()
    }
    
    deinit {
        print("\(TestViewController.self) deinit")
    }
    
    // MARK: - Actions
    
    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func destroyButtonTapped(_ sender: Any) {
        FloatWindow.shared.destroy()
    }
    
    @IBAction func hideButtonTapped(_ sender: Any) {
        FloatWindow.shared.hide()
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
