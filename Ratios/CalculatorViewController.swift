//
//  CalculatorViewController.swift
//  Ratios
//
//  Created by Edward Wellbrook on 09/01/2017.
//  Copyright © 2017 Brushed Type. All rights reserved.
//

import UIKit

fileprivate struct Actions {
    private init() {}

    static let handleSettingsButtonPress = #selector(CalculatorViewController.handleSettingsButtonPress(_:))
    static let handleFieldValueChange = #selector(CalculatorViewController.handleFieldValueChange(_:))
}

class CalculatorViewController: UIViewController {

    var persistenceStore: PersistenceStore?

    let ratioInputView = LabelInputView(label: "RATIO", initialValue: "16")
    let totalInputView = LabelInputView(label: "TOTAL BREW (ML)", initialValue: "315")
    let waterInputView = LabelInputView(label: "WATER (ML)", initialValue: "0")
    let groundsInputView = LabelInputView(label: "GROUNDS (G)", initialValue: "0")

    var centerYConstraint: NSLayoutConstraint? = nil


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Calculator"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: Actions.handleSettingsButtonPress)
        self.navigationController?.isNavigationBarHidden = true

        self.view.backgroundColor = UIColor(red: 0.87256, green: 0.79711, blue: 0.71713, alpha: 1)

        let topView = UIStackView(arrangedSubviews: [
            self.ratioInputView,
            self.totalInputView
        ])

        topView.alignment = .fill
        topView.axis = .horizontal
        topView.distribution = .fillEqually
        topView.spacing = 4

        let stackView = UIStackView(arrangedSubviews: [
            topView,
            self.groundsInputView,
            self.waterInputView
        ])

        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4

        self.view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 8).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true

        self.totalInputView.textField.addTarget(self, action: Actions.handleFieldValueChange, for: .editingChanged)
        self.waterInputView.textField.addTarget(self, action: Actions.handleFieldValueChange, for: .editingChanged)
        self.groundsInputView.textField.addTarget(self, action: Actions.handleFieldValueChange, for: .editingChanged)
        self.ratioInputView.textField.addTarget(self, action: Actions.handleFieldValueChange, for: .editingChanged)

        if let values = self.persistenceStore?.getValues() {
            let water = Calculator.calculateWater(grounds: values.grounds, ratio: values.ratio)
            let brew = Calculator.calculateBrew(grounds: values.grounds, water: water)

            self.ratioInputView.textField.text = String(values.ratio)
            self.groundsInputView.textField.text = CalculatorViewController.formatDoubleToString(values.grounds)
            self.waterInputView.textField.text = CalculatorViewController.formatDoubleToString(water)
            self.totalInputView.textField.text = CalculatorViewController.formatDoubleToString(brew)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.totalInputView.textField.becomeFirstResponder()
    }

    @objc func handleFieldValueChange(_ sender: AnyObject) {
        let total = Double(self.totalInputView.textField.text ?? "0") ?? 0
        let water = Double(self.waterInputView.textField.text ?? "0") ?? 0
        let grounds = Double(self.groundsInputView.textField.text ?? "0") ?? 0
        let ratio = Int(self.ratioInputView.textField.text ?? "16") ?? 16

        self.persistenceStore?.save(grounds: grounds, ratio: ratio)

        guard let field = sender as? UITextField else {
            return
        }

        switch field {
        case self.totalInputView.textField:
            let newGrounds = Calculator.calculateGrounds(brew: total, ratio: ratio)
            let newWater = Calculator.calculateWater(grounds: newGrounds, ratio: ratio)
            self.groundsInputView.textField.text = CalculatorViewController.formatDoubleToString(newGrounds)
            self.waterInputView.textField.text = CalculatorViewController.formatDoubleToString(newWater)

        case self.waterInputView.textField:
            let newGrounds = Calculator.calculateGrounds(water: water, ratio: ratio)
            let newBrew = Calculator.calculateBrew(grounds: newGrounds, water: water)
            self.groundsInputView.textField.text = CalculatorViewController.formatDoubleToString(newGrounds)
            self.totalInputView.textField.text = CalculatorViewController.formatDoubleToString(newBrew)

        case self.groundsInputView.textField, self.ratioInputView.textField:
            let newWater = Calculator.calculateWater(grounds: grounds, ratio: ratio)
            let newBrew = Calculator.calculateBrew(grounds: grounds, water: newWater)
            self.waterInputView.textField.text = CalculatorViewController.formatDoubleToString(newWater)
            self.totalInputView.textField.text = CalculatorViewController.formatDoubleToString(newBrew)

        default:
            break
        }
    }

    @objc func handleSettingsButtonPress(_ sender: AnyObject) {

    }

    static func formatDoubleToString(_ value: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        return formatter.string(from: NSNumber(value: value))
    }

}
