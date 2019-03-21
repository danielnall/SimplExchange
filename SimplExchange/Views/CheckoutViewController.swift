//
//  CheckoutViewController.swift
//  SimplExchange
//
//  Created by Daniel Nall on 3/17/19.
//  Copyright © 2019 Daniel Nall. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
    var viewModel: CheckoutViewModel? {
        didSet {
            viewModel?.updateCurrencyButtonText = { [unowned self] buttonTitle in
                DispatchQueue.main.async {
                    self.currencyButton.setTitle(buttonTitle, for: .normal)
                }
            }
            
            viewModel?.updateTotalLabel = { [unowned self] labelText in
                DispatchQueue.main.async {
                    self.totalLabel.text = labelText
                }
            }
            
            viewModel?.updateCurrencyPicker = { [unowned self] selectedIndex in
                DispatchQueue.main.async {
                    self.currencyPicker.reloadAllComponents()
                    self.currencyPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
                }
            }
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var currencyButton: UIButton!
    
    var pickerPanel: UIView!
    var pickerPanelTopConstraint: NSLayoutConstraint!
    var pickerPanelBottomConstraint: NSLayoutConstraint!
    var pickerToolbar: UIToolbar!
    var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = viewModel else {
            return
        }
        
        backButton.setImage(UIImage(named: "backArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        totalLabel.text = viewModel.totalString
        
        // initialize programmatic views
        pickerPanel = UIView()
        pickerPanel.translatesAutoresizingMaskIntoConstraints = false
        pickerPanel.backgroundColor = UIColor.white
        self.view.addSubview(pickerPanel)
        
        pickerToolbar = UIToolbar()
        pickerToolbar.translatesAutoresizingMaskIntoConstraints = false
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CheckoutViewController.selectCurrency))
        pickerToolbar.setItems([flex,doneButton], animated: false)
        pickerPanel.addSubview(pickerToolbar)
        
        currencyPicker = UIPickerView()
        currencyPicker.translatesAutoresizingMaskIntoConstraints = false
        currencyPicker.delegate = viewModel
        currencyPicker.dataSource = viewModel
        pickerPanel.addSubview(currencyPicker)
        
        // create autolayout constraints for programmatic views
        
        // set up top and bottom constraints to be animated
        pickerPanelTopConstraint = pickerPanel.topAnchor.constraint(equalTo: view.bottomAnchor)
        pickerPanelTopConstraint.isActive = true
        pickerPanelBottomConstraint = pickerPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        pickerPanelBottomConstraint.isActive = false
        
        // remaining constraints
        pickerPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        pickerToolbar.leadingAnchor.constraint(equalTo: pickerPanel.leadingAnchor).isActive = true
        pickerToolbar.topAnchor.constraint(equalTo: pickerPanel.topAnchor).isActive = true
        pickerToolbar.trailingAnchor.constraint(equalTo: pickerPanel.trailingAnchor).isActive = true
        
        currencyPicker.topAnchor.constraint(equalTo: pickerToolbar.bottomAnchor).isActive = true
        currencyPicker.leadingAnchor.constraint(equalTo: pickerPanel.leadingAnchor).isActive = true
        currencyPicker.bottomAnchor.constraint(equalTo: pickerPanel.bottomAnchor).isActive = true
        currencyPicker.trailingAnchor.constraint(equalTo: pickerPanel.trailingAnchor).isActive = true
    }

    @IBAction func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapCurrency(_ sender: UIButton) {
        showCurrencyPicker()
    }
    
    func showCurrencyPicker() {
        pickerPanelTopConstraint.isActive = false
        pickerPanelBottomConstraint.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func selectCurrency() {
        viewModel?.changeCurrency(selectedIndex: currencyPicker.selectedRow(inComponent: 0))
        pickerPanelTopConstraint.isActive = true
        pickerPanelBottomConstraint.isActive = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
