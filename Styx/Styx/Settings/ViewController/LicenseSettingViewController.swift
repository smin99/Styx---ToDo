//
//  LicenseSettingViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/23/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class LicenseSettingViewController: UIViewController {

    @IBOutlet weak var oslTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Open Source License".localized
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        oslTextView.setContentOffset(CGPoint.zero, animated: false)
    }
}
