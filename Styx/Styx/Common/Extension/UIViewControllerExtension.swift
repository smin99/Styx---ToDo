//
//  UIViewControllerExtension.swift
//  Styx
//
//  Created by HwangSeungmin on 12/21/18.
//  Copyright © 2018 Min. All rights reserved.
//


import UIKit

// 키보드 관련 처리 추가 UIViewController 클래스
extension UIViewController {
    
    // Add the event when keyboard frame changes
    func startAvoidingKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(_onKeyboardFrameWillChangeNotificationReceived(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // Delete setted keyboard event
    func stopAvoidingKeyboard() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // When keyboard frame changes, change the size of viewcontroller as well
    @objc private func _onKeyboardFrameWillChangeNotificationReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
        let intersection = safeAreaFrame.intersection(keyboardFrameInView)
        
        let animationDuration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: {
            self.additionalSafeAreaInsets.bottom = intersection.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // Dismiss keyboard when tab happens in ViewController 
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(recognizer:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
