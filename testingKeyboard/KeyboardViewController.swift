import UIKit

class KeyboardViewController: UIInputViewController {
    
    var nextKeyboardButton: UIButton!

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
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)

        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }
    
    // Handle delete button tap event
    @objc func deleteButtonTapped() {
            (textDocumentProxy as UIKeyInput).deleteBackward()
        }

    // handle keypress event of normal keys
    @objc func keyPressed(_ sender: UIButton) {
        guard let key = sender.titleLabel?.text else { return }
        (textDocumentProxy as UIKeyInput).insertText(key)
    }
    
    func setupKeyboard() {
        // Create the main keyboard stack view
        let keyboardStackView = UIStackView()
        keyboardStackView.axis = .vertical
        keyboardStackView.distribution = .fillEqually
        keyboardStackView.alignment = .fill
        keyboardStackView.spacing = 5
        keyboardStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardStackView)

        // Add constraints to the keyboard stack view
        NSLayoutConstraint.activate([
            keyboardStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            keyboardStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            keyboardStackView.bottomAnchor.constraint(equalTo: nextKeyboardButton.topAnchor, constant: 30),
            keyboardStackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 5)
        ])

        // Define the layout of the keyboard
        let rows = [
            ["12$", "F", "G", "H", "Tr", "J", "K", "L", "M", "N","del"],
            ["caps","E", "I", "O", "T+", "P", "Q", "R", "S", "T", ";"],
            ["A", "B", "C", "D", "U", "V", "W", "X", "Y", "Z", "n{R"],
            ["A", "B", "C", "D", "U", "V", "W", "X", "Y", "Z", "n{R"]
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
            let button = createKeyButton(title: key)
            
            switch key {
            case "Tr":
                button.backgroundColor = .green
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
            case "T+":
                button.backgroundColor = .green
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
            case "del":
                button.tintColor = .gray
                button.setTitle(nil, for: .normal)
                button.setImage(UIImage(systemName: "delete.left"), for: .normal)
                button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
            default:
                button.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
            }
            rowStackView.addArrangedSubview(button)
        }

        return rowStackView
    }
    
}

