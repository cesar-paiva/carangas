//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Cesar Paiva.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    var car = Car()
    var brands: [Brand] = []
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tfBrand.text = car.brand
        tfName.text = car.name
        tfPrice.text = (String(describing: car.price))
        scGasType.selectedSegmentIndex = car.gasType
        if car._id != nil {
            btAddEdit.setTitle("Alterar carro", for: .normal)
        }
    
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        tfBrand.inputView = pickerView
        tfBrand.inputAccessoryView = toolbar
        
        loadBrands()
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        
        sender.isEnabled = false
        sender.backgroundColor = .gray
        sender.alpha = 0.5
        loading.startAnimating()
        
        car.name = tfName.text ?? ""
        car.brand = tfBrand.text ?? ""
        car.price = Double(tfPrice.text ?? "0") ?? 0
        car.gasType = scGasType.selectedSegmentIndex
        
        if car._id == nil {
            Rest.save(car: car) { (success) in
                self.goBack()
            }
        } else {
            Rest.update(car: car) { (success) in
                self.goBack()
            }
        }
    }
    
    func loadBrands() {
        Rest.loadBrands { (brands) in
            if let brands = brands {
                self.brands = brands.sorted(by: {$0.nome < $1.nome})
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
            }
        }
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func cancel() {
        tfBrand.resignFirstResponder()
    }
    
    @objc func done() {
        tfBrand.text = brands[pickerView.selectedRow(inComponent: 0)].nome
    }

}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let brand = brands[row]
        return brand.nome
    }
}
