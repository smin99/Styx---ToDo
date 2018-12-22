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
    
    // 키보드 프레임에 변경이 생길시에 이벤트를 등록한다.
    func startAvoidingKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(_onKeyboardFrameWillChangeNotificationReceived(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // 등록된 키보드 이벤트를 삭제 한다.
    func stopAvoidingKeyboard() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // 키보드 프레임에 변경이 생기면 - ViewController의 사이즈를 같이 변경 한다.
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
    
    // ViewController 영역에 탭이 발생하면 키보드를 사라지게 한다.
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(recognizer:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
