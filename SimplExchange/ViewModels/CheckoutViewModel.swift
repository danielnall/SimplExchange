//
//  CheckoutViewModel.swift
//  SimplExchange
//
//  Created by Daniel Nall on 3/18/19.
//  Copyright © 2019 Daniel Nall. All rights reserved.
//

import Foundation
import UIKit

class CheckoutViewModel: NSObject {
    let peasPricePerBag: Double = 0.95
    let eggsPricePerDozen: Double = 2.10
    let milkPricePerBottle: Double = 1.30
    let beansPricePerCan: Double = 0.73
    var currencies: [Currency] = [
        Currency(currencyName: "US Dollar", currencyCode: "USD"),
        Currency(currencyName: "Euro", currencyCode: "EUR"),
        Currency(currencyName: "Pound Sterling", currencyCode: "GBP"),
        Currency(currencyName: "Australian Dollar", currencyCode: "AUD"),
        Currency(currencyName: "Japanese Yen", currencyCode: "JPY"),
        Currency(currencyName: "Swiss Franc", currencyCode: "CHF")
        ] {
        didSet {
            if let index = currencies.index(where: { $0.code == "USD" }) {
                updateCurrencyPicker?(index)
            }
        }
    }
    
    var currentCurrency = Currency(currencyName: "US Dollar", currencyCode: "USD") {
        didSet {
            updateCurrencyButtonText?(currentCurrency.code)
        }
    }
    var basketTotal: Double = 0.00
    var totalString: String = "0.00" {
        didSet {
            updateTotalLabel?(totalString)
        }
    }
    
    var updateCurrencyButtonText: ((String) -> ())?
    var updateTotalLabel: ((String) -> ())?
    var updateCurrencyPicker: ((Int) -> ())?
    
    init(basket: ShoppingBasket) {
        let total = (Double(basket.bagsOfPeas) * peasPricePerBag) + (Double(basket.dozensOfEggs) * eggsPricePerDozen) + (Double(basket.bottlesOfMilk) * milkPricePerBottle) + (Double(basket.cansOfBeans) * beansPricePerCan)
        self.basketTotal = round(total*100)/100 // round to 2 decimal places
        
        self.totalString = String(format: "%.2f", self.basketTotal)
        
        super.init()
        
        fetchCurrencies()
    }
    
    func fetchCurrencies() {
        let currencyListURL = URL(string: "http://apilayer.net/api/list?access_key=2d51012a2923e0f35cef7741215ece41")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: currencyListURL) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            do {
                guard let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    return
                }
                
                if let currencyDictionary = json["currencies"] as? NSDictionary {
                    var currencyArray = [Currency]()
                    var keys = currencyDictionary.allKeys as! [String]
                    keys.sort(by: { $0 < $1 })
                    for key in keys {
                        if let name = currencyDictionary[key] as? String {
                            let currency = Currency(currencyName: name, currencyCode: key)
                            currencyArray.append(currency)
                        }
                    }
                    self.currencies = currencyArray
                }
            } catch {
                print("Error parsing data")
            }
        }
        task.resume()
    }
    
    func changeCurrency(selectedIndex: Int) {
        let selectedCurrency = currencies[selectedIndex]
        fetchCurrencyRate(currencyCode: selectedCurrency.code) { rate in
            let newTotal = self.basketTotal * rate
            self.totalString = String(format: "%.2f", newTotal)
            self.currentCurrency = selectedCurrency
        }
    }
    
    func fetchCurrencyRate(currencyCode: String, completion: @escaping (Double) -> ()) {
        let currencyListURL = URL(string: "http://apilayer.net/api/live?access_key=2d51012a2923e0f35cef7741215ece41&currencies=\(currencyCode)")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: currencyListURL) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            do {
                guard let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    return
                }
                
                if let ratesDictionary = json["quotes"] as? NSDictionary, let rate = ratesDictionary["USD\(currencyCode)"] as? Double {
                    completion(rate)
                }
            } catch {
                print("Error parsing data")
            }
        }
        task.resume()
    }
}

extension CheckoutViewModel: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currencyForThisRow = currencies[row]
        return "\(currencyForThisRow.code) \(currencyForThisRow.name)"
    }
}
