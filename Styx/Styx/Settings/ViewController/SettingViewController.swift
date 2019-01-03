//
//  SettingViewController.swift
//  Styx
//
//  Created by HwangSeungmin on 12/22/18.
//  Copyright © 2018 Min. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let version: String = " 1.0"
    
    let sections = [["Screen Lock".localized, "Notification".localized],
                    ["Add review".localized, "Recommended Apps".localized, "Recommend to Friends".localized],
                    ["Open Source License".localized, "Version".localized]]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Setting".localized

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        if indexPath.section == 2 && indexPath.row == 1 {
            cell.textLabel?.text = sections[indexPath.section][indexPath.row] + version
        }
        else {
            cell.textLabel?.text = sections[indexPath.section][indexPath.row]
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Screen lock setting view controller
        if indexPath.section == 0 && indexPath.row == 0 {
            
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LockSettingViewController") {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
        }
        // Notification setting view controller
        else if indexPath.section == 0 && indexPath.row == 1 {
            
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "NotificationSettingViewController") {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
        }
        // Add review
        else if indexPath.section == 1 && indexPath.row == 0 {
            
            if let url = URL(string: ConstsCommon.iTunesReviewUrl), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
        // Recommended Apps
        else if indexPath.section == 1 && indexPath.row == 1 {
            
            if let url = URL(string: ConstsCommon.iTunesCompanyUrl), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
        // Recommend to Friends:
        else if indexPath.section == 1 && indexPath.row == 2 {
            
            let url = URL(string: ConstsCommon.iTunesAppUrl)!
            let title = "\n\n" + "Recommendation".localized
            let textToShare = [ url, title ] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
            
        }
        // Open Source License
        else if indexPath.section == 2 && indexPath.row == 0 {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LicenseSettingViewController") {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
