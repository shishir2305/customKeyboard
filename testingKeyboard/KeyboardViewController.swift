import UIKit

class KeyboardViewController: UIInputViewController {
    
    let keyboardStackView = UIStackView()
    var nextKeyboardButton: UIButton!
    
    var capsLockButton: UIButton! // Caps lock button
    var isCapsLockOn: Bool = false // Property to track the current state of caps lock button
    var keyboardButton: UIButton!
    var returnButton: UIButton!
    var settingsButton: UIButton!

    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Perform custom UI setup here
        setupNextKeyboardButton()
        setupKeyboard()
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
    func createKeyButton(title: String) -> UIButton {
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
    func setupKeyboard() {
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
            keyboardStackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 5)
        ])

        // Define the layout of the keyboard
        let rows = [
            ["12$", "f", "g", "h", "Tr", "j", "k", "l", "m", "n","del"],
            ["caps","e", "i", "o", "T+", "p", "q", "r", "s", "t", ";"],
            ["a", "b", "c", "d", "u", "v", "w", "x", "y", "z", "n{r"],
            ["keyboard", "@", "_", "settings", "space", "<", ">", "/", "return"]
        ]

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
                
            case "a" , "e" ,"i" ,"o" ,"u" ,"r", "s", "t":
                let button = createKeyButton(title: key)
                button.setTitle(key, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
                rowStackView.addArrangedSubview(button)
                
            case "Tr":
                let button = createKeyButton(title: key)
                button.backgroundColor = .green
                button.setTitle(key, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .green
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
                
            case "T+":
                let button = createKeyButton(title: key)
                button.setTitle(key, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .systemGreen
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
                
            case "del":
                let button = createKeyButton(title: key)
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
                let button = createKeyButton(title: key)
                button.tintColor = .gray
                button.setTitle(nil, for: .normal)
                button.setImage(UIImage(systemName: "space"), for: .normal)
                button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                button.addTarget(self, action: #selector(spaceBarTapped), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
                
            case "settings":
                settingsButton = UIButton(type: .system)
                settingsButton.layer.cornerRadius = 5
                settingsButton.tintColor = .darkGray
                settingsButton.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
                rowStackView.addArrangedSubview(settingsButton)
                
            default:
                let button = createKeyButton(title: key)
                button.setTitle(key, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                rowStackView.addArrangedSubview(button)
            }
        }

        return rowStackView
    }
    
}
