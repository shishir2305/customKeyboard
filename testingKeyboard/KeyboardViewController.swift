//
//  KeyboardViewController.swift
//  testingKeyboard
//
//  Created by Promact on 23/02/24.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var keyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        
        view = objects[0] as? UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    @IBAction func keyboardButtonPressed(button:UIButton){
        let str = button.titleLabel?.text
        (textDocumentProxy as UIKeyInput).insertText("\(str!)")
    }
    
    @IBAction func keyboardButtonTapped(_ sender: UIButton) {
        let duration: TimeInterval = 0.1
                
                // Define the distance to move the key up (in points)
                let moveDistance: CGFloat = -10.0 // Adjust this value to control the upward movement
                
                // Animate the key
                UIView.animate(withDuration: duration, animations: {
                    // Move the key up
                    self.keyboardButton.frame.origin.y += moveDistance
                }) { _ in
                    // Move the key back to its original position
                    UIView.animate(withDuration: duration) {
                        self.keyboardButton.frame.origin.y -= moveDistance
                    }
                }
        }
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
