import UIKit

class KeyboardViewController: UIInputViewController {
    
    let keyboardStackView = UIStackView()
    var nextKeyboardButton: UIButton!
    
    var capsLockButton: UIButton! // Caps lock button
    var keyboardButton: UIButton!
    var returnButton: UIButton!
    var settingsButton: UIButton!
    var leftArrowButton: UIButton!
    var showFirstKeyboardScreenKey: UIButton!
    var showSecondKeyboardScreenKey: UIButton!
    
    var isCapsLockOn: Bool = false // Property to track the current state of caps lock button
    
    var firstScreenKeys = [
        ["'12$", "f", "g", "h", "Tr", "j", "k", "l", "m", "n","del"],
        ["caps","e", "i", "o", "T+", "p", "q", "r", "s", "t", ";"],
        ["a", "b", "c", "d", "u", "v", "w", "x", "y", "z", "n{r"],
        ["keyboard", "@", "_", "settings", "space", "<", ">", "/", "return"]
    ]
    
    var secondScreenKeys = [
        ["@Bc","1","2","3","4","5","6","7","8","9","0"],
        ["~","!","£","#","$","%","^","&","*","=",""],
        ["`","€","¥","(",")","leftArrow","'","\"","-","+","del"],
        ["keyboard","ñ{R","settings","space",",",".","/","return"]
    ]

    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Perform custom UI setup here
        setupNextKeyboardButton()
        setupKeyboard(keyboardLayout:firstScreenKeys)
    }

    func setupNextKeyboardButton() {
        nextKeyboardButton = UIButton(type: .system)

        nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false

        nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)

        view.addSubview(nextKeyboardButton)

        NSLayoutConstraint.activate([
            nextKeyboardButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            nextKeyboardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nextKeyboardButton.isHidden = !needsInputModeSwitchKey
    }

    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.

        let textColor: UIColor = textDocumentProxy.keyboardAppearance == .dark ? .white : .black
        nextKeyboardButton.setTitleColor(textColor, for: [])
    }
}


extension KeyboardViewController {
    
    // function to create a custom button
    func createKeyButton() -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }
    
    // Handle delete button tap event
    @objc func deleteButtonTapped() {
            (textDocumentProxy as UIKeyInput).deleteBackward()
        }

    // Handle keypress event of normal keys
    @objc func keyPressed(_ sender: UIButton) {
        guard let key = sender.titleLabel?.text else { return }
        (textDocumentProxy as UIKeyInput).insertText(key)
    }
    
    // Handle return keypress event
    @objc func returnKeyPressed() {
        (textDocumentProxy as UIKeyInput).insertText("\n")
    }
    
    // Insert a space character when the space bar button is tapped
    @objc func spaceBarTapped() {
        (textDocumentProxy as UIKeyInput).insertText(" ")
    }
    
    // Show first keyboard screen
    @objc func showFirstKeyboardScreen () {
        setupKeyboard(keyboardLayout: firstScreenKeys)
    }
    
    // Show second keyboard screen
    @objc func showSecondKeyboardScreen () {
        setupKeyboard(keyboardLayout: secondScreenKeys)
    }
    
    
    // To perform initial set up of the caps lock button
    func setupCapsLockButton() {
            capsLockButton = UIButton(type: .system)
            capsLockButton.setImage(UIImage(systemName: "capslock"), for: .normal)
            capsLockButton.addTarget(self, action: #selector(capsLockButtonTapped), for: .touchUpInside)
            view.addSubview(capsLockButton)
        }
    
    @objc func capsLockButtonTapped() {
            isCapsLockOn.toggle() // Toggle Caps Lock state
            updateCapsLockButtonUI() // Update UI of Caps Lock button
            updateButtonTitles() // Update button titles based on Caps Lock state
        }

        // Update UI of Caps Lock button based on Caps Lock state
        func updateCapsLockButtonUI() {
            let imageName = isCapsLockOn ? "capslock.fill" : "capslock"
            let image = UIImage(systemName: imageName)
            capsLockButton.setImage(image, for: .normal)
        }

//    Function to update button titles based on Caps Lock state
    func updateButtonTitles() {
        // Iterate through all buttons and update their titles
        for case let rowStackView as UIStackView in keyboardStackView.arrangedSubviews {
            for case let button as UIButton in rowStackView.arrangedSubviews {
                if let title = button.titleLabel?.text {
                    if (title == "Tr" || title == "T+"){
                        continue
                    }
                    let newTitle = isCapsLockOn ? title.uppercased() : title.lowercased()
                    button.setTitle(newTitle, for: .normal)
                }
            }
        }
    }
    
    
    // Create the main keyboard stack view
    func setupKeyboard(keyboardLayout:[[String]]) {
        keyboardStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // removing already present horizontal stack to render new ones
        
        keyboardStackView.axis = .vertical
        keyboardStackView.distribution = .fillEqually
        keyboardStackView.alignment = .fill
        keyboardStackView.spacing = 5
        keyboardStackView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.addSubview(keyboardStackView)

        // Add constraints to the keyboard stack view
        NSLayoutConstraint.activate([
            keyboardStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            keyboardStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            keyboardStackView.bottomAnchor.constraint(equalTo: nextKeyboardButton.topAnchor, constant: 20),
            keyboardStackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 50)
        ])

        // Define the layout of the keyboard
        let rows = keyboardLayout

        // Create a horizontal stack view for each row of keys
        for row in rows {
            let rowStackView = createRow(for: row)
            keyboardStackView.addArrangedSubview(rowStackView)
        }
    }

    func createRow(for keys: [String]) -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.distribution = .fillEqually
        rowStackView.alignment = .fill
        rowStackView.spacing = 3
        rowStackView.translatesAutoresizingMaskIntoConstraints = false

        for key in keys {
            
            switch key {
                
            case "'12$":
                showFirstKeyboardScreenKey = UIButton(type: .system)
                showFirstKeyboardScreenKey.setTitle(key, for: .normal)
                showFirstKeyboardScreenKey.setTitleColor(.black, for: .normal)
                showFirstKeyboardScreenKey.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                showFirstKeyboardScreenKey.addTarget(self, action: #selector(showSecondKeyboardScreen), for: .touchUpInside)
                showFirstKeyboardScreenKey.layer.cornerRadius = 5
                showFirstKeyboardScreenKey.translatesAutoresizingMaskIntoConstraints = false
                showFirstKeyboardScreenKey.heightAnchor.constraint(equalToConstant: 45).isActive = true
                showFirstKeyboardScreenKey.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                rowStackView.addArrangedSubview(showFirstKeyboardScreenKey)
                
            case "@Bc":
                showSecondKeyboardScreenKey = UIButton(type: .system)
                showSecondKeyboardScreenKey.setTitle(key, for: .normal)
                showSecondKeyboardScreenKey.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                showSecondKeyboardScreenKey.setTitleColor(.black, for: .normal)
                showSecondKeyboardScreenKey.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                showSecondKeyboardScreenKey.addTarget(self, action: #selector(showFirstKeyboardScreen), for: .touchUpInside)
                showSecondKeyboardScreenKey.layer.cornerRadius = 5
                showSecondKeyboardScreenKey.translatesAutoresizingMaskIntoConstraints = false
                showSecondKeyboardScreenKey.heightAnchor.constraint(equalToConstant: 45).isActive = true
                showSecondKeyboardScreenKey.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                rowStackView.addArrangedSubview(showSecondKeyboardScreenKey)
                
            case "a" , "e" ,"i" ,"o" ,"u" ,"r", "s", "t":
                let button = createKeyButton()
                button.setTitle(key, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
                rowStackView.addArrangedSubview(button)
                
            case "Tr":
                let button = createKeyButton()
                button.backgroundColor = .green
                button.setTitle(key, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .green
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
                
            case "T+":
                let button = createKeyButton()
                button.setTitle(key, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .systemGreen
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
                
            case "del":
                let button = createKeyButton()
                button.tintColor = .gray
                button.setTitle(nil, for: .normal)
                button.setImage(UIImage(systemName: "delete.left.fill"), for: .normal)
                button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
                
            case "caps":
                capsLockButton = UIButton(type: .system)
                capsLockButton.layer.cornerRadius = 5
                capsLockButton.translatesAutoresizingMaskIntoConstraints = false
                capsLockButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
                capsLockButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                capsLockButton.tintColor = .darkGray
                capsLockButton.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                capsLockButton.setImage(UIImage(systemName: "capslock"), for: .normal)
                capsLockButton.addTarget(self, action: #selector(capsLockButtonTapped), for: .touchUpInside)
                rowStackView.addArrangedSubview(capsLockButton)
                
            case "keyboard":
                keyboardButton = UIButton(type: .system)
                keyboardButton.layer.cornerRadius = 5
                keyboardButton.tintColor = .darkGray
                keyboardButton.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                keyboardButton.setImage(UIImage(systemName: "keyboard.chevron.compact.down.fill"), for: .normal)
                keyboardButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
                rowStackView.addArrangedSubview(keyboardButton)
                
            case "return":
                returnButton = UIButton(type: .system)
                returnButton.layer.cornerRadius = 5
                returnButton.tintColor = .white
                returnButton.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
                returnButton.setImage(UIImage(systemName: "return"), for: .normal)
                returnButton.addTarget(self, action: #selector(returnKeyPressed), for: .touchUpInside)
                rowStackView.addArrangedSubview(returnButton)
                
            case "space":
                let button = createKeyButton()
                button.tintColor = .white
                button.setTitle(nil, for: .normal)
                button.setImage(UIImage(systemName: "space"), for: .normal)
                button.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
                button.addTarget(self, action: #selector(spaceBarTapped), for: .touchUpInside)
                print("inside")
                rowStackView.addArrangedSubview(button)
                
            case "settings":
                settingsButton = UIButton(type: .system)
                settingsButton.layer.cornerRadius = 5
                settingsButton.tintColor = .darkGray
                settingsButton.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
                rowStackView.addArrangedSubview(settingsButton)
                
            case "leftArrow":
                leftArrowButton = UIButton(type: .system)
                leftArrowButton.layer.cornerRadius = 5
                leftArrowButton.tintColor = .darkGray
                leftArrowButton.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                leftArrowButton.setImage(UIImage(systemName: "arrowtriangle.left.fill"), for: .normal)
                leftArrowButton.addTarget(self, action: #selector(showPopup(sender:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(leftArrowButton)
                
                
            default:
                let button = createKeyButton()
                button.setTitle(key, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                button.addTarget(self, action: #selector(showPopup(sender:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
            }
        }

        return rowStackView
    }
    
}

extension KeyboardViewController {
//    @objc private func showPopup(sender: UIButton) {
//        // Create a UILabel with the same size as the button
//        let label = UILabel(frame: sender.frame)
//        label.text = sender.currentTitle
//        label.textAlignment = .center
//        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        label.textColor = .white
//        label.layer.cornerRadius = 10
//        label.clipsToBounds = true
//        label.alpha = 0
//        
//        // Position the label above the button
//        label.center.y -= label.frame.height
//        
//        // Add the label to the view
//        view.addSubview(label)
//        
//        // Animate the label to fade in
//        UIView.animate(withDuration: 0.3, animations: {
//            label.alpha = 1
//            label.center.y += label.frame.height
//        }) { _ in
//            // After 0.4 seconds, dismiss the label
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                UIView.animate(withDuration: 0.3, animations: {
//                    label.alpha = 0
//                    label.center.y -= label.frame.height
//                }, completion: { _ in
//                    label.removeFromSuperview()
//                })
//            }
//        }
//    }
    
//    @objc private func showPopup(sender: UIButton) {
//      // Create a UILabel with the same size and position as the button
//      let label = UILabel(frame: sender.frame)
//      label.text = sender.currentTitle
//      label.textAlignment = .center
//      label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//      label.textColor = .white
//      label.layer.cornerRadius = 10
//      label.clipsToBounds = true
//      label.alpha = 0
//
//      // Add the label to the view
//      view.addSubview(label)
//
//      // Animate the label fadeIn and fadeOut sequentially
//      UIView.animate(withDuration: 0.3, animations: {
//        label.alpha = 1
//      }) { _ in
//        UIView.animate(withDuration: 0.3, animations: {
//          label.alpha = 0
//        }, completion: { _ in
//          label.removeFromSuperview()
//        })
//      }
//    }
    
    @objc private func showPopup(sender: UIButton) {
        // Create a UILabel with the desired position
        let labelWidth: CGFloat = 40 // Adjust the width as needed
        let labelHeight: CGFloat = 45
        let buttonFrame = sender.convert(sender.bounds, to: view)
        let labelX = (buttonFrame.origin.x + buttonFrame.width / 2) - (labelWidth / 2)
        let labelY = buttonFrame.origin.y - labelHeight // Adjust the vertical offset as needed
        
        let label = UILabel(frame: CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight))
        label.text = sender.currentTitle
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.alpha = 0
        
        // Add the label to the view
        view.addSubview(label)
        
        // Animate the label to fade in
        UIView.animate(withDuration: 0.3, animations: {
            label.alpha = 1
        }) { _ in
            // After 0.4 seconds, dismiss the label
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.3, animations: {
                    label.alpha = 0
                }, completion: { _ in
                    label.removeFromSuperview()
                })
            }
        }
    }


}
