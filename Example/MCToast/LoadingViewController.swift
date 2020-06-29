//
//  LoadingViewController.swift
//  MCToast_Example
//
//  Created by Mccc on 2019/11/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MCToast

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
                
        MCToast.mc_loading(text: "loading")
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MCToast.mc_remove()
    }
}



