//
//  ShopViewController.swift
//  Simple Exchange
//
//  Created by Daniel Nall on 3/15/19.
//  Copyright © 2019 Daniel Nall. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    @IBOutlet weak var bagsOfPeasLabel: UILabel!
    @IBOutlet weak var dozensOfEggsLabel: UILabel!
    @IBOutlet weak var bottlesOfMilkLabel: UILabel!
    @IBOutlet weak var cansOfBeansLabel: UILabel!
    
    var bagsOfPeas: Int = 0 {
        didSet {
            bagsOfPeasLabel.text = "\(bagsOfPeas)"
        }
    }
    var dozensOfEggs: Int = 0 {
        didSet {
            dozensOfEggsLabel.text = "\(dozensOfEggs)"
        }
    }
    var bottlesOfMilk: Int = 0 {
        didSet {
            bottlesOfMilkLabel.text = "\(bottlesOfMilk)"
        }
    }
    var cansOfBeans: Int = 0 {
        didSet {
            cansOfBeansLabel.text = "\(cansOfBeans)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func updatePeas(_ sender: UIStepper) {
        bagsOfPeas = Int(sender.value)
    }
    
    @IBAction func updateEggs(_ sender: UIStepper) {
        dozensOfEggs = Int(sender.value)
    }
    
    @IBAction func updateMilk(_ sender: UIStepper) {
        bottlesOfMilk = Int(sender.value)
    }
    
    @IBAction func updateBeans(_ sender: UIStepper) {
        cansOfBeans = Int(sender.value)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CheckoutViewController {
            let basket = ShoppingBasket(peas: bagsOfPeas, eggs: dozensOfEggs, milk: bottlesOfMilk, beans: cansOfBeans)
            let checkoutViewModel = CheckoutViewModel(basket: basket)
            vc.viewModel = checkoutViewModel
        } else {
            print("Error: Unexpected segue initiated")
        }
    }
}

