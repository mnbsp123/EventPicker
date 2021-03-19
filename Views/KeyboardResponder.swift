//
//  KeyboardResponder.swift
//  BeefPassport
//
//  Created by Benedict Pupp on 3/11/21.
//

import Foundation
import SwiftUI

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    @Published var isKeyboardVisible: Bool = false
    
    var _center: NotificationCenter
    
    init(center: NotificationCenter = .default) {
        _center = center
        //4. Tell the notification center to listen to the system keyboardWillShow and keyboardWillHide notification
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            withAnimation {
                isKeyboardVisible = true
                currentHeight = keyboardSize.height
                //print("KeyboardResponder keyboard height: \(currentHeight)")
            }
        }
    }
    @objc func keyBoardWillHide(notification: Notification) {
        withAnimation {
            isKeyboardVisible = false
            currentHeight = 0
        }
    }
}
