//
//  LoadingViewController.swift
//  MCToast_Example
//
//  Created by 满聪 on 2019/11/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MCToast

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = true

        view.backgroundColor = UIColor.white
                
        MCToast.mc_loading(text: "loading", autoClearTime: 1000, font: UIFont.boldSystemFont(ofSize: 15))
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MCToast.mc_remove()
    }
}
