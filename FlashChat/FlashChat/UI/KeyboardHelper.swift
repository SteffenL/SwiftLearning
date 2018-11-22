//
//  KeyboardHelper.swift
//
//  Copyright 2018 Steffen André Langnes
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Resources:
//  https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
//  https://developer.apple.com/documentation/uikit/uiwindow/keyboard_notification_user_info_keys
//  https://developer.apple.com/documentation/uikit/uiresponder/1621616-keyboardframebeginuserinfokey
//  https://developer.apple.com/documentation/uikit/uiresponder/1621578-keyboardframeenduserinfokey
//  https://developer.apple.com/documentation/uikit/uiresponder/1621576-keyboardwillshownotification
//  https://developer.apple.com/documentation/uikit/uiresponder/1621606-keyboardwillhidenotification
//  https://developer.apple.com/documentation/uikit/uitextfielddelegate/1619603-textfieldshouldreturn
//
//  Example:
//  class LoginViewController: UIViewController, KeyboardHelperDelegate {
//      @IBOutlet weak var emailTextField: UITextField!
//      @IBOutlet weak var passwordTextField: UITextField!
//      @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
//
//      private var keyboardHelper: KeyboardHelper?
//
//      override func viewDidLoad() {
//          super.viewDidLoad()
//          keyboardHelper = KeyboardHelper(view: view, constraint: bottomLayoutConstraint)
//          keyboardHelper!.delegate = self
//      }
//
//      func kbhTextFieldShouldReturn(_ textField: UITextField) -> Bool {
//          switch textField.returnKeyType {
//          case .next:
//              if textField == emailTextField! {
//                  passwordTextField.becomeFirstResponder()
//              }
//          case .done:
//              logIn()
//          default:
//              return true
//          }
//
//          return false
//      }
//  }
//

import UIKit

protocol KeyboardHelperDelegate {
    func kbhTextFieldShouldReturn(_ textField: UITextField) -> Bool
}

class KeyboardHelper : NSObject, UITextFieldDelegate {
    private weak var view: UIView? = nil
    private weak var constraint: NSLayoutConstraint? = nil
    private var showingKeyboard = false
    private let constraintHeight: CGFloat
    public var delegate: KeyboardHelperDelegate? = nil

    private static let animationOptionMap: [UIView.AnimationCurve: UIView.AnimationOptions] = [
        .easeInOut: UIView.AnimationOptions.curveEaseInOut,
        .easeIn: UIView.AnimationOptions.curveEaseIn,
        .easeOut: UIView.AnimationOptions.curveEaseOut,
        .linear: UIView.AnimationOptions.curveLinear
    ]

    init(view: UIView, constraint: NSLayoutConstraint) {
        self.view = view
        self.constraint = constraint
        constraintHeight = constraint.constant

        super.init()

        for textField in findTextFieldsInView(view) {
            textField.delegate = self
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShowNotification(notification: Notification) {
        //  The keyboard's dimensions may change multiple times while it is displayed
        showingKeyboard = true

        let userInfo = notification.userInfo!
        let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationInfo = animationInfoFromUserInfo(userInfo)
        let newConstraintConstant = constraintHeight + size.height

        UIView.animate(withDuration: animationInfo.duration, delay: 0, options: animationInfo.options, animations: {
            self.constraint?.constant = newConstraintConstant
            self.view?.layoutIfNeeded()
        }, completion: nil)
    }

    @objc private func keyboardWillHideNotification(notification: Notification) {
        // This function may be called multiple times, e.g. when hiding the keyboard and when navigating away from the current screen
        if !showingKeyboard {
            return
        }

        showingKeyboard = false

        let animationInfo = animationInfoFromUserInfo(notification.userInfo!)
        let newConstraintConstant = constraintHeight

        UIView.animate(withDuration: animationInfo.duration, delay: 0, options: animationInfo.options, animations: {
            self.constraint?.constant = newConstraintConstant
            self.view?.layoutIfNeeded()
        }, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .next, .default:
            // When "next" and "return" (default) is pressed on the keyboard, do not dismiss the keyboard
            break
        default:
            // In any other case, try to dismiss the keyboard
            textField.resignFirstResponder()
        }

        return delegate?.kbhTextFieldShouldReturn(textField) ?? true
    }

    private func findTextFieldsInView(_ parent: UIView) -> [UITextField] {
        var textFields = [UITextField]()
        findTextFieldsInView(view!, result: &textFields)
        return textFields
    }

    private func findTextFieldsInView(_ parent: UIView, result: inout [UITextField]) {
        for subview in parent.subviews {
            if let textField = subview as? UITextField {
                result.append(textField)
            } else {
                findTextFieldsInView(subview, result: &result)
            }
        }
    }

    private func animationInfoFromUserInfo(_ userInfo: [AnyHashable: Any]) -> (duration: Double, options: UIView.AnimationOptions) {
        let curve: UIView.AnimationCurve = UIView.AnimationCurve(rawValue: (userInfo[UIWindow.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)!
        let duration = (userInfo[UIWindow.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let options = type(of: self).animationOptionMap[curve] ?? UIView.AnimationOptions()
        return (duration: duration, options: options)
    }
}
